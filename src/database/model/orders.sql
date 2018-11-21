-- 需求7：查询订单和删除订单
-- 乘客可以查询历史订单
-- 给定出发日期范围，显示订单列表
-- 订单信息：订单号，日期、出发到达站、总票价、订单状
-- 态（是否已经取消）
-- 提供链接，点击显示订单具体信息
-- 提供链接，点击取消订单
-- – 取消的订单，在订单列表中仍将显示，但注明取消

-- 查询历史订单

-- SELECT 
--     O_oid, O_order_date, 
--     ISC_sname as depart_station, 
--     ISC_sname as arrive_station, 
-- FROM Orders, 
-- WHERE 

-- 查询订单

SELECT
    O_oid, O_order_date, 
    scid.ISC_sname as depart_station, 
    scia.ISC_sname as arrive_station, 
    O_price,
    O_valid
FROM ID_Station_City as scid, ID_Station_City as scia, Orders  
WHERE O_start_sid=scid.ISC_sid 
    and O_arrive_sid=scia.ISC_sid
    and O_order_date<=%date_upperbound
    and O_order_date>=%date_lowerbound;

-- 创建订单
-- 注意: 需要手动调用下面的减票语句

INSERT INTO Orders
VALUES(
    4242,
    42,

    '2018-11-17',

    1,
    2,
    233.23,

    '2018-11-18',
    '18:06',
    '1095',
    1,
    2

);

INSERT INTO Orders
VALUES(
    5353,
    42,

    '2018-11-18',

    3,
    4,
    888.88,

    '2018-11-19',
    '23:59',
    'G27',
    3,
    4

);


-- 取消订单
UPDATE Orders 
SET O_valid=0 
WHERE O_pid=%pid; 

-- 直接生成新订单号
SELECT COUNT(*)+1
FROM ORDERS;

-- -- 直接生成新用户号
-- DO NOT USE THIS!
-- pid是身份证号
-- SELECT COUNT(*)+1
-- FROM Passenger;


-- 查询列车的空座位数
SELECT
    ES_tid,
    ES_current_sid,
    ISC_sname,
    ES_date,
    ES_left_yz,
    ES_left_rz,
    ES_left_yws,
    ES_left_ywz,
    ES_left_ywx,
    ES_left_rws,
    ES_left_rwx
FROM Empty_Seat, ID_Station_City
WHERE ES_tid=$tid and
    ID_Station_City.ISC_sid=ES_current_sid;

-- ex:
SELECT
    ES_tid,
    ES_current_sid,
    ISC_sname,
    ES_date,
    ES_left_yz,
    ES_left_rz,
    ES_left_yws,
    ES_left_ywz,
    ES_left_ywx,
    ES_left_rws,
    ES_left_rwx
FROM Empty_Seat, ID_Station_City
WHERE ES_tid='1095' and
    ES_date='2018-11-22' and
    ID_Station_City.ISC_sid=ES_current_sid;


-- 减少/增加对应区间余票数
-- 减少硬座余票数

-- SELECT TT_count as depart_count
-- FROM Train_Table
-- WHERE TT_sid=$depart_sid and
--     TT_tid=$tid;

-- SELECT TT_count as arrive_count
-- FROM Train_Table
-- WHERE TT_sid=$arrive_sid and
--     TT_tid=$tid;

-- UPDATE Empty_Seat
-- SET ES_left_yz=ES_left_yz-1
-- WHERE 
--     ES_tid=$tid and
--     ES_current_sid=Train_Table.T_sid and
--     (Train_Table.TT_count>=$depart_count) and
--     (Train_Table.TT_count<$arrive_count);

-- ALL IN ONE VERSION
-- allocate seat
UPDATE Empty_Seat
SET ES_left_yz=ES_left_yz-1
FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
WHERE 
    ES_tid=$tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=$depart_sid and
    TT2.TT_sid=$arrive_sid and
    TT3.TT_sid=ES_current_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);

-- release seat
UPDATE Empty_Seat
SET ES_left_yz=ES_left_yz+1
FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
WHERE 
    ES_tid=$tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=$depart_sid and
    TT2.TT_sid=$arrive_sid and
    TT3.TT_sid=ES_current_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);

-- ex:
UPDATE Empty_Seat
SET ES_left_yz=ES_left_yz-1
FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
WHERE 
    ES_tid='1095' and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=2069 and
    TT2.TT_sid=1699 and
    ES_current_sid=TT3.TT_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);

-- 判断区间是否有剩余的座位

SELECT count(ES_current_sid) as no_empty_seat
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3
WHERE 
    ES_tid=$tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=$depart_sid and
    TT2.TT_sid=$arrive_sid and
    TT3.TT_sid=ES_current_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count) and
    (ES_left_yz=0);

-- ex:

SELECT count(ES_current_sid) as no_empty_seat
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3
WHERE 
    ES_tid='1095' and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=2069 and
    TT2.TT_sid=1699 and
    TT3.TT_sid=ES_current_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count) and
    (ES_left_yz=0);

-- 区间余票计算

SELECT min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3
WHERE 
    ES_tid=$tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=$depart_sid and
    TT2.TT_sid=$arrive_sid and
    TT3.TT_sid=ES_current_sid and
    ES_date='2018-11-22' and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);

-- ex:


SELECT min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3
WHERE 
    ES_tid='1095' and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=798 and
    TT2.TT_sid=807 and
    ES_date='2018-11-22' and
    TT3.TT_sid=ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);