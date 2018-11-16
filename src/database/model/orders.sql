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

-- 直接生成新用户号
SELECT COUNT(*)+1
FROM Passenger;