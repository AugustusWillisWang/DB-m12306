DB-m12306
===============

Database lab2: 火车订票系统模拟.

***

<!-- TOC -->

- [1. 综述](#1-综述)
    - [1.1. 文件夹结构](#11-文件夹结构)
    - [1.2. 关键代码及功能对应](#12-关键代码及功能对应)
- [2. 数据库逻辑](#2-数据库逻辑)
    - [2.1. 数据库应用整体实现](#21-数据库应用整体实现)
    - [2.2. ER图](#22-er图)
    - [2.3. 关系模式](#23-关系模式)
        - [2.3.1. ID_Station_City 车站城市对照表ISC_](#231-id_station_city-车站城市对照表isc_)
        - [2.3.2. Train 列车T_](#232-train-列车t_)
        - [2.3.3. Train_Table 列车时刻表TT_](#233-train_table-列车时刻表tt_)
        - [2.3.4. Empty_Seat 可用座位表ES_](#234-empty_seat-可用座位表es_)
        - [2.3.6. Passenger 乘客P_](#236-passenger-乘客p_)
        - [2.3.7. Orders 订单O_](#237-orders-订单o_)
        - [2.3.8. Station_Connection 车站联通表SC_](#238-station_connection-车站联通表sc_)
        - [2.3.9. City_Connection 城市联通表CC_](#239-city_connection-城市联通表cc_)
    - [2.4. 范式细化，分析](#24-范式细化分析)
- [3. 查询与刷新函数](#3-查询与刷新函数)
    - [3.1. SQL查询语句模板](#31-sql查询语句模板)
        - [3.1.1. 记录乘客信息](#311-记录乘客信息)
        - [3.1.2. 查询具体车次](#312-查询具体车次)
        - [3.1.3. 查询两地之间的车次](#313-查询两地之间的车次)
        - [3.1.4. 预订车次座位](#314-预订车次座位)
        - [3.1.5. 查询订单和删除订单](#315-查询订单和删除订单)
        - [3.1.6. 管理员](#316-管理员)
    - [3.2. SQL刷新语句及调用地点](#32-sql刷新语句及调用地点)
- [4. 数据库系统实现](#4-数据库系统实现)
    - [4.1. 数据导入](#41-数据导入)
    - [4.2. 余票查询](#42-余票查询)
    - [其他查询语句](#其他查询语句)
- [5. 前端实现](#5-前端实现)
    - [5.2. 前端与数据库的连接 -->](#52-前端与数据库的连接---)
- [6. ACKNOWLEDGE](#6-acknowledge)

<!-- /TOC -->

# 1. 综述

在此项目中, 我们完成了实验二要求的全部内容: 搭建一个类似于12306的应用, 支持用户登录, 管理员登陆, 订票, 余票查询等功能.

技术实现采用python脚本进行数据预处理, psql搭建数据库, php实现前端代码.

小组分工如下:

* 前端实现: 刘蕴哲
* 换乘查询, ER图及范式分析: 蔡昕
* 数据预处理, 数据库架构, 数据库查询语句, 报告撰写: 王华强

## 1.1. 文件夹结构

```
-data                   原始数据以及经过预处理的数据
-dest                   最终生成的数据库应用及sql源码
-dev                    开发过程中使用的脚本
-doc                    文档
-src                    开发过程中的全部源码
-src-database           数据库源码
-src-database-setup_db  预处理及建库源码
-src-database-model     数据库操作语句源码
-src-php                php源码
-web                    网站建设参考代码
-playground             测试目录
```

## 1.2. 关键代码及功能对应

```
create_database.py      数据预处理
declare.sql             建立数据库, 各表定义
seats.sql               余座表初始化(处理随时间推移时, 新的列车开放订票的情况)
user.sql                处理用户相关的逻辑
admin.sql               处理管理员相关的逻辑
transfer_withleft.sql   处理换乘以及余座计算
orders.sql              生成/取消订单
```

***

# 2. 数据库逻辑

## 2.1. 数据库应用整体实现

数据库系统的实现首先依赖于数据的导入. 在本实验中数据的预处理使用python脚本解析正则表达式的形式, 将数据转化成规整的CSV文件. 在预处理过程中同时对数据中的缺失项做了处理, 同时根据换乘查询的需要, 计算生成了城市间的连通图表和车站之间的连通图表, 希望通过这些数据的预处理来提高查询速度, 降低查询难度.

基本的数据库查询语句略过不表. 查询语句的难点集中在换乘计算的消耗上. 通过在预处理中预先建表来降低计算复杂度, 以及引入`LIMIT`来降低计算量的方式, 我们将换乘查询的时间消耗控制在了可以接受的量级.

在前端通过php语句调用sql查询语句来访问数据库. 尽管从软件工程的角度上来讲, 应该使用MVC模型为佳. 但是考虑到小组成员都是第一次接触PHP, 因此没有采用这些面向对象的软件开发模型.

## 2.2. ER图

## 2.3. 关系模式

具体到代码级别的定义, 可以参见`declare.sql` 

Table Layouts 如下:

### 2.3.1. ID_Station_City 车站城市对照表ISC_

列名|内容|数据种类|附注
-|-|-|-
ISC_sid|INTEGER|not null, primary key 
ISC_sname|CHAR(20)|not null
ISC_cname|CHAR(20)|not null

### 2.3.2. Train 列车T_

列名|内容|数据种类|附注
-|-|-|-
T_tid|车次号|char(10)|identifier, not null
T_start_sid|始发站id|int|foreign key references ID_Station_City(ISC_sid)
T_end_sid|终点站id|int|foreign key references ID_Station_City(ISC_sid)

### 2.3.3. Train_Table 列车时刻表TT_

列名|内容|数据种类|附注
-|-|-|-
TT_tid|车次号|char(10)|identifier|foreign key references Train(T_tid)
TT_sid|车站id|int|identifier|foreign key references ID_Station_City(ISC_sid)
TT_depart_time|发车时间|date|
TT_arrive_time|到达时间|date|
TT_price_yz|硬座票价|decimal|
TT_price_rz|软座票价|decimal|
TT_price_yws|硬卧上铺票价|decimal|
TT_price_ywz|硬卧中铺票价|decimal|
TT_price_ywx|硬卧下铺票价|decimal|
TT_price_rws|软卧上铺票价|decimal|
TT_price_rwx|软卧下铺票价|decimal|
TT_count|当前站是列车的第几站|int|用于换乘计算

### 2.3.4. Empty_Seat 可用座位表ES_

列名|内容|数据种类|附注
-|-|-|-
ES_tid|车次号|char(10)|identifier
ES_current_sid|当前车站id|int|identifier
ES_next_sid|下一个车站id|int|identifier
ES_date|日期|date|identifier
ES_left_yz|硬座剩余座位数|int|初始化时置为5
ES_left_rz|软座剩余座位数|int|初始化时置为5
ES_left_yws|硬卧上铺剩余座位数|int|初始化时置为5
ES_left_ywz|硬卧中铺剩余座位数|int|初始化时置为5
ES_left_ywx|硬卧下铺剩余座位数|int|初始化时置为5
ES_left_rws|软卧上铺剩余座位数|int|初始化时置为5
ES_left_rwx|软卧下铺剩余座位数|int|初始化时置为5

注意: 终点站的剩余座位数无用

<!-- ### 2.3.5. 城市C_

列名|数据种类|附注
-|-|-
城市名|char(20)|identifier -->



### 2.3.6. Passenger 乘客P_

列名|内容|数据种类|附注
-|-|-|-
P_pid|身份证号|bigint|primary key, unique
P_phone|手机号|bigint|unique
P_pname|姓名|char(20)|
P_uname|用户名|char(30)|
P_credit_card|信用卡|int|
P_password|密码char(30)|

### 2.3.7. Orders 订单O_

列名|内容|数据种类|附注
-|-|-|-
O_oid|订单号|int|identifier
O_pid|身份证号|int|
O_order_date|订单日期|date|not null default CURRENT_DATE
O_tid|车次序号|char(10)|
O_start_sid|始发站|int|
O_arrive_sid|到达站|int|
O_price|总票价|decimal
O_date1|第一列车的日期|date|not null
O_time1|第一列车的时间|time|not null
O_tid1|第一列车id|char(10)|not null
O_start_sid1|第一列车的始发站|int|not null
O_arrive_sid1|第一列车的终到站|int|not null
O_date2|第二列车的日期|date|
O_time2|第二列车的时间|time|
O_tid2|第二列车id|char(10)|
O_start_sid2|第二列车的始发站|int|
O_arrive_sid2|第二列车的终到站|int|
O_valid|订单有效|int|default 1

### 2.3.8. Station_Connection 车站联通表SC_

列名|内容|数据种类|附注
-|-|-|-
SC_depart_sid|出发车站id|int|identifier, foreign key  references ID_Station_City(ISC_sid)
SC_arrive_sid|到达车站id|int|identifier, foreign key  references ID_Station_City(ISC_sid)
SC_tid|列车号|int|identifier, foreign key references Train(T_tid
SC_crossday|列车开行过程中跨日情况记录|int|default 0

### 2.3.9. City_Connection 城市联通表CC_

注: 此表用在某个换乘查询算法中. 最终实现的数据库不需要此表. 为了演示多种不同的查询方法, 故保留.

列名|内容|数据种类|附注
-|-|-|-
CC_depart_city|出发城市|char(20)|identifier
CC_arrive_city|到达城市|char(20)|identifier
CC_tid|列车号|int|identifier
CC_crossday|列车开行过程中跨日情况记录|int|default 0

***

<!-- 原始数据的Table, Layouts如下: -->



## 2.4. 范式细化，分析

***

# 3. 查询与刷新函数

## 3.1. SQL查询语句模板

### 3.1.1. 记录乘客信息
### 3.1.2. 查询具体车次
### 3.1.3. 查询两地之间的车次
### 3.1.4. 预订车次座位
### 3.1.5. 查询订单和删除订单
### 3.1.6. 管理员

## 3.2. SQL刷新语句及调用地点

***

# 4. 数据库系统实现

## 4.1. 数据导入

在本实验中数据的预处理使用python脚本解析正则表达式的形式, 将数据转化成规整的CSV文件. 在预处理过程中同时对数据中的缺失项做了处理, 同时根据换乘查询的需要, 计算生成了城市间的连通图表和车站之间的连通图表, 希望通过这些数据的预处理来提高查询速度, 降低查询难度.

## 4.2. 余票查询

通过引入以下的框架, 可以使得一个查询语句支持两站之间的余票查询, 借此可以快速使某个查询支持余票查询.

```
SELECT 
    RES.XX
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 
        XX,
        ......
    ) as RES
WHERE 
    ES_tid=RES.PT_tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.PT_depart_sid_f and
    TT2.TT_sid=RES.PT_arrive_sid_f and
    TT3.TT_sid=ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count)
GROUP BY
    RES.XX
;
```

## 其他查询语句

其他查询语句已在上文详述.

***

# 5. 前端实现

<!-- ## 5.1. 前端技术栈

## 5.2. 前端与数据库的连接 -->

前端通过php语句调用sql查询语句来访问数据库. 尽管从软件工程的角度上来讲, 应该使用MVC模型为佳. 但是考虑到小组成员都是第一次接触PHP, 因此没有采用这些面向对象的软件开发模型.

~~前端大哥辛苦了~~

***

# 6. ACKNOWLEDGE

[1][网络技术应用: MHW-50382]
[2][stackoverflow]

***

Copyright (C) 2018 Team WLC(Wireless LAN Controller)