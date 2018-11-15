CREATE TABLE ID_Station_City(
    sid INTEGER, 
    sname CHAR(20),
    cname CHAR(20)
    );

-- https://www.postgresql.org/docs/9.2/sql-copy.html

COPY ID_Station_City FROM '/mnt/hgfs/DB-m12306/data/all-stations.txt' WITH DELIMITER ',' NULL AS '' CSV;

--OK

psql -U dbms -d test12306

DROP TABLE ori_1095;

CREATE TABLE ori_1095(
    insid INTEGER,
    sname CHAR(20),
    arrive_time CHAR(20),
    depart_time CHAR(20),
    stay_time CHAR(20),
    duration_time CHAR(20),
    duration_km INTEGER,
    yz_rz CHAR(40),
    yw CHAR(40),
    rw CHAR(40)
    );

COPY ori_1095 FROM '/mnt/hgfs/DB-m12306/data/0/1095.csv' WITH 
DELIMITER AS ',' 
NULL AS ''
HEADER
CSV ;


CREATE TABLE t_1095(
    insid INTEGER,
    sname CHAR(20),
    arrive_time TIME,
    depart_time TIME,
    price_yz decimal,
    price_rz decimal,
    price_yws decimal,
    price_ywz decimal,
    price_ywx decimal,
    price_rws decimal,
    price_rwx decimal
    );

--TODO: 将上面的原始数据解析成这样的可用数据

-- substring(string from pattern)


-- HEADER QUOTE AS ',';
-- https://www.cnblogs.com/dview112/archive/2012/10/22/2733706.html


-- psql -v v1=12 -v v2="'Hello World'"
-- and then refer to the variables in sql as :v1, :v2 etc

-- select * from table_1 where id = :v1;

CREATE TABLE Train_Table(
    TT_tid char(10),
    TT_depart_station int,
    TT_arrive_station int,
    TT_depart_time time,
    TT_arrive_time time,
    TT_price_yz decimal,
    TT_price_rz decimal,
    TT_price_yws decimal,
    TT_price_ywz decimal,
    TT_price_ywx decimal,
    TT_price_rws decimal,
    TT_price_rwx decimal
);

CREATE TABLE Train(
    T_tid char(10),
    T_start_station char(20),
    T_end_station char(20)
);

CREATE TABLE Empty_Seat(
    ES_tid char(10),
    ES_current_sid int,
    ES_next_sid int,
    ES_date date,
    ES_left_yz int,
    ES_left_rz int,
    ES_left_yws int,
    ES_left_ywz int,
    ES_left_ywx int,
    ES_left_rws int,
    ES_left_rwx int
);

CREATE TABLE Passenger(
    P_pid int,
    P_phone int,
    P_pname char(20),
    P_uname char(30),
    P_credit_card int
);

CREATE TABLE Orders(
    O_oid int,
    O_pid int,
    O_date date,
    O_tid char(10),
    O_start_sid int,
    O_arrive_sid int
);

CREATE TABLE Station_Connection(
    SC_depart_sid int,
    SC_arrive_sid int,
    SC_tid int
);

CREATE TABLE City_Connection(
    CC_depart_city int,
    CC_arrive_city int,
    CC_tid int
);