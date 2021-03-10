

# <font color='#b42222'>![](https://i.loli.net/2021/03/05/tzfnANeC4B8lDGQ.png)  再学MySQL进阶实战篇</font>

​																								  ——  2021.03.05  02:30    by    Fisher  

### <font color='#e6000b'>一、 MySQL视图机制</font>

#### <font color='#ff6537'>1. 什么是视图？</font>

##### <font color='#054fd2'>① 概念</font>

- 	视图是指计算机数据库中的视图，是一个虚拟表，其内容由查询定义。同真实的表一样，视图包含一系列带有名称的列和行数据。但是，视图并不在数据库中以存储的数据值集形式存在。行和列数据来自由定义视图的查询所引用的表，并且在引用视图时动态生成。

##### <font color='#054fd2'>② 名称</font>

-   VIEW


##### <font color='#054fd2'>③ 简介</font>

- 	对其中所引用的基础表来说，视图的作用类似于筛选。定义视图的筛选可以来自当前或其它数据库的一个或多个表，或者其它视图。分布式查询也可用于定义使用多个异类源数据的视图。如果有几台不同的服务器分别存储组织中不同地区的数据，而您需要将这些服务器上相似结构的数据组合起来，这种方式就很有用。      在mssql，oracle里，视图是不支持输入参数的，因此有些人宁愿用存储过程，也不用视图，而且存储过程和视图，在效率上，基本上没什么区别。     虽然视图不支持输入参数，但在一些数据量不多，但查询比较复杂的操作情况，利用视图来进行开发，是比较方便的。

##### <font color='#054fd2'>④ 含义</font>

- 存储在数据库中的查询的SQL 语句

##### <font color='#054fd2'>⑤ 优点</font>

- ###### <font color='#1cb569'>第一点：   使用视图，可以定制用户数据，聚焦特定的数据。</font>

  	解释：在实际过程中，公司有不同角色的工作人员，我们以销售公司为例的话，采购人员，可以需要一些与其有关的数据，而与他无关的数据，对他没有任何意义，我们可以根据这一实际情况，专门为采购人员创建一个视图，以后他在查询数据时，只需select  *  from  view_caigou  就可以啦。

- ###### <font color='#1cb569'>第二点：使用视图，可以简化数据操作。 </font>

  	解释：我们在使用查询时，在很多时候我们要使用聚合函数，同时还要显示其它字段的信息，可能还会需要关联到其它表，这时写的语句可能会很长，如果这个动作频繁发生的话，我们可以创建视图，这以后，我们只需要select  *  from  view1就可以啦，这样很方便。

- ###### <font color='#1cb569'>第三点：使用视图，基表中的数据就有了一定的安全性 。</font>

  	解释：因为视图是虚拟的，物理上是不存在的，只是存储了数据的集合，我们可以将基表中重要的字段信息，可以不通过视图给用户，视图是动态的数据的集合，数据是随着基表的更新而更新。同时，用户对视图，不可以随意的更改和删除，可以保证数据的安全性。

- ###### <font color='#1cb569'>第四点：可以合并分离的数据，创建分区视图。</font>

  	解释：随着社会的发展，公司的业务量的不断的扩大，一个大公司，下属都设有很多的分公司，为了管理方便，我们需要统一表的结构，定期查看各公司业务情况，而分别看各个公司的数据很不方便，没有很好的可比性，如果将这些数据合并为一个表格里，就方便多啦，这时我们就可以使用union关键字，将各分公司的数据合并为一个视图。  

##### <font color='#054fd2'>⑥ 缺点</font>

- ###### <font color='#1cb569'>性能差</font>　

   	sql server必须把视图查询转化成对基本表的查询，如果这个视图是由一个复杂的多表查询所定义，那么，即使是视图的一个简单查询，sql server也要把它变成一个复杂的结合体，需要花费一定的时间。

- ###### <font color='#1cb569'>修改限制</font>

   当用户试图修改试图的某些信息时，数据库必须把它转化为对基本表的某些信息的修改，对于简单的试图来说，这是很方便的，但是，对于比较复杂的试图，可能是不可修改的。

- ###### <font color='#1cb569'>举例如下</font>

  基础教程中创建了4张表。

  ```mysql
  #items表创建语句
  CREATE TABLE 'items' (
    'id' int(11) NOT NULL AUTO_INCREMENT,
    'name' varchar(32) NOT NULL COMMENT '商品名称',
    'price' float(10,1) NOT NULL COMMENT '商品定价',
    'detail' text COMMENT '商品描述',
    'pic' varchar(64) DEFAULT NULL COMMENT '商品图片',
    'createtime' datetime NOT NULL COMMENT '生产日期',
    PRIMARY KEY ('id')  -- <---------------------------指明items的唯一主键字段
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  #user表创建语句
  CREATE TABLE 'user' (
    'id' int(11) NOT NULL AUTO_INCREMENT,
    'username' varchar(32) NOT NULL COMMENT '用户名称',
    'birthday' date DEFAULT NULL COMMENT '生日',
    'sex' char(1) DEFAULT NULL COMMENT '性别',
    'address' varchar(256) DEFAULT NULL COMMENT '地址',
    PRIMARY KEY ('id')
  ) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
  
  
  #订单表orders创建语句
  CREATE TABLE 'orders' (
    'id' int(11) NOT NULL AUTO_INCREMENT,
    'user_id' int(11) NOT NULL COMMENT '下单用户id',
    'number' varchar(32) NOT NULL COMMENT '订单号',
    'createtime' datetime NOT NULL COMMENT '创建订单时间',
    'note' varchar(100) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY ('id'),
    CONSTRAINT 'FK_orders_id' FOREIGN KEY ('user_id') REFERENCES 'user' ('id') ON DELETE NO ACTION ON UPDATE NO ACTION
  ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
  
  
  #订单详情表order_info创建语句
  DROP TABLE `t_anvanced`.`order_info`;
  CREATE TABLE `t_anvanced`.`order_info`  (
    `id` int(11) NOT NULL COMMENT 'id',
    `orders_id` int(11) NOT NULL COMMENT '订单id',
    `items_id` int(11) NOT NULL COMMENT '商品id',
    `items_num` int(11) NULL COMMENT '商品购买数量',
    PRIMARY KEY (`id`),
    CONSTRAINT `orders_id` FOREIGN KEY (`orders_id`) REFERENCES `t_anvanced`.`orders`(`id`),
    CONSTRAINT `items_id` FOREIGN KEY (`items_id`) REFERENCES `t_anvanced`.`items`(`id`)
  );
  ```

  - 	因为视图与数据库中存在的表不太一样，前面我们创建的4张表都是包含数据的，如用户信息，订单信息等，而视图则是不包含数据的，下面通过一个例子来演示视图,下面的sql是查询王五的所有订单情况，需要关联到orders表、order_info表、items表、user表。

  ```mysql
  SELECT u.username, o.number, tm.NAME AS itemsName, tm.price, od.items_num FROM
  	(
  		( orders AS o INNER JOIN order_info AS od ON o.id = od.orders_id )
  		INNER JOIN items AS tm ON od.items_id = tm.id 
  	)
  	INNER JOIN USER AS u ON o.user_id = u.id 
  WHERE
  	username = '王五';
  ```

  - 		上面sql显然数据已如期查询出来了，但是我们发现任何需要这个数据的人都必须了解相关联的表结构，并且需要知道如何创建查询和对表进行联结，为了检索其他用户的相同数据必须修改Where条件并带上一大段关联查询的sql语句。是的，每次这样的操作确实挺麻烦的，假如现在可以把这个除了where条件外的sql查询出来的数据包装成一个名为user_order_data的虚拟表，就可以使用以下方式检索出数据了。

  ```sql
  select * from user_order_data where username='王五';
  ```

  - 		按这样的方式每次查询不同的用户只需修改where条件即可也不同再写那段看起有点恶心的长sql了，而事实上user_order_data就是一张视图表，也可称为虚拟表，而这就是视图最显著的作用了。

#### <font color='#ff6537'>2. 视图的创建与使用</font>

- 了解完什么是视图后，我们来看看如何创建视图和使用视图，使用以下语法可创建视图：

```mysql
-- 创建视图虚拟表user_order_data
CREATE VIEW user_order_data ( username, number, itemname, price, items_num ) AS SELECT
u.username, o.number, tm.NAME, tm.price, od.items_num 
FROM
	(
		( orders AS o INNER JOIN orderdetail AS od ON o.id = od.orders_id )
		INNER JOIN items AS tm ON od.items_id = tm.id 
	)
	INNER JOIN USER AS u ON o.user_id = u.id;
```

- 现在我们使用前面关联查询的orders表、order_info表、items表、user表来创建视图user_order_data。

```mysql
-- 使用视图
SELECT *  FROM user_order_data;
```

- 		可以看出除了在select语句前面加上create view user_order_data as外，其他几乎没变化。在使用视图user_order_data时，跟使用数据库表没啥区别，因此以后需要查询指定用户或者所有用户的订单情况时，就不用编写长巴巴的一段sql了，还是蛮简洁的。除了上述的方式，还可以将视图虚拟表的字段别名移动到查询字段后面：

```mysql
 CREATE OR REPLACE VIEW user_order_data
 AS
 SELECT
 	u.username as username, 
 	o.number as number , 
 	tm.name as name , 
 	tm.price as price , 
 	od.items_num as items_num
 FROM
 (
 (orders as o INNER JOIN orderdetail as od ON o.id = od.orders_id ) 
 INNER JOIN items as tm ON od.items_id = tm.id 
 )
 INNER JOIN user as u ON o.user_id = u.id;
```

- 注意这里使用了<font color='red'>`CREATE OR REPLACE VIEW`</font>语句，意思就是不存在就创建，存在就替换。


- 如果想删除视图可以使用以下语法：

```mysql
DROP VIEW 视图名称;
```

在使用视图的过程还有些需要注意的点，如下：

- <font color='#1cb569'>与创建表一样，创建视图的名称必须唯一</font>

  创建视图的个数并没限制，但是如果一张视图嵌套或者关联的表过多，同样会引发性能问题，在实际生产环节中部署时务必进行必要的性能检测。

- <font color='#1cb569'>在过滤条件数据时如果在创建视图的sql语句中存在where的条件语句，而在使用该视图的语句中也存在where条件语句时，这两个where条件语句会自动组合。</font>


- <font color='#1cb569'>order by 可以在视图中使用，但如果从该视图检索数据的select语句中也含有order by ，那么该视图中的order by 将被覆盖。</font>


- <font color='#1cb569'>视图中不能使用索引，也不能使用触发器(索引和触发器后面会分析)</font>


- <font color='#1cb569'>使用可以和普通的表一起使用，编辑一条联结视图和普通表的sql语句是允许的。</font>



-   ​		关于使用视图对数据的进行更新(增删改)，因为视图本身并没有数据，所以这些操作都是直接作用到普通表中的，但也并非所有的视图都可以进行更新操作,如视图中存在分组(group by)、联结、子查询、并(unoin)、聚合函数(sum/count等)、计算字段、DISTINCT等都不能对视图进行更新操作，因此我们前面的例子也是不能进行更新操作的，事实上，视图更多的是用于数据检索而更新，因此对于更新也没有必要进行过多阐述。

#### <font color='#ff6537'>3. 视图的本质</font>

- 	到此对于视图的创建和使用都比较清晰了，现在准备进一步认识视图的本质，前面我们反复说过，视图是一张虚拟表，是不带任何数据的，每次查询时只是从普通表中动态地获取数据并组合，只不过外表看起来像一张表罢了。其原理通过下图便一目了然：

![img](https://i.loli.net/2021/03/05/HjbyINXS5GksQdE.png)

- 	事实上有些时候视图还会被用于限制用户对普通表的查询操作，对于这类用户只赋予对应视图的select操作权限，仅让他们只能读取特定的行或列的数据。这样我们也就不用直接使用数据库的权限设置限制行列的读取，同时也避免了权限细化的麻烦。

### <font color='#e6000b'>二、 高效索引</font>

#### <font color='#ff6537'>1. 使用索引的理由是什么？</font>

> 	由于mysql在默认情况下，表中的数据记录是没有顺序可言的，也就是说在数据检索过程中，符合条件的数据存储在哪里，我们是完全不知情的，如果使用select语句进行查询，数据库会从第一条记录开始检索，即使找到第一条符合条件的数据，数据库的搜索也并不会因此而停止，毕竟符合条件的数据可能并不止一条，也就是说此时检索会把表中的数据全部检索一遍才结束，这样的检索方式也称为全表扫描。但假设表中存在上百上千万条数据呢？这样的检索效率就十分低了，为了解决这个问题，索引的概念就诞生了，索引是为检索而存在的。如一些书的末尾一般会提供专门附录索引，指明了某个关键字在正文中的出现的页码位置或章节的位置，这样只要找到对应页面就能找到要搜索的内容了，数据库的索引也是类似这样的原理，通过创建某个字段或者多个字段的索引，在搜索该字段时就可以根据对应的索引进行快速检索出相应内容而无需全表扫描了。

#### <font color='#ff6537'>2. 什么是索引？</font>

- ##### <font color='#054fd2'>概念</font>

   	在关系数据库中，索引是一种单独的、物理的对数据库表中一列或多列的值进行排序的一种存储结构，它是某个表中一列或若干列值的集合和相应的指向表中物理标识这些值的数据页的逻辑指针清单。索引的作用相当于图书的目录，可以根据目录中的页码快速找到所需的内容。
     索引提供指向存储在表的指定列中的数据值的指针，然后根据您指定的排序顺序对这些指针排序。数据库使用索引以找到特定值，然后顺指针找到包含该值的行。这样可以使对应于表的SQL语句执行得更快，可快速访问数据库表中的特定信息。
   	当表中有大量记录时，若要对表进行查询，第一种搜索信息方式是全表搜索，是将所有记录一一取出，和查询条件进行一一对比，然后返回满足条件的记录，这样做会消耗大量数据库系统时间，并造成大量磁盘I/O操作；第二种就是在表中建立索引，然后在索引中找到符合查询条件的索引值，最后通过保存在索引中的ROWID（相当于页码）快速找到表中对应的记录。

  - <font color='#F5555D'>**索引是为了加速对表中数据行的检索而创建的一种分散的存储结构。索引是针对表而建立的，它是由数据页面以外的索引页面组成的，每个索引页面中的行都会含有逻辑指针，以便加速检索物理数据。**</font>



 	<font color='#1cb569'>在数据库关系图中，可以在选定表的“索引/键”属性页中创建、编辑或删除每个索引类型。当保存索引所附加到的表，或保存该表所在的关系图时，索引将保存在数据库中。</font>

#### <font color='#ff6537'>3. 索引的作用</font>

- ##### <font color='#3a79c3'>快速取数据；</font>

- ##### <font color='#3a79c3'>保证数据记录的唯一性；</font>

- ##### <font color='#3a79c3'>实现表与表之间的参照完整性；</font>

- ##### <font color='#3a79c3'>在使用ORDER BY，GROUP BY子句进行数据检索时，利用索引可以减少排序和分组的时间；</font>

#### <font color='#ff6537'>4. 索引的优缺点</font>

- ##### <font color='#3a79c3'>优点</font>
  - ##### Ⅰ 大大加快了数据检索的速度；

  - ##### Ⅱ 创建唯一性索引，保证数据库中每一行数据的唯一性；

  - ##### Ⅲ 加速表和表之间的连接；

  - ##### Ⅳ 在使用ORDER BY，GROUP BY子句进行数据检索时，可以显著减少查询中分组和排序的时间；

- ##### <font color='#3a79c3'>缺点</font>

  - ##### Ⅰ 索引本身是一种存储结构，需要占用物理存储空间；

  - ##### Ⅱ 但对表中的数据进行增加、删除和修改的时候，索引也要动态地维护，降低了数据的维护速度；

#### <font color='#ff6537'>5. 索引的索引类型</font>

> ##### <font color='#3a79c3'>根据数据库的功能，可以在数据库设计器中创建四种索引：单列索引、复合索引、唯一索引、主键索引和聚集索引。</font>

##### 	<font color='#3a79c3'>① 单列索引</font>

- <font color='#3dcb85'>Ⅰ.    单列索引，也称为普通索引，单列索引是最基本的索引，它没有任何限制，创建一个单列索引。</font>语法如下：

```mysql
CREATE INDEX index_name ON tbl_name(index_colum_name);
```

【注】其中index_name为索引的名称，可以自定义，tbl_name则指明要创建索引的表，而index_colum_name指明表中那一个列要创建索引。

- <font color='#3dcb85'>	Ⅱ.    当然我们也可以通过修改表结构的方式添加索引。</font>语法如下：

```mysql
ALTER TABLE tbl_name ADD INDEX index_name ON (index_colum_name);
```

- <font color='#3dcb85'>Ⅲ.    还可以在创建表时直接指定。</font> 语法如下：

```mysql
-- 创建表时直接指定
CREATE TABLE `table_name` (
`id` int(11) NOT NULL AUTO_INCREMENT ,
`name` varchar(32)  NOT NULL ,
......  -- 其他字段
PRIMARY KEY (`id`),
indexName (name(32))  -- 创建name字段索引
);
```

举例：下面为user表中username字段创建单列索引：

```mysql
-- 创建username字段的索引名称为 index_name，这就是基础的索引创建
CREATE index index_name ON user(username);
-- 查看user表中存在的索引 \G 代表优化显示方式
SHOW index FROM user \G;
```

- 	执行上面的语句得查询结果，可见user表中的username字段的索引已被创建，在使用<font color='red'>`SHOW index FROM user`</font>查看索引时，我们<font color='#1cb569'>发现 id 字段也被创建的索引，事实上，当user表被创建时，主键定义的字段 id 就会被自动按创建索引，这是一种特殊的索引，也称为***丛生索引***</font>，而刚才创建的index_name索引属于单列索引。

##### <font color='#3a79c3'>② 复合索引</font>

- 	<font color='#1cb569'>Ⅰ. 复合索引是在多个字段上创建的索引。复合索引遵守“最左前缀”原则，即在查询条件中使用了复合索引的第一个字段，索引才会被使用。因此，在复合索引中索引列的顺序至关重要。   </font>创建一个复合索引的语法如下：

```mysql
-- index_name 代表索引名称，而index_colum_named1, index_colum_named2, ... 为列名，可以是多个。 
CREATE INDEX index_name ON tbl_name(index_colum_name1, index_colum_name2, ...);
```

- <span style='color:#1cb569'>Ⅱ.   同样的道理，也可通过添加表结构的方式添加索引。</span>语法如下：

```mysql
ALTER TABLE tbl_name ADD INDEX index_name ON (index_colum_name1,index_colum_name2,...);
```

- <span style='color:#1cb569'>Ⅲ.     创建表时直接指定。</span>语法如下：

```mysql
CREATE TABLE `table` (
	`id` int(11) NOT NULL AUTO_INCREMENT ,
	`name` varchar(32)  NOT NULL ,
	'pinyin' varchar(32) ,
	......  -- 其他字段
PRIMARY KEY (`id`),
indexName (name(32),pinyin(32)) 
);
```

- 为了方便演示，为user表中添加名称为拼音字段的字段（pinyin）：

```mysql
-- 添加新字段pinyin
ALTER TABLE user ADD pinyin varchar(32) AFTER username;
```

- 	现在利用username和pinyin 两个字段为user表创建复合索引，先删除之前为username创建的索引，删	 除索引语法如下：

```mysql
DROP INDEX 索引名称 ON 表名
```

```mysql
-- 删除username的索引：
DROP index index_name ON user;

-- 查看user的索引
SHOW index FROM user \G;
```

- OK，index_name 索引已被删除，现在联合username和pinyin创建索引如下：

```mysql
-- 创建新索引多列组成，index_pinyin为复合索引名称
CREATE index index_pinyin ON user(username,pinyin);

-- 这里省略主键索引
SHOW index FROM user \G;
```

- 	像这样<font color='#1cb569'>由两个以上组成的索引，称为***`复合索引`*** </font>，由于是复合索引，因此索引的名称都相同，注意`Seq_in_index`代表索引字段的顺序，前面我们说过在查询条件中使用了复合索引的第一个字段（这里指username），索引才会被使用。因此，<font color='#1cb569'>***在复合索引中索引列的顺序至关重要。***</font>



##### 	<font color='#3a79c3'>③ 唯一索引</font>

>   唯一索引是不允许其中任何两行具有相同索引值的索引。
>
>   当现有数据中存在重复的键值时，大多数数据库不允许将新创建的唯一索引与表一起保存。数据库还可能防止添加将在表中创建重复键值的新数据。例如，如果在 employee 表中职员的姓 (lname) 上创建了唯一索引，则任何两个员工都不能同姓。
>
>   对某个列建立UNIQUE索引后，插入新记录时，数据库管理系统会自动检查新纪录在该列上是否取了重复值，在CREATE TABLE 命令中的UNIQE约束将隐式创建UNIQUE索引。

-   <font color='#1cb569'>Ⅰ. 创建唯一索引必须指定关键字<span style='color:red'>***`UNIQUE`***</span>，唯一索引和单列索引类似，主要的区别在于，唯一索引限制列的值必须唯一，但允许有空值。对于多个字段，唯一索引规定列值的组合必须唯一。</font>如创建username为唯一索引，那么username的值是不可以重复的。语法如下：

    ```mysql
    -- 创建唯一索引
    CREATE UNIQUE INDEX index_name ON tbl_name(index_col_name[,...]);
    ```

-   <font color='#1cb569'>Ⅱ. *添加（通过修改表结构）* </font>

    ```mysql
    -- 添加（通过修改表结构）
    ALTER TABLE tbl_name ADD UNIQUE INDEX index_name ON (index_col_name[,...]);
    ```

-   <font color='#1cb569'>Ⅲ. 创建表时直接指定 </font>

    ```mysql
    -- 创建表时直接指定
    CREATE TABLE `table` (
    `id` int(11) NOT NULL AUTO_INCREMENT ,
    `name` varchar(32)  NOT NULL ,
    ......  -- 其他字段
    PRIMARY KEY (`id`),
    UNIQUE indexName (name(32)) 
    );
    ```

-   下面为user表的username字段创建唯一索引：

    ```mysql
    -- 仅为演示
    create unique index idx_name on user(username);
    ```

    -   ​		事实上这里讲username设置为唯一索引是不合理的，毕竟用户可能存在相同username，因此在实际生产环节中username是不应该设置为唯一索引的。否则当有相同的名称插入时，数据库表将会报错。

##### 	<font color='#3a79c3'>④ 主键索引</font>

>   主键索引也称<font color='#1cb569'>***`丛生索引`***</font>，是一种特殊的唯一索引，不允许有空值。
>
>   简称为主索引，数据库表中一列或列组合（字段）的值唯一标识表中的每一行。该列称为表的主键。
>
>   在数据库关系图中为表定义主键将自动创建主键索引，主键索引是唯一索引的特定类型。该索引要求主键中的每个值都唯一。当在查询中使用主键索引时，它还允许对数据的快速访问。

-   创建主键索引语法如下：

    ```mysql
    ALTER TABLE tbl_name ADD PRIMARY KEY(index_col_name);
    ```

##### 	<font color='#3a79c3'>⑤ 聚集索引</font>

>   ​		也称为<font color='#1cb569'>***`聚簇索引`***</font>，在聚集索引中，表中行的物理顺序与键值的逻辑（索引）顺序相同。一个表只能包含一个聚集索引， 即如果存在聚集索引，就不能再指定CLUSTERED 关键字。
>
>   ​		索引不是聚集索引，则表中行的物理顺序与键值的逻辑顺序不匹配。与非聚集索引相比，聚集索引通常提供更快的数据访问速度。聚集索引更适用于对很少对基表进行增删改操作的情况。
>
>   ​		如果在表中创建了主键约束，SQL Server将自动为其产生唯一性约束。在创建主键约束时，指定了CLUSTERED关键字或干脆没有制定该关键字，SQL Sever将会自动为表生成唯一聚集索引。

##### <font color='#3a79c3'>⑥ 非聚集索引</font>

>   ​		也叫<font color='#1cb569'>***`非簇索引`***</font>，在非聚集索引中，数据库表中记录的物理顺序与索引顺序可以不相同。一个表中只能有一个聚集索引，但表中的每一列都可以有自己的非聚集索引。如果在表中创建了主键约束，SQL Server将自动为其产生唯一性约束。在创建主键约束时，如果制定CLUSTERED关键字，则将为表产生唯一聚集索引。

##### <font color='#3a79c3'>⑦ 候选索引</font>

>   ​		与主索引一样要求字段值的唯一性，并决定了处理记录的顺序。在数据库和自由表中，可以为每个表建立多个候选索引。

#### <font color='#ff6537'>6. 索引的创建，修改、删除及维护使用</font>

##### <font color='#3a79c3'>① 创建索引</font>

-   SQL语言使用CREATE INDEX 语句建立索引，其一般格式是：

    ```mysql
    CREATE [UNIQUE] [CLUSTERED| NONCLUSTERED] INDEX <索引名>
    ON <表名>(<列名>[ASC|DESC] [, <列名>[ASC|DESC]...])
    ```

    -   【说明】：与表一样，索引也需要有唯一的名字，且基于一个表来建立，可以根据表中的一列或者多列，当列的顺序都是升序默认可不必标出，当属性列有按照降序排列的，所有属性的升序降序都不要标明。

        UNIQUE——建立唯一索引。

        CLUSTERED——建立聚集索引。

        NONCLUSTERED——建立非聚集索引。

        ASC——索引升序排序。

        DESC——索引降序排序。

##### <font color='#3a79c3'>② 修改索引</font>

-   对于已经建立的索引，如果需要对其重新命名，可以使用ALTER INDEX 语句。其一般格式为：

    ```mysql
    ALTER INDEX <旧引索名字> RENAME TO<新引索名>
    ```

##### <font color='#3a79c3'>③ 删除索引</font>

-   当某个时期基本表中数据更新频繁或者某个索引不再需要时，需要删除部分索引。SQL语言使用DROP INDEX 语句删除索引，其一般格式是：

    ```mysql
    DROP INDEX<索引名>
    ```

    -   删除索引时，DBMS不仅在物理删除相关的索引数据，也会从数据字典删除有关该索引的描述。

##### <font color='#3a79c3'>④ 维护和使用索引</font>

-   DBMS自动完成维护和自动选择是否使用索引以及使用哪些索引。

#### <font color='#ff6537'>7. 索引的设计</font>

-   where子句中的列可能最适合做为索引；


-   不要尝试为性别或者有无这类字段等建立索引(因为类似性别的列，一般只含有“0”和“1”，无论搜索结果如何都会大约得出一半的数据)；


-   如果创建复合索引，要遵守最左前缀法则。即查询从索引的最左前列开始，并且不跳过索引中的列；


-   不要过度使用索引。每一次的更新，删除，插入都会维护该表的索引，更多的索引意味着占用更多的空间；
-   使用InnoDB存储引擎时，记录(行)默认会按照一定的顺序存储，如果已定义主键，则按照主键顺序存储，由于普通索引都会保存主键的键值，因此主键应尽可能的选择较短的数据类型，以便节省存储空间；

-   不要尝试在索引列上使用函数。

#### <font color='#ff6537'>8. 注意事项</font>

1.  并非所有的数据库都以相同的方式使用索引。作为通用规则，只有当经常查询索引列中的数据时，才需要在表上创建索引。索引占用磁盘空间，并且降低添加、删除和更新行的速度。如果应用程序非常频繁地更新数据或磁盘空间有限，则可能需要限制索引的数量。在表较大时再建立索引，表中的数据越多，索引的优越性越明显。

2.   可以基于数据库表中的单列或多列创建索引。多列索引使您可以区分其中一列可能有相同值的行。

3.  如果经常同时搜索两列或多列或按两列或多列排序时，索引也很有帮助。例如，如果经常在同一查询中为姓和名两列设置判据，那么在这两列上创建多列索引将很有意义。

4.  确定索引的有效性：

5.  检查查询的 WHERE 和 JOIN 子句。在任一子句中包括的每一列都是索引可以选择的对象。

6.  对新索引进行试验以检查它对运行查询性能的影响。

7.  考虑已在表上创建的索引数量。最好避免在单个表上有很多索引。

8.  检查已在表上创建的索引的定义。最好避免包含共享列的重叠索引。

9.  检查某列中唯一数据值的数量，并将该数量与表中的行数进行比较。比较的结果就是该列的可选择性，这有助于确定该列是否适合建立索引，如果适合，确定索引的类型。

### <font color='#e6000b'>三、 存储过程</font>

#### <font color='#ff6537'>1. 为什么需要存储过程？</font>

-   ​		迄今为止，我们所使用的大多数SQL语句都针对一个或多个表的单条语句，当需要通过处理流程来达到预期目标时，单条sql语句就很难做到了，这是因为sql语句无法编写处理流程的语句，所有的sql都只能通过一个个命令执行，比如想循环执行某个SQL语句，对于没有处理流程的sql显然是无法实现的，此时就需要通过存储过程来达到目的了，简单的理解存储过程就是数据库中保存的一系列SQL命令的集合，也就是说通过存储过程就可以编写流程语句，如循环操作语句等。

    

-   存储过程在现在的开发环境中已经逐渐被废弃掉了。主要是因为存储过程难以调用和扩展，跟没有移植性。维护起来特别费劲，给运维带来了极大的挑战和困难。

#### <font color='#ff6537'>2. 什么存储过程？</font>

-   存储过程（Stored Procedure）是一种在数据库中存储复杂程序，以便外部程序调用的一种数据库对象。

    存储过程是为了完成特定功能的SQL语句集，经编译创建并保存在数据库中，用户可通过指定存储过程的名字并给定参数(需要时)来调用执行。

    存储过程思想上很简单，就是数据库 SQL 语言层面的代码封装与重用。

#### <font color='#ff6537'>3. 存储过程的优缺点</font>

-   <font color='#3a79c3'>优点</font>
    -   存储过程可封装，并隐藏复杂的商业逻辑。
    -   存储过程可以回传值，并可以接受参数。
    -   存储过程无法使用 SELECT 指令来运行，因为它是子程序，与查看表，数据表或用户定义函数不同。
    -   存储过程可以用在数据检验，强制实行商业逻辑等。
-   <font color='#3a79c3'>缺点</font>
    -   存储过程，往往定制化于特定的数据库上，因为支持的编程语言不同。当切换到其他厂商的数据库系统时，需要重写原有的存储过程。
-   -   存储过程可封装，并隐藏复杂的商业逻辑。
        存储过程可以回传值，并可以接受参数。
        存储过程无法使用 SELECT 指令来运行，因为它是子程序，与查看表，数据表或用户定义函数不同。
        存储过程可以用在数据检验，强制实行商业逻辑等。
    -   

#### <font color='#ff6537'>4. 存储过程的创建与使用</font>



#### <font color='#ff6537'>5. 存储过程的删除</font>



#### <font color='#ff6537'>6. 查看存储过程的状态</font>



#### <font color='#ff6537'>7. 查看存储过程的创建语句</font>



#### <font color='#ff6537'>8. 存储过程的流程控制语句</font>



### <font color='#e6000b'>四、 存储函数</font>

#### <font color='#ff6537'>1. 创建存储函数</font>

-   ​		有些时候自带函数并不能很好满足我们的需求，此时就需要自定义存储函数了，<font color='#1cb569'>***`存储函数与存储过程有些类似，简单来说就是封装一段sql代码，完成一种特定的功能，并返回结果。`***</font>其语法如下：

    ```mysql
    CREATE FUNCTION 函数([参数类型 数据类型[,….]]) RETURNS 返回类型 
    　　BEGIN
    　　　  SQL语句.....
    　　　　RETURN (返回的数据)
    　　END
    ```
    -   ​	与存储过程不同的是，存储函数中不能指定输出参数(OUT)和输入输出参数(INOUT)类型。存储函数只能指定输入类型而且不能带IN。同时存储函数可以通过RETURN命令将处理的结果返回给调用方。注意必须在参数列表后的RETURNS（ 该值的RETURNS多个S，务必留意）命令中预先指定返回值的类型。如下创建一个计算斐波那契数列的函数。

        ```mysql
        -- 创建存储函数
        create function fn_factorial(num int) returns int
            begin
            declare result int default 1;
            while num > 1 do 
            set result = result * num ;
              set num = num -1 ;
              end while;
             return result;
            end
        ```

        ```mysql
        -- 查询
        select fn_factorial(0),fn_factorial(5),fn_factorial(10);
        ```

        

#### <font color='#ff6537'>2. 删除存储函数</font>





#### <font color='#ff6537'>3. 存储过程和存储函数的区别</font>



### <font color='#e6000b'>五、 触发器</font>
#### <font color='#ff6537'>1. 触发器的概念及语法</font>

- 触发器可以简单理解一种特殊的存储过程，之前存储过程的变量定义及流程语句同样适合触发器，唯一不同的是我们只需要定义触发器，而不用手动调用触发器。从事件触发的角度来说，触发器编写的过程就是触发事件定义的过程，因为触发器定义好后会随着数据库操作命令的执行而触发，这些具体的操作是INSERT/UPDATE/DELETE。比如可以在user表中删除记录执行后，通过定义一个触发器把删除的数据自动添加到历史表中保存以便以后可以进行其他操作。创建触发器的语法如下：

  ```mysql
  CREATE TRIGGER trigger_name trigger_time
  trigger_event ON tbl_name
  FOR EACH ROW
  BEGIN
  trigger_stmt
  END
  ```

  语法解释：

  - trigger_name：触发器名称。自定义。
  - trigger_time：触发时机。取值为<font color='#3dcb85'>***`BRFORE`***或者***`AFTER`***。</font>
  - trigger_event：触发事件。取值为 <font color='#3dcb85'>***`INSERT`*** 、***`UPDATE`*** 或 ***`DELETE`***</font>；需要注意的是，这些命令并不一定是严格意义上的命令，因为像<font color='#3dcb85'>***`LOAD DATA`*** </font>和 <font color='#3dcb85'>***`REPLACE`*** </font>语句也能触发上述事件。<font color='#3dcb85'>LOAD DATA 语句用于将一个文件装入到一个数据表中，是一系列的 INSERT 操作。REPLACE 语句类似INSERT 语句，当表中有 primary key 或 unique 索引时，如果插入的数据和原来 primary key 或 unique 索引一致时，会先删除原来的数据，然后增加一条新数据，也就是说，一条 REPLACE 语句会等价于一条INSERT 语句或者一条 DELETE 语句和上一条 INSERT 语句。</font>
  - tbl_name：表示在哪张表上建立触发器；
  - trigger_stmt：触发器程序体，可以是一句SQL语句或者流程语句；
  - FOR EACH ROW ： 在mysql中属于固定写法，指明触发器以行作为执行单位，也就是当用户执行删除命令删除3条数据，与删除动作相关的触发器也会被执行3次。

#### <font color='#ff6537'>2. 创建触发器</font>

- 在日常的数据库开发中，因业务需求，可能需要在插入更新删除时留下数据的日志，这时采用触发器来实现是个非常不错的选择，下面我们定义一个用户删除事件的触发器，当用户被删除后自动把被删除的数据添加到用户历史表user_history，历史用户表结构如下：

```mysql
-- 为了让字段更简洁，这里我们修改几个字段名称
alter table user change username name varchar(32);

alter table user change birthday birth datetime;

-- user 表结构
desc user;

-- 历史表 user_history 其中updated字段为删除日期
desc user_history;
```

- 触发器定义语句如下：

```mysql
DELIMITER
-- 创建触发器
create trigger trg_user_history after delete
       on user for each row
     begin
      insert into user_history(uid,name,pinyin,birth,sex,address,updated)
      values(OLD.id,OLD.name,OLD.pinyin,OLD.birth,OLD.sex,OLD.address,NOW());
     end
DELIMITER ;
```

- 上述sql中创建语句的形式与前面的存储过程或者存储函数都很类似，这里有点要注意的是，使用OLD/NEW关键字可以获取数据变更前后的记录，其中OLD用于AFTER时刻，而NEW用于BEFORE时刻的变更。如OLD.name表示从user表删除的记录的名称。INSERT操作一般使用NEW关键字，UPDATE操作一般使用NEW和OLD，而DELETE操作一般使用OLD。现在我们从user表删除一条数据，然后查看user_history表的数据。

```mysql
-- 删除user中id为60的用户数据
delete from user where id =60;

-- 查看历史表
 select * from user_history;
```

- 显然我们定义的触发器已生效了。	



#### <font color='#ff6537'>3. 查看触发器</font>

- 如果需要查看定义好的触发器可以使用以下语句：

  ```mysql
  SHOW TRIGGERS [FROM schema_name];1
  ```

  - 其中，schema_name 即 Schema 的名称，在 MySQL 中 Schema 和 Database 是一样的，Schema指定为数据库名即可。

  - ```mysql
    mysql> SHOW TRIGGERS \G;
    *************************** 1. row ***************************
                 Trigger: trg_user_history --触发器名称
                   Event: DELETE  --触发事件
                   Table: user --触发器作用的表
               Statement: begin
    insert into user_history(uid,name,pinyin,birth,sex,address,updated)
    values(OLD.id,OLD.name,OLD.pinyin,OLD.birth,OLD.sex,OLD.address,NOW());
    end
                  Timing: AFTER
                 Created: 2017-04-21 09:27:56.58
                sql_mode: ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
                 Definer: root@localhost
    character_set_client: utf8
    collation_connection: utf8_general_ci
      Database Collation: utf8_general_ci
    1 row in set (0.00 sec)
    ```

#### <font color='#ff6537'>4. 删除触发器</font>

- 删除触发器可以使用以下语句：

  ```mysql
  DROP TRIGGER 触发器名称;
  ```

### <font color='#e6000b'>六、 游标</font>

-   在前面的分析中可知sql的检索操作返回的数据几乎都是以整个集合的形式，也就是说sql善于将多条查询记录集中到一起并返回，倘若现在需要一行行地处理查询的结果，这对于sql语句来说确实是个难题，好在存在一种称为游标的技术可以解决这个问题，所谓的游标就就是可以将检索出来的数据集合保存在内存中然后依次取出每条数据进行处理，这样就解决了sql语句无法进行行记录处理的难题，游标的读取图解如下：

    ![image-20210308230538350](https://i.loli.net/2021/03/11/ZaElJKibcAkNdzY.png)

-   其中有个指针的概念，指针指明了当前行记录的信息，在游标的处理过程中通过移动指针进行逐行读取数据。要明白的是，游标一般结合存储过程或存储函数或触发器进行使用，ok~，理解了游标的概念后，看看其定义语法：

```mysql
-- 声明游标
DECLARE cursor_name CURSOR FOR SELECT 语句;

-- 打开游标
OPEN cursor_name;

-- 从游标指针中获取数据
FETCH cursor_name INTO 变量名 [,变量名2,...];

-- 关闭游标
CLOSE cursor_name
```

-   在使用游标前需要对其进行声明，其中cursor_name表示游标名，<font color='#3dcb85'>***`CURSOR FOR`***</font>是固定写法，SELECT 是检索语句，把检索出来的数据存放到游标中等待处理。下面我们通过一个案例演示并理解游标的使用。

```mysql
DELIMITER //
-- 创建存储过程
create procedure sp_cursor(out result text)
     begin 
      declare flag bit default 0;--定义标识变量用于判断是否退出循环
      declare tmp varchar(20);-- 定义临时存储变量
      declare cur cursor for select distinct name from user where id < 20;-- 声明游标
      declare continue handler for not found set flag = 1; --异常处理并设置flag=1
      open cur; -- 打开游标
      while flag!=1 do 
        fetch cur into tmp ; --从游标中取值并存放到tmp中
        if flag !=1 then
           set result = concat_ws(',',result,tmp); --拼接每次获取的结果
        end if;
      end while;
      close cur; --关闭游标
     end
    
DELIMITER ;
-- 执行
call sp_user_cursor(@result);

-- 查询结果
select @result;
+------------------------------------------------+
| @result                                        |
+------------------------------------------------+
| 王五,张曹宇,李达康,张书记,任在明               |
+------------------------------------------------+
1 row in set (0.00 sec)
```

-   上述的存储过程是用于查询出id小于20的用户名称，并拼接成一个以逗号隔开的字符串输出。我们声明了一个flag的变量用于标识是否结束while循环，同时也声明了tmp变量用于存储每次从游标中获取的行数据，因为我们定义游标是从user表中查询name字段的数据，因此只需要一个tmp变量就行了，如果需要查询user中多个字段，则声明多个tmp字段并在获取数据时以<font color='#3dcb85'>**`fetch cur into tmp [,tmp2,tmp3,...]`**</font>；形式即可，请注意在使用游标前必须先打开，使用<font color='#3dcb85'>**`open cur`**</font>；语句，而且只有在打开游标后前面定义的select语句开正式开始执行。循环获取cur中的数据使用了while流程语句，这里我们还定义了前面分析过的异常处理语句即：

    ```mysql
    -- 异常处理并设置flag=1
    declare continue handler for not found set flag = 1; 
    ```

    -   在发生not found 的异常时将flag设置为1，并通过声明为continue而让程序继续执行。这样处理的理由是<font color='#3dcb85'>**`fetch cur into tmp`**</font>语句执行时，如果游标的指针无法读取下一行数据时就会抛出NOT FOUND异常，抛出后由已声明的异常程序处理，并设置flag为1，以此来结束循环，注意抛出异常后程序还会继续执行，毕竟声明了continue。所以最后一次判断<font color='#3dcb85'>**`if flag !=1 then`**</font>是必要的。最后执行完成，通过<font color='#3dcb85'>**`close cur`**</font> 关闭游标，这样整个游标的使用就完成了。

### <font color='#e6000b'>七、 事务处理</font>

>   事务处理是数据库中的一个大块头，涉及到数据的完整性与一致性问题，由于mysql存在多种数据存储引擎提供给用户选择，但不是所有的引擎都支持事务处理，常见的引擎有：MyISAM和InnoDB。MyISAM是默认高速的引擎并不支持事务功能，InnoDB支持行锁定和事务处理，速度比MyISAM稍慢。事实上前面我们在创建表时都指明存储引擎为InnoDB，本篇中我们也将采用InnoDB引擎进行分析，毕竟InnoDB是支持事务功能的。

【注】[MyISAM和InnoDB引擎的比较及区别](https://www.cnblogs.com/rgever/p/9736374.html)

#### <font color='#ff6537'>1. 事务的概念</font>

先看一个经典银行转账案例，A向B的银行卡转账1000元，这里分两个主要事件，一个是A向B转账1000，那么A的银行卡转账成功后必须在原来的数额上扣掉1000元，另一个是B收到了A的转款，B的银行卡上数额必须增加1000元，这两个步骤是必须都成功才算转账成功，总不能A转账B后，A的数额没有变化而B增加了1000元吧？这样银行不得亏死了？因此两个步骤只要有一个失败，此次转账的结果就是失败。但我们在执行sql语句时，两个动作是分两个语句执行的，万一执行完一个突然没电了另外一个没有执行，那岂不出问题了？此时就需要事务来解决这个问题了，所谓的事物就是保证以上的两个步骤在同一个环境中执行，只要其中一个失败，事务就会撤销之前的操作，回滚的没转账前的状态，如果两个都执行成功，那么事务就认为转成成功了。这就是事务的作用。

对事务有了初步理解后，进一步了解事务的官方概念，<font color='#054fd2'>事务是DBMS的执行单位。它由有限个数据库操作语句组成。但不是任意的数据库操作序列都能成为事务。</font> 一般来说，事务是必须满足4个条件（ACID）：

-   <font color='#054fd2'>**`原子性（Autmic）`**</font>：一个原子事务要么完整执行，要么干脆不执行。也就是说，工作单元中的每项任务都必须正确执行，如果有任一任务执行失败，则整个事务就会被终止并且此前对数据所作的任何修改都将被撤销。如果所有任务都被成功执行，事务就会被提交，那么对数据所作的修改将会是永久性的。

-   <font color='#054fd2'>**`一致性（Consistency）`**</font>：一致性代表了底层数据存储的完整性。 它是由事务系统和应用开发人员共同来保证。事务系统通过保证事务的原子性，隔离性和持久性来满足这一要求; 应用开发人员则需要保证数据库有适当的约束(主键，引用完整性等)，并且工作单元中所实现的业务逻辑不会导致数据的不一致(数据预期所表达的现实业务情况不相一致)。例如，在刚才的AB转账过程中，从A账户中扣除的金额必须与B账户中存入的金额相等。

-   <font color='#054fd2'>**`隔离性（Isolation）`**</font>：隔离性是指事务必须在不干扰其他事务的前提下独立执行，也就是说，在事务执行完毕之前，其所访问的数据不能受系统其他部分的影响。

-   <font color='#054fd2'>**`持久性（Durability）`**</font>：持久性指明当系统或介质发生故障时，确保已提交事务的更新数据不能丢失，也就意味着一旦事务提交，DBMS保证它对数据库中数据的改变应该是永久性的，耐得住任何系统故障，持久性可以通过数据库备份和恢复来保证。



#### <font color='#ff6537'>2. 事务控制流程实践</font>

-   在使用事务处理可能涉及到以下命令：

```mysql
-- 声明事务的开始
BEGIN(或START TRANSACTION);

-- 提交整个事务
COMMIT;

-- 回滚到事务初始状态
ROLLBACK;
```

-   下面通过删除user表中的用户数据，然后再回滚来演示上述命令的作用：

```mysql
-- 先查看user表中的数据
select * from user;

-- 开始事务
begin;

-- 删除ID为24的用户
delete from user where id =24;

-- 删除完成后再次查看user表数据，显然ID为24的数据已被删除
select * from user;

-- 执行回滚操作rollback
rollback;

-- 再次查看数据，可见ID为24的用户数据已恢复
select * from user;
```

-   从上述一系列操作中，从启动事务到删除用户数据，再到回滚数据，体现了事务控制的过程，这里我们还没使用<font color='#3dcb85'>***`COMMIT`***</font>，如果刚才把rollback改成commit，那么事务就提交了，数据也就真的删除了。下面我们再次来演示删除数据的过程，并且这次使用commit提交事务。

```mysql
-- 先添加一条要删除数据
insert into user values(30,'要被删除的数据',null,null,1,null);

-- 查看数据
select * from user;

-- 开启新事务
mysql> begin;

-- 删除数据
delete from user where id =30;

-- 提交事务
commit;

-- 回滚数据
rollback;

-- 查看数据
select * from user;
```

-   可以发现当删除完数据后，使用commit提交了事务，此时数据就会被真正更新到数据库了，即使使用rollback回滚也是没有办法恢复数据的。ok~，这就是事务控制最简化的流程，事实上除了上述的回滚到事务的初始状态外，还可以进行部分回滚，也就是我们可以自己控制事务发生错误时回滚到某个点，这需要利用以下命令来执行：

```mysql
-- 定义保存点（回滚点）
SAVEPOINT savepoint_name（名称）;

--回滚到指定保存点
ROLLBACK TO SAVEPOINT savepoint_name（名称）;
```

-   演示 如下：

```mysql
-- 开启事务
begin;

insert into user values(31,'保存点1',null,null,1,null);

-- 创建保存点
savepoint sp;

insert into user values(32,'保存点2',null,null,1,null);

insert into user values(33,'保存点3',null,null,1,null);

insert into user values(34,'保存点4',null,null,1,null);

select * from user;

-- 回滚到保存点
rollback to savepoint sp;

-- 查看数据
select * from user;

-- 提交事务
commit ;
```

-   关于commit有点需要知道的，在mysql中每条sql命令都会被自动commit，这种功能称为自动提交功能，是默认开启的。前面我们在执行事务使用了begin命令开启了事务，这时自动提交在事务中就关闭了直到事务被手动commit。当然我们也可以手动控制开启或者关闭此功能，语法如下：

```mysql
-- 关闭自动提交功能
SET AUTOCOMMIT=0;

-- 开启自动提交功能
SET AUTOCOMMIT=1;
```

####  <font color='#ff6537'>3. 锁以及事务处理分离水平</font>

##### <font color='#054fd2'>① 了解乐观锁、悲观锁的概念</font>

-   <font color='#3dcb85'>**`悲观锁`**</font>：假设会发生并发冲突，回避一切可能违反数据完整性的操作。


-   <font color='#3dcb85'>**`乐观锁`**</font>：假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性，注意乐观锁并不能解决脏读的问题(关于脏读稍后解析)。

    

    ​		在一般情况下，悲观锁依靠数据库的锁机制实现，以保证操作最大程度的排他性和独占性，因而会导致数据库性能的大量开销和并发性很低，特别是对长事务而言，这种开销往往过于巨大而无法承受。为了解决这样的问题，乐观锁机制便出现了。乐观锁，大多情况下是基于数据版本（ Version ）记录机制实现。何谓数据版本？即为数据增加一个版本标识，在基于数据库表的版本解决方案中，一般是通过为数据库表增加一个 “version” 字段来实现。读取出数据时，将此版本号一同读出，之后更新时，对此版本号加一。此时，将提交数据的版本数据与数据库表对应记录的当前版本信息进行比对，如果提交的数据版本号大于数据库表当前版本号，则给予更新，否则认为是过期数据。

##### <font color='#054fd2'>② MySQL中的共享锁与排他锁</font>

>   在mysql中，为了保证数据一致性和防止数据处理冲突，引入了加锁和解锁的技术，这样可以使数据库中特定的数据在使用时不让其他用户(进程或事务)操作而为该数据加锁，直到该数据被处理完成后再进行解锁。根据使用目的不同把锁分为共享锁定(也称为读取锁定)和排他锁定(写入锁定)。
>

-   <font color='#3dcb85'>**`共享锁定`**</font>：将对象数据变为只读形式的锁定，这样就允许多方同时读取一个数据，此时数据将无法修改。

-   <font color='#3dcb85'>**`排他锁定`**</font>：在对数据进行insert/update/delete时进行锁定，在此时其他用户(进程或事务)一律不能读取数据，从而也保证数据完整性。

    

    ​		以上两种锁都属于悲观锁的应用，还有一点，根据锁定粒度的不同，可分为行锁定(共享锁和排他锁使用应用的就是行锁定)，表锁定，数据库锁定，可见粒度的不同将影响用户(进程或事务)对数据操作的并发性，目前mysql支持行锁定和表锁定。

##### <font color='#054fd2'>③ 事务处理分离水平</font>

锁的出现更多的是为了在多个用户(进程或事务)同时执行更新操作时保证数据的完整性和一致性，但随之而来的问题是当数据的锁定时间越长，数据同时运行性也会随之降低。也就意味着当一个用户(进程或事务)对数据保存锁定时，其他用户(进程或事务)只能等待锁定解锁，这样也就导致并发访问该数据的同时性较低。所以在多用户(进程或事务)对数据进行更新或者访问的同时如何保证数据的完整性和一致性，这样的情况下需要有一个相对折中的妥协，因为并不是频繁锁定数据或者极致提供同时运行性就是合理的，为了描述这个问题数据库中引入分离水平(有些地方称为隔离级别)的概念来确定事务处理之间的相互影响程度。其规则描述：<font color='#3dcb85'>***`分离水平越高，数据的完整性也就越高，但同时运行性下降，相反如果分离水平越低数据完整性越低，同时运行性也就提高了。`***</font>在典型的应用程序中，多个事务并发运行，经常会操作相同的数据来完成各自的任务，并发虽然是常见的，但可能会导致不同分离水平下发生不同的数据读取情况，4种分离水平以及可能导致的情景如下：

![image-20210308235152680](https://i.loli.net/2021/03/08/O91a6wSIqlAuyRZ.png)

<font color='#054fd2'>**四种分离水平(隔离级别)：**</font>

-   <font color='#3dcb85'>**`READ_UNCOMMITTED`**</font>：这是事务最低的分离水平(隔离级别)，它充许别外一个事务可以看到这个事务未提交的数据，会出现脏读、不可重复读、幻读 （分离水平最低，并发性能高）。

-   <font color='#3dcb85'>**`READ_COMMITTED`**</font>：保证一个事务修改的数据提交后才能被另外一个事务读取。另外一个事务不能读取该事务未提交的数据。可以避免脏读，但会出现不可重复读、幻读问题（锁定正在读取的行，mysql默认隔离级别）。

-   <font color='#3dcb85'>**`REPEATABLE_READ`**</font>：可以防止脏读、不可重复读，但会出幻读（锁定所读取的所有行）。

-   <font color='#3dcb85'>**`SERIALIZABLE`**</font>：这是花费最高代价但是最可靠的事务分离水平(隔离级别)，事务被处理为顺序执行。保证所有的情况不会发生（锁表,并发性及其低）。

<font color='#054fd2'>**读未提交、不可重复读，幻读：**</font>

-   <font color='#3dcb85'>**`读未提交，也称脏读`**</font>，脏读发生在一个事务读取了另一个事务改写但尚未提交的数据时。如果改写在稍后被回滚了，那么第一个事务获取的数据就是无效的。


-   <font color='#3dcb85'>**`不可重复读`**</font>：不可重复读发生在一个事务执行相同的查询两次或两次以上，但是每次都得到不同的数据时。这通常是因为另一个并发事务在两次查询期间进行了更新。请注意，不可重复读重点是修改数据导致的(修改数据时排他读);，例如：在事务1中，客户管理人员在读取了张曹宇的生日为1990-08-05,操作并没有完成


```mysql
select birth from user where name ='张曹宇' ;
```

在事务2中，这时张曹宇自己修改生日为1990-06-05,并提交了事务.

```mysql
begin;
-- 其他操作省略
update user set birth='1990-06-05' where  name ='张曹宇' ;
commit;
```

在事务1中，客户管理人员 再次读取了张曹宇的生日时，生日变为1990-06-05,从而导致在一个事务中前后两次读取的结果并不一致，导致了不可重复读。

-   <font color='#3dcb85'>**`幻读：幻读与不可重复读类似`**。</font>它发生在一个事务（T1）读取了几行数据，接着另一个并发事务（T2）插入了一些数据时。在随后的查询中，第一个事务（T1）就会发现多了一些原本不存在的记录。请注意，幻读重点是插入或者删除数据导致的（对满足条件的数据行集进行锁定），同样的道理，在事务1中，客户管理查询所有用户生日在1990-06-05的人只有20个，操作并没有完成，此时事务2中，刚好有一个新注册的用户，其生日也1990-06-05，在事务2中插入新用户并提交了事务，此时在事务1中再次查询时，所有用户生日在1990-06-05的人变为21个了，从也就导致了幻读。

    

    ​		可以发现在分离水平为READ UNCOMMITTED时，将会导致3种情况的出现，因此这样的分离水平一般是不建议使用的。在分离水平为READ COMMITTED时，不会导致脏读，但会导致不可重复读和幻读，要回避这样的现象，必须采用分离水平为REPEATABLE READ，这样就只会导致幻读，而当分离水平为SERIALIZABLE时，3种现象都不复存在。但请注意这并不意味着所有情况下采用分离水平为SERIALIZABLE都是合理的，就如前面所分析的分离水平越高，数据的完整性也就越高，但同时运行性下降。在大多数情况下，我们会在根据应用的实际情景选择分离水平为REPEATABLE READ或者READ COMMITTED(MySQL默认的事务分离水平为REPEATABLE READ)，这样既能一定程度上保证数据的完整性也同时提供了数据的同时运行性，在mysql中我们可以使用以下语法设置事务分离水平。

```mysql
-- 设置当前连接的事务分离水平
SET SESSION TRANSACTION ISOLATION LEVEL 事务分离水平;

--设置全部连接（包括新连接）的事务分离水平
SET GLOBAL TRANSACTION ISOLATION LEVEL 事务分离水平;
```

##### <font color='#054fd2'>④ 事务、分离水平、锁之间的关系</font>

​		通过上述的分析，我们也理解了事务、锁和分离水平的概念，但锁和事务以及分离水平关系如何呢？实际上，事务是解决多条sql执行执行过程的原子性、一致性、隔离性、持久性的整体解决方案，而事务分离水平则是并发控制的整体解决方案，其实际是综合利用各种类型的锁来解决并发问题。锁是数据库并发控制的内部基础机制。对应用开发人员来说，只有当事务分离水平无法解决并发问题和需求时，才有必要在语句中手动设置锁。关于锁的锁定，对于UPDATE、DELETE和INSERT语句，InnoDB会自动给涉及数据集加排他锁（X)；对于普通SELECT语句，InnoDB不会加任何锁，事务可以通过以下语句显示给记录集加共享锁或排他锁。请注意InnoDB行锁是通过给索引上的索引项加锁来实现的，也就是说，只有通过索引条件检索数据，InnoDB才使用行级锁，否则，InnoDB将使用表锁。

```mysql
-- 共享锁（S）
SELECT * FROM table_name WHERE ... LOCK IN SHARE MODE;

-- 排他锁（X)
SELECT * FROM table_name WHERE ... FOR UPDATE;
```

####  <font color='#ff6537'>4. 事务原理概要</font>

>   事实上事务的处理机制是通过记录更新日志而实现的，其中与事务处理相关的日志是UNDO日志和REDO日志。

-   UNDO：日志亦称为回滚端，在进行数据插入、更新、删除的情景下，保存变更前的数据，原理图如下：

![事务原理概要](https://i.loli.net/2021/03/09/lVLOWYrFo1zepJj.png)

​		在表中保存了指向UNDO日志的指针，rollback执行时根据这个指针来获取旧数据并覆盖到表中，rollback执行完成后或者commit后UNDO日志将被删除。UNDO还有另外一种作用，当A用户正在更新数据时，还没提交，而B用户也需要使用该数据，这时不可能让B读取未提交的数据，因此会将存在UNDO表中的数据提供给B用户。这就是事务回滚的简单模型。

-   REDO日志主要是事务提交后由于错误或者断电停机等原因使数据无法更新到数据库中时，REDO日志将提供数据恢复作用。其原理是通过数据库中的一段缓冲的数据先<font color='#3dcb85'>***`实时更新`***</font>到REDO日志再更新到数据库，也就是说平常的更新操作并非一步执行到位的，而是首选更新到REDO日志中，再更新到数据库文件的。所以REDO日志才能用户故障数据的恢复。

------

​																													至此，MySQL进阶篇完成。

------

 <font color='#3dcb85'>***`流转于指尖的记忆，既使一瞬，亦是永恒。                                                                                                     ———— Fisher`***</font>