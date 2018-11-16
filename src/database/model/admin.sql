-- • Admin登录后显示不同的登录首页
-- • Admin可以看到下述信息
-- 总订单数
-- 总票价
-- 最热点车次排序，排名前10的车次
-- 当前注册用户列表
-- 查看每个用户的订单


-- 总订单数
select count(*) from Orders;

-- 总票价
select sum(O_price) from Orders;

-- 最热点车次排序，排名前10的车次
select O_tid1, count(O_tid1)+count(O_tid2) as sum_cnt
from Orders 
group by O_tid1
order by sum_cnt desc;

-- 当前注册用户列表
SELECT 
    P_pid,
    P_phone,
    P_pname,
    P_uname,
    P_credit_card
FROM Passenger;

-- 查看每个用户的订单
SELECT
    O_oid,
    O_pid,
    O_order_date,
    O_start_sid,
    O_arrive_sid,
    O_price,
    O_date1,
    O_time1,
    O_tid1,
    O_start_sid1,
    O_arrive_sid1,
    O_date2,
    O_time2,
    O_tid2,
    O_start_sid2,
    O_arrive_sid2,
    O_valid
FROM Orders
WHERE O_pid=%pid;

SELECT
    O_oid,
    O_pid,
    O_order_date,
    O_start_sid,
    O_arrive_sid,
    O_price,
    O_date1,
    O_time1,
    O_tid1,
    O_start_sid1,
    O_arrive_sid1,
    O_date2,
    O_time2,
    O_tid2,
    O_start_sid2,
    O_arrive_sid2,
    O_valid
FROM Orders
WHERE O_pid=42;
