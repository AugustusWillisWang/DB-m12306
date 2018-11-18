<?php
session_start(); 
    $start = trim($_POST["start"]);
    $end = trim($_POST["end"]);
    if($_POST["date"])
        $date  = strtotime($_POST["date"]);
    else
        $date  = strtotime("tomorrow");
    $inputdate = date("Y-m-d", $date);
    $type = trim($_POST["type"]);
    if($type =="hardseat")
        $inputtype = "PT_price_yz";
    else if($type =="softseat")
        $inputtype = "PT_price_rz";
    else if($type =="hardbed_top")
        $inputtype = "PT_price_yws";
    else if($type =="hardbed_middle")
        $inputtype = "PT_price_ywz";
    else if($type =="hardbed_bottom")
        $inputtype = "PT_price_ywx";
    else if($type =="softbed_top")
        $inputtype = "PT_price_rws";
    else
        $inputtype = "PT_price_rwx";
    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
    $q1 ="drop table price_time_de;";
    pg_query($dbconn,$q1)or die('Q1 failed: ' . pg_last_error());
    $q2 ="drop table price_time_ar;";
    pg_query($dbconn,$q2)or die('Q2 failed: ' . pg_last_error());
    $q3 ="drop table price_time;";
    pg_query($dbconn,$q3)or die('Q3 failed: ' . pg_last_error());
    $q4 ="create table price_time_de (
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
    );";
    pg_query($dbconn,$q4)or die('Q4 failed: ' . pg_last_error());
    $q5 ="create table price_time_ar (
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
    );";
    pg_query($dbconn,$q5)or die('Q5 failed: ' . pg_last_error());
    $q6 ="create table price_time(
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
    ";
    pg_query($dbconn,$q6)or die('Q6 failed: ' . pg_last_error());
    $q7 = "insert into price_time_de(PT_tid_De,PT_depart_sid,PT_depart_price_yz,PT_depart_time)
    select distinct TT_tid,TT_sid,TT_price_yz,TT_time 
    from Train_Table,City_Connection,ID_Station_City,Train 
    where TT_tid=CC_tid and ISC_cname ='$start' and TT_sid=ISC_sid and
    CC_depart_city='$start' and CC_arrive_city ='$end' 
    and TT_tid=T_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid);
    -- and TT_depart_time>%4;
    ";
    pg_query($dbconn,$q7)or die('Q7 failed: ' . pg_last_error());
    $q8 = "insert into price_time_ar(PT_tid_ar,PT_arrive_sid,PT_arrive_price_yz,PT_arrive_time)
    select distinct TT_tid,TT_sid,TT_price_yz,TT_time 
    from Train_Table,City_Connection,price_time_de,ID_Station_City
    where TT_tid=CC_tid and ISC_cname='$end'  and TT_sid=ISC_sid and PT_tid_de=TT_tid and 
    CC_depart_city='$start'and CC_arrive_city ='$end' and TT_price_yz!=0;
    ";
    pg_query($dbconn,$q8)or die('Q8 failed: ' . pg_last_error());
    $q9 = "insert into price_time(PT_tid,PT_depart_sid_f,PT_arrive_sid_f,PT_price_yz,PT_time)
    SELECT distinct PT_tid_ar ,PT_depart_sid,PT_arrive_sid,PT_arrive_price_yz-PT_depart_price_yz,PT_arrive_time-PT_depart_time
    FROM price_time_de,price_time_ar
    WHERE PT_tid_ar=PT_tid_de;
    ";
    pg_query($dbconn,$q9)or die('Q9 failed: ' . pg_last_error());
    $query = "select DISTINCT PT_tid ,$inputtype ,PT_time ,TT_depart_time ,PT_depart_sid_f,
    PT_arrive_sid_f 
    from price_time,Train_Table
    where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
    ORDER by PT_price_yz,PT_time,TT_depart_time;";

    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
?>

<html>
<head>
    <style type="text/css">
        body {background-size: 100%}
        table{border:1}
    </style>
</head> 
<body background="purchase_background.jpg">
<?php
    echo "直达";
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>价格</th>";
    echo "\t\t<th>运行时长</th>";
    echo "\t\t<th>出发时间</th>";

    echo "\t</tr>\n";
    $number =0 ;
    while($number <=10)
    {   
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $number ++ ;
        echo "\t<tr>\n";
        for($i=0;$i<4;$i++)
        {
            echo "\t\t<td>".$line[$i]."</td>\n";
        }
        echo "\t</tr>\n";
    }
    echo "</table>\n";

///////////////////////////////////////////////////////////////////////
    echo "<br>换乘";

    $q10 = "drop table Transfer_de;
    drop table Transfer_ar_tf;
    drop table Transfer_de_tf;
    drop table Transfer_ar;
    drop table Transfer;
    ";
    pg_query($dbconn,$q10)or die('Q10 failed: ' . pg_last_error());
    $q11 ="CREATE TABLE Transfer_de(
        TF_tid_de char(10),
        TF_depart_price_yz decimal,
        TF_depart_sid int,
        TF_depart_time time,
        TF_tf_city_de  char(20) ,
        PRIMARY key(TF_tid_de,TF_depart_sid,TF_tf_city_de),
        foreign key (TF_tid_de,TF_depart_sid) references Train_Table(TT_tid,TT_sid)
      );
    ";
    pg_query($dbconn,$q11)or die('Q11 failed: ' . pg_last_error());
    $q12 ="CREATE TABLE Transfer_ar_tf(
        TF_tid_ar_tf char(10),
        TF_arrive_tf_price_yz decimal,
        TF_arrive_tf_sid int,
        TF_arrive_tf_time time,
        TF_tf_city_ar_tf  char(20) ,
        
        PRIMARY key(TF_tid_ar_tf,TF_arrive_tf_sid,TF_tf_city_ar_tf),
        foreign key (TF_tid_ar_tf) references Train(T_tid),
        foreign key (TF_arrive_tf_sid) references ID_Station_City(ISC_sid)
        );
    ";
    pg_query($dbconn,$q12)or die('Q12 failed: ' . pg_last_error());
    $q13="CREATE TABLE Transfer_de_tf(
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
    ";
    pg_query($dbconn,$q13)or die('Q13 failed: ' . pg_last_error());
    $q14="CREATE TABLE Transfer_ar(
        TF_tid_ar char(10),
        TF_arrive_price_yz decimal,
        TF_arrive_sid int,
        TF_arrive_time time,
        TF_city_ar  char(20) ,
        
        PRIMARY key(TF_tid_ar,TF_arrive_sid,TF_city_ar),
        foreign key (TF_tid_ar) references Train(T_tid),
        foreign key (TF_arrive_sid) references ID_Station_City(ISC_sid)
      );
    ";
    pg_query($dbconn,$q14)or die('Q14 failed: ' . pg_last_error());
    $q15="insert into Transfer_de (TF_tid_de,TF_depart_sid,TF_depart_price_yz,TF_depart_time ,TF_tf_city_de)
    SELECT distinct TT_tid,TT_sid,TT_price_yz,TT_depart_time,CC_arrive_city
    from Train_Table,City_Connection,ID_Station_City,Train
    where TT_tid=CC_tid and ISC_cname ='$start' and TT_sid=ISC_sid and
    CC_depart_city='$start' and T_tid=TT_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid ) ;
    -- and TT_depart_time>%4
    insert into Transfer_ar_tf (TF_tid_ar_tf,TF_arrive_tf_sid,TF_arrive_tf_price_yz,TF_arrive_tf_time,TF_tf_city_ar_tf) select DISTINCT
    TT_tid,TT_sid,TT_price_yz,TT_arrive_time,TF_tf_city_de
    from Train_Table,City_Connection,Transfer_de,ID_Station_City
    where TT_tid=CC_tid and ISC_cname=TF_tf_city_de and TT_sid=ISC_sid and TT_tid=TF_tid_de and 
    CC_depart_city='$start' and CC_arrive_city =TF_tf_city_de and TT_price_yz!=0 ;
    ";
    pg_query($dbconn,$q15)or die('Q15 failed: ' . pg_last_error());
    $q16="
    insert into Transfer_de_tf (TF_tid_ar_first,TF_tid_de_tf,TF_depart_tf_sid,TF_depart_tf_price_yz,TF_depart_tf_time,TF_tf_city_de_tf,TF_tf_date) select DISTINCT
    TF_tid_ar_tf,TT_tid,TT_sid,TT_price_yz,TT_depart_time,TF_tf_city_ar_tf,case when (TT_depart_time-TF_arrive_tf_time> interval '0 min') then 0 else 1 end 
    from Train_Table,City_Connection,Transfer_ar_tf,ID_Station_City,Train
    where TT_tid=CC_tid and ISC_cname=TF_tf_city_ar_tf and TT_sid=ISC_sid  and 
    CC_depart_city=TF_tf_city_ar_tf and CC_arrive_city ='$end' 
    and( (TF_arrive_tf_sid=tt_sid 
    and ((interval '60 min'<TT_depart_time-TF_arrive_tf_time 
      AND interval '240 min'>TT_depart_time-TF_arrive_tf_time)or (interval '60 min'<TT_depart_time-TF_arrive_tf_time+interval '24 hour'
      AND interval '240 min'>TT_depart_time-TF_arrive_tf_time+interval '24 hour'      )))or
     (TF_arrive_tf_sid!=TT_sid and 
     ((interval '120 min'<TT_depart_time-TF_arrive_tf_time
      AND interval '240 min'>TT_depart_time-TF_arrive_tf_time) or (interval '120 min'<TT_depart_time-TF_arrive_tf_time+interval '24 hour'
      AND interval '240 min'>TT_depart_time-TF_arrive_tf_time+interval '24 hour'))))
     and T_tid=TT_tid and (((T_start_sid!=TT_sid) and TT_price_yz!=0 ) or T_start_sid=TT_sid) ;
    ";
    pg_query($dbconn,$q16)or die('Q16 failed: ' . pg_last_error());
    $q17="insert into Transfer_ar (TF_tid_ar,TF_arrive_sid,TF_arrive_price_yz,TF_arrive_time,TF_city_ar) select DISTINCT
    TT_tid,TT_sid,TT_price_yz,TT_arrive_time ,TF_tf_city_de_tf
    from Train_Table,Transfer_DE_tf,ID_Station_City
    where  ISC_cname ='$end' and TT_sid=ISC_sid and TT_tid=TF_tid_de_tf and TT_price_yz!=0  ;
    ";
    pg_query($dbconn,$q17)or die('Q17 failed: ' . pg_last_error());
    $q18="create table Transfer (
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
    ";
    pg_query($dbconn,$q18)or die('Q18 failed: ' . pg_last_error());
    $q19="INSERT into Transfer(TF_first,TF_second,TF_depart_sid_f,TF_arrive_tf_sid_f,TF_depart_tf_sid_f,TF_arrive_sid_f,TF_tf_city,TF_price_first_yz,TF_price_second_yz,TF_price_yz,TF_depart_time_f,TF_arrive_time_f,TF_tf_date_f)
    SELECT DISTINCT TF_tid_ar_first,TF_tid_de_tf,TF_depart_sid,TF_arrive_tf_sid,TF_depart_tf_sid,TF_arrive_sid,TF_tf_city_de_tf,TF_arrive_tf_price_yz-TF_depart_price_yz,
     TF_arrive_price_yz-TF_depart_tf_price_yz, TF_arrive_tf_price_yz-TF_depart_price_yz+TF_arrive_price_yz-TF_depart_tf_price_yz,TF_depart_time,TF_arrive_time,
     TF_tf_date
    FROM Transfer_de,Transfer_ar_tf,Transfer_de_tf, Transfer_ar 
    WHERE TF_tid_de=TF_tid_ar_tf and TF_tid_ar_tf=TF_tid_ar_first and TF_tid_de_tf=TF_tid_ar and TF_tf_city_de=TF_tf_city_ar_tf and TF_tf_city_ar_tf=TF_tf_city_de_tf ;
    ";
    pg_query($dbconn,$q19)or die('Q19 failed: ' . pg_last_error());
    $q20="SELECT * from Transfer order by TF_price_yz,case when ((TF_arrive_time_f-TF_depart_time_f)>interval '0 min') then TF_arrive_time_f-TF_depart_time_f else TF_arrive_time_f-TF_depart_time_f + interval '24 hour' end ,
    TF_depart_time_f;
    ";
    $result=pg_query($dbconn,$q20)or die('Q20 failed: ' . pg_last_error());

    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>价格</th>";
    echo "\t\t<th>运行时长</th>";
    echo "\t\t<th>出发时间</th>";

    echo "\t</tr>\n";
    $number =0 ;
    while($number <=20)
    {   
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $number ++ ;
        echo "\t<tr>\n";
        //for($i=0;$i<8;$i++)
        //{
         //   echo "\t\t<td>".$line[$i]."</td>\n";
        //}
        echo "\t\t<td>".$line[0]."</td>\n";
        echo "\t\t<td>".$line[1]."</td>\n";
        for($i=6;$i<12;$i++)
        {
            echo "\t\t<td>".$line[$i]."</td>\n";
        }
        echo "\t\t<td>".$line[12]."</td>\n";
        echo "\t</tr>\n";
    }
    echo "</table>\n";



    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);
?>
<p style="text-align:center;font-size:15">
    <a href="trainadvanced.html">返回<a>
</p>
</body>
</html>