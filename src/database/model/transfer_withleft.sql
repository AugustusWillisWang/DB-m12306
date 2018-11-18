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
