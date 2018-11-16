-- 需求4：查询具体车次
-- •输入
-- 车次序号，例如G101
-- 日期，例如：2018‐11‐1，默认为明天
-- •显示该车次所有信息
-- 有静态信息
-- – 始发站，中间经停站，终点站
-- – 每站的发车时间和到达时间
-- – 票价
-- 也有动态信息：余票
-- •余票上有链接，点击跳转到预订功能网页（需求6，
-- 预定始发站到当前站的票）

select DISTINCT 
    TT_tid,
    ISC_sname,
    TT_arrive_time,
    TT_depart_time,
    TT_time,
    TT_price_yz,
    TT_price_yws,
    ES_left_yws,
    TT_price_ywz,
    ES_left_ywz,
    TT_price_ywx,
    ES_left_ywx,
    TT_price_rz,
    ES_left_rz,
    TT_price_rws,
    ES_left_rws,
    TT_price_rwx,
    ES_left_rwx,
    ES_date,
    ES_left_yz
FROM Train_Table,Empty_Seat,ID_Station_City 
WHERE TT_sid=ES_current_sid AND 
    tt_sid=ISC_sid AND 
    TT_tid='G3' AND 
    ES_date='2018-11-17' 
ORDER by TT_depart_time;

