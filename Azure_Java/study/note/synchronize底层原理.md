

# synchronize底层原理

>synchronize是如何使用的？这里不再赘述，从底层出发了解原理。
>
>时间：<span style="color:#42B983;font-weight:bold;">2021年4月1日14:44:08</span>    本文所有内容基于: 	<span style="color:#42B983;font-weight:bold;">HotSpot    jdk1.8</span>	

## 一、前置知识

### 1、cas和unsafe类

#### a、<span style="color:#FC5531; font-weight:bold;">cas </span> 
**Compare and Swap(set)** 基于乐观锁的一种概念</br>
描述了，每次不加锁而是假设没有冲突而去完成某项操作，如果因为冲突失败就重试，直到成功为止的机制</br>



#### b、<span style="color:#FC5531; font-weight:bold;">unsafe类</span> 

unsafe(不安全)类，是对cas机制的一种  <span style="color:#42B983;font-weight:bold;">"安全实现"</span>  下边我们详细描述。

##### 不安全

因为unsafe类是<span style="color:#FC5531; font-weight:bold;"> 直接操作内存 </span>的类，所以不安全

##### 安全

因为unsafe类是直接操作内存的类，所以为了不让程序员们直接使用，对unsafe类加了限制</br>

该类只能有Bootstrap类加载器加载（<span style=" font-weight:bold;border-bottom:1px dashed #000; height:50px;width:350px">但让使用反射这种非常规的方式还是可以突破限制 ^_-！</span>）

##### 正常尝试使用

~~~java
/**
 * 正常渠道使用unsafe类
 * ：因为 unsafe类 是在rt包下的，并且unsafe是直接操作内存的类，所以官方为了不让程序员们直接操作内存导致不安全的问题发生，所以对unsafe类使用加了以下限制
 * 首先unsafe类必须有Bootstrap类加载器加载才能使用
 *
 * @author cWX993443
 * @since 2021-02-02
 */
public class NormalChannelUnsafe {
    // 获取unsafe的实例
    static final Unsafe unsafe = sun.misc.Unsafe.getUnsafe();

    // state 字段内存偏移量
    static long stateOffSet;

    // cas 要修改的字段state
    private volatile long state = 0;

    static {
        try {
            // 获取字段“state" 在对象NormalChannelUnsafe中的内存偏移量
            stateOffSet = unsafe.objectFieldOffset(NormalChannelUnsafe.class.getDeclaredField("state"));
        } catch (NoSuchFieldException e) {
            System.out.println(e.getLocalizedMessage());
        }
    }

    public static void main(String[] args) {
        NormalChannelUnsafe normalChannelUnsafe = new NormalChannelUnsafe();
        // 使用unsafe类的cas方式修改对象normalChannelUnsafe对象在内存偏移量为stateOffSet位置上的值为1
        Boolean sucess = unsafe.compareAndSwapLong(normalChannelUnsafe, stateOffSet, 0, 1);
    }
}
~~~

##### 反射尝试

~~~java
/**
 * 非正规渠道使用unsafe类
 *  正常的渠道无法使用unsafe类 但是我们可以利用强大的 反射来打破平衡，突破限制
 *
 * @author cWX993443
 * @since 2021-02-02
 */
public class AbnormalChannelUnsafe {

    static  Unsafe unsafe;

    static long stateOffSet;

    private volatile long state = 0;

    static{
        try {
            Field field = Unsafe.class.getDeclaredField("theUnsafe");

            field.setAccessible(true);

            unsafe = (Unsafe) field.get(null);

            stateOffSet = unsafe.objectFieldOffset(AbnormalChannelUnsafe.class.getDeclaredField("state"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {

        AbnormalChannelUnsafe abnormalChannelUnsafe = new AbnormalChannelUnsafe();

        Boolean success = unsafe.compareAndSwapLong(abnormalChannelUnsafe,stateOffSet,256,1);

        System.out.println("abnormalChannelUnsafe to update state`s value result :" + success + " | current value :" + abnormalChannelUnsafe.state);

    }

}
~~~

##### unsafe对cas实现解读

> 这里以上例中的 unsafe.compareAndSwapLong();为例探索

* java代码

~~~java
/**
     * Atomically update Java variable to <tt>x</tt> if it is currently
     * holding <tt>expected</tt>.
     * @return <tt>true</tt> if successful
     */
    public final native boolean compareAndSwapLong(Object o, long offset,
                                                   long expected,long x);
~~~

* openjdk1.8源码说明

~~~c++
UNSAFE_ENTRY(jboolean, Unsafe_CompareAndSwapLong(JNIEnv *env, jobject unsafe, jobject obj, jlong offset, jlong e, jlong x))
  UnsafeWrapper("Unsafe_CompareAndSwapLong");
  Handle p (THREAD, JNIHandles::resolve(obj));
  jlong* addr = (jlong*)(index_oop_from_field_offset_long(p(), offset));
  if (VM_Version::supports_cx8())
    return (jlong)(Atomic::cmpxchg(x, addr, e)) == e;
  else {
    jboolean success = false;
    ObjectLocker ol(p, THREAD);
    if (*addr == e) { *addr = x; success = true; }
    return success;
  }
UNSAFE_END
~~~

接着我们再看上面这段代码中的核心代码点：<span style="color:#FC5531; font-weight:bold;">Atomic::cmpxchg(x, addr, e)</span>
在atomic_linux_x86.inline.hpp中的实现

~~~c++
inline jlong    Atomic::cmpxchg    (jlong    exchange_value, volatile jlong*    dest, jlong    compare_value) {
  bool mp = os::is_MP();
  __asm__ __volatile__ (LOCK_IF_MP(%4) "cmpxchgq %1,(%3)"
                        : "=a" (exchange_value)
                        : "r" (exchange_value), "a" (compare_value), "r" (dest), "r" (mp)
                        : "cc", "memory");
  return exchange_value;
}
~~~

<span style="color:#FC5531; font-weight:bold;">简单说明：</span>

	<span style="color:#42B983;font-weight:bold;">\__asm__  \__volatile__ </span>:声明接下来的4部分表达式（：分割的）不被gcc指令优化</br>
	
	<span style="color:#42B983;font-weight:bold;">os::is_MP()</span>：判断当前环境是否为多处理器环境 </br>
	
	<span style="color:#42B983;font-weight:bold;">重点★★★</span> LOCK_IF_MP(%4) "cmpxchgq %1,(%3)" </br>
	
		 LOCK_IF_MP：如果为多核处理器，则在“核心指令”前追加“lock”指令</br>
	
		 lock:语义：只允许一个cpu修改地址偏移量上的值</br>
	
				    硬件层面细究：锁总线：锁定总线一个北桥电信号 这里就不在往深了探讨了 0.o</br>

 		 cmpxchgq：核心指令，语义：比较并交换</br>

	<span style="color:#FC5531; font-weight:bold;">总</span>：总结cas机制用unsafe核心实现底层指令：<span style="color:#FC5531; font-weight:bold;">lock  cmpxchgp</span>

### 2、JOL

	>  JOL:java object layout,有专门的文章讲解，这里不在赘述

## 二、synchronize使用场景

### 1、修饰代码块

~~~java
// 指定一个加锁的对象，给对象加锁
public Demo1{
   Object lock=new Object();
   public void test1(){
       synchronized(lock){
       }
   }
}
~~~



### 2、修饰静态方法

~~~java
// 对当前类的Class对象加锁
public class Demo2 {
   //形式一
    public void test1(){
        synchronized(Demo2.class){
        }
    }
  //形式二
    public void test2(){
        public synchronized static void test1(){
        }
    }
}
~~~

### 3、修饰普通方法

~~~java
// 对当前实例对象this加锁
public class Demo3 {
    public synchronized void test1(){
    }
}
~~~



## 三、字节码层面解读synchronize

### 1、java代码

~~~java
public static void main( String[] args ){
    System.out.println( "hello Java" );
}
//synchronized修饰普通方法
public synchronized void test1() { }

//修饰代码块
public void test2() {
    synchronized (this) {}
}
~~~

### 2、java字节码

(字节码查看命令：javap -verbose  类名) 下文只是截取了test1 和 test2方法部分

test1()    <span style="color:#42B983;font-weight:bold;">核心标志：</span><span style="color:#FC5531; font-weight:bold;">ACC_SYNCHRONIZED</span>

~~~java
'''
public synchronized void test1();
    descriptor: ()V
    flags: ACC_PUBLIC, ACC_SYNCHRONIZED
    Code:
      stack=0, locals=1, args_size=1
         0: return
      LineNumberTable:
        line 59: 0
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       1     0  this   Lsite/ryanc/lock/SyncLearn;
'''
~~~

> 如果修饰同步方法是通过的flag ACC_SYNCHRONIZED来完成的，也就是说一旦执行到这个方法，就会先判断是否有标志位，然后ACC_SYNCHRONIZED会去隐式调用刚才的两个指令：monitorenter和monitorexit。

---

test2()    <span style="color:#42B983;font-weight:bold;">核心指令：</span><span style="color:#FC5531; font-weight:bold;">monitorenter 、monitorexit</span>

~~~java
'''
 public void test2();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=2, locals=3, args_size=1
         0: aload_0
         1: dup
         2: astore_1
         3: monitorenter
         4: aload_1
         5: monitorexit
         6: goto          14
         9: astore_2
        10: aload_1
        11: monitorexit
        12: aload_2
        13: athrow
        14: return
~~~

> 首先如果被synchronized修饰在方法块的话，是通过 monitorenter 和 monitorexit 这两个字节码指令获取线程的执行权的。当方法执行完毕退出以后或者出现异常的情况下会自动释放锁。

### 3、综述

<span style="color:#FC5531; font-weight:bold;">简单说明：</span>
在Java虚拟机执行到monitorenter指令时：</br>
1首先它会尝试获取对象的锁，如果该对象没有锁，或者当前线程已经拥有了这个对象的锁时</br>
它会把计数器+1；然后当执行到monitorexit 指令时就会将计数器-1</br>
然后当计数器为0时，锁就释放了。2⃣️如果获取锁 失败，那么当前线程就要阻塞等待</br>
直到对象锁被另一个线程释放为止。</br>

<span style="color:#FC5531; font-weight:bold;">问题讨论(面试经)：</span>为啥方法test2中有两个monitorexit？



## 四、源码层面解读synchronize

> 这里我们配合synchronize1.6优化后的，锁升级的过程来探究

### 1、锁状态在markword的布局

![1617267712331](../jvm/assets/1617267712331.png)

### 2、无锁状态

#### a、java代码

~~~java
public class NoLock {
    private static Object o = new Object();
    public static void main(String[] args) {
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
    }
}
~~~

#### b、jol

~~~
java.lang.Object object internals:
 OFFSET  SIZE   TYPE DESCRIPTION VALUE
      0     4   (object header)  01 00 00 00 (00000001 00000000 00000000 00000000) (1)
      4     4   (object header)  00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4   (object header)  dd 01 00 f8 (11011101 00000001 00000000 11111000) (-134217251)
     12     4   (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total
~~~

<span style="color:#FC5531; font-weight:bold;">问题讨论(面试经)：</span>上面布局中，锁标记状态最后两位，为啥打印出来是前两位？
<span style="color:#42B983;font-weight:bold;">解惑 : </span> 大端模式 和 小端模式

总：无锁状态不涉及锁，我们从jol层面理解一下就好，这里不在深究 o.0

### 3、偏向锁状态

#### a、java代码

~~~java
public class DeflectionLock {
    private static Object o = new Object();
//    private static Object o;

    public static void main(String[] args) throws InterruptedException {
//        Thread.sleep(5000);
//        o = new Object();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
        lock();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
    }

    private static void lock() {
        synchronized (o) {

        }
    }
}
~~~

#### b、jol

~~~
java.lang.Object object internals:
 OFFSET  SIZE   TYPE DESCRIPTION VALUE
      0     4  (object header)   05 00 00 00 (00000101 00000000 00000000 00000000) (5)
      4     4  (object header)   00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4  (object header)   dd 01 00 f8 (11011101 00000001 00000000 11111000) (-134217251)
     12     4  (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total

java.lang.Object object internals:
 OFFSET  SIZE   TYPE DESCRIPTION VALUE
      0     4  (object header)   05 50 05 01 (00000101 01010000 00000101 00000001) (17125381)
      4     4  (object header)   00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4  (object header)   dd 01 00 f8 (11011101 00000001 00000000 11111000) (-134217251)
     12     4  (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total
~~~

<span style="color:#FC5531; font-weight:bold;">问题讨论(面试经)：</span>上述代码打印的jol于我们预期的jol不同？</br>
<span style="color:#42B983;font-weight:bold;">解惑 : </span> jdk1.6后默认开启偏向锁（-XX:-UseBiasedLocking = true）输入延迟开启</br>

	   取消延时（XX:BiasedLockingStartUpDelay=0；）</br>

#### c、加锁流程

![img](https://img-blog.csdnimg.cn/20200325162842928.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)



#### d、monitorenter指令源码

~~~c++
'''
//UseHeavyMonitors表示是否只使用重量级锁，默认为false，如果为true则调用InterpreterRuntime::monitorenter方法获取重量级锁
  if (UseHeavyMonitors) {
    call_VM(noreg,CAST_FROM_FN_PTR(address, InterpreterRuntime::monitorenter),
            lock_reg);
  } else {
    Label done;
    '''
     //UseBiasedLocking默认为true
    if (UseBiasedLocking) {
      //首先尝试获取偏向锁，获取成功会跳转到done，否则走到slow_case
      biased_locking_enter(lock_reg, obj_reg, swap_reg, rscratch1, false, done, 			  &slow_case);
    }

~~~

<span style="color:#FC5531; font-weight:bold;">简单说明：</span> 

	1、UseHeavyMonitors：首先判断是否使用重级锁，默认是false；</br>
	
	2、UseBiasedLocking:是否启用偏向锁,1.6以后默认开启,也可关闭(-XX:-UseBiasedLocking = false）</br>
	
	3、biased_locking_enter();该方法用cas将当前线程id刷新到 对象头markword中

### 4、轻量级锁

#### a、java代码

~~~java
public class LightweightLocking {
    private static Object o;
    public static void main(String[] args) throws InterruptedException {
        Thread.sleep(5000L);
        o = new Object();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
        new Thread(LightweightLocking::lock).start();
        // 加个睡眠是怕上面的线程没有执行完成而形成线程争用而升级为重量级锁
        Thread.sleep(3000L);
        lock();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
    }

    private static void lock() {
        synchronized (o) {
            System.out.println(ClassLayout.parseInstance(o).toPrintable());
        }
    }
}
~~~



#### b、jol

> 运行java代码查看，探讨

#### c、monitorenter指令源码

~~~c++
void ObjectSynchronizer::slow_enter(Handle obj, BasicLock* lock, TRAPS) {
  markOop mark = obj->mark();
  assert(!mark->has_bias_pattern(), "should not see bias pattern here");

  if (mark->is_neutral()) {//如果当前是无锁状态, markword的
    //直接把mark保存到BasicLock对象的_displaced_header字段
    lock->set_displaced_header(mark);
    //通过CAS将mark word更新为指向BasicLock对象的指针，更新成功表示获得了轻量级锁
    if (mark == (markOop) Atomic::cmpxchg_ptr(lock, obj()->mark_addr(), mark)) {
      TEVENT (slow_enter: release stacklock) ;
      return ;
    }
    // Fall through to inflate() ...
  } 
  //如果markword处于加锁状态、且markword中的ptr指针指向当前线程的栈帧，表示为重入操作，不需要争抢锁
  else
  if (mark->has_locker() && THREAD->is_lock_owned((address)mark->locker())) {
    assert(lock != mark->locker(), "must not re-lock the same lock");
    assert(lock != (BasicLock*)obj->mark(), "don't relock with same BasicLock");
    lock->set_displaced_header(NULL);
    return;
  }

#if 0
  // The following optimization isn't particularly useful.
  if (mark->has_monitor() && mark->monitor()->is_entered(THREAD)) {
    lock->set_displaced_header (NULL) ;
    return ;
  }
#endif
	//代码执行到这里，说明有多个线程竞争轻量级锁，轻量级锁通过`inflate`进行膨胀升级为重量级锁
  lock->set_displaced_header(markOopDesc::unused_mark());
  ObjectSynchronizer::inflate(THREAD, obj())->enter(THREAD);
}
~~~

<span style="color:#FC5531; font-weight:bold;">简单说明：</span> 

	1、在关闭偏向锁、或多线程竞争是发现偏向锁已经被获取时，就会升级为轻量级锁（自旋锁）
	
	2、Atomic::cmpxchg_ptr：cas修改资源对象markword 中指向当前线程的lockrecord对象

总：当多次(10次,-XX:PreBlockSpin可以修改)cas修改markword指向锁记录的指针失败，就会升级为重量级锁

#### d、加锁流程

![img](https://img-blog.csdnimg.cn/20200325180458220.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### e、解锁流程

![img](https://img-blog.csdnimg.cn/20200325180942827.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

### 5、重量级锁

#### a、java代码

~~~java
public class HeavyweightLock {
    private static Object o;
    public static void main(String[] args) throws InterruptedException {
        Thread.sleep(5000L);
        o = new Object();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
        new Thread(HeavyweightLock::lock).start();
        lock();
        System.out.println(ClassLayout.parseInstance(o).toPrintable());
    }

    private static void lock() {
        synchronized (o) {
            System.out.println(ClassLayout.parseInstance(o).toPrintable());
        }
    }
}
~~~



#### b、jol

> 运行java代码查看，探讨



#### c、指令源码

* 第一段

~~~c++
void ObjectSynchronizer::slow_enter(Handle obj, BasicLock* lock, TRAPS) {
  markOop mark = obj->mark();
  assert(!mark->has_bias_pattern(), "should not see bias pattern here");

  if (mark->is_neutral()) {//如果当前是无锁状态, markword的
    //直接把mark保存到BasicLock对象的_displaced_header字段
    lock->set_displaced_header(mark);
    //通过CAS将mark word更新为指向BasicLock对象的指针，更新成功表示获得了轻量级锁
    if (mark == (markOop) Atomic::cmpxchg_ptr(lock, obj()->mark_addr(), mark)) {
      TEVENT (slow_enter: release stacklock) ;
      return ;
    }
    // Fall through to inflate() ...
  } 
  //如果markword处于加锁状态、且markword中的ptr指针指向当前线程的栈帧，表示为重入操作，不需要争抢锁
  else
  if (mark->has_locker() && THREAD->is_lock_owned((address)mark->locker())) {
    assert(lock != mark->locker(), "must not re-lock the same lock");
    assert(lock != (BasicLock*)obj->mark(), "don't relock with same BasicLock");
    lock->set_displaced_header(NULL);
    return;
  }

#if 0
  // The following optimization isn't particularly useful.
  if (mark->has_monitor() && mark->monitor()->is_entered(THREAD)) {
    lock->set_displaced_header (NULL) ;
    return ;
  }
#endif
	//代码执行到这里，说明有多个线程竞争轻量级锁，轻量级锁通过`inflate`进行膨胀升级为重量级锁
  lock->set_displaced_header(markOopDesc::unused_mark());
  ObjectSynchronizer::inflate(THREAD, obj())->enter(THREAD);
}
~~~

* 第二段

~~~c++
ObjectMonitor * ATTR ObjectSynchronizer::inflate (Thread * Self, oop object) {
  ...

  for (;;) {
      const markOop mark = object->mark() ;
      assert (!mark->has_bias_pattern(), "invariant") ;
    
      // mark是以下状态中的一种：
      // *  Inflated（重量级锁状态）     - 直接返回
      // *  Stack-locked（轻量级锁状态） - 膨胀
      // *  INFLATING（膨胀中）    - 忙等待直到膨胀完成
      // *  Neutral（无锁状态）      - 膨胀
      // *  BIASED（偏向锁）       - 非法状态，在这里不会出现

      // CASE: inflated
      if (mark->has_monitor()) {
          // 已经是重量级锁状态了，直接返回
          ObjectMonitor * inf = mark->monitor() ;
          ...
          return inf ;
      }

      // CASE: inflation in progress
      if (mark == markOopDesc::INFLATING()) {
         // 正在膨胀中，说明另一个线程正在进行锁膨胀，continue重试
         TEVENT (Inflate: spin while INFLATING) ;
         // 在该方法中会进行spin/yield/park等操作完成自旋动作 
         ReadStableMark(object) ;
         continue ;
      }
 
      if (mark->has_locker()) {
          // 当前轻量级锁状态，先分配一个ObjectMonitor对象，并初始化值
          ObjectMonitor * m = omAlloc (Self) ;
          
          m->Recycle();
          m->_Responsible  = NULL ;
          m->OwnerIsThread = 0 ;
          m->_recursions   = 0 ;
          m->_SpinDuration = ObjectMonitor::Knob_SpinLimit ;   // Consider: maintain by type/class
  // 将锁对象的mark word设置为INFLATING (0)状态 
          markOop cmp = (markOop) Atomic::cmpxchg_ptr (markOopDesc::INFLATING(), object->mark_addr(), mark) ;
          if (cmp != mark) {
             omRelease (Self, m, true) ;
             continue ;       // Interference -- just retry
          }

          // 栈中的displaced mark word
          markOop dmw = mark->displaced_mark_helper() ;
          assert (dmw->is_neutral(), "invariant") ;

          // 设置monitor的字段
          m->set_header(dmw) ;
          // owner为Lock Record
          m->set_owner(mark->locker());
          m->set_object(object);
          ...
          // 将锁对象头设置为重量级锁状态
          object->release_set_mark(markOopDesc::encode(m));

         ...
          return m ;
      }

      // CASE: neutral
    
      // 分配以及初始化ObjectMonitor对象
      ObjectMonitor * m = omAlloc (Self) ;
      // prepare m for installation - set monitor to initial state
      m->Recycle();
      m->set_header(mark);
      // owner为NULL
      m->set_owner(NULL);
      m->set_object(object);
      m->OwnerIsThread = 1 ;
      m->_recursions   = 0 ;
      m->_Responsible  = NULL ;
      m->_SpinDuration = ObjectMonitor::Knob_SpinLimit ;       // consider: keep metastats by type/class
  // 用CAS替换对象头的mark word为重量级锁状态
      if (Atomic::cmpxchg_ptr (markOopDesc::encode(m), object->mark_addr(), mark) != mark) {
          // 不成功说明有另外一个线程在执行inflate，释放monitor对象
          m->set_object (NULL) ;
          m->set_owner  (NULL) ;
          m->OwnerIsThread = 0 ;
          m->Recycle() ;
          omRelease (Self, m, true) ;
          m = NULL ;
          continue ;
          // interference - the markword changed - just retry.
          // The state-transitions are one-way, so there's no chance of
          // live-lock -- "Inflated" is an absorbing state.
      }

      ...
      return m ;
  }
}
~~~

* 第三段

~~~c++
void ATTR ObjectMonitor::enter(TRAPS) {
   
  Thread * const Self = THREAD ;
  void * cur ;
  // owner为null代表无锁状态，如果能CAS设置成功，则当前线程直接获得锁
  cur = Atomic::cmpxchg_ptr (Self, &_owner, NULL) ;
  if (cur == NULL) {
     ...
     return ;
  }
  // 如果是重入的情况
  if (cur == Self) {
     // TODO-FIXME: check for integer overflow!  BUGID 6557169.
     _recursions ++ ;
     return ;
  }
  // 当前线程是之前持有轻量级锁的线程。由轻量级锁膨胀且第一次调用enter方法，那cur是指向Lock Record的指针
  if (Self->is_lock_owned ((address)cur)) {
    assert (_recursions == 0, "internal state error");
    // 重入计数重置为1
    _recursions = 1 ;
    // 设置owner字段为当前线程（之前owner是指向Lock Record的指针）
    _owner = Self ;
    OwnerIsThread = 1 ;
    return ;
  }

  ...

  // 在调用系统的同步操作之前，先尝试自旋获得锁
  if (Knob_SpinEarly && TrySpin (Self) > 0) {
     ...
     //自旋的过程中获得了锁，则直接返回
     Self->_Stalled = 0 ;
     return ;
  }

  ...

  { 
    ...

    for (;;) {
      jt->set_suspend_equivalent();
      // 在该方法中调用系统同步操作
      EnterI (THREAD) ;
      ...
    }
    Self->set_current_pending_monitor(NULL);
    
  }

  ...

}
~~~



<span style="color:#FC5531; font-weight:bold;">简单说明：</span> 

1、当代码执行到上述代码的最后两行时，有轻量级锁升级为重量级锁

2、此时引入了“ObjectMonitor“对象

3、膨胀完后再用第三段代码 中的enter方法获得锁

#### d、ObjectMonitor

~~~ c++

ObjectMonitor::ObjectMonitor() {  
  _header       = NULL;  
  _count       = 0;  
  _waiters      = 0,  
  _recursions   = 0;       //线程的重入次数
  _object       = NULL;  
  _owner        = NULL;    //标识拥有该monitor的线程
  _WaitSet      = NULL;    //等待线程组成的双向循环链表，_WaitSet是第一个节点
  _WaitSetLock  = 0 ;  
  _Responsible  = NULL ;  
  _succ         = NULL ;  
  _cxq          = NULL ;    //多线程竞争锁进入时的单向链表
  FreeNext      = NULL ;  
  _EntryList    = NULL ;    //_owner从该双向循环链表中唤���线程结点，_EntryList是第一个节点
  _SpinFreq     = 0 ;  
  _SpinClock    = 0 ;  
  OwnerIsThread = 0 ;  
} 
~~~



#### d、锁膨胀流程

![img](https://img-blog.csdnimg.cn/20200325203025518.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### e、加锁流程

![img](https://img-blog.csdnimg.cn/2020032811351930.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### f、wait流程

~~~c++
  //1.调用ObjectSynchronizer::wait方法
void ObjectSynchronizer::wait(Handle obj, jlong millis, TRAPS) {
  /*省略 */
  //2.获得Object的monitor对象(即内置锁)
  ObjectMonitor* monitor = ObjectSynchronizer::inflate(THREAD, obj());
  DTRACE_MONITOR_WAIT_PROBE(monitor, obj(), THREAD, millis);
  //3.调用monitor的wait方法
  monitor->wait(millis, true, THREAD);
  /*省略*/
}
  //4.在wait方法中调用addWaiter方法
  inline void ObjectMonitor::AddWaiter(ObjectWaiter* node) {
  /*省略*/
  if (_WaitSet == NULL) {
    //_WaitSet为null，就初始化_waitSet
    _WaitSet = node;
    node->_prev = node;
    node->_next = node;
  } else {
    //否则就尾插
    ObjectWaiter* head = _WaitSet ;
    ObjectWaiter* tail = head->_prev;
    assert(tail->_next == head, "invariant check");
    tail->_next = node;
    head->_prev = node;
    node->_next = head;
    node->_prev = tail;
  }
}
  //5.然后在ObjectMonitor::exit释放锁，接着 thread_ParkEvent->park  也就是wait
~~~



![img](https://img-blog.csdnimg.cn/2020032811351930.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### g、notify流程

~~~c++
 //1.调用ObjectSynchronizer::notify方法
    void ObjectSynchronizer::notify(Handle obj, TRAPS) {
    /*省略*/
    //2.调用ObjectSynchronizer::inflate方法
    ObjectSynchronizer::inflate(THREAD, obj())->notify(THREAD);
}
    //3.通过inflate方法得到ObjectMonitor对象
    ObjectMonitor * ATTR ObjectSynchronizer::inflate (Thread * Self, oop object) {
    /*省略*/
     if (mark->has_monitor()) {
          ObjectMonitor * inf = mark->monitor() ;
          assert (inf->header()->is_neutral(), "invariant");
          assert (inf->object() == object, "invariant") ;
          assert (ObjectSynchronizer::verify_objmon_isinpool(inf), "monitor is inva;lid");
          return inf 
      }
    /*省略*/ 
      }
    //4.调用ObjectMonitor的notify方法
    void ObjectMonitor::notify(TRAPS) {
    /*省略*/
    //5.调用DequeueWaiter方法移出_waiterSet第一个结点
    ObjectWaiter * iterator = DequeueWaiter() ;
    //6.后面省略是将上面DequeueWaiter尾插入_EntrySet的操作
    /**省略*/
  }
~~~



![img](https://img-blog.csdnimg.cn/20200328200119362.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### h、解锁流程

![img](https://img-blog.csdnimg.cn/20200328210803767.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

### 6、总述

#### a、整体加锁流程

![img](https://img-blog.csdnimg.cn/2020032320204669.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

#### b、整体解锁流程

![img](https://img-blog.csdnimg.cn/2020032309275286.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMxODY1OTgz,size_16,color_FFFFFF,t_70)

## 五、锁优化

### 1、锁粗化

<span style="color:#FC5531; font-weight:bold;">锁粗化 : </span> 

	如果一系列的连续操作都对同一个对象反复加锁和解锁，甚至加锁操作是出现在循环体中的</br>
	
	那即使没有出现线程竞争，频繁地进行互斥同步操作也会导致不必要的性能损耗。</br>
	
	如果虚拟机检测到有一串零碎的操作都是对同一对象的加锁，将会把加锁同步的范围扩展（粗化）到</br>
	
	整个操作序列的外部。</br>

<span style="color:#FC5531; font-weight:bold;">举栗子</span>

~~~java
public class StringBufferTest {
    StringBuffer stringBuffer = new StringBuffer();

    public void append(){
        stringBuffer.append("a");
        stringBuffer.append("b");
        stringBuffer.append("c");
    }
}
~~~

> 这里每次调用stringBuffer.append方法都需要加锁和解锁，如果虚拟机检测到有一系列连串的对同一个对象加锁和解锁操作，就会将其合并成一次范围更大的加锁和解锁操作，即在第一次append方法时进行加锁，最后一次append方法结束后进行解锁。

### 2、锁消除

<span style="color:#FC5531; font-weight:bold;">锁消除 : </span>

	即删除不必要的加锁操作。虚拟机即时编辑器在运行时，对一些“代码上要求同步</br>
	
	但是被检测到不可能存在共享数据竞争”的锁进行消除。</br>
	
	根据代码<span style="color:#42B983;font-weight:bold;"> 逃逸技术 </span>，如果判断到一段代码中，堆上的数据不会逃逸出当前线程，</br>
	
	那么可以认为这段代码是线程安全的，不必要加锁。</br>

<span style="color:#FC5531; font-weight:bold;">举栗子</span>

~~~java
public class SynchronizedTest {

    public static void main(String[] args) {
        SynchronizedTest test = new SynchronizedTest();

        for (int i = 0; i < 100000000; i++) {
            test.append("abc", "def");
        }
    }

    public void append(String str1, String str2) {
        StringBuffer sb = new StringBuffer();
        sb.append(str1).append(str2);
    }
}
~~~

> 虽然StringBuffer的append是一个同步方法，但是这段程序中的StringBuffer属于一个局部变量，并且不会从该方法中逃逸出去（即StringBuffer sb的引用没有传递到该方法外，不可能被其他线程拿到该引用），所以其实这过程是线程安全的，可以将锁消除。

## 附录

### 解惑

#### 1、大端模式&小段模式

<span style="color:#FC5531; font-weight:bold;">大端模式</span> 是高位字节存储在底地址段，低位字节存储在高地址段</br>
<span style="color:#FC5531; font-weight:bold;">小端模式</span> 是低位字节存储在底地址段，高位字节存储在高地址段</br>

~~~java
0x 00 00 00 00 00 00 00 01 表示MarkWord的8个字节，最左边就是高位字节，最右边就是地位字节
小端模式在内存中存储顺序：
0x 01 00 00 00 00 00 00 00
大端模式在内存中存储顺序:
0x 00 00 00 00 00 00 00 01 
~~~

#### 2、monitorenter指令实现

~~~c++

void TemplateTable::monitorenter() {
  //校验当前指令的栈顶缓存类型是否正确
  transition(atos, vtos);
 
  //校验rax中值是否为空，栈顶缓存就保存在rax寄存器中，如果为NULL会触发底层操作系统的NULL异常
  //此时rax中保存的是用于获取锁的实例oop
  __ null_check(rax);
 
  const Address monitor_block_top(
        rbp, frame::interpreter_frame_monitor_block_top_offset * wordSize);
  const Address monitor_block_bot(
        rbp, frame::interpreter_frame_initial_sp_offset * wordSize);
  const int entry_size = frame::interpreter_frame_monitor_size() * wordSize;
 
  Label allocated;
 
  //xorl用于按位异或，相同的位置为0，不同的位置为1，此处是将c_rarg1置为NULL
  __ xorl(c_rarg1, c_rarg1); // points to free slot or NULL
 
  //找到一个空闲的monitor_block，结果保存在c_rarg1中
  {
    Label entry, loop, exit;
    //将monitor_block_top拷贝到c_rarg3中
    __ movptr(c_rarg3, monitor_block_top); // points to current entry,
                                     // starting with top-most entry
    //将monitor_block_bot拷贝到c_rarg2                             
    __ lea(c_rarg2, monitor_block_bot); // points to word before bottom
                                     // of monitor block
    //跳转到entry标签处执行                     
    __ jmpb(entry);
 
    __ bind(loop);
    //判断c_rarg3指向的BasicObjectLock的obj属性是否为空，如果为空表示未使用
    __ cmpptr(Address(c_rarg3, BasicObjectLock::obj_offset_in_bytes()), (int32_t) NULL_WORD);
    //如果相等，即BasicObjectLock的obj属性为空，则将c_rarg3的值拷贝到c_rarg1
    __ cmov(Assembler::equal, c_rarg1, c_rarg3);
    // 判断c_rarg3指向的BasicObjectLock的obj属性与rax中实例是否一致
    __ cmpptr(rax, Address(c_rarg3, BasicObjectLock::obj_offset_in_bytes()));
    // 如果一致则退出，一致说明BasicObjectLock的obj属性不为空，此时c_rarg1为空，就是重新分配一个新的
    __ jccb(Assembler::equal, exit);
    // 如果不一致则把c_rarg3地址加上entry_size，即开始遍历前面一个monitor_block，即存在空闲的，但是没有obj属性相同的时候会把所有的
    //BasicObjectLock都遍历一遍，找到最上面的地址最大一个空闲的BasicObjectLock
    __ addptr(c_rarg3, entry_size);
    __ bind(entry);
    //判断两个寄存器的值是否相等
    __ cmpptr(c_rarg3, c_rarg2);
    //如果不等于则跳转到loop标签，否则跳转到exit
    __ jcc(Assembler::notEqual, loop);
    __ bind(exit);
  }
   
  //判断c_rarg1是否为空，如果不为空则跳转到allocated处
  __ testptr(c_rarg1, c_rarg1); // check if a slot has been found
  __ jcc(Assembler::notZero, allocated); // if found, continue with that one
 
  //如果没有找到空闲的monitor_block则分配一个
  {
    Label entry, loop;
    // 将monitor_block_bot拷贝到c_rarg1            // rsp: old expression stack top
    __ movptr(c_rarg1, monitor_block_bot); // c_rarg1: old expression stack bottom
    //向下（低地址端）移动rsp指针entry_size字节
    __ subptr(rsp, entry_size);            // move expression stack top
    //将c_rarg1减去entry_size
    __ subptr(c_rarg1, entry_size);        // move expression stack bottom
    //将rsp拷贝到c_rarg3
    __ mov(c_rarg3, rsp);                  // set start value for copy loop
    //将c_rarg1中的值写入到monitor_block_bot
    __ movptr(monitor_block_bot, c_rarg1); // set new monitor block bottom
    //跳转到entry处开始循环
    __ jmp(entry);
    // 2.移动monitor_block_bot到栈顶的数据，将从栈顶分配的一个monitor_block插入到原来的monitor_block_bot下面
    __ bind(loop);
    //将c_rarg3之后的entry_size处的地址拷贝到c_rarg2，即原来的rsp地址
    __ movptr(c_rarg2, Address(c_rarg3, entry_size)); // load expression stack
                                                      // word from old location
    //将c_rarg2中的数据拷贝到c_rarg3处，即新的rsp地址                                                  
    __ movptr(Address(c_rarg3, 0), c_rarg2);          // and store it at new location
    //c_rarg3加上一个字宽，即准备复制下一个字宽的数据
    __ addptr(c_rarg3, wordSize);                     // advance to next word
    __ bind(entry);
    //比较两个寄存器的值
    __ cmpptr(c_rarg3, c_rarg1);            // check if bottom reached
    //如果不等于则跳转到loop
    __ jcc(Assembler::notEqual, loop);      // if not at bottom then
                                            // copy next word
  }
 
  // call run-time routine
  // c_rarg1: points to monitor entry
  __ bind(allocated);
 
  //增加r13，使其指向下一个字节码指令
  __ increment(r13);
 
  //将rax中保存的获取锁的oop保存到c_rarg1指向的BasicObjectLock的obj属性中
  __ movptr(Address(c_rarg1, BasicObjectLock::obj_offset_in_bytes()), rax);
  //获取锁
  __ lock_object(c_rarg1);
 
  //保存bcp，为了出现异常时能够返回到原来的执行位置
  __ save_bcp();  // in case of exception
  __ generate_stack_overflow_check(0);
  
  //恢复字节码指令的正常执行
  //因为上面已经增加r13了，所以此处dispatch_next的第二个参数使用默认值0，即执行r13指向的字节码指令即可，不用跳转到下一个指令
  __ dispatch_next(vtos);
}
 
void InterpreterMacroAssembler::lock_object(Register lock_reg) {
  assert(lock_reg == c_rarg1, "The argument is only for looks. It must be c_rarg1");
 
  //UseHeavyMonitors表示是否只使用重量级锁，默认为false，如果为true则调用InterpreterRuntime::monitorenter方法获取重量级锁
  if (UseHeavyMonitors) {
    call_VM(noreg,
            CAST_FROM_FN_PTR(address, InterpreterRuntime::monitorenter),
            lock_reg);
  } else {
    Label done;
 
    const Register swap_reg = rax; // Must use rax for cmpxchg instruction
    const Register obj_reg = c_rarg3; // Will contain the oop
 
    const int obj_offset = BasicObjectLock::obj_offset_in_bytes();
    const int lock_offset = BasicObjectLock::lock_offset_in_bytes ();
    const int mark_offset = lock_offset +
                            BasicLock::displaced_header_offset_in_bytes();
 
    Label slow_case;
    
    //进入此方法目标obj要么是无锁状态，要么是对同一个对象的synchronized嵌套情形下的有锁状态
    //将用于获取锁的实例oop拷贝到obj_reg中
    movptr(obj_reg, Address(lock_reg, obj_offset));
    
    //UseBiasedLocking默认为true
    if (UseBiasedLocking) {
      //首先尝试获取偏向锁，获取成功会跳转到done，否则走到slow_case
      biased_locking_enter(lock_reg, obj_reg, swap_reg, rscratch1, false, done, &slow_case);
    }
    
    //如果UseBiasedLocking为false或者目标对象的锁不是偏向锁了会走此逻辑
    movl(swap_reg, 1);
 
    //计算 object->mark() | 1，结果保存到swap_reg，跟1做或运算将其标记为无锁状态
    orptr(swap_reg, Address(obj_reg, 0));
 
    //将(object->mark() | 1)的结果保存到BasicLock的displaced_header中，保存原来的对象头
    movptr(Address(lock_reg, mark_offset), swap_reg);
 
    //lock_reg即是里面的lock属性的地址
    assert(lock_offset == 0,
           "displached header must be first word in BasicObjectLock");
 
    if (os::is_MP()) lock(); //如果是多核系统，通过lock指令保证cmpxchgp的操作是原子的，即只可能有一个线程操作obj对象头
    //将obj的对象头同rax即swap_reg比较，如果相等将lock_reg写入obj对象头，即lock属性写入obj对象头，如果不等于则将obj对象头放入rax中
    cmpxchgptr(lock_reg, Address(obj_reg, 0));
    if (PrintBiasedLockingStatistics) {
      //增加计数器
      cond_inc32(Assembler::zero,
                 ExternalAddress((address) BiasedLocking::fast_path_entry_count_addr()));
    }
    //如果等于，说明obj的对象头是无锁状态的，此时跟1做或运算，结果不变
    jcc(Assembler::zero, done);
    
    //如果不等于，说明obj的对象头要么是偏向锁，要么是重量级锁，多线程下可能其他线程已经获取了该对象的轻量级锁
    //下面的汇编指令相当于执行如下判断，判断目标对应的对象头是否属于当前调用栈帧，如果是说明还是当前线程占有该轻量级锁，如果不是则说明其他线程占用了轻量级锁或者已经膨胀成重量级锁
    //  1) (mark & 7) == 0, and
    //  2) rsp <= mark < mark + os::pagesize()
    subptr(swap_reg, rsp);
    andptr(swap_reg, 7 - os::vm_page_size());
 
    //在递归即synchronized嵌套使用的情形下，上述指令计算的结果就是0
    //当BasicLock的displaced_header置为NULL
    movptr(Address(lock_reg, mark_offset), swap_reg);
    if (PrintBiasedLockingStatistics) {
      //增加计数器
      cond_inc32(Assembler::zero,
                 ExternalAddress((address) BiasedLocking::fast_path_entry_count_addr()));
    }
    //如果andptr的结果为0，说明当前线程已经获取了轻量级锁则跳转到done
    jcc(Assembler::zero, done);
    //否则执行InterpreterRuntime::monitorenter将轻量级锁膨胀成重量级锁或者获取重量级锁
    bind(slow_case);
 
    // Call the runtime routine for slow case
    call_VM(noreg,
            CAST_FROM_FN_PTR(address, InterpreterRuntime::monitorenter),
            lock_reg);
 
    bind(done);
  }
}
~~~

#### 3、monitorexit指令实现

~~~c++
void TemplateTable::monitorexit() {
  //检查栈顶缓存的类型是否正确
  transition(atos, vtos);
 
  //检查rax包含的跟锁关联的对象oop是否为空
  __ null_check(rax);
 
  const Address monitor_block_top(
        rbp, frame::interpreter_frame_monitor_block_top_offset * wordSize);
  const Address monitor_block_bot(
        rbp, frame::interpreter_frame_initial_sp_offset * wordSize);
  const int entry_size = frame::interpreter_frame_monitor_size() * wordSize;
 
  Label found;
 
  // find matching slot
  {
    Label entry, loop;
    //把monitor_block_top拷贝到c_rarg1
    __ movptr(c_rarg1, monitor_block_top); // points to current entry,
                                     // starting with top-most entry
    //把monitor_block_bot拷贝到c_rarg2                    
    __ lea(c_rarg2, monitor_block_bot); // points to word before bottom
                                     // of monitor block
    __ jmpb(entry);
 
    __ bind(loop);
    //比较rax中对象oop与obj属性是否一致
    __ cmpptr(rax, Address(c_rarg1, BasicObjectLock::obj_offset_in_bytes()));
    //如果一致则表示找到了跳转到found
    __ jcc(Assembler::equal, found);
    //如果没有找到则增加entry_size，即开始遍历前面一个BasicObjectLock
    __ addptr(c_rarg1, entry_size);
    __ bind(entry);
    //比较这两个是否相等，如果相等表示遍历完成
    __ cmpptr(c_rarg1, c_rarg2);
    //如果不等则跳转到loop标签
    __ jcc(Assembler::notEqual, loop);
  }
 
  //没有在当前线程的栈帧中找到关联的BasicObjectLock，抛出异常
  __ call_VM(noreg, CAST_FROM_FN_PTR(address,
                   InterpreterRuntime::throw_illegal_monitor_state_exception));
  __ should_not_reach_here();
 
  // call run-time routine
  // rsi: points to monitor entry
  __ bind(found);
  //将这个锁对象放入栈帧中
  __ push_ptr(rax); // make sure object is on stack (contract with oopMaps)
  //执行解锁逻辑
  __ unlock_object(c_rarg1);
  //从栈帧中弹出锁对象
  __ pop_ptr(rax); // discard object
}
 
void InterpreterMacroAssembler::unlock_object(Register lock_reg) {
  assert(lock_reg == c_rarg1, "The argument is only for looks. It must be rarg1");
 
  if (UseHeavyMonitors) {
    //如果只使用重量级锁，UseHeavyMonitors默认为false
    call_VM(noreg,
            CAST_FROM_FN_PTR(address, InterpreterRuntime::monitorexit),
            lock_reg);
  } else {
    Label done;
 
    const Register swap_reg   = rax;  // Must use rax for cmpxchg instruction
    const Register header_reg = c_rarg2;  // Will contain the old oopMark
    const Register obj_reg    = c_rarg3;  // Will contain the oop
 
    save_bcp(); //保存bcp，方便解锁异常时回滚
 
    //将lock属性的地址复制到swap_reg
    lea(swap_reg, Address(lock_reg, BasicObjectLock::lock_offset_in_bytes()));
 
    //将obj属性复制到obj_reg
    movptr(obj_reg, Address(lock_reg, BasicObjectLock::obj_offset_in_bytes()));
 
    //将obj属性置为NULL
    movptr(Address(lock_reg, BasicObjectLock::obj_offset_in_bytes()), (int32_t)NULL_WORD);
 
    if (UseBiasedLocking) {
      //如果持有偏向锁，则解锁完成后跳转到done
      biased_locking_exit(obj_reg, header_reg, done);
    }
 
    //将BasicLock的displaced_header属性复制到header_reg中，即该对象原来的对象头
    movptr(header_reg, Address(swap_reg,
                               BasicLock::displaced_header_offset_in_bytes()));
 
    //判断这个是否为空
    testptr(header_reg, header_reg);
 
    //如果为空说明这是对同一目标对象的synchronized嵌套情形，则跳转到done，等到外层的synchronized解锁恢复目标对象的对象头
    jcc(Assembler::zero, done);
 
    // Atomic swap back the old header
    if (os::is_MP()) lock();//如果是多核系统则通过lock指令前缀将cmpxchg变成一个原子操作，即只能有一个线程同时操作obj的对象头
    //将obj的对象头同rax即swap_reg，即lock属性地址比较，如果相等把header_reg写入到obj的对象头中即恢复对象头，如果不等把obj对象头写入rax中
    cmpxchgptr(header_reg, Address(obj_reg, 0));
 
    //如果相等，说明还是轻量级锁，解锁完成
    jcc(Assembler::zero, done);
 
    //如果不等于，说明轻量级锁被膨胀成重量级锁，恢复obj属性，因为上面将该属性置为NULL
    movptr(Address(lock_reg, BasicObjectLock::obj_offset_in_bytes()),
         obj_reg); // restore obj
    //调用InterpreterRuntime::monitorexit，完成重量级锁退出     
    call_VM(noreg,
            CAST_FROM_FN_PTR(address, InterpreterRuntime::monitorexit),
            lock_reg);
 
    bind(done);
    //恢复bcp
    restore_bcp();
  }
}
 
//偏向锁的解锁只是判断目标对象是否持有偏向锁，如果持有就跳转到done，没有实际的解锁动作
void MacroAssembler::biased_locking_exit(Register obj_reg, Register temp_reg, Label& done) {
  assert(UseBiasedLocking, "why call this otherwise?");
  //将obj的对象头拷贝到temp_reg
  movptr(temp_reg, Address(obj_reg, oopDesc::mark_offset_in_bytes()));
  //将对象头指针同biased_lock_mask_in_place求且
  andptr(temp_reg, markOopDesc::biased_lock_mask_in_place);
  //判断且运算后的结果是否是5
  cmpptr(temp_reg, markOopDesc::biased_lock_pattern);
  //如果相等则跳转到done
  jcc(Assembler::equal, done);
}
~~~

#### 4、自适应的自旋锁

* 简述

  JDK1.6引入自适应的自旋锁，自适应就意味着自旋的次数不再是固定的，它是由前一次在同一个锁上的自旋时间及锁的拥有者的状态来决定：如果在同一个锁的对象上，自旋等待刚刚成功获得过锁，并且持有锁的线程正在运行中，那么虚拟机就会认为这次自旋也很有可能再次成功，进而它将允许自旋等待持续相对更长的时间。如果对于某个锁，自旋很少成功获得过，那在以后要获取这个锁时将可能省略掉自旋过程，以避免浪费处理器资源。简单来说，就是线程如果自旋成功了，则下次自旋的次数会更多，如果自旋失败了，则自旋的次数就会减少。

* 场景

  从轻量级锁获取的流程中我们知道，当线程在获取轻量级锁的过程中执行CAS操作失败时，是要通过自旋来获取重量级锁的。（见前面“轻量级锁”）

### 参考

[深入理解synchronized底层源码，小白这篇足够了_MarkJava-CSDN博客](https://blog.csdn.net/realize_dream/article/details/106968443)

[深入OpenJDK源码核心探秘Unsafe(含JNI完整使用流程)_黄智霖的博客-CSDN博客](https://blog.csdn.net/huangzhilin2015/article/details/101158137)

[synchronized的锁升级过程和详细的代码演示_killerofjava的博客-CSDN博客](https://blog.csdn.net/killerofjava/article/details/112445366)

[Hotspot synchronized与volatile关键字实现（一） 源码解析_菜鸟进阶之路-CSDN博客](https://blog.csdn.net/qq_31865983/article/details/104875342)

[Hotspot 三种锁实现总结_菜鸟进阶之路-CSDN博客](https://blog.csdn.net/qq_31865983/article/details/105024397)

[死磕Synchronized底层实现--重量级锁-Java架构笔记-51CTO博客](https://blog.51cto.com/14440216/2427707?source=dra)

