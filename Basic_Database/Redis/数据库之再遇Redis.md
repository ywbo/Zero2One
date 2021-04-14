# 数据库之再遇Redis

## 一、概述

> 	Redis 是速度非常快的<font style="color:red">**`非关系型（NoSQL）内存键值数据库`**</font>。可以存储键和物种不同类型的值之间的映射。
>
> <font color='red'>键的类型只能为**`字符串`**</font>，值支持五种数据类型：<font color='green'>**`字符串`**、**`列表`**、**`集合`**、**`散列表`**、**`有序集合`**</font>。
>	
> Redis 支持很多特性，例如将内存中的数据持久化到硬盘中，使用复制来扩展读性能，使用分片来扩展写性能。

## 二、数据类型

| 数据类型 | 可以存储的值           | 操作                                                         |
| :------- | :--------------------- | ------------------------------------------------------------ |
| STRING   | 字符串、整数或者浮点数 | 对整个字符串或者字符串的其中一部分执行操作</br> 对整数和浮点数执行自增或者自减操作 |
| LIST     | 列表                   | 从两端压入或者弹出元素 </br> 对单个或者多个元素进行修剪，</br> 只保留一个范围内的元素 |
| SET      | 无序集合               | 添加、获取、移除单个元素</br> 检查一个元素是否存在于集合中</br> 计算交集、并集、差集</br> 从集合里面随机获取元素 |
| HASH     | 包含键值对的无序散列表 | 添加、获取、移除单个键值对</br> 获取所有键值对</br> 检查某个键是否存在 |
| ZSET     | 有序集合               | 添加、获取、删除元素</br> 根据分值范围或者成员来获取元素</br> 计算一个键的排名 |

### 1. STRING

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\String.png)

```powershell
> set hello world
OK
> get hello
"world"
> del hello
(integer) 1
> get hello
(nil)
```

### 2. LIST

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\List.png)

```powershell
> rpush list-key item
(integer) 1
> rpush list-key item2
(integer) 2
> rpush list-key item
(integer) 3

> lrange list-key 0 -1
1) "item"
2) "item2"
3) "item"

> lindex list-key 1
"item2"

> lpop list-key
"item"

> lrange list-key 0 -1
1) "item2"
2) "item"
```

### 3. SET

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Set.png)

```powershell
> sadd set-key item
(integer) 1
> sadd set-key item2
(integer) 1
> sadd set-key item3
(integer) 1
> sadd set-key item
(integer) 0

> smembers set-key
1) "item"
2) "item2"
3) "item3"

> sismember set-key item4
(integer) 0
> sismember set-key item
(integer) 1

> srem set-key item2
(integer) 1
> srem set-key item2
(integer) 0

> smembers set-key
1) "item"
2) "item3"
```

### 4. HASH

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Hash.png)

```powershell
> hset hash-key sub-key1 value1
(integer) 1
> hset hash-key sub-key2 value2
(integer) 1
> hset hash-key sub-key1 value1
(integer) 0

> hgetall hash-key
1) "sub-key1"
2) "value1"
3) "sub-key2"
4) "value2"

> hdel hash-key sub-key2
(integer) 1
> hdel hash-key sub-key2
(integer) 0

> hget hash-key sub-key1
"value1"

> hgetall hash-key
1) "sub-key1"
2) "value1"
```

### 5. ZSET

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Zset.png)

```powershell
> zadd zset-key 728 member1
(integer) 1
> zadd zset-key 982 member0
(integer) 1
> zadd zset-key 982 member0
(integer) 0

> zrange zset-key 0 -1 withscores
1) "member1"
2) "728"
3) "member0"
4) "982"

> zrangebyscore zset-key 0 800 withscores
1) "member1"
2) "728"

> zrem zset-key member1
(integer) 1
> zrem zset-key member1
(integer) 0

> zrange zset-key 0 -1 withscores
1) "member0"
2) "982"
```

## 三、数据结构

### 1. 字典

dictht 是一个散列表结构，使用拉链法解决哈希冲突。

```c
/* This is our hash table structure. Every dictionary has two of this as we
 * implement incremental rehashing, for the old to the new table. */
typedef struct dictht {
    dictEntry **table;
    unsigned long size;
    unsigned long sizemask;
    unsigned long used;
} dictht;
```

```c
typedef struct dictEntry {
    void *key;
    union {
        void *val;
        uint64_t u64;
        int64_t s64;
        double d;
    } v;
    struct dictEntry *next;
} dictEntry;
```

	Redis 的字典 dict 中包含两个哈希表 dictht，这是为了方便进行 rehash 操作。在扩容时，将其中一个 dictht 上的键值对 rehash 到另一个 dictht 上面， 完成之后释放空间并交换两个 dictht 的角色。

```c
typedef struct dict {
    dictType *type;
    void *privdata;
    dictht ht[2];
    long rehashidx; /* rehashing not in progress if rehashidx == -1 */
    unsigned long iterators; /* number of iterators currently running */
} dict;
```

<font style="color:green">rehash 操作不是一次性完成，而是采用渐进式，这是为了避免一次性执行过多的 rehash 操作给服务器带来过大的负担。</font>

	渐进式 rehash 通过记录 dict 的 rehashidx 完成，它从 0 开始，然后每执行一次 rehash 都会递增。例如在一次 rehash 中，要把 dict[0] rehash 到 dict[1]，这一次会把 dict[0] 上 table[rehashidx] 的键值对 rehash 到 dict[1] 上，dict[0] 的 table[rehashidx] 指向 null，并令 rehashidx++。

在 rehash 期间，每次对字典执行添加、删除、查找或者更新操作时，都会执行一次渐进式 rehash。

	采用渐进式 rehash 会导致字典中的数据分散在两个 dictht 上，因此对字典的查找操作也需要到对应的 dictht 去执行。

```c
/* Performs N steps of incremental rehashing. Returns 1 if there are still
 * keys to move from the old to the new hash table, otherwise 0 is returned.
 *
 * Note that a rehashing step consists in moving a bucket (that may have more
 * than one key as we use chaining) from the old to the new hash table, however
 * since part of the hash table may be composed of empty spaces, it is not
 * guaranteed that this function will rehash even a single bucket, since it
 * will visit at max N*10 empty buckets in total, otherwise the amount of
 * work it does would be unbound and the function may block for a long time. */
int dictRehash(dict *d, int n) {
    int empty_visits = n * 10; /* Max number of empty buckets to visit. */
    if (!dictIsRehashing(d)) return 0;

    while (n-- && d->ht[0].used != 0) {
        dictEntry *de, *nextde;

        /* Note that rehashidx can't overflow as we are sure there are more
         * elements because ht[0].used != 0 */
        assert(d->ht[0].size > (unsigned long) d->rehashidx);
        while (d->ht[0].table[d->rehashidx] == NULL) {
            d->rehashidx++;
            if (--empty_visits == 0) return 1;
        }
        de = d->ht[0].table[d->rehashidx];
        /* Move all the keys in this bucket from the old to the new hash HT */
        while (de) {
            uint64_t h;

            nextde = de->next;
            /* Get the index in the new hash table */
            h = dictHashKey(d, de->key) & d->ht[1].sizemask;
            de->next = d->ht[1].table[h];
            d->ht[1].table[h] = de;
            d->ht[0].used--;
            d->ht[1].used++;
            de = nextde;
        }
        d->ht[0].table[d->rehashidx] = NULL;
        d->rehashidx++;
    }

    /* Check if we already rehashed the whole table... */
    if (d->ht[0].used == 0) {
        zfree(d->ht[0].table);
        d->ht[0] = d->ht[1];
        _dictReset(&d->ht[1]);
        d->rehashidx = -1;
        return 0;
    }

    /* More to rehash... */
    return 1;
}
```

### 2. 跳跃表

跳跃表是有序集合的底层实现之一。

跳跃表是基于多指针有序链表实现的，可以看成多个有序链表。

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\tiaoyuebiao1.png)

在查找时，从上层指针开始查找，找到对应的区间之后再到下一层去查找。下图演示了查找 22 的过程。

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\tiaoyuebiao2.png)

<font color='#1cb569'>与红黑树等平衡树相比，跳跃表具有以下优点：</font>

- <font color='#1cb569'>插入速度非常快速，因为不需要进行旋转等操作来维护平衡性；</font>
- <font color='#1cb569'>更容易实现；</font>
- <font color='#1cb569'>支持无锁操作。</font>

## 四、使用场景 :coffee:

### 1. 计数器

- 可以对 String 进行自增自减运算，从而实现计数器功能。

- Redis 这种内存型数据库的读写性能非常高，很适合存储频繁读写的计数量。

### 2. 缓存

- <font color='#1cb569'>将**`热点数据`**放到内存中，设置内存的最大使用量以及淘汰策略来保证缓存的命中率。</font>

### 3. 查找表

- 例如 DNS 记录就很适合使用 Redis 进行存储。
- 查找表和缓存类似，也是利用了 Redis 快速的查找特性。但是查找表的内容不能失效，而缓存的内容可以失效，因为缓存不作为可靠的数据来源。

### 4. 消息队列

- List 是一个双向链表，可以通过 lpush 和 rpop 写入和读取消息
- 不过最好使用 Kafka、RabbitMQ 等消息中间件。

### 5. 会话缓存

- 可以使用 Redis 来统一存储多台应用服务器的会话信息。
- 当应用服务器不再存储用户的会话信息，也就不再具有状态，一个用户可以请求任意一个应用服务器，从而更容易实现高可用性以及可伸缩性。

### 6. 分布式锁实现

- 在分布式场景下，无法使用单机环境下的锁来对多个节点上的进程进行同步。
- 可以使用 Redis 自带的 SETNX 命令实现分布式锁，除此之外，还可以使用官方提供的 RedLock 分布式锁实现。

### 7. 其它

- Set 可以实现交集、并集等操作，从而实现共同好友等功能。
- ZSet 可以实现有序性操作，从而实现排行榜等功能。

## 五、Redis与Memcached :dart:

两者都是非关系型内存键值数据库，主要有以下不同：

### 1. 数据类型

- <font color='#e6000b'>Memcached 仅支持字符串类型</font>，而 Redis 支持<font color='#e6000b'>五种不同的数据类型</font>，可以更灵活地解决问题。

### 2. 数据持久化

- Redis 支持两种持久化策略：RDB 快照和 AOF 日志，而 <font color='#e6000b'>Memcached 不支持持久化</font>。

### 3. 分布式

- <font color='#e6000b'>Memcached 不支持分布式</font>，只能通过在客户端使用一致性哈希来实现分布式存储，这种方式在存储和查询时都需要先在客户端计算一次数据所在的节点。
- <font color='#e6000b'>Redis Cluster 实现了分布式的支持</font>。

### 4. 内存管理机制

- 在 Redis 中，并不是所有数据都一直存储在内存中，可以将一些很久没用的 value 交换到磁盘，而 <font color='#e6000b'>Memcached 的数据则会一直在内存中</font>。
- Memcached 将内存分割成特定长度的块来存储数据，以完全解决内存碎片的问题。但是这种方式会使得内存的利用率不高，例如块的大小为 128 bytes，只存储 100 bytes 的数据，那么剩下的 28 bytes 就浪费掉了。

## 六、键的过期时间

- Redis 可以为每个键设置过期时间，当键过期时，会自动删除该键。
- 对于散列表这种容器，只能为整个键设置过期时间（整个散列表），而不能为键里面的单个元素设置过期时间。

## 七、数据淘汰策略

可以设置内存最大使用量，当内存使用量超出时，会施行数据淘汰策略。

Redis 具体有 6 种淘汰策略：

|                          策略                          |                             描述                             |
| :----------------------------------------------------: | :----------------------------------------------------------: |
|                      volatile-lru                      |     从已设置过期时间的数据集中挑选最近最少使用的数据淘汰     |
|                      volatile-ttl                      |       从已设置过期时间的数据集中挑选将要过期的数据淘汰       |
|                    volatile-random                     |          从已设置过期时间的数据集中任意选择数据淘汰          |
|                      allkeys-lru                       |           从所有数据集中挑选最近最少使用的数据淘汰           |
|                     allkeys-random                     |              从所有数据集中任意选择数据进行淘汰              |
|                       noeviction                       |                         禁止驱逐数据                         |
| <font color='#1cb569'>volatile-lfu（Redis 4.0）</font> | <font color='#1cb569'>通过统计访问频率，将访问频率最少的键值对淘汰</font> |
| <font color='#1cb569'>allkeys-lfu（Redis 4.0）</font>  | <font color='#1cb569'>通过统计访问频率，将访问频率最少的键值对淘汰</font> |

- 作为内存数据库，出于对性能和内存消耗的考虑，Redis 的淘汰算法实际实现上并非针对所有 key，而是抽样一小部分并且从中选出被淘汰的 key。
- 使用 Redis 缓存数据时，为了提高缓存命中率，需要保证缓存数据都是热点数据。可以将内存最大使用量设置为热点数据占用的内存量，然后启用 allkeys-lru 淘汰策略，将最近最少使用的数据淘汰。
- Redis 4.0 引入了 volatile-lfu 和 allkeys-lfu 淘汰策略，LFU 策略通过统计访问频率，将访问频率最少的键值对淘汰。

## 八、持久化

Redis 是内存型数据库，为了保证数据在断电后不会丢失，需要将内存中的数据持久化到硬盘上。

### 1. RDB 持久化

- 将某个时间点的所有数据都存放到硬盘上。
- 可以将快照复制到其它服务器从而创建具有相同数据的服务器副本。
- 如果系统发生故障，将会丢失最后一次创建快照之后的数据。
- 如果数据量很大，保存快照的时间会很长。

### 2. AOF 持久化

- 将写命令添加到 AOF 文件（Append Only File）的末尾。
- 使用 AOF 持久化需要设置同步选项，从而确保写命令同步到磁盘文件上的时机。这是因为对文件进行写入并不会马上将内容同步到磁盘上，而是先存储到缓冲区，然后由操作系统决定什么时候同步到磁盘。有以下同步选项：

|   选项   |         同步频率         |
| :------: | :----------------------: |
|  always  |     每个命令都会同步     |
| everysec |       每秒同步一次       |
|    no    | 让操作系统来决定何时同步 |

- always 选项会严重减低服务器的性能；

- everysec 选项比较合适，可以保证系统崩溃时只会丢失一秒左右的数据，并且 Redis 每秒执行一次同步对服务器性能几乎没有任何影响；
- no 选项并不能给服务器性能带来多大的提升，而且也会增加系统崩溃时数据丢失的数量。

:point_right: <font color='#e6000b'>随着服务器写请求增多，AOF文件会越来越大。Redis 提供了一种将 AOF 重写的特性，能够去除 AOF 文件命令中的冗余写命令。</font>

## 九、事务

### 1. Redis 事务

- <font color='#e6000b'>一个事务包含了多个命令</font>，服务器在执行事务期间，不会改去执行其它客户端的命令请求。
- 事务中的多个命令被一次性发送给服务器，而不是一条一条发送，这种方式被称为流水线，它可以减少客户端与服务器之间的网络通信次数从而提升性能。
- Redis 最简单的事务实现方式是使用 MULTI 和 EXEC 命令将事务操作包围起来。
- <font color='#e6000b'>Redis 事务可以一次执行多个命令</font>， 并且带有以下三个重要的保证：
  - 批量操作在发送 EXEC 命令前被放入队列缓存。
  - 收到 EXEC 命令后进入事务执行，事务中任意命令执行失败，其余的命令依然被执行。
  - 在事务执行过程，其他客户端提交的命令请求不会插入到事务执行命令序列中。

- 一个事务从开始到执行会经历以下三个阶段：
  - 开始事务。
  - 命令入队。
  - 执行事务。

### 2. 实例

```powershell
127.0.0.1:6379> MULTI
OK

127.0.0.1:6379> SET book-name "Thinking in Java"
QUEUED

127.0.0.1:6379> GET book-name
QUEUED

127.0.0.1:6379> SADD tag "Java" "Programming" "Mastering Series"
QUEUED

127.0.0.1:6379> SMEMBERS tag
QUEUED

127.0.0.1:6379> EXEC
1) OK
2) "Mastering C++ in 21 days"
3) (integer) 3
4) 1) "Mastering Series"
   2) "C++"
   3) "Programming"
```

> <font color='#e6000b'>**`单个 Redis 命令的执行是原子性的，但 Redis 没有在事务上增加任何维持原子性的机制，所以 Redis 事务的执行并不是原子性的。`**</font>
>
> <font color='#e6000b'>**`事务可以理解为一个打包的批量执行脚本，但批量指令并非原子化的操作，中间某条指令的失败不会导致前面已做指令的回滚，也不会造成后续的指令不做。`**</font>

> **这是官网上的说明 From redis docs on [transactions](https://redis.io/topics/transactions):**
>
> It's important to note that even when a command fails, all the other commands in the queue are processed – Redis will not stop the processing of commands.

```powershell
127.0.0.1:7000> multi
OK
127.0.0.1:7000> set a aaa
QUEUED
127.0.0.1:7000> set b bbb
QUEUED
127.0.0.1:7000> set c ccc
QUEUED
127.0.0.1:7000> exec
1) OK
2) OK
3) OK
```

:point_right:  <font color='#e6000b'>如果在 set b bbb 处失败，set a 已成功不会回滚，set c 还会继续执行。</font>

### 3. Redis 事务命令

下表列出了 redis 事务的相关命令：

| 命令                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [DISCARD](https://www.runoob.com/redis/transactions-discard.html) | 取消事务，放弃执行事务块内的所有命令。                       |
| [EXEC](https://www.runoob.com/redis/transactions-exec.html)  | 执行所有事务块内的命令。                                     |
| [MULTI](https://www.runoob.com/redis/transactions-multi.html) | 标记一个事务块的开始。                                       |
| [UNWATCH](https://www.runoob.com/redis/transactions-unwatch.html) | 取消 WATCH 命令对所有 key 的监视。                           |
| [WATCH key [key ...\]](https://www.runoob.com/redis/transactions-watch.html) | 监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。 |

## 十、事件

Redis 服务器是一个事件驱动程序。

### 1. 文件事件

- 服务器通过[套接字(Socket)](https://blog.csdn.net/luzhensmart/article/details/81838193)与客户端或者其它服务器进行通信，文件事件就是对套接字操作的抽象。
- Redis 基于 Reactor 模式开发了自己的网络事件处理器，使用 I/O 多路复用程序来同时监听多个套接字，并将到达的事件传送给文件事件分派器，分派器会根据套接字产生的事件类型调用相应的事件处理器。

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\wenjianshijian.png)

	:mag_right: [什么时套接字(Socket)](https://blog.csdn.net/luzhensmart/article/details/81838193)
	
	:mag_right: [Socket的学习](https://blog.csdn.net/weixin_39258979/article/details/80835555?utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control&dist_request_id=&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-1.control)

### 2. 时间事件

- 服务器有一些操作需要在给定的时间点执行，时间事件是对这类定时操作的抽象。
- 时间事件又分为：
  - 定时事件：是让一段程序在指定的时间之内执行一次；
  - 周期性事件：是让一段程序每隔指定时间就执行一次。

:warning: Redis 将所有时间事件都放在一个无序链表中，通过遍历整个链表查找出已到达的时间事件，并调用相应的事件处理器。

### 3. 事件的调度与执行

服务器需要不断监听文件事件的套接字才能得到待处理的文件事件，但是不能一直监听，否则时间事件无法在规定的时间内执行，因此监听时间应该根据距离现在最近的时间事件来决定。

事件调度与执行由 aeProcessEvents 函数负责，伪代码如下：

```c
def aeProcessEvents():
    # 获取到达时间离当前时间最接近的时间事件
    time_event = aeSearchNearestTimer()
    # 计算最接近的时间事件距离到达还有多少毫秒
    remaind_ms = time_event.when - unix_ts_now()
    # 如果事件已到达，那么 remaind_ms 的值可能为负数，将它设为 0
    if remaind_ms < 0:
        remaind_ms = 0
    # 根据 remaind_ms 的值，创建 timeval
    timeval = create_timeval_with_ms(remaind_ms)
    # 阻塞并等待文件事件产生，最大阻塞时间由传入的 timeval 决定
    aeApiPoll(timeval)
    # 处理所有已产生的文件事件
    procesFileEvents()
    # 处理所有已到达的时间事件
    processTimeEvents()
```

将 aeProcessEvents 函数置于一个循环里面，加上初始化和清理函数，就构成了 Redis 服务器的主函数，伪代码如下：

```c
def main():
    # 初始化服务器
    init_server()
    # 一直处理事件，直到服务器关闭为止
    while server_is_not_shutdown():
        aeProcessEvents()
    # 服务器关闭，执行清理操作
    clean_server()
```

从事件处理的角度来看，服务器运行流程如下： 

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\shijiandiaodu.png)

## 十一、复制

> - **<font color='#e6000b'>通过使用 slaveof host port 命令来让一个服务器成为另一个服务器的从服务器。</font>**
> - **<font color='#e6000b'>一个从服务器只能有一个主服务器，并且不支持 `主主复制`。</font>**

### 1. 连接过程

	1）主服务器创建快照文件，发送给从服务器，并在发送期间使用缓冲区记录执行的写命令。快照文件发送完毕之后，开始向从服务器发送存储在缓冲区中的写命令；
	
	2）从服务器丢弃所有旧数据，载入主服务器发来的快照文件，之后从服务器开始接受主服务器发来的写命令；
	
	3）主服务器每执行一次写命令，就向从服务器发送相同的写命令。

### 2. 主从链

	随着负载不断上升，主服务器可能无法很快地更新所有从服务器，或者重新连接和重新同步从服务器将导致系统超载。为了解决这个问题，可以创建一个中间层来分担主服务器的复制工作。中间层的服务器是最上层服务器的从服务器，又是最下层服务器的主服务器。

![img](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\zhuconglian.png)

## 十二、Sentinel（哨兵模式）

Sentinel（哨兵）可以监听集群中的服务器，并在主服务器进入下线状态时，自动从从服务器中选举出新的主服务器。

### 1. Sentinel（哨兵模式）介绍

Sentinel(哨兵)是用于监控redis集群中Master状态的工具，是Redis 的高可用性解决方案，sentinel哨兵模式已经被集成在redis2.4之后的版本中。sentinel是redis高可用的解决方案，sentinel系统可以监视一个或者多个redis master服务，以及这些master服务的所有从服务；当某个master服务下线时，自动将该master下的某个从服务升级为master服务替代已下线的master服务继续处理请求。

sentinel可以让redis实现主从复制，当一个集群中的master失效之后，sentinel可以选举出一个新的master用于自动接替master的工作，集群中的其他redis服务器自动指向新的master同步数据。一般建议sentinel采取奇数台，防止某一台sentinel无法连接到master导致误切换。其结构如下:

![在这里插入图片描述](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Sentinel.png)

Redis-Sentinel是Redis官方推荐的高可用性(HA)解决方案，当用Redis做Master-slave的高可用方案时，假如master宕机了，Redis本身(包括它的很多客户端)都没有实现自动进行主备切换，而Redis-sentinel本身也是一个独立运行的进程，它能监控多个master-slave集群，发现master宕机后能进行自动切换。Sentinel由一个或多个Sentinel 实例 组成的Sentinel 系统可以监视任意多个主服务器，以及这些主服务器属下的所有从服务器，并在被监视的主服务器进入下线状态时，自动将下线主服务器属下的某个从服务器升级为新的主服务器。

例如下图所示：

![在这里插入图片描述](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Sentinel_01.png)

在Server1 掉线后：

![在这里插入图片描述](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Sentinel_02.png)

升级Server2 为新的主服务器：

![在这里插入图片描述](D:\ywbWork\StudyNote\三省吾身\数据库\accesst\Sentinel_03.png)

------------------------------------------------
:mag_right: [Sentinel（哨兵模式）详细介绍](https://blog.csdn.net/weixin_45572139/article/details/106295494)

:mag_right: [Redis哨兵(sentinel)模式配置详解及原理介绍](https://blog.csdn.net/macro_g/article/details/82593996)

------------------------------------------------
## 十三、分片

分片是将数据划分为多个部分的方法，可以将数据存储到多台机器里面，这种方法在解决某些问题时可以获得线性级别的性能提升。

假设有 4 个 Redis 实例 R0，R1，R2，R3，还有很多表示用户的键 user:1，user:2，... ，有不同的方式来选择一个指定的键存储在哪个实例中。

- 最简单的方式是范围分片，例如用户 id 从 0~1000 的存储到实例 R0 中，用户 id 从 1001~2000 的存储到实例 R1 中，等等。但是这样需要维护一张映射范围表，维护操作代价很高。
- 还有一种方式是哈希分片，使用 CRC32 哈希函数将键转换为一个数字，再对实例数量求模就能知道应该存储的实例。

根据执行分片的位置，可以分为三种分片方式：

- 客户端分片：客户端使用一致性哈希等算法决定键应当分布到哪个节点。
- 代理分片：将客户端请求发送到代理上，由代理转发请求到正确的节点上。
- 服务器分片：Redis Cluster。

## 十四、缓存穿透，缓存击穿，缓存雪崩等问题解剖分析

### 1. 概念初识

- **缓存穿透**：key对应的数据在数据源并不存在，自然在缓存中也不会存在。每次针对此key的请求从缓存获取不到，请求都会到数据源，从而可能压垮数据源。比如用一个不存在的用户id获取用户信息，不论缓存还是数据库都没有，若黑客利用此漏洞进行攻击可能压垮数据库。
- **缓存击穿**：key对应的数据存在，但在redis中过期，此时若有大量并发请求过来，这些请求发现缓存过期一般都会从后端DB加载数据并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮。
- **缓存雪崩**：当缓存服务器重启或者大量缓存集中在某一个时间段失效（过期），新缓存未到时间。这样在失效的时候，所有请求都去查数据库，对数据库CPU造成巨大压力，严重的会造成数据库宕机。从而形成一系列连锁反应，造成整个系统崩溃。
- **缓存预热**：缓存预热就是系统上线后，将相关的缓存数据直接加载到缓存系统。这样避免，用户请求的时候，再去加载相关的数据。

### 2. 缓存穿透解决方案

- 一个一定不存在缓存及查询不到的数据，由于缓存是不命中时被动写的，并且出于容错考虑，如果从存储层查不到数据则不写入缓存，这将导致这个不存在的数据每次请求都要到存储层去查询，失去了缓存的意义。
- **有很多种方法可以有效地解决缓存穿透问题**，**最常见**的则是采用布隆过滤器，将所有可能存在的数据哈希到一个足够大的bitmap中，一个一定不存在的数据会被 这个bitmap拦截掉，从而避免了对底层存储系统的查询压力。**另外也有一个**更为简单粗暴的方法（我们采用的就是这种），如果一个查询返回的数据为空（不管是数据不存在，还是系统故障），我们仍然把这个空结果进行缓存，但它的过期时间会很短，最长不超过五分钟。

解决办法：粗暴方式伪代码：

```java
//伪代码
public object GetProductListNew() {
    int cacheTime = 30;
    String cacheKey = "product_list";

    String cacheValue = CacheHelper.Get(cacheKey);
    if (cacheValue != null) {
        return cacheValue;
    }

    cacheValue = CacheHelper.Get(cacheKey);
    if (cacheValue != null) {
        return cacheValue;
    } else {
        //数据库查询不到，为空
        cacheValue = GetProductListFromDB();
        if (cacheValue == null) {
            //如果发现为空，设置个默认值，也缓存起来
            cacheValue = string.Empty;
        }
        CacheHelper.Add(cacheKey, cacheValue, cacheTime);
        return cacheValue;
    }
}
```

### 3. 缓存击穿解决方案

- key可能会在某些时间点被超高并发地访问，是一种非常“热点”的数据。这个时候，需要考虑一个问题：缓存被“击穿”的问题。

- **使用互斥锁(mutex key)**

- 业界比较常用的做法，是使用mutex。简单地来说，就是在缓存失效的时候（判断拿出来的值为空），不是立即去load db，而是先使用缓存工具的某些带成功操作返回值的操作（比如Redis的SETNX或者Memcache的ADD）去set一个mutex key，当操作返回成功时，再进行load db的操作并回设缓存；否则，就重试整个get缓存的方法。

- SETNX，是「SET if Not eXists」的缩写，也就是只有不存在的时候才设置，可以利用它来实现锁的效果。

解决方法：

```java
public String get(key) {
      String value = redis.get(key);
      if (value == null) { //代表缓存值过期
          //设置3min的超时，防止del操作失败的时候，下次缓存过期一直不能load db
      if (redis.setnx(key_mutex, 1, 3 * 60) == 1) {  //代表设置成功
               value = db.get(key);
                      redis.set(key, value, expire_secs);
                      redis.del(key_mutex);
              } else {  //这个时候代表同时候的其他线程已经load db并回设到缓存了，这时候重试获取缓存值即可
                      sleep(50);
                      get(key);  //重试
              }
          } else {
              return value;      
          }
 }
```

memcache代码：

```java
if (memcache.get(key) == null) {  
    // 3 min timeout to avoid mutex holder crash  
    if (memcache.add(key_mutex, 3 * 60 * 1000) == true) {  
        value = db.get(key);  
        memcache.set(key, value);  
        memcache.delete(key_mutex);  
    } else {  
        sleep(50);  
        retry();  
    }  
}
```

### 4. 缓存雪崩解决方案

- 与缓存击穿的区别在于这里针对很多key缓存，前者则是某一个key。
- 缓存失效时的雪崩效应对底层系统的冲击非常可怕！大多数系统设计者考虑用加锁或者队列的方式保证来保证不会有大量的线程对数据库一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。还有一个简单方案就时讲缓存失效时间分散开，比如我们可以在原有的失效时间基础上增加一个随机值，比如1-5分钟随机，这样每一个缓存的过期时间的重复率就会降低，就很难引发集体失效的事件。

**Ⅰ. 加锁排队，伪代码如下：**

```java
//伪代码
public object GetProductListNew() {
    int cacheTime = 30;
    String cacheKey = "product_list";
    String lockKey = cacheKey;

    String cacheValue = CacheHelper.get(cacheKey);
    if (cacheValue != null) {
        return cacheValue;
    } else {
        synchronized(lockKey) {
            cacheValue = CacheHelper.get(cacheKey);
            if (cacheValue != null) {
                return cacheValue;
            } else {
              //这里一般是sql查询数据
                cacheValue = GetProductListFromDB(); 
                CacheHelper.Add(cacheKey, cacheValue, cacheTime);
            }
        }
        return cacheValue;
    }
}
```

加锁排队只是为了减轻数据库的压力，并没有提高系统吞吐量。假设在高并发下，缓存重建期间key是锁着的，这是过来1000个请求999个都在阻塞的。同样会导致用户等待超时，这是个治标不治本的方法！

<font color='#e6000b'>**注意：加锁排队的解决方式分布式环境的并发问题，有可能还要解决分布式锁的问题；线程还会被阻塞，用户体验很差！因此，在真正的高并发场景下很少使用！**</font>

**Ⅱ. 随机值伪代码：**

```java
//伪代码
public object GetProductListNew() {
    int cacheTime = 30;
    String cacheKey = "product_list";
    //缓存标记
    String cacheSign = cacheKey + "_sign";

    String sign = CacheHelper.Get(cacheSign);
    //获取缓存值
    String cacheValue = CacheHelper.Get(cacheKey);
    if (sign != null) {
        return cacheValue; //未过期，直接返回
    } else {
        CacheHelper.Add(cacheSign, "1", cacheTime);
        ThreadPool.QueueUserWorkItem((arg) -> {
      //这里一般是 sql查询数据
            cacheValue = GetProductListFromDB(); 
          //日期设缓存时间的2倍，用于脏读
          CacheHelper.Add(cacheKey, cacheValue, cacheTime * 2);                 
        });
        return cacheValue;
    }
} 
```

**解释说明：**

- 缓存标记：记录缓存数据是否过期，如果过期会触发通知另外的线程在后台去更新实际key的缓存；
- 缓存数据：它的过期时间比缓存标记的时间延长1倍，例：标记缓存时间30分钟，数据缓存设置为60分钟。这样，当缓存标记key过期后，实际缓存还能把旧数据返回给调用端，直到另外的线程在后台更新完成后，才会返回新缓存。

关于缓存崩溃的解决方法，这里提出了三种方案：使用锁或队列、设置过期标志更新缓存、为key设置不同的缓存失效时间，还有一种被称为“二级缓存”的解决方法。

### 5. 缓存预热解决方案

缓存预热就是系统上线后，将相关的缓存数据直接加载到缓存系统。这样避免，用户请求的时候，再去加载相关的数据。

解决思路：

　　　1，直接写个缓存刷新页面，上线时手工操作下。

　　　2，数据量不大，可以在WEB系统启动的时候加载。

　　　3，定时刷新缓存。

------

参考：[REDIS缓存穿透，缓存击穿，缓存雪崩原因+解决方案](https://www.cnblogs.com/xichji/p/11286443.html)

------

## 十五、Redis 常用命令

### 1. 连接操作命令

- quit：关闭连接（connection）

- auth：简单密码认证
- help cmd： 查看cmd帮助，例如：help quit

### 2. 持久化

- save：将数据同步保存到磁盘

- bgsave：将数据异步保存到磁盘
- lastsave：返回上次成功将数据保存到磁盘的Unix时戳
- shundown：将数据同步保存到磁盘，然后关闭服务

### 3. 远程服务控制

- info：提供服务器的信息和统计

- monitor：实时转储收到的请求
- slaveof：改变复制策略设置
- config：在运行时配置Redis服务器

### 4. 对value操作的命令

- exists(key)：确认一个key是否存在

- del(key)：删除一个key
- type(key)：返回值的类型
- keys(pattern)：返回满足给定pattern的所有key
- randomkey：随机返回key空间的一个
- keyrename(oldname, newname)：重命名key
- dbsize：返回当前数据库中key的数目
- expire：设定一个key的活动时间（s）
- ttl：获得一个key的活动时间
- select(index)：按索引查询
- move(key, dbindex)：移动当前数据库中的key到dbindex数据库
- flushdb：删除当前选择数据库中的所有key
- flushall：删除所有数据库中的所有key

### 5. String

- set(key, value)：给数据库中名称为key的string赋予值value

- get(key)：返回数据库中名称为key的string的value
- getset(key, value)：给名称为key的string赋予上一次的value
- mget(key1, key2,…, key N)：返回库中多个string的value
- setnx(key, value)：添加string，名称为key，值为value
- setex(key, time, value)：向库中添加string，设定过期时间time
- mset(key N, value N)：批量设置多个string的值
- msetnx(key N, value N)：如果所有名称为key i的string都不存在
- incr(key)：名称为key的string增1操作
- incrby(key, integer)：名称为key的string增加integer
- decr(key)：名称为key的string减1操作
- decrby(key, integer)：名称为key的string减少integer
- append(key, value)：名称为key的string的值附加value
- substr(key, start, end)：返回名称为key的string的value的子串

### 6. List 

- rpush(key, value)：在名称为key的list尾添加一个值为value的元素

- lpush(key, value)：在名称为key的list头添加一个值为value的 元素
- llen(key)：返回名称为key的list的长度
- lrange(key, start, end)：返回名称为key的list中start至end之间的元素
- ltrim(key, start, end)：截取名称为key的list
- lindex(key, index)：返回名称为key的list中index位置的元素
- lset(key, index, value)：给名称为key的list中index位置的元素赋值
- lrem(key, count, value)：删除count个key的list中值为value的元素
- lpop(key)：返回并删除名称为key的list中的首元素
- rpop(key)：返回并删除名称为key的list中的尾元素
- blpop(key1, key2,… key N, timeout)：lpop命令的block版本。
- brpop(key1, key2,… key N, timeout)：rpop的block版本。
- rpoplpush(srckey, dstkey)：返回并删除名称为srckey的list的尾元素，并将该元素添加到名称为dstkey的list的头部

### 7. Set

- sadd(key, member)：向名称为key的set中添加元素member

- srem(key, member) ：删除名称为key的set中的元素member
- spop(key) ：随机返回并删除名称为key的set中一个元素
- smove(srckey, dstkey, member) ：移到集合元素
- scard(key) ：返回名称为key的set的基数
- sismember(key, member) ：member是否是名称为key的set的元素
- sinter(key1, key2,…key N) ：求交集
- sinterstore(dstkey, (keys)) ：求交集并将交集保存到dstkey的集合
- sunion(key1, (keys)) ：求并集
- sunionstore(dstkey, (keys)) ：求并集并将并集保存到dstkey的集合
- sdiff(key1, (keys)) ：求差集
- sdiffstore(dstkey, (keys)) ：求差集并将差集保存到dstkey的集合
- smembers(key) ：返回名称为key的set的所有元素
- srandmember(key) ：随机返回名称为key的set的一个元素

### 8. Hash

- hset(key, field, value)：向名称为key的hash中添加元素field
- hget(key, field)：返回名称为key的hash中field对应的value
- hmget(key, (fields))：返回名称为key的hash中field i对应的value
- hmset(key, (fields))：向名称为key的hash中添加元素field 
- hincrby(key, field, integer)：将名称为key的hash中field的value增加integer
- hexists(key, field)：名称为key的hash中是否存在键为field的域
- hdel(key, field)：删除名称为key的hash中键为field的域
- hlen(key)：返回名称为key的hash中元素个数
- hkeys(key)：返回名称为key的hash中所有键
- hvals(key)：返回名称为key的hash中所有键对应的value
- hgetall(key)：返回名称为key的hash中所有的键（field）及其对应的value

------------------------------------------------
原文链接：https://blog.csdn.net/ithomer/article/details/9213185/

------



## 【附录】参考资料

参考文中相应的链接地址。
