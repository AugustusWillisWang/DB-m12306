drop database test12306;
create database test12306;


CREATE TABLE ID_Station_City(
    ISC_sid INTEGER not null, 
    ISC_sname CHAR(20) not null,
    ISC_cname CHAR(20) not null,
    primary key (ISC_sid)
    -- foreign key () references x(x)
);

CREATE TABLE Train(
    T_tid char(10) not null,
    T_start_sid int,
    T_end_sid int,
    primary key (T_tid),
    foreign key (T_start_sid) references ID_Station_City(ISC_sid),
    foreign key (T_end_sid) references ID_Station_City(ISC_sid)

);

CREATE TABLE Train_Table(
    TT_tid char(10) not null,
    TT_sid int not null,
    TT_arrive_time time not null,
    TT_depart_time time not null,
    TT_time int,
    TT_price_yz decimal not null,
    TT_price_rz decimal not null,
    TT_price_yws decimal not null,
    TT_price_ywz decimal not null,
    TT_price_ywx decimal not null,
    TT_price_rws decimal not null,
    TT_price_rwx decimal not null,
    TT_count    int,
    primary key (TT_tid,TT_sid),
    foreign key (TT_tid) references Train(T_tid),
    foreign key (TT_sid) references ID_Station_City(ISC_sid)
);

-- DROP TABLE Empty_Seat;

CREATE TABLE Empty_Seat(
    ES_tid char(10),
    ES_current_sid int not null,
    ES_next_sid int,
    ES_date date default CURRENT_DATE,
    ES_left_yz int not null default 5,
    ES_left_rz int not null default 5,
    ES_left_yws int not null default 5,
    ES_left_ywz int not null default 5,
    ES_left_ywx int not null default 5,
    ES_left_rws int not null default 5,
    ES_left_rwx int not null default 5,
    primary key (ES_tid,ES_current_sid,ES_date),
    foreign key (ES_current_sid) references ID_Station_City(ISC_sid),
    foreign key (ES_next_sid) references ID_Station_City(ISC_sid)
);

CREATE TABLE Passenger(
    P_pid bigint unique,
    P_phone bigint unique,
    P_pname char(20),
    P_uname char(30) unique,
    P_credit_card bigint,
    P_password char(30),
    primary key (P_pid)
);

CREATE TABLE Orders(
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
    primary key (O_oid),
    foreign key (O_pid) references Passenger(P_pid),
    foreign key (O_tid1) references Train(T_tid),
    foreign key (O_tid2) references Train(T_tid),
    foreign key (O_start_sid) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid) references ID_Station_City(ISC_sid),
    foreign key (O_start_sid1) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid1) references ID_Station_City(ISC_sid),
    foreign key (O_start_sid2) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid2) references ID_Station_City(ISC_sid)

);

CREATE TABLE Station_Connection(
    SC_depart_sid int not null,
    SC_arrive_sid int not null,
    SC_tid char(10) not null,
    SC_crossday int default 0,
    primary key (SC_depart_sid,SC_arrive_sid,SC_tid),
    foreign key (SC_depart_sid) references ID_Station_City(ISC_sid),
    foreign key (SC_arrive_sid) references ID_Station_City(ISC_sid),
    foreign key (SC_tid) references Train(T_tid)
);

CREATE TABLE City_Connection(
    CC_depart_city char(20) not null,
    CC_arrive_city char(20) not null,
    CC_tid char(10) not null,
    CC_crossday int default 0,
    -- primary key (CC_depart_city,CC_arrive_city,CC_tid),
    foreign key (CC_tid) references Train(T_tid)
);

CREATE TABLE Global_Vars(
    G_pid int default 0,
    G_oid int default 0
);

INSERT INTO Global_Vars
VALUES(0,0);

-- 导入站表

-- https://www.postgresql.org/docs/9.2/sql-copy.html

COPY ID_Station_City FROM '/mnt/hgfs/DB-m12306/data/all-stations.txt' WITH DELIMITER ',' NULL AS '' CSV;

--OK

-- 导入每次列车信息

COPY Train FROM '/mnt/hgfs/DB-m12306/data/train.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY Train_Table FROM '/mnt/hgfs/DB-m12306/data/output.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY Station_Connection FROM '/mnt/hgfs/DB-m12306/data/ss.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY City_Connection FROM '/mnt/hgfs/DB-m12306/data/cc.csv' WITH DELIMITER ',' NULL AS '' CSV;
-- create empty seat table from train_table

-- CREATE TABLE Train_Table(
--     TT_sid int not null,
--     TT_tid char(10) not null,
--     TT_depart_time time not null,
--     TT_arrive_time time not null,
--     TT_time int,
--     TT_price_yz decimal not null,
--     TT_price_rz decimal not null,
--     TT_price_yws decimal not null,
--     TT_price_ywz decimal not null,
--     TT_price_ywx decimal not null,
--     TT_price_rws decimal not null,
--     TT_price_rwx decimal not null,
--     TT_count    int,
--     primary key (TT_tid,TT_sid),
--     foreign key (TT_tid) references Train(T_tid),
--     foreign key (TT_sid) references ID_Station_City(ISC_sid)
-- );


-- CREATE TABLE Empty_Seat(
--     ES_tid char(10),
--     ES_current_sid int not null,
--     ES_next_sid int,
--     ES_date date not null,
--     ES_left_yz int not null,
--     ES_left_rz int not null,
--     ES_left_yws int not null,
--     ES_left_ywz int not null,
--     ES_left_ywx int not null,
--     ES_left_rws int not null,
--     ES_left_rwx int not null,
--     primary key (ES_tid,ES_current_sid,ES_date),
--     foreign key (ES_current_sid) references ID_Station_City(ISC_sid),
--     foreign key (ES_next_sid) references ID_Station_City(ISC_sid)
-- );

-- DECLARE loop_count_s INTEGER;
-- loop_count_s:=0;

-- CREATE OR REPLACE FUNCTION set_seat (n INTEGER) 
-- RETURNS INTEGER AS $$ 
-- BEGIN
--     FOR counter IN 1..5 LOOP

--     INSERT INTO Empty_Seat(
--         ES_tid,
--         ES_current_sid,
--         -- ES_next_sid
--         ES_date
--         -- ES_left_yz,
--         -- ES_left_rz,
--         -- ES_left_yws,
--         -- ES_left_ywz,
--         -- ES_left_ywx,
--         -- ES_left_rws,
--         -- ES_left_rwx
--         )
--     SELECT 
--         TT_tid,
--         TT_sid,
--         current_date+counter
--     FROM Train_Table;

--     END LOOP;
-- END;

-- INSERT INTO Empty_Seat(
--     ES_tid,
--     ES_current_sid,
--     -- ES_next_sid
--     ES_date
--     -- ES_left_yz,
--     -- ES_left_rz,
--     -- ES_left_yws,
--     -- ES_left_ywz,
--     -- ES_left_ywx,
--     -- ES_left_rws,
--     -- ES_left_rwx
--     )
-- SELECT 
--     TT_tid,
--     TT_sid,
--     current_date
-- FROM Train_Table;

-- FOR counter IN 0..5 LOOP
--    select counter;
-- END LOOP;

-----------------

INSERT INTO Empty_Seat(
    ES_tid,
    ES_current_sid,
    -- ES_next_sid
    ES_date
    -- ES_left_yz,
    -- ES_left_rz,
    -- ES_left_yws,
    -- ES_left_ywz,
    -- ES_left_ywx,
    -- ES_left_rws,
    -- ES_left_rwx
    )
SELECT 
    TT_tid,
    TT_sid,
    current_date
FROM Train_Table;

INSERT INTO Empty_Seat(
    ES_tid,
    ES_current_sid,
    -- ES_next_sid
    ES_date
    -- ES_left_yz,
    -- ES_left_rz,
    -- ES_left_yws,
    -- ES_left_ywz,
    -- ES_left_ywx,
    -- ES_left_rws,
    -- ES_left_rwx
    )
SELECT 
    TT_tid,
    TT_sid,
    current_date+1
FROM Train_Table;
INSERT INTO Empty_Seat(
    ES_tid,
    ES_current_sid,
    -- ES_next_sid
    ES_date
    -- ES_left_yz,
    -- ES_left_rz,
    -- ES_left_yws,
    -- ES_left_ywz,
    -- ES_left_ywx,
    -- ES_left_rws,
    -- ES_left_rwx
    )
SELECT 
    TT_tid,
    TT_sid,
    current_date+2
FROM Train_Table;

INSERT INTO Empty_Seat(
    ES_tid,
    ES_current_sid,
    -- ES_next_sid
    ES_date
    -- ES_left_yz,
    -- ES_left_rz,
    -- ES_left_yws,
    -- ES_left_ywz,
    -- ES_left_ywx,
    -- ES_left_rws,
    -- ES_left_rwx
    )
SELECT 
    TT_tid,
    TT_sid,
    current_date+3
FROM Train_Table;

INSERT INTO Empty_Seat(
    ES_tid,
    ES_current_sid,
    -- ES_next_sid
    ES_date
    -- ES_left_yz,
    -- ES_left_rz,
    -- ES_left_yws,
    -- ES_left_ywz,
    -- ES_left_ywx,
    -- ES_left_rws,
    -- ES_left_rwx
    )
SELECT 
    TT_tid,
    TT_sid,
    current_date+4
FROM Train_Table;

INSERT INTO Passenger
VALUES(
    123456789012345678,
    18818881888,
    'Dio',
    '迪奥',
    233323333333333,
    ''
);

-- select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,TT_price_yz,
-- TT_price_yws,ES_left_yws,TT_price_ywz,ES_left_ywz,TT_price_ywx,ES_left_ywx,TT_price_rz,ES_left_rz,TT_price_rws,ES_left_rws,TT_price_rwx,ES_left_rwx,
-- ES_date,ES_left_yz
--  from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND tt_sid=ISC_sid and TT_tid='G3' and ES_date='2018-11-19' ORDER by TT_depart_time;
 
drop table price_time_de;
drop table price_time_ar;
drop table price_time;
create table price_time_de (
    PT_tid_de char(10) ,
    PT_depart_sid int,
  --  PT_arrive_sid int,
 --   PT_arrive_price_yz decimal ,
    PT_depart_price_yz decimal ,
  --  PT_arrive_time int ,
    PT_depart_time int ,
   -- PT_price_yz decimal ,
   -- PT_time int ,
    primary key(PT_depart_sid,PT_tid_de),
    foreign key (PT_tid_de) references Train(T_tid),
    foreign key (PT_depart_sid) references ID_Station_City(ISC_sid)
   -- foreign key (PT_arrive_sid) references ID_Station_City(ISC_sid)
);

create table price_time_ar (
    PT_tid_ar char(10) ,
   -- PT_depart_sid int,
    PT_arrive_sid int,
  
    PT_arrive_price_yz decimal ,
  --  PT_depart_price_yz decimal ,


    PT_arrive_time int ,
  --  PT_depart_time int ,

   -- PT_price_yz decimal ,
   -- PT_time int ,
    primary key(PT_arrive_sid,PT_tid_ar),
    foreign key (PT_tid_ar) references Train(T_tid),
    foreign key (PT_arrive_sid) references ID_Station_City(ISC_sid)
);

create table price_time(
      PT_tid char(10) ,
      PT_depart_sid_f int,
      PT_arrive_sid_f int,
     
      PT_price_yz decimal ,
      PT_time int ,
      primary key(PT_depart_sid_f,PT_arrive_sid_f,PT_tid),
      foreign key (PT_tid) references Train(T_tid),
      foreign key (PT_depart_sid_f) references ID_Station_City(ISC_sid),
      foreign key (PT_arrive_sid_f) references ID_Station_City(ISC_sid)
);


insert into price_time_de(PT_tid_De,PT_depart_sid,PT_depart_price_yz,PT_depart_time)
select distinct TT_tid,TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection,ID_Station_City,Train 
where TT_tid=CC_tid and ISC_cname ='北京' and TT_sid=ISC_sid and
CC_depart_city='北京' and CC_arrive_city ='上海' 
and TT_tid=T_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid);
-- and TT_depart_time>%4;

insert into price_time_ar(PT_tid_ar,PT_arrive_sid,PT_arrive_price_yz,PT_arrive_time)
select distinct TT_tid,TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection,price_time_de,ID_Station_City
where TT_tid=CC_tid and ISC_cname='上海'  and TT_sid=ISC_sid and PT_tid_de=TT_tid and 
CC_depart_city='北京'and CC_arrive_city ='上海' and TT_price_yz!=0;

insert into price_time(PT_tid,PT_depart_sid_f,PT_arrive_sid_f,PT_price_yz,PT_time)
SELECT distinct PT_tid_ar ,PT_depart_sid,PT_arrive_sid,PT_arrive_price_yz-PT_depart_price_yz,PT_arrive_time-PT_depart_time
FROM price_time_de,price_time_ar
WHERE PT_tid_ar=PT_tid_de;

--select distinct PT_tid ,PT_price_yz ,PT_time ,TT_depart_time 
--from price_time,Train_Table
--where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 


drop table Transfer_de;
drop table Transfer_ar_tf;
drop table Transfer_de_tf;
drop table Transfer_ar;
drop table Transfer;
CREATE TABLE Transfer_de(
  TF_tid_de char(10),
  TF_depart_price_yz decimal,
  TF_depart_sid int,
  TF_depart_time time,
  TF_tf_city_de  char(20) ,
  PRIMARY key(TF_tid_de,TF_depart_sid,TF_tf_city_de),
  foreign key (TF_tid_de,TF_depart_sid) references Train_Table(TT_tid,TT_sid)
  
);
CREATE TABLE Transfer_ar_tf(
  TF_tid_ar_tf char(10),
  TF_arrive_tf_price_yz decimal,
  TF_arrive_tf_sid int,
  TF_arrive_tf_time time,
  TF_tf_city_ar_tf  char(20) ,
  
  PRIMARY key(TF_tid_ar_tf,TF_arrive_tf_sid,TF_tf_city_ar_tf),
  foreign key (TF_tid_ar_tf) references Train(T_tid),
  foreign key (TF_arrive_tf_sid) references ID_Station_City(ISC_sid)
  );
CREATE TABLE Transfer_de_tf(
  TF_tid_ar_first char(10),
  TF_tid_de_tf char(10),
  TF_depart_tf_price_yz decimal,
  TF_depart_tf_sid int,
  TF_depart_tf_time time,
  TF_tf_city_de_tf  char(20),
  TF_tf_date int ,
  PRIMARY key(TF_tid_de_tf,TF_depart_tf_sid,TF_tf_city_de_tf,  TF_tid_ar_first),
  foreign key (TF_tid_de_tf) references Train(T_tid),
  foreign key (TF_depart_tf_sid) references ID_Station_CITY(ISC_sid)
);
CREATE TABLE Transfer_ar(
  TF_tid_ar char(10),
  TF_arrive_price_yz decimal,
  TF_arrive_sid int,
  TF_arrive_time time,
  TF_city_ar  char(20) ,
  
  PRIMARY key(TF_tid_ar,TF_arrive_sid,TF_city_ar),
  foreign key (TF_tid_ar) references Train(T_tid),
  foreign key (TF_arrive_sid) references ID_Station_City(ISC_sid)
);

insert into Transfer_de (TF_tid_de,TF_depart_sid,TF_depart_price_yz,TF_depart_time ,TF_tf_city_de)
SELECT distinct TT_tid,TT_sid,TT_price_yz,TT_depart_time,CC_arrive_city
from Train_Table,City_Connection,ID_Station_City,Train
where TT_tid=CC_tid and ISC_cname ='北京' and TT_sid=ISC_sid and
CC_depart_city='北京' and T_tid=TT_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid ) ;
-- and TT_depart_time>%4
insert into Transfer_ar_tf (TF_tid_ar_tf,TF_arrive_tf_sid,TF_arrive_tf_price_yz,TF_arrive_tf_time,TF_tf_city_ar_tf) select DISTINCT
TT_tid,TT_sid,TT_price_yz,TT_arrive_time,TF_tf_city_de
from Train_Table,City_Connection,Transfer_de,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city_de and TT_sid=ISC_sid and TT_tid=TF_tid_de and 
CC_depart_city='北京' and CC_arrive_city =TF_tf_city_de and TT_price_yz!=0 ;

insert into Transfer_de_tf (TF_tid_ar_first,TF_tid_de_tf,TF_depart_tf_sid,TF_depart_tf_price_yz,TF_depart_tf_time,TF_tf_city_de_tf,TF_tf_date) select DISTINCT
TF_tid_ar_tf,TT_tid,TT_sid,TT_price_yz,TT_depart_time,TF_tf_city_ar_tf,case when (TT_depart_time-TF_arrive_tf_time> interval '0 min') then 0 else 1 end 
from Train_Table,City_Connection,Transfer_ar_tf,ID_Station_City,Train
where TT_tid=CC_tid and ISC_cname=TF_tf_city_ar_tf and TT_sid=ISC_sid  and 
CC_depart_city=TF_tf_city_ar_tf and CC_arrive_city ='抚顺' 
and( (TF_arrive_tf_sid=tt_sid 
and ((interval '60 min'<TT_depart_time-TF_arrive_tf_time 
  AND interval '240 min'>TT_depart_time-TF_arrive_tf_time)or (interval '60 min'<TT_depart_time-TF_arrive_tf_time+interval '24 hour'
  AND interval '240 min'>TT_depart_time-TF_arrive_tf_time+interval '24 hour'      )))or
 (TF_arrive_tf_sid!=TT_sid and 
 ((interval '120 min'<TT_depart_time-TF_arrive_tf_time
  AND interval '240 min'>TT_depart_time-TF_arrive_tf_time) or (interval '120 min'<TT_depart_time-TF_arrive_tf_time+interval '24 hour'
  AND interval '240 min'>TT_depart_time-TF_arrive_tf_time+interval '24 hour'))))
 and T_tid=TT_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid) ;
 
 


insert into Transfer_ar (TF_tid_ar,TF_arrive_sid,TF_arrive_price_yz,TF_arrive_time,TF_city_ar) select DISTINCT
TT_tid,TT_sid,TT_price_yz,TT_arrive_time ,TF_tf_city_de_tf
from Train_Table,Transfer_DE_tf,ID_Station_City
where  ISC_cname ='抚顺' and TT_sid=ISC_sid and TT_tid=TF_tid_de_tf and TT_price_yz!=0  ;

create table Transfer (
    TF_first char(10),
    TF_second char(10),
    TF_depart_sid_f int ,
    TF_arrive_tf_sid_f int ,
    TF_depart_tf_sid_f int ,
    TF_arrive_sid_f int ,
    TF_tf_city  char(20) ,
    TF_price_first_yz decimal,
    TF_price_second_yz decimal,
    TF_price_yz decimal,
    TF_depart_time_f time,
    TF_arrive_time_f time,
    TF_tf_date_f int ,
    --TF_time int ,

    primary key(TF_depart_sid_f,TF_arrive_sid_f,TF_arrive_tf_sid_f,TF_depart_tf_sid_f,TF_first,TF_second,TF_tf_city),
    foreign key (TF_first) references Train(T_tid),
    foreign key (TF_second) references Train(T_tid),
    foreign key (TF_depart_sid_F) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_tf_sid_f) references ID_Station_City(ISC_sid),
    foreign key (TF_depart_tf_sid_f) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_sid_f) references ID_Station_City(ISC_sid)

);

INSERT into Transfer(TF_first,TF_second,TF_depart_sid_f,TF_arrive_tf_sid_f,TF_depart_tf_sid_f,TF_arrive_sid_f,TF_tf_city,TF_price_first_yz,TF_price_second_yz,TF_price_yz,TF_depart_time_f,TF_arrive_time_f,TF_tf_date_f)
SELECT DISTINCT TF_tid_ar_first,TF_tid_de_tf,TF_depart_sid,TF_arrive_tf_sid,TF_depart_tf_sid,TF_arrive_sid,TF_tf_city_de_tf,TF_arrive_tf_price_yz-TF_depart_price_yz,
 TF_arrive_price_yz-TF_depart_tf_price_yz, TF_arrive_tf_price_yz-TF_depart_price_yz+TF_arrive_price_yz-TF_depart_tf_price_yz,TF_depart_time,TF_arrive_time,
 TF_tf_date
FROM Transfer_de,Transfer_ar_tf,Transfer_de_tf, Transfer_ar 
WHERE TF_tid_de=TF_tid_ar_tf and TF_tid_ar_tf=TF_tid_ar_first and TF_tid_de_tf=TF_tid_ar and TF_tf_city_de=TF_tf_city_ar_tf and TF_tf_city_ar_tf=TF_tf_city_de_tf ;
