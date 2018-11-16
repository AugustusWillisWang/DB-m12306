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