UPDATE Orders
SET O_valid=0
WHERE O_oid=$wwww;



INSERT INTO Orders VALUES(
    O_oid int not null,
    O_pid int not null,
    O_order_date date not null default CURRENT_DATE,
    O_start_sid int not null,
    O_arrive_sid int not null,
    O_price decimal not null,
    O_date1 date not null,
    O_time1 time not null,
    O_tid1 char(10) not null,
    O_start_sid1 int not null,
    O_arrive_sid1 int not null,
    O_date2 date,
    O_time2 time,
    O_tid2 char(10),
    O_start_sid2 int,
    O_arrive_sid2 int,
    O_valid int default 1,
);

INSERT INTO Orders VALUES(
    4242,
    42999999999999999999,

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

    4242,
    42999999999999999999,

    '2018-11-17',

    1,
    2,
    233.23,

    '2018-11-18',
    '18:06',
    '1095',
    1,
    2


-- 一列车的所有余票

SELECT 
    RES.TT_count, 
    RES.TT_tid, 
    ISC_sname,
    RES.TT_sid, 
    RES.TT_arrive_time, 
    RES.TT_depart_time, 
    RES.TT_price_yz,
    min(ES_left_yz) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ID_Station_City,
    Train,
    ( 
        SELECT 
            TT_count, TT_tid, TT_sid, TT_arrive_time, TT_depart_time, TT_price_yz
        FROM Train_Table
        WHERE TT_tid='1095'
        ORDER BY TT_count
    ) as RES
WHERE 
    ES_tid='1095' and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    T_tid=ES_tid and
    ISC_sid=RES.TT_sid and
    ES_date='2018-11-22' and
    (
        (
            TT1.TT_sid=T_start_sid and
            TT2.TT_sid=RES.TT_sid and
            TT3.TT_sid=ES_current_sid and
            (TT3.TT_count>=TT1.TT_count) and
            (TT3.TT_count<TT2.TT_count)
        )
        OR
        (
            TT1.TT_sid=T_start_sid and
            TT2.TT_sid=T_start_sid and
            TT3.TT_sid=T_start_sid and
            ES_current_sid=T_start_sid
        )
    )
GROUP BY
    RES.TT_count, 
    RES.TT_tid, 
    ISC_sname,
    RES.TT_sid, 
    RES.TT_arrive_time, 
    RES.TT_depart_time, 
    RES.TT_price_yz
ORDER BY RES.TT_count
;