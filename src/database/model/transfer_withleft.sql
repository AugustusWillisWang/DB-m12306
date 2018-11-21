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

------------------------1
-- FROM:
select DISTINCT PT_tid ,PT_price_yz ,PT_time ,TT_depart_time ,PT_depart_sid_f,
PT_arrive_sid_f
from price_time,Train_Table
where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
ORDER by PT_price_yz,PT_time,TT_depart_time;

-- TO:
SELECT 
    RES.PT_tid ,
    RES.PT_price_yz ,
    RES.PT_time ,
    RES.TT_depart_time ,
    RES.PT_depart_sid_f,
    RES.PT_arrive_sid_f,
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
   ( 
       select DISTINCT PT_tid ,PT_price_yz ,PT_time ,TT_depart_time ,PT_depart_sid_f,
        PT_arrive_sid_f
        from price_time,Train_Table
        where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
        ORDER by PT_price_yz,PT_time,TT_depart_time
)as RES
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
    RES.PT_tid ,
    RES.PT_price_yz ,
    RES.PT_time ,
    RES.TT_depart_time ,
    RES.PT_depart_sid_f,
    RES.PT_arrive_sid_f;

----------------------------------------------2
-- FROM:
select DISTINCT PT_tid ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
PT_price_yz,SC_crossday
--,CC_day
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,price_time,Train_Table as Train_Table2,Station_Connection
 where Train_Table1.TT_sid= PT_depart_sid_f and Train_Table2.TT_sid= PT_arrive_sid_f 
 and ID_Station_City1.ISC_sid=PT_depart_sid_f and  ID_Station_City2.ISC_sid=PT_arrive_sid_f
 and SC_depart_sid=PT_depart_sid_f  and SC_arrive_sid=PT_arrive_sid_f
 and Train_Table1.TT_tid='G3' and Train_Table2.TT_tid=Train_Table1.TT_tid and PT_tid=Train_Table1.TT_tid ;

 --TO:


SELECT 
    RES.PT_tid,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.PT_price_yz,
    RES.SC_crossday,
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 
        select DISTINCT 
        PT_tid,
        ID_Station_City1.ISC_sname as depart_sname,
        ID_Station_City2.ISC_sname as arrive_sname,
        Train_Table1.TT_depart_time,
        Train_Table2.TT_arrive_time,
        PT_price_yz,
        SC_crossday,
        -- NEWLY ADDED
        PT_depart_sid_f,
        PT_arrive_sid_f
        --,CC_day
        from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,price_time,Train_Table as Train_Table2,Station_Connection
        where Train_Table1.TT_sid= PT_depart_sid_f and Train_Table2.TT_sid= PT_arrive_sid_f 
        and ID_Station_City1.ISC_sid=PT_depart_sid_f and  ID_Station_City2.ISC_sid=PT_arrive_sid_f
        and SC_depart_sid=PT_depart_sid_f  and SC_arrive_sid=PT_arrive_sid_f
        and Train_Table1.TT_tid='G3' and Train_Table2.TT_tid=Train_Table1.TT_tid and PT_tid=Train_Table1.TT_tid
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
    RES.PT_tid,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.PT_price_yz,
    RES.SC_crossday
;

------------------------------3
-- FROM:

SELECT * from Transfer order by TF_price_yz,case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end ,
TF_depart_time_f;

ie:

SELECT DISTINCT TF_first, TF_second,ID_Station_City1.ISC_sname,ID_Station_City2.ISC_sname,ID_Station_City3.ISC_sname,ID_Station_City4.ISC_sname,
TF_tf_city,TF_price_first_yz,TF_price_second_yz,TF_price_yz,TF_depart_time_f,TF_arrive_time_f,TF_tf_date_f,
case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f 
else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end
from Transfer,ID_Station_City as ID_Station_City1,ID_Station_City as ID_Station_City2,
ID_Station_City as ID_Station_City3,ID_Station_City as ID_Station_City4
WHERE ID_Station_City1.ISC_sid= TF_depart_sid_f and  ID_Station_City2.ISC_sid= TF_arrive_tf_sid_f
and  ID_Station_City3.ISC_sid=  TF_depart_tf_sid_f and  ID_Station_City4.ISC_sid= TF_arrive_sid_f 
order by TF_price_yz,case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f
 else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end ,
TF_depart_time_f;


--TO:

SELECT 
    RES.TF_first,
    RES.TF_second,
    RES.sname1,
    RES.sname2,
    RES.sname3,
    RES.sname4,
    RES.TF_tf_city,
    RES.TF_price_first_yz,
    RES.TF_price_second_yz,
    RES.TF_price_yz,
    RES.TF_depart_time_f,
    RES.TF_arrive_time_f,
    RES.TF_tf_date_f,
    RES.timeused,
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
        SELECT DISTINCT
            TF_first, 
            TF_second,
            ID_Station_City1.ISC_sname as sname1,
            ID_Station_City2.ISC_sname as sname2,
            ID_Station_City3.ISC_sname as sname3,
            ID_Station_City4.ISC_sname as sname4,
            TF_tf_city,
            TF_price_first_yz,
            TF_price_second_yz,
            TF_price_yz,
            TF_depart_time_f,
            TF_arrive_time_f,
            TF_tf_date_f,
            TF_depart_sid_f,
            TF_arrive_tf_sid_f,
            TF_depart_tf_sid_f,
            TF_arrive_sid_f,
            case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end as timeused

        from Transfer,ID_Station_City as ID_Station_City1,ID_Station_City as ID_Station_City2,
        ID_Station_City as ID_Station_City3,ID_Station_City as ID_Station_City4
        WHERE ID_Station_City1.ISC_sid= TF_depart_sid_f and  ID_Station_City2.ISC_sid= TF_arrive_tf_sid_f
        and  ID_Station_City3.ISC_sid=  TF_depart_tf_sid_f and  ID_Station_City4.ISC_sid= TF_arrive_sid_f 
        order by TF_price_yz,case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f
         else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end ,
        TF_depart_time_f
    ) as RES
WHERE 
    ES1.ES_tid=RES.TF_first and
    ES1.ES_tid=TT1.TT_tid and
    ES1.ES_tid=TT2.TT_tid and
    ES1.ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.TF_depart_sid_f and
    TT2.TT_sid=RES.TF_arrive_tf_sid_f and
    TT3.TT_sid=ES1.ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count) 
    and
    ES2.ES_tid=RES.TF_second and
    ES2.ES_tid=TT4.TT_tid and
    ES2.ES_tid=TT5.TT_tid and
    ES2.ES_tid=TT6.TT_tid and
    TT4.TT_sid=RES.TF_depart_tf_sid_f and
    TT5.TT_sid=RES.TF_arrive_sid_f and
    TT6.TT_sid=ES2.ES_current_sid and
    (TT6.TT_count>=TT4.TT_count) and
    (TT6.TT_count<TT5.TT_count) 
GROUP BY
    RES.TF_first,
    RES.TF_second,
    RES.sname1,
    RES.sname2,
    RES.sname3,
    RES.sname4,
    RES.TF_tf_city,
    RES.TF_price_first_yz,
    RES.TF_price_second_yz,
    RES.TF_price_yz,
    RES.TF_depart_time_f,
    RES.TF_arrive_time_f,
    RES.TF_tf_date_f,
    RES.timeused
;

------------------------------4
-- FROM:

select DISTINCT TF_first ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
tf_price_first_yz,SC_crossday
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
 where Train_Table1.TT_sid= TF_depart_sid_f and Train_Table2.TT_sid= TF_arrive_tf_sid_f
 and ID_Station_City1.ISC_sid=TF_depart_sid_f and  ID_Station_City2.ISC_sid=TF_arrive_tf_sid_f
 and SC_depart_sid=TF_depart_sid_f and  SC_arrive_sid=TF_arrive_tf_sid_f 
and Train_Table1.TT_tid='K915' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_first=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid  and TF_tf_city='唐山';
--TO:

SELECT 
    RES.TF_first,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.tf_price_first_yz,
    RES.SC_crossday,
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 
        select DISTINCT 
            TF_first,
            ID_Station_City1.ISC_sname as depart_sname,
            ID_Station_City2.ISC_sname as arrive_sname,
            Train_Table1.TT_depart_time,
            Train_Table2.TT_arrive_time,
            tf_price_first_yz,
            SC_crossday,
            TF_depart_sid_f,
            TF_arrive_tf_sid_f
        from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
        where Train_Table1.TT_sid= TF_depart_sid_f and Train_Table2.TT_sid= TF_arrive_tf_sid_f
        and ID_Station_City1.ISC_sid=TF_depart_sid_f and  ID_Station_City2.ISC_sid=TF_arrive_tf_sid_f
        and SC_depart_sid=TF_depart_sid_f and  SC_arrive_sid=TF_arrive_tf_sid_f 
        and Train_Table1.TT_tid='K915' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_first=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid  and TF_tf_city='唐山'
    ) as RES
WHERE 
    ES_tid=RES.TF_first and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.TF_depart_sid_f and
    TT2.TT_sid=RES.TF_arrive_tf_sid_f and
    TT3.TT_sid=ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count)
GROUP BY
    RES.TF_first,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.tf_price_first_yz,
    RES.SC_crossday
;

------------------------------5
-- FROM:

select DISTINCT TF_second ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
tf_price_second_yz,SC_crossday
--,CC_day
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
where Train_Table1.TT_sid= TF_depart_tf_sid_f and Train_Table2.TT_sid= TF_arrive_sid_f
and ID_Station_City1.ISC_sid=TF_depart_tf_sid_f  and  ID_Station_City2.ISC_sid=TF_arrive_sid_f 
and SC_depart_sid=TF_depart_tf_sid_f and SC_arrive_sid=TF_arrive_sid_f 
and Train_Table1.TT_tid='K95' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_second=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid and TF_tf_city='唐山' ;

--TO:

SELECT 
    RES.TF_second,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.tf_price_second_yz,
    RES.SC_crossday,
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 
        select DISTINCT TF_second ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
        tf_price_second_yz,SC_crossday,
            TF_depart_tf_sid_f,
            TF_arrive_sid_f
        --,CC_day
        from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
        where Train_Table1.TT_sid= TF_depart_tf_sid_f and Train_Table2.TT_sid= TF_arrive_sid_f
        and ID_Station_City1.ISC_sid=TF_depart_tf_sid_f  and  ID_Station_City2.ISC_sid=TF_arrive_sid_f 
        and SC_depart_sid=TF_depart_tf_sid_f and SC_arrive_sid=TF_arrive_sid_f 
        and Train_Table1.TT_tid='K95' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_second=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid and TF_tf_city='唐山'

    ) as RES
WHERE 
    ES_tid=RES.TF_second and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.TF_depart_tf_sid_f and
    TT2.TT_sid=RES.TF_arrive_sid_f and
    TT3.TT_sid=ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count)
GROUP BY
    RES.TF_second,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.tf_price_second_yz,
    RES.SC_crossday
;

--------

-----------------------------原型:


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
    TT_tid=ES_tid AND 
    tt_sid=ISC_sid AND 
    TT_tid='G3' AND 
    ES_date='2018-11-17' 
ORDER by TT_depart_time;

select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,ES_date, $inputtype
from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND tt_sid=ISC_sid and TT_tid='$train' and ES_date='$inputdate' ORDER by TT_depart_time;

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
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count);

SELECT 
    RES.
    RES.
    RES.
    RES.
    RES.
    RES.
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 

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
    RES.
    RES.
    RES.
    RES.
    RES.
    RES.
;

SELECT
    SC1.SC_depart_sid as depart_station,
    SC1.SC_arrive_sid as transfer_station,
    SC2.SC_arrive_sid as arrive_station,
    SC1.SC_tid as tid1,
    SC2.SC_tid as tid2
FROM 
    Station_Connection as SC1,
    Station_Connection as SC2
WHERE
    SC1.SC_depart_sid=443 and
    SC1.SC_arrive_sid=SC2.SC_depart_sid and
    SC2.SC_arrive_sid=59 and
    SC1.SC_tid!=SC2.SC_tid
    ;

-- FINAL:


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
    SCI1.ISC_cname='北京' and
    SCI2.ISC_cname='抚顺' and
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
    TT1.Tt_depart_time;



    ;

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
    SCI1.ISC_cname='北京' and
    SCI2.ISC_cname='抚顺' and
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
