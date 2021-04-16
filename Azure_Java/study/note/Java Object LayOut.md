



# Java Object LayOut

> 本文所有内容基于: 	<span style="color:#42B983;font-weight:bold;">HotSpot    jdk1.8</span>	
>
> 时间：<span style="color:#42B983;font-weight:bold;">2021年3月26日12:31:52</span>

## 一、简述

在 <span style="color:#42B983;font-weight:bold;">HotSpot</span>虚拟机中
对象在内存中的存储分为三块区域：<span style="color:#FC5531; font-weight:bold;">对象头（Header）</span>、<span style="color:#FC5531; font-weight:bold;">实例数据（Instance Data）</span>、<span style="color:#FC5531; font-weight:bold;">对齐填充（Padding）</span>

![1617109250439](assets/\1617109250439.png)

---

* 对象头

  对象头(12个字节)主要分为两部分：

  <span style="color:#FC5531; font-weight:bold;">markWord ：</span> 占4个字节，主要描述：哈希码、gc分代年龄、锁状态标志、线程持有的锁、偏向线程id等。

  ~~~c++
  class markOopDesc: public oopDesc {
   private:
    // Conversion
    uintptr_t value() const { return (uintptr_t) this; }
   public:
    // Constants
    enum { age_bits                 = 4,  //分代年龄
           lock_bits                = 2, //锁标识
           biased_lock_bits         = 1, //是否为偏向锁
           max_hash_bits            = BitsPerWord - age_bits - lock_bits - biased_lock_bits,
           hash_bits                = max_hash_bits > 31 ? 31 : max_hash_bits, //对象的hashcode
           cms_bits                 = LP64_ONLY(1) NOT_LP64(0),
           epoch_bits               = 2 //偏向锁的时间戳
    };
  ~~~



  <span style="color:#FC5531; font-weight:bold;">Class对象指针：</span> 占8个字节，主要描述：</br>

  * 普通对象：对象类型指针  <span style="color:#FC5531; font-weight:bold;">注</span>：<span style="color:#42B983;font-weight:bold;">对象定位方式</span>  和  <span style="color:#42B983;font-weight:bold;">指针压缩</span>  问题 </br>
  * 数组：数组元素类型指针 & 数组长度</br>

---

* 实例数据

  实例数据部分就是成员变量的值：<span style="color:#42B983;font-weight:bold;">基本变量</span> & <span style="color:#42B983;font-weight:bold;">引用变量</span>。

  * 基本变量：八种基本类型成员变量
  * 引用变量：存放类的引用变量句柄，如String,Object每个句柄大小在32位虚拟机上是4byte，64位虚拟机上是8byte，但java8开始默认开启UseCompressedOops压缩参数，故也是4byte,classpoint也是如此；

  <span style="color:#FC5531; font-weight:bold;">注：</span>其中包括父类成员变量和本类成员变量

---

* 对齐填充

  用于确保对象的总长度为 8 字节的整数倍。

  HotSpot VM 的自动内存管理系统要求对象的大小必须是 8 字节的整数倍。

  而对象头部分正好是 8 字节的倍数（1 倍或 2 倍），因此，当对象实例数据部分没有对齐时，

  就需要通过对齐填充来补全。

  > 对齐填充并不是必然存在，也没有特别的含义，它仅仅起着占位符的作用。

---



## 二 、详释

> 实例数据 和 对齐填充 没有什么好说的，这里我们一起来看一下对象头（markWord & 实例数据）
>
> mark word的位长度为JVM的一个Word大小，也就是说32位JVM的Mark word为32位，64位JVM为64位。

### 1、MarkWord

* 32位对象头markword

<table>
	<tr>
	    <th rowspan="2">锁状态</th>
	    <th colspan="2">25bit</th>  
        <th rowspan="2">4bit</th>
	    <th rowspan="2">1bit(是否偏向锁)</th>
	    <th rowspan="2">2bit(锁标志位)</th>  
	</tr >
	<tr >
	    <td>23bit</td>
	    <td>2bit</td>
	</tr>
    <tr >
	    <td>无锁</td>
	    <td colspan="2">对象hashCode</td>
        <td>分代年龄</td>
	    <td>0</td>
	    <td>01</td>
	</tr>
    <tr >
	    <td>偏向锁</td>
	    <td>(锁偏向的线程id)</td>
	    <td>Epoch</td>
        <td>对象分代年龄</td>
	    <td>1</td>
	    <td>01</td>
	</tr>
    <tr >
	    <td>轻量级</td>
	    <td colspan="4">指向栈中锁记录的指针</td>
	    <td>00</td>
	</tr>
    <tr >
	    <td>重量级</td>
	    <td colspan="4">指向重量级锁的指针</td>
	    <td>10</td>
	</tr>
    <tr >
	    <td>GC标记</td>
	    <td colspan="4">空</td>
	    <td>11</td>
	</tr>
</table>

* 64位对象头markword

<table>
	<tr>
	    <th align="center" rowspan="2" >锁状态</th>
	    <th align="center" colspan="2">56bit</th>  
        <th align="center" rowspan="2">1bit</th>
	    <th align="center" rowspan="2">4bit</th>
	    <th align="center" rowspan="2">1bit(是否偏向锁)</th>
        <th align="center" rowspan="2">2bit(锁标志位)</th>
	</tr >
	<tr >
	    <td align="center">25bit</td>
	    <td align="center">31bit</td>
	</tr>
    <tr >
	    <td align="center">无锁</td>
        <td align="center">unused</td>
	    <td align="center">对象hashCode</td>
        <td align="center">cms_free</td>
        <td align="center">分代年龄</td>
	    <td align="center">0</td>
	    <td align="center">01</td>
	</tr>
    <tr >
	    <td align="center">偏向锁</td>
	    <td align="center">(锁偏向的线程id)</td>
	    <td align="center">Epoch</td>
        <td align="center">cms_free</td>
        <td align="center">对象分代年龄</td>
	    <td align="center">1</td>
	    <td align="center">01</td>
	</tr>
    <tr >
	    <td align="center">轻量级</td>
	    <td align="center" colspan="5">指向栈中锁记录的指针</td>
	    <td align="center">00</td>
	</tr>
    <tr >
	    <td align="center">重量级</td>
	    <td align="center" colspan="5">指向重量级锁的指针</td>
	    <td align="center">10</td>
	</tr>
    <tr >
	    <td align="center">GC标记</td>
	    <td align="center" colspan="5">空</td>
	    <td align="center">11</td>
	</tr>
</table>

>  <span style="color:#FC5531; font-weight:bold;">注</span>：这里锁升级（锁膨胀）、锁消除、锁粗化不做讨论，放在synchronize原理中讲解

* 问题讨论

  jvm对内存，对象年龄到15就会被移入老年代，那调优jvm是不是可以调大这个年龄？</br>

  调优参数-XX:MaxTenuringThreshold</br>

### 2、class类指针

> class类指针 即：类型指针，通过该指针能确定对象属于哪个类。如果对象是一个数组，那么对象头还会包括数组长度。

* 指针压缩

  指针：对象指向它的类元数据的指针，虚拟机通过这个指针来确定这个对象是哪个类的实例。</br>

   这部分就涉及到一个指针压缩的概念，在开启指针压缩的情况下，占4字节（32bit）</br>

  未开启情况下，占8字节（64bit），现在JVM在1.6之后，在64位操作系统下都是默认开启的。</br>

  * 未开启指针压缩

  ![1617246983290](assets/\1617246983290.png)



  ![1617247062129](assets\1617247062129.png)

  采用8字节（64位）存储真实内存地址，比之前采用4字节（32位）压缩存储地址带来的问题：</br>

  1. <span style="color:#FC5531; font-weight:bold;">增加了GC开销</span>：64位对象引用需要占用更多的堆空间，留给其他数据的空间将会减少，</br>

     从而加快了GC的发生，更频繁的进行GC。</br>

  2. <span style="color:#FC5531; font-weight:bold;">降低CPU缓存命中率</span>：64位对象引用增大了,CPU能缓存的oop将会更少,从而降低了CPU缓存的效率。</br>



  * 开启指针压缩

  ![1617246963007](assets\1617246963007.png)

![1617247316252](assets\1617247316252.png)

4个字节，32位，可以表示232 个地址，如果这个地址是真实内存地址的话，</br>
那么由于CPU寻址的最小单位是byte，也就是 232 byte = 4GB。</br>
如果内存地址是指向 bit的话，32位的最大寻址范围其实是 512MB，但是由于内存里，将8bit为一组划分，</br>
所以内存地址就其实是指向的8bit为一组的byte地址，所以32位可以表示的容量就扩充了8倍，</br>
就变成了4GB。</br>

将java堆内存进行8字节划分</br>

java对象的指针地址就可以不用存对象的真实的64位地址了，而是可以存一个映射地址编号。</br>
这样4字节就可以表示出2^32个地址，而每一个地址对应的又是8byte的内存块。</br>
所以，再乘以8以后，一换算，就可以表示出32GB的内存空间。</br>

### 3、实例数据

> 基本变量这里不再讨论，这里涉及到对象的访问方式：<span style="color:#42B983;font-weight:bold;">句柄访问</span> & <span style="color:#42B983;font-weight:bold;">指针访问</span>

* 句柄访问

  堆中需要有一块叫做“句柄池”的内存空间，句柄中包含了对象实例数据与类型数据各自的具体地址信息。

  引用类型的变量存放的是该对象的句柄地址（reference）。访问对象时，首先需要通过引用类型的变量找到该对象的句柄，然后根据句柄中对象的地址找到对象。

![1617246273983](assets\1617246273983.png)

* 指针访问

  引用类型的变量直接存放对象的地址，从而不需要句柄池，通过引用能够直接访问对象。但对象所在的内存空间需要额外的策略存储对象所属的类信息的地址。

  ![1617246318399](assets\1617246318399.png)

<span style="color:#FC5531; font-weight:bold;">注</span>：HotSpot 采用第二种方式，即直接指针方式来访问对象，只需要一次寻址操作，所以在性能上比句柄访问方式快一倍。但像上面所说，它需要**额外的策略**来存储对象在方法区中类信息的地址。

## 三、实例说明

### 1、引入JOL辅助依赖

~~~xml
<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.9</version>
</dependency>
~~~



### 2、obj说明类

* learner类

~~~java
public class JolLearn {
    public static void main(String[] args) {
        /**
         *  User对象的布局
         *
         *
         *
         *         --   +-------------+--------------------------------+
         *        |     |   markword  |   8字节 (synchronized 信息在这里 |
         * 对象头 {      +-------------+--------------------------------+
         *        \     |class pointer|   开启ccp4字节，不开启8字节       |
         *         --   +-------------+--------------------------------+
         *              |instant data |   具体分析：int 4字节。。。       |
         *              +-------------+--------------------------------+
         *              |   padding   |   总字节数被8整除，否则补齐       |
         *              +-------------+--------------------------------+
         *
         *  Q:
         *      1、
         */
        User_NoVal user_NoVal = new User_NoVal();
        User_HaveVal user_HaveVal = new User_HaveVal();

        // 普通对象:无成员变量时的对象布局
        System.out.println(ClassLayout.parseInstance(user_NoVal).toPrintable());

        // 普通对象:有成员变量时的对象布局
        System.out.println(ClassLayout.parseInstance(user_HaveVal).toPrintable());

        // 普通对象：无成员变量 有synchronized 信息时的对象布局
        /*synchronized(user_NoVal){
            System.out.println(ClassLayout.parseInstance(user_NoVal).toPrintable());
        }*/
    }
}
~~~

* 有成员变量（hava_val）类

~~~java
class User_HaveVal{
    // 4个字节
    private int id;
    // 开启普通指针压缩的情况下 4个字节
    private String name;
}
~~~

* 无成员变量（  no_val  ）类

~~~java
class User_NoVal{

}
~~~



## 附录

### 参考

[聊一聊JAVA指针压缩的实现原理（图文并茂，让你秒懂）_liujianyangbj的博客-CSDN博客_指针压缩](https://blog.csdn.net/liujianyangbj/article/details/108049482)

https://github.com/doocs/jvm/blob/main/docs/02-hotspot-jvm-object.md

[java byte object的子类_Java对象布局(JOL)实现过程解析_王若然的博客-CSDN博客](https://blog.csdn.net/weixin_31458015/article/details/114184239)
