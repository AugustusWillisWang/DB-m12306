select TT_tid,TT_sid,TT_arrive_time,TT_depart_time,TT_price_yz,TT_price_yws,
TT_price_ywz,TT_price_ywx,TT_price_rz,TT_price_rws,TT_price_rwx,ES_date,ES_left_yz,
ES_left_yws,ES_left_ywz,ES_left_ywx,ES_left_rz,ES_left_rws,ES_left_rwx from 
Train_Table,Empty_Seat where TT_sid=ES_current_sid and TT_tid='G3' and ES_date='2018-11-17';

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

select PT_tid ,PT_price_yz ,PT_time ,TT_depart_time 
from price_time,Train_Table
where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
ORDER by PT_price_yz,PT_time,TT_depart_time;

select PT_tid ,PT_price_yz ,PT_time ,TT_depart_time 
from price_time,Train_Table,Empty_Seat 
where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
and ES_date='2018-11-17' and ES_tid=PT_pid and ES_left_yz>0
ORDER by PT_price_yz,PT_time,TT_depart_time;



create table Transfer (
    TF_first char(10),
    TF_second char(10),
    --TF_depart_sid int ,
    --TF_arrive_tf_sid int ,
    --TF_depart_tf_sid int ,
    --TF_arrive_sid int ,
    TF_tf_city  char(20) ,

    TF_arrive_price_yz decimal ,
    TF_arrive_tf_price_yz decimal ,
    TF_depart_tf_price_yz decimal ,
    TF_depart_price_yz decimal ,
    TF_depart_time time ,
    TF_arrive_tf_time time  ,
    TF_depart_tf_time time ,
    TF_arrive_time time ,
    TF_price_yz decimal,
    TF_time int ,

    primary key(TF_depart_sid,TF_arrive_sid,TF_arrive_tf_sid,TF_depart_tf_sid,TF_first,TF_second),
    foreign key (TF_first) references Train(T_tid),
    foreign key (TF_second) references Train(T_tid),
    foreign key (TF_depart_sid) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_tf_sid) references ID_Station_City(ISC_sid),
    foreign key (TF_depart_tf_sid) references ID_Station_City(ISC_sid),
    foreign key (TF_arrive_sid) references ID_Station_City(ISC_sid)

);

insert into Transfer (TF_first,TF_depart_sid,TF_depart_price_yz,TF_depart_time，TF_tf_city) select 
TT_tid,TT_sid,TT_price_yz,TT_depart_time，CC_arrive_city 
from Train_Table,City_Connection,ID_Station_City
where TT_tid=CC_tid and ISC_cname =%1 and TT_sid=ISC_sname and
CC_depart_city=%1 and TT_depart_time>%4;

insert into Transfer (TF_arrive_tf_sid,TF_arrive_tf_price_yz,TF_arrive_tf_time) select
TT_sid,TT_price_yz,TT_arrive_time 
from Train_Table,City_Connection,Transfer,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city and TT_sid=ISC_sname and TT_tid=TF_first and 
CC_depart_city=%1 and CC_arrive_city =TF_tf_city ;

insert into Transfer (TF_second,TF_depart_tf_sid,TF_depart_tf_price_yz,TF_depart_tf_time) select 
TT_tid,TT_sid,TT_price_yz,TT_depart_time
from Train_Table,City_Connection,Transfer,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city and TT_sid=ISC_sname and PT_tid=TT_tid and 
CC_depart_city=TF_tf_city and CC_arrive_city =%2 and ((TF_depart_tf_sid=TF_arrive_tf_sid and 
 60<datediff(minute,TF_arrive_tf_time,TT_depart_time)<240) or(TF_depart_tf_sid!=TF_arrive_tf_sid and 
 120<datediff(minute,TF_arrive_tf_time,TT_depart_time)<240));

insert into Transfer (TF_arrive_sid,TF_arrive_price_yz,TF_arrive_time) select
TT_sid,TT_price_yz,TT_arrive_time 
from Train_Table,City_Connection,Transfer,ID_Station_City
where TT_tid=CC_tid and ISC_cname=TF_tf_city and TT_sid=ISC_sname and TT_tid=TT_second and 
CC_depart_city=TF_tf_city and CC_arrive_city = %2; 

update Transfer set TF_price_yz(TF_arrive_tf_price_yz+ TF_arrive_price_yz-TF_depart_tf_price_yz-TF_depart_price_yz);
update Transfer set TF_time datediff(minute,TF_arrive_time,TF_depart_time);

