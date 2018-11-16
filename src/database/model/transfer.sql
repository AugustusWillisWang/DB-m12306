create table price_time(
    PT_tid char(10) not null,
    PT_depart_sid int not null,
    PT_arrive_sid int not null,
  
    PT_arrive_price_yz int not null,
    PT_depart_price_yz int not null,

    PT_arrive_price_yws int not null,
    PT_depart_price_yws int not null,
    
    PT_arrive_price_ywz int not null,
    PT_depart_price_ywz int not null,

    PT_arrive_price_ywx int not null,
    PT_depart_price_ywx int not null,
    
    PT_arrive_price_rz int not null,
    PT_depart_price_rz int not null,

    -- PT_arrive_price_yws int not null,
    -- PT_depart_price_yws int not null,

    -- PT_arrive_price_ywx int not null,
    -- PT_depart_price_ywx int not null,

    PT_arrive_time int not null,
    PT_depart_time int not null,

    PT_price_yz int not null,
    PT_price_yws int not null,
    PT_price_ywz int not null,
    PT_price_ywx int not null,
    PT_price_rz int not null,
    PT_price_rws int not null,
    PT_price_rwx int not null,

    PT_time int not null,
    primary key(PT_depart_sid,PT_arrive_sid,PT_tid),
    foreign key (PT_tid) references Train(T_tid),
    foreign key (PT_depart_sid) references ID_Station_City(ISC_sid),
    foreign key (PT_arrive_sid) references ID_Station_City(ISC_sid)
);
 
insert into price_time(PT_tid,PT_depart_sid,PT_depart_price_yz,PT_depart_time)
select TT_tid,TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection 
where TT_tid=CC_tid and TT_sid=1 and 
CC_depart_city='' and CC_arrive_city ='' and TT_depart_time>%4;

insert into price_time(PT_arrive_sid,PT_arrive_price_yz,PT_arrive_time)
select TT_sid,TT_price_yz,TT_time 
from Train_Table,City_Connection,price_time
where TT_tid=CC_tid and TT_sid=2 and PT_tid=TT_tid and 
CC_depart_city=%1 and CC_arrive_city =%2;

update price_time set PT_time = PT_arrive_time-PT_depart_time ;
update price_time set PT_price_yz = PT_arrive_price_yz-PT_depart_price_yz ;


select PT_tid,ES_left_yz from price_time,Empty_Seat order where ES_date=%3 and ES_tid=PT_pid and ES_left_yz>0 by PT_price_yz,PT_time,PT_depart_time;
