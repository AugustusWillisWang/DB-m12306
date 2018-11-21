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

-- 带余票的版本

SELECT 
    RES.depart_station,
    RES.transfer_station1,
    RES.transfer_station2,
    RES.arrive_station,
    RES.transfer_city,
    RES.tid1,
    RES.tid2,
    RES.price1,
    RES.price2,
    RES.price_total,
    min(ES1.ES_left_yz) as left_yz1,
    min(ES2.ES_left_yz) as left_yz2
    
FROM 
    Empty_Seat as ES1,
    Empty_Seat as ES2,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    Train_Table as TT4, 
    Train_Table as TT5, 
    Train_Table as TT6,
    ( 


SELECT
    SC1.SC_depart_sid as depart_station,
    SC1.SC_arrive_sid as transfer_station1,
    SC2.SC_depart_sid as transfer_station2,
    SC2.SC_arrive_sid as arrive_station,
    SCI3.ISC_cname as transfer_city,
    SC1.SC_tid as tid1,
    SC2.SC_tid as tid2,
    TT2.TT_price_yz-TT1.TT_price_yz as price1,
    TT4.TT_price_yz-TT3.TT_price_yz as price2,
    TT4.TT_price_yz-TT3.TT_price_yz+TT2.TT_price_yz-TT1.TT_price_yz as price_total
FROM 
    Station_Connection as SC1,
    Station_Connection as SC2,
    ID_Station_City as SCI1,--始发站
    ID_Station_City as SCI2,--终到站
    ID_Station_City as SCI3, --换乘下车站
    ID_Station_City as SCI4, --换乘上车站
    Train_Table as TT1,--始发站
    Train_Table as TT2,--终到站
    Train_Table as TT3,--换乘下车站
    Train_Table as TT4,--换乘上车站
    Train as T1,--第一次列车
    Train as T2 --第二次列车
WHERE
    --始发终到站
    SCI1.ISC_cname='上海' and
    SCI2.ISC_cname='深圳' and
    SCI1.ISC_sid=SC1.SC_depart_sid and
    SCI2.ISC_sid=SC2.SC_arrive_sid
    and
    --基本换乘逻辑
    -- SC1.SC_depart_sid=443 and
    -- SC1.SC_arrive_sid=SC2.SC_depart_sid and
    SCI3.ISC_cname=SCI4.ISC_cname and
    SCI3.ISC_sid=SC1.SC_arrive_sid and
    SCI4.ISC_sid=SC2.SC_depart_sid and
    -- SC2.SC_arrive_sid=59 and
    SC1.SC_tid!=SC2.SC_tid
    -- and
    and
    --禁止始发站/终到站同城市换乘
    SCI1.ISC_cname!=SCI3.ISC_cname and
    SCI2.ISC_cname!=SCI4.ISC_cname
    and
    --连接对应车次
    TT1.TT_tid=SC1.SC_tid and
    TT2.TT_tid=SC1.SC_tid and
    TT3.TT_tid=SC2.SC_tid and
    TT4.TT_tid=SC2.SC_tid and
    TT1.TT_sid=SC1.SC_depart_sid and
    TT2.TT_sid=SC1.SC_arrive_sid and
    TT3.TT_sid=SC2.SC_depart_sid and
    TT4.TT_sid=SC2.SC_arrive_sid
    and
    --换乘时间条件
    -- TT3.TT_depart_time-TT2.TT_arrive_time
    (
        (
            (
                SC1.SC_arrive_sid=SC2.SC_depart_sid --同站换乘
            )
            and
            (
                (
                    (interval '60 min'<TT3.TT_depart_time-TT2.TT_arrive_time) and
                    (interval '240 min'>TT3.TT_depart_time-TT2.TT_arrive_time)
                )
                or
                (
                    (interval '60 min'<interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time) and
                    (interval '240 min'>interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time)
                )
            )
        )
        OR
        (
            (
                SC1.SC_arrive_sid!=SC2.SC_depart_sid --异站换乘
            )
            and
            (
                (
                    (interval '120 min'<TT3.TT_depart_time-TT2.TT_arrive_time) and
                    (interval '240 min'>TT3.TT_depart_time-TT2.TT_arrive_time)
                )
                or
                (
                    (interval '120 min'<interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time) and
                    (interval '240 min'>interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time)
                )
            )
        )
    )
    --不可上车/下车站判断
    and
    (
        T1.T_tid=SC1.SC_tid and
        T2.T_tid=SC2.SC_tid
    )
    and
    (
        (TT1.TT_sid=T1.T_start_sid)
        or
        (
            TT1.TT_sid!=T1.T_start_sid and
            TT1.TT_price_yz!=0
        )
    )
    and
    (
        (TT3.TT_sid=T2.T_start_sid)
        or
        (
            TT3.TT_sid!=T2.T_start_sid and
            TT3.TT_price_yz!=0
        )
    )
    and
    TT2.TT_price_yz!=0 
    and
    TT4.TT_price_yz!=0

ORDER BY 
    price_total,
    case 
        when ((TT4.TT_arrive_time-TT1.Tt_depart_time)>interval '0 min') 
        then TT4.TT_arrive_time-TT1.Tt_depart_time
        else TT4.TT_arrive_time-TT1.Tt_depart_time + interval '24 hour' 
        end,
    TT1.Tt_depart_time

LIMIT 20

    ) as RES
WHERE 
    ES1.ES_tid=RES.tid1 and
    ES1.ES_tid=TT1.TT_tid and
    ES1.ES_tid=TT2.TT_tid and
    ES1.ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.depart_station and
    TT2.TT_sid=RES.transfer_station1 and
    TT3.TT_sid=ES1.ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count) 
    and
    ES2.ES_tid=RES.tid2 and
    ES2.ES_tid=TT4.TT_tid and
    ES2.ES_tid=TT5.TT_tid and
    ES2.ES_tid=TT6.TT_tid and
    TT4.TT_sid=RES.transfer_station2 and
    TT5.TT_sid=RES.arrive_station and
    TT6.TT_sid=ES2.ES_current_sid and
    (TT6.TT_count>=TT4.TT_count) and
    (TT6.TT_count<TT5.TT_count) 
GROUP BY
    RES.depart_station,
    RES.transfer_station1,
    RES.transfer_station2,
    RES.arrive_station,
    RES.transfer_city,
    RES.tid1,
    RES.tid2,
    RES.price1,
    RES.price2,
    RES.price_total
;
