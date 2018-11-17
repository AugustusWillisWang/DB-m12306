USAGE
===========

```
python create_database.py

<!-- then manually convert cc.csv to encoding='utf-8' -->

psql
drop database test12306;
create database test12306;

psql -U dbms -d test12306
or
psql -U dbms -d test12306 –f declare.sql
psql -U dbms -d test12306 –f alloc_seats.sql
```

Then:

* run declare.sql
* run alloc_seats.sql