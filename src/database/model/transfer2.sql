select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,TT_price_yz,
TT_price_yws,ES_left_yws,TT_price_ywz,ES_left_ywz,TT_price_ywx,ES_left_ywx,TT_price_rz,ES_left_rz,TT_price_rws,ES_left_rws,TT_price_rwx,ES_left_rwx,
ES_date,ES_left_yz
 from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND tt_sid=ISC_sid and TT_tid='G3' and ES_date='2018-11-17' ORDER by TT_depart_time;
 
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
--ORDER by PT_price_yz,PT_time,TT_depart_time;
.......................................................
select DISTINCT PT_tid ,PT_price_yz ,PT_time ,TT_depart_time ,PT_depart_sid_f,
PT_arrive_sid_f 
from price_time,Train_Table
where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
ORDER by PT_price_yz,PT_time,TT_depart_time;
.............................................................................
select DISTINCT PT_tid ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
PT_price_yz,SC_crossday
--,CC_day
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,price_time,Train_Table as Train_Table2,Station_Connection
 where Train_Table1.TT_sid= PT_depart_sid_f and Train_Table2.TT_sid= PT_arrive_sid_f 
 and ID_Station_City1.ISC_sid=PT_depart_sid_f and  ID_Station_City2.ISC_sid=PT_arrive_sid_f
 and SC_depart_sid=PT_depart_sid_f  and SC_arrive_sid=PT_arrive_sid_f
 and Train_Table1.TT_tid='G3' and Train_Table2.TT_tid=Train_Table1.TT_tid and PT_tid=Train_Table1.TT_tid ;
..........................................................................................

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

........................................................................................................................
SELECT * from Transfer order by TF_price_yz,case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end ,
TF_depart_time_f;


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

...............................................................................................................................


..................................................
select DISTINCT TF_first ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
tf_price_first_yz,SC_crossday
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
 where Train_Table1.TT_sid= TF_depart_sid_f and Train_Table2.TT_sid= TF_arrive_tf_sid_f
 and ID_Station_City1.ISC_sid=TF_depart_sid_f and  ID_Station_City2.ISC_sid=TF_arrive_tf_sid_f
 and SC_depart_sid=TF_depart_sid_f and  SC_arrive_sid=TF_arrive_tf_sid_f 
and Train_Table1.TT_tid='K915' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_first=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid  and TF_tf_city='唐山';
....................................................

..................................................
select DISTINCT TF_second ,ID_Station_City1.ISC_sname as depart_sname,ID_Station_City2.ISC_sname as arrive_sname,Train_Table1.TT_depart_time,Train_Table2.TT_arrive_time,
tf_price_second_yz,SC_crossday
--,CC_day
from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,Transfer,Train_Table as Train_Table2,Station_Connection
where Train_Table1.TT_sid= TF_depart_tf_sid_f and Train_Table2.TT_sid= TF_arrive_sid_f
and ID_Station_City1.ISC_sid=TF_depart_tf_sid_f  and  ID_Station_City2.ISC_sid=TF_arrive_sid_f 
and SC_depart_sid=TF_depart_tf_sid_f and SC_arrive_sid=TF_arrive_sid_f 
and Train_Table1.TT_tid='K95' and Train_Table2.TT_tid=Train_Table1.TT_tid and TF_second=Train_Table1.TT_tid and SC_tid =Train_Table1.TT_tid and TF_tf_city='唐山' ;
..............................................................


--extract (min from (TF_arrive_time-TF_depart_time))
