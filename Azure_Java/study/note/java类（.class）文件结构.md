# java类（.class）文件结构

>Class文件结构是了解虚拟机的重要基础之一，如果想深入的了解虚拟机，Class文件结构是不能不了解的。
>
>时间：<span style="color:#42B983;font-weight:bold;">2021年3月29日14:48:33</span>

## 一 、概述

Class文件格式只有两种数据类型：<span style="color:#FC5531; font-weight:bold;">无符号数</span>  和  <span style="color:#FC5531; font-weight:bold;">表</span>。

* <span style="color:#42B983; font-weight:bold;">无符号数 : </span>

   属于基本的数据类型，以

   u1 ：代表1个字节
   u2 ：代表2个字节
   u4 ：代表4个字节
   u8 ：代表8个字节  的无符号数；

  可用来描述数字，索引引用，数量值或者按照UTF-8编码构成的字符串值

* <span style="color:#42B983; font-weight:bold;">表 : </span>

  	由多个无符号数或者其他表作为数据项构成的复合数据类型，所有表都习惯性地以 <span style="color:#FC5531; font-weight:bold;">“_info”</span> 结尾。

  表用于描述由层次关系的复合结构的数据，整个Class文件本质上就是一张表

## 二、class文件内容

class文件内容：

<span style="color:#42B983; font-weight:bold;">			魔数、次版本号、主版本号、常量池计数器、常量池、访问标志、类索引、父类索引、接口计数器 </span></br>

<span style="color:#42B983; font-weight:bold;">接口索引集合，字段计数器、字段表集合、方法计数器、方法表集合、属性计数器、属性表集合</span></br>

具体表现形式：

![](assets\20170923072656258.png)

## 三、魔数与class文件版本

* <span style="color:#42B983; font-weight:bold;">魔数 : </span>

  Class 文件的头 4 个字节称为魔数，用来表示这个 Class 文件的类型</br>

  Class 文件的魔数是用 16 进制表示的“CAFE BABE”，是不是很具有浪漫色彩？</br>

  ![1617009147770](assets\1617009147770.png)

> 魔数相当于文件后缀名，只不过后缀名容易被修改，不安全，因此在 Class 文件中标识文件类型比较合适。



* <span style="color:#42B983; font-weight:bold;">class文件版本 : </span></br>

  **紧接着魔数的4个字节是Class文件的版本号**：</br>

  第5,6字节是次版本号（Minor Version）</br>

  第7,8字节是主版本号（Major Version）</br>

  ![1617009187240](assets\1617009187240.png)

> 如上例：0x00000034  十进制版本代号：52.0 即jdk1.8.0


## 四、常量池

### 1、简述

版本信息之后就是常量池，常量池中存放两种类型的常量：</br>

<span style="color:#42B983; font-weight:bold;">字面值常量 : </span></br>

	<span style="color:#FC5531; font-weight:bold;">字面值常量就是我们在程序中定义的字符串、被 final 修饰的值。</span></br>

<span style="color:#42B983; font-weight:bold;">符号引用 : </span></br>

	<span style="color:#FC5531; font-weight:bold;">符号引用就是我们定义的各种名字：类和接口的全限定名、字段的名字和描述符、方法的名字和描述符。</span></br>

### 2、常量池特点

- 常量池中常量数量不固定，因此常量池开头放置一个 u2 类型的无符号数，用来存储当前常量池的容量。

- ![1617009213111](assets\1617009213111.png)

  > 一个U2无符号数：0X00 12  代表十进制常量个数:1*16 +2 -1 =17个
  >
  > <span style="color:#FC5531; font-weight:bold;">注：</span>这里说有17个常量，不是指往后数17个字节都是常量，<span style="color:#FC5531; font-weight:bold;">切记常量的个数是从1计数的</span>

- 常量池的每一项常量都是一个表，表开始的第一位是一个 u1 类型的标志位（tag），代表当前这个常量属于哪种常量类型。

![1617009295970](assets\1617009295970.png)

> 一个U1无符号数：0X0A  表示第一个常量的tag 
>
> 即：tag=10 表示：CONSTANT_Methodref_info类中方法的符号引用

![1617006769949](assets\1617006769949.png)

> 上表详见：常量类型结构
>
> 故：该常量由：U1_tag，U2_index，U2_index组成 ：0x 0A 00 03 00 0F
>
> ![1617009332453](assets\1617009332453.png)

### 3、常量池类型

| 类型                             | tag  | 描述                   |
| -------------------------------- | ---- | ---------------------- |
| CONSTANT_utf8_info               | 1    | UTF-8 编码的字符串     |
| CONSTANT_Integer_info            | 3    | 整型字面量             |
| CONSTANT_Float_info              | 4    | 浮点型字面量           |
| CONSTANT_Long_info               | 5    | 长整型字面量           |
| CONSTANT_Double_info             | 6    | 双精度浮点型字面量     |
| CONSTANT_Class_info              | 7    | 类或接口的符号引用     |
| CONSTANT_String_info             | 8    | 字符串类型字面量       |
| CONSTANT_Fieldref_info           | 9    | 字段的符号引用         |
| CONSTANT_Methodref_info          | 10   | 类中方法的符号引用     |
| CONSTANT_InterfaceMethodref_info | 11   | 接口中方法的符号引用   |
| CONSTANT_NameAndType_info        | 12   | 字段或方法的符号引用   |
| CONSTANT_MethodHandle_info       | 15   | 表示方法句柄           |
| CONSTANT_MethodType_info         | 16   | 标识方法类型           |
| CONSTANT_InvokeDynamic_info      | 18   | 表示一个动态方法调用点 |

### 4、常量类型结构表

![](assets\20180306173808622.png)

![](assets\20180306173826647.png)

## 五、访问标志

> <span style="color:#42B983;font-weight:bold;">访问标志 ：</span>在常量池结束之后，紧接着的两个字节代表访问标志，这个标志用于识别一些类或者接口层次的访问信息，包括：这个 Class 是类还是接口；是否定义为 public 类型；是否被 abstract/final 修饰

![](assets\20180306174116287.png)

在本例中：0x00 21 == 0x0001|0x0020表示是一个用户定义的public类

![1617009937871](assets\1617009937871.png)

## 六、索引

> <span style="color:#42B983;font-weight:bold;">索引：</span> <span style="color:#FC5531; font-weight:bold;">类索引、父类索引</span> 和 <span style="color:#FC5531; font-weight:bold;">接口索引集合</span>

访问标志符紧接着的二进制表示本例中类的继承关系，共三项

###  <span style="color:#FC5531; font-weight:bold;">1、类索引</span>

U2 两个字节，常量池中的对本类的描述

![1617073926069](assets\1617073926069.png)

> 0x0002 表示常量池中第2个常量为类索引

### <span style="color:#FC5531; font-weight:bold;">2、父类索引</span>

U2 两个字节，常量池中对父类的描述

![1617073968982](assets\1617073968982.png)

> 0x0003 表示常量池中第3个常量为类索引

### <span style="color:#FC5531; font-weight:bold;">3、接口索引 、</span> <span style="color:#FC5531; font-weight:bold;border-bottom:1px dashed #000; height:50px;width:350px">接口索引集合</span>

头两个字节表示接口数，然后，紧跟进接口列表

![1617073986457](assets\1617073986457.png)

> 0x0000表示实现的接口个数为0个,也就没有接口索引集合了

## 七、字段表集合

接着的二进制表示字段表，头两位为个数，个数后边是字段内容

### <span style="color:#42B983;font-weight:bold;">1、字段描述规则：</span>

![1617074278474](assets\1617074278474.png)

###  <span style="color:#42B983;font-weight:bold;">2、access_flags的取值表：</span>

![1617074310253](assets\1617074310253.png)

###  <span style="color:#42B983;font-weight:bold;">3、name_index</span>

	name_index的含义，同上，映射至常量池中的常量索引

### <span style="color:#42B983;font-weight:bold;">4、descriptor_index</span>

	descriptor_index，描述符，表示该变量的类型，此处插一下描述符的表示规则：
	
	 4.1 描述符中的字符含义如下：

![1617074550746](assets\1617074550746.png)

	4.2 表示数组时，每一个维度前用“[”表示
	
	4.3 描述方法，先参后返回值

### <span style="color:#42B983;font-weight:bold;">5、本例字段</span>

* 字段计数

  ![1617074730851](assets\1617074730851.png)

  > 0x0001 表示只有一个字段

* 字段内容

  ![1617074804975](assets\1617074804975.png)

  > 0x0002000400050000表示：0002(private)00040005(查看第四、第五常量)0000(attributes_count)

## 八、方法表集合

接着的二进制表示方法表，头两位为个数

### <span style="color:#42B983;font-weight:bold;">1、方法描述规则：</span>

![1617089287926](assets\1617089287926.png)

### <span style="color:#42B983;font-weight:bold;">2、access_flags的取值表：</span>

![1617089281407](assets\1617089281407.png)

### <span style="color:#42B983;font-weight:bold;">3、本例方法</span>

* 方法计数器

![1617089527090](assets\1617089527090.png)

> 0x0001 表示本例中方法个数为1

![1617090818887](assets\1617090818887.png)

> 0x0001 表示方法为public   

> 0x0006 表示常量池中第六个常量   : 表示初始化方法（构造器）

![1617090950717](assets\1617090950717.png)

> 0x0007 表示常量池中第七个常量 ：依据“描述字符含义表” v 为void返回值

![1617090991978](assets\1617090991978.png)

## 九、属性表集合



## 十、附录

### 1、java类

~~~java
package site.ryanc;

public class User {
    private String name;
}
~~~

### 2、class文件

~~~java
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package site.ryanc;

public class User {
    private String name;

    public User() {
    }
}
~~~



### 3、class二进制文件

~~~txt
			0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
00000000h: CA FE BA BE 00 00 00 34 00 12 0A 00 03 00 0F 07 ; 漱壕...4........
00000010h: 00 10 07 00 11 01 00 04 6E 61 6D 65 01 00 12 4C ; ........name...L
00000020h: 6A 61 76 61 2F 6C 61 6E 67 2F 53 74 72 69 6E 67 ; java/lang/String
00000030h: 3B 01 00 06 3C 69 6E 69 74 3E 01 00 03 28 29 56 ; ;...<init>...()V
00000040h: 01 00 04 43 6F 64 65 01 00 0F 4C 69 6E 65 4E 75 ; ...Code...LineNu
00000050h: 6D 62 65 72 54 61 62 6C 65 01 00 12 4C 6F 63 61 ; mberTable...Loca
00000060h: 6C 56 61 72 69 61 62 6C 65 54 61 62 6C 65 01 00 ; lVariableTable..
00000070h: 04 74 68 69 73 01 00 11 4C 73 69 74 65 2F 72 79 ; .this...Lsite/ry
00000080h: 61 6E 63 2F 55 73 65 72 3B 01 00 0A 53 6F 75 72 ; anc/User;...Sour
00000090h: 63 65 46 69 6C 65 01 00 09 55 73 65 72 2E 6A 61 ; ceFile...User.ja
000000a0h: 76 61 0C 00 06 00 07 01 00 0F 73 69 74 65 2F 72 ; va........site/r
000000b0h: 79 61 6E 63 2F 55 73 65 72 01 00 10 6A 61 76 61 ; yanc/User...java
000000c0h: 2F 6C 61 6E 67 2F 4F 62 6A 65 63 74 00 21 00 02 ; /lang/Object.!..
000000d0h: 00 03 00 00 00 01 00 02 00 04 00 05 00 00 00 01 ; ................
000000e0h: 00 01 00 06 00 07 00 01 00 08 00 00 00 2F 00 01 ; ............./..
000000f0h: 00 01 00 00 00 05 2A 3F 00 01 3F 00 00 00 02 00 ; ......*?..?.....
00000100h: 09 00 00 00 06 00 01 00 00 00 02 00 0A 00 00 00 ; ................
00000110h: 0C 00 01 00 00 00 05 00 0B 00 0C 00 00 00 01 00 ; ................
00000120h: 0D 00 00 00 02 00 0E                            ; .......
~~~

### 4、class二进制解读

___

<span style="color:#FC5531; font-weight:bold;">（魔数）</span>      <span style="color:#ed7d31; font-weight:bold;">CA FE BA BE</span> 
<span style="color:#FC5531; font-weight:bold;">（版本）</span>      <span style="color:#ffc000; font-weight:bold;">00 00 00 34</span> 
<span style="color:#FC5531; font-weight:bold;">（常量容量</span>	<span style="color:#70ad47; font-weight:bold;">00 12</span> 
<span style="color:#FC5531; font-weight:bold;">（常量01）</span>    <span style="color:#5b73d5; font-weight:bold;">0A 00 03 00 0F</span> 
<span style="color:#FC5531; font-weight:bold;">（常量02）</span>    <span style="color:#5b73d5; font-weight:bold;">07 00 10</span> 
<span style="color:#FC5531; font-weight:bold;">（常量03）</span>    <span style="color:#5b73d5; font-weight:bold;">07 00 11</span>
<span style="color:#FC5531; font-weight:bold;">（常量04）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 04 6E 61 6D 65</span> 
<span style="color:#FC5531; font-weight:bold;">（常量05）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 12 4C 6A 61 76 61 2F 6C 61 6E 67 2F 53 74 72 69 6E 67 3B</span> 
<span style="color:#FC5531; font-weight:bold;">（常量06）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 06 3C 69 6E 69 74 3E</span> 
<span style="color:#FC5531; font-weight:bold;">（常量07）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 03 28 29 56</span>
<span style="color:#FC5531; font-weight:bold;">（常量08）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 04 43 6F 64 65</span> 
<span style="color:#FC5531; font-weight:bold;">（常量09）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 0F 4C 69 6E 65 4E 75 6D 62 65 72 54 61 62 6C 65</span> 
<span style="color:#FC5531; font-weight:bold;">（常量10）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 12 4C 6F 63 61 6C 56 61 72 69 61 62 6C 65 54 61 62 6C 65</span> 
<span style="color:#FC5531; font-weight:bold;">（常量11）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 04 74 68 69 73</span> 
<span style="color:#FC5531; font-weight:bold;">（常量12）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 11 4C 73 69 74 65 2F 72 79 61 6E 63 2F 55 73 65 72 3B</span> 
<span style="color:#FC5531; font-weight:bold;">（常量13）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 0A 53 6F 75 72 63 65 46 69 6C 65</span> 
<span style="color:#FC5531; font-weight:bold;">（常量14）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 09 55 73 65 72 2E 6A 61 76 61</span> 
<span style="color:#FC5531; font-weight:bold;">（常量15）</span>    <span style="color:#5b73d5; font-weight:bold;">0C 00 06 00 07</span> 
<span style="color:#FC5531; font-weight:bold;">（常量16）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 0F 73 69 74 65 2F 72 79 61 6E 63 2F 55 73 65 72</span> 
<span style="color:#FC5531; font-weight:bold;">（常量17）</span>    <span style="color:#5b73d5; font-weight:bold;">01 00 10 6A 61 76 61 2F 6C 61 6E 67 2F 4F 62 6A 65 63 74</span> 
<span style="color:#FC5531; font-weight:bold;">（访问标志） </span><span style="color:#7030a0; font-weight:bold;">00 21</span> 
<span style="color:#FC5531; font-weight:bold;">（类索引）</span>     <span style="color:#c00000; font-weight:bold;">00 02</span> 
<span style="color:#FC5531; font-weight:bold;">（父类索引） </span><span style="color:#c00000; font-weight:bold;">00 03</span> 
<span style="color:#FC5531; font-weight:bold;">（接口个数） </span><span style="color:#c00000; font-weight:bold;">00 00</span> 
<span style="color:#FC5531; font-weight:bold;">（接口索引）</span><span style="color:#c00000; font-weight:bold;"> NULL</span>
<span style="color:#FC5531; font-weight:bold;">（字段计数）</span> <span style="color:#000000; font-weight:bold;">00 01</span> 
<span style="color:#FC5531; font-weight:bold;">（字段一）</span>     <span style="color:#000000; font-weight:bold;">00 02 00 04 00 05 00 00</span> 
<span style="color:#FC5531; font-weight:bold;">（方法计数） </span><span style="color:#000000; font-weight:bold;">00 01</span> 

00 01 00 06 00 07 00 01 00 08 00 00 00 2F 00 01 

00 01 00 00 00 05 2A 3F 00 01 3F 00 00 00 02 00 

09 00 00 00 06 00 01 00 00 00 02 00 0A 00 00 00 

0C 00 01 00 00 00 05 00 0B 00 0C 00 00 00 01 00 

0D 00 00 00 02 00 0E

___





### 参考

[Java中的类文件结构之一：如何分析一个.class文件的二进制码内容_kcstrong的博客-CSDN博客](https://blog.csdn.net/kcstrong/article/details/79460262)

[Java类文件结构详解_A_zhenzhen的专栏-CSDN博客_java类文件结构](https://blog.csdn.net/A_zhenzhen/article/details/77977345)

https://github.com/doocs/jvm/blob/main/docs/07-class-structure.md

