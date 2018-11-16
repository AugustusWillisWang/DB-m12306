select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,TT_price_yz,
TT_price_yws,ES_left_yws,TT_price_ywz,ES_left_ywz,TT_price_ywx,ES_left_ywx,TT_price_rz,ES_left_rz,TT_price_rws,ES_left_rws,TT_price_rwx,ES_left_rwx,
ES_date,ES_left_yz
 from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND tt_sid=ISC_sid and TT_tid='G3' and ES_date='2018-11-17' ORDER by TT_depart_time;

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
select TT_tid,TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection,ID_Station_City
where TT_tid=CC_tid and ISC_cname ='北京' and TT_sid=ISC_sid and
CC_depart_city='北京' and CC_arrive_city ='上海' ;
-- and TT_depart_time>%4;

insert into price_time_ar(PT_tid_ar,PT_arrive_sid,PT_arrive_price_yz,PT_arrive_time)
select TT_tid,TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection,price_time_de,ID_Station_City
where TT_tid=CC_tid and ISC_cname='上海'  and TT_sid=ISC_sid and PT_tid_de=TT_tid and 
CC_depart_city='北京'and CC_arrive_city ='上海' ;

insert into price_time(PT_tid,PT_depart_sid_f,PT_arrive_sid_f,PT_price_yz,PT_time)
SELECT PT_tid_ar ,PT_depart_sid,PT_depart_sid,PT_arrive_price_yz-PT_depart_price_yz,PT_arrive_time-PT_depart_time
FROM price_time_de,price_time_ar 
WHERE PT_tid_ar=PT_tid_de;

--select distinct PT_tid ,PT_price_yz ,PT_time ,TT_depart_time 
--from price_time,Train_Table
--where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
--ORDER by PT_price_yz,PT_time,TT_depart_time;

select DISTINCT PT_tid ,PT_price_yz ,PT_time ,TT_depart_time 
from price_time,Train_Table,Empty_Seat 
where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
and ES_date='2018-11-17' and ES_tid=PT_tid and ES_left_yz>0
ORDER by PT_price_yz,PT_time,TT_depart_time;


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
  PRIMARY key(TF_tid_de_tf,TF_depart_tf_sid,TF_tf_city_de_tf),
  foreign key (TF_tid_de_tf) references Train(T_tid),
  foreign key (TF_depart_tf_sid) references ID_Station_City(ISC_sid)
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
from Train_Table,City_Connection,ID_Station_City
where TT_tid=CC_tid and ISC_cname ='北京' and TT_sid=ISC_sid and
CC_depart_city='北京'  ;
--and TT_depart_time>%4
insert into Transfer_ar_tf (TF_tid_ar_tf,TF_arrive_tf_sid,TF_arrive_tf_price_yz,TF_arrive_tf_time,TF_tf_city_ar_tf) select DISTINCT
TT_tid,TT_sid,TT_price_yz,TT_arrive_time,TF_tf_city_de
from Train_Table,City_Connection,Transfer_de,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city_de and TT_sid=ISC_sid and TT_tid=TF_tid_de and 
CC_depart_city='北京' and CC_arrive_city =TF_tf_city_de ;

insert into Transfer_de_tf (TF_tid_ar_first,TF_tid_de_tf,TF_depart_tf_sid,TF_depart_tf_price_yz,TF_depart_tf_time,TF_tf_city_de_tf) select DISTINCT
TF_tid_ar_tf,TT_tid,TT_sid,TT_price_yz,TT_depart_time,TF_tf_city_ar_tf
from Train_Table,City_Connection,Transfer_ar_tf,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city_ar_tf and TT_sid=ISC_sid  and 
CC_depart_city=TF_tf_city_ar_tf and CC_arrive_city ='商丘' and ((TF_arrive_tf_sid=tt_sid and (
 interval '60 min'<TT_depart_time-TF_arrive_tf_time AND interval '240 min'>TT_depart_time-TF_arrive_tf_time) )or(TF_arrive_tf_sid!=TT_sid and (
 interval '120 min'<TT_depart_time-TF_arrive_tf_time AND interval '240 min'>TT_depart_time-TF_arrive_tf_time )) ;
 
insert into Transfer_ar (TF_tid_ar,TF_arrive_sid,TF_arrive_price_yz,TF_arrive_time) select
TT_tid,TT_sid,TT_price_yz,TT_arrive_time 
from Train_Table,City_Connection,Transfer_ar_tf,ID_Station_City
where TT_tid=CC_tid and ISC_cname ='商丘' and TT_sid=ISC_sid and TT_tid=TF_tid_de_tf and 
CC_depart_city=TF_tf_city_de_tf and CC_arrive_city = '商丘';


create table Transfer (
    TF_first char(10),
    TF_second char(10),
    TF_depart_sid_f int ,
    TF_arrive_tf_sid_f int ,
    TF_depart_tf_sid_f int ,
    TF_arrive_sid_f int ,
    TF_tf_city  char(20) ,
    TF_price_yz decimal,
    TF_time int ,

    primary key(TF_depart_sid,TF_arrive_sid,TF_arrive_tf_sid,TF_depart_tf_sid,TF_first,TF_second),
    foreign key (TF_first) references Train(T_tid),
    foreign key (TF_second) references Train(T_tid),
    foreign key (TF_depart_sid_F) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_tf_sid_f) references ID_Station_City(ISC_sid),
    foreign key (TF_depart_tf_sid_f) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_sid_f) references ID_Station_City(ISC_sid)

);

INSERT into Transfer(TF_first,TF_second,TF_depart_sid_f,TF_arrive_tf_sid_f,TF_depart_sid_f,TF_arrive_sid_f,TF_tf_city,TF_price_yz,TF_time)
SELECT TF_tid_ar_first,TF_tid_de_tf,TF_depart_sid,TF_arrive_tf_sid,TF_depart_sid,TF_arrive_sid,TF_tf_city_de_tf,TF_arrive_tf_price_yz+ TF_arrive_price_yz-TF_depart_tf_price_yz-TF_depart_price_yz,
datediff(minute,TF_arrive_time,TF_depart_time) FROM Transfer_de,Transfer_ar_tf,Transfer_de_tf, Transfer_ar 
WHERE TF_tid_de=TF_tie_ar_tf and TF_tid_ar_tf=TF_tid_ar_first and TF_tid_de_tf=TF_tid_ar and TF_tf_city_de=TF_tf_city_ar_tf and TF_tf_city_ar_tf=TF_tf_city_de_tf ;

update Transfer set TF_price_yz(TF_arrive_tf_price_yz+ TF_arrive_price_yz-TF_depart_tf_price_yz-TF_depart_price_yz);
update Transfer set TF_time datediff(minute,TF_arrive_time,TF_depart_time);

