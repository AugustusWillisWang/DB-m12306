CREATE TABLE ID_Station_City(
    sid INTEGER, 
    sname CHAR(20),
    cname CHAR(20)
    );

COPY ID_Station_City FROM '/mnt/hgfs/DB-m12306/data/all-stations.txt' WITH DELIMITER ',' NULL AS '' CSV;

-- https://www.cnblogs.com/dview112/archive/2012/10/22/2733706.html

-- HEADER QUOTE AS '|';

