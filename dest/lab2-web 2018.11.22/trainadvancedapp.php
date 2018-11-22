<?php
session_start(); 
    $start = trim($_POST["start"]);
    $_SESSION['p2_start'] = $start;
    $end = trim($_POST["end"]);
    $_SESSION['p2_end'] = $end;
    if($_POST["date"])
        $date  = strtotime($_POST["date"]);
    else
        $date  = strtotime("tomorrow");
    $inputdate = date("Y-m-d", $date);
    $_SESSION['p2_date'] = $date;
    $type = trim($_POST["type"]);
    $_SESSION['p2_type'] = $type;
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

        if($type =="hardseat")
        {
            $inputtype1 = "TT_price_yz";
            $inputtype2= "ES_left_yz";
        }
        else if($type =="softseat")
        {
            $inputtype1 = "TT_price_rz";
            $inputtype2= "ES_left_rz";
        }
        else if($type =="hardbed_top")
        {
            $inputtype1 = "TT_price_yws";
            $inputtype2= "ES_left_yws";
        }
        else if($type =="hardbed_middle")
        {
            $inputtype1 = "TT_price_ywz";
            $inputtype2= "ES_left_ywz";
        }
        else if($type =="hardbed_bottom")
        {
            $inputtype1 = "TT_price_ywx";
            $inputtype2= "ES_left_ywx";
        }
        else if($type =="softbed_top")
        {
            $inputtype1 = "TT_price_rws";
            $inputtype2= "ES_left_rws";
        }
        else
        {
            $inputtype1 = "TT_price_rwx";
            $inputtype2= "ES_left_rwx";
        }
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
       -- $inputtype decimal ,
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
    
       -- $inputtype decimal ,
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
       
        $inputtype decimal ,
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
    $q9 = "insert into price_time(PT_tid,PT_depart_sid_f,PT_arrive_sid_f,$inputtype,PT_time)
    SELECT distinct PT_tid_ar ,PT_depart_sid,PT_arrive_sid,PT_arrive_price_yz-PT_depart_price_yz,PT_arrive_time-PT_depart_time
    FROM price_time_de,price_time_ar
    WHERE PT_tid_ar=PT_tid_de;
    ";
    pg_query($dbconn,$q9)or die('Q9 failed: ' . pg_last_error());
    $query = "SELECT 
    RES.PT_tid ,
    RES.$inputtype ,
    RES.PT_time ,
    RES.TT_depart_time,
    RES.depart_station,
    RES.arrive_station,
    RES.PT_depart_sid_f,
    RES.PT_arrive_sid_f,
    min($inputtype2) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
   ( 
       select DISTINCT PT_tid ,$inputtype ,PT_time ,TT_depart_time ,PT_depart_sid_f,
        PT_arrive_sid_f, SCI1.ISC_sname  as depart_station,SCI2.ISC_sname    as arrive_station
        
        from price_time,Train_Table, ID_Station_City as SCI1,ID_Station_City as SCI2
        where TT_sid= PT_depart_sid_f and PT_tid=TT_tid 
        and SCI1.ISC_sid=PT_depart_sid_f and SCI2.ISC_sid=PT_arrive_sid_f
        ORDER by $inputtype,PT_time,TT_depart_time
)as RES
WHERE 
    ES_tid=RES.PT_tid and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=RES.PT_depart_sid_f and
    TT2.TT_sid=RES.PT_arrive_sid_f and
    TT3.TT_sid=ES_current_sid and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count)
GROUP BY
    RES.PT_tid ,
    RES.$inputtype ,
    RES.PT_time ,
    RES.TT_depart_time,
    RES.depart_station,
    RES.arrive_station,
    RES.PT_depart_sid_f,
    RES.PT_arrive_sid_f
    ORDER by RES.$inputtype,RES.PT_time;"
;

    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
?>

<html>
<head>
    <meta charset="UTF-8">
    <style type="text/css">
        table thead,table tr {
        border-top-width: 1px;
        border-top-style: solid;
        border-top-color: rgb(235, 242, 224);
        }
        table {
        border-bottom-width: 1px;
        border-bottom-style: solid;
        border-bottom-color: rgb(235, 242, 224);
        }

        /* Padding and font style */
        table td,table th {
        padding: 5px 10px;
        font-size: 16px;
        font-family: Verdana;
        color: #333;
        }

        /* Alternating background colors */
        table tr:nth-child(even) {
        background: lightgrey
        }
        table tr:nth-child(odd) {
        background: #FFF
        }
        body {background-size: 100%}
        a:link,a:visited{
            text-decoration:none;  /*超链接无下划线*/
            }
        div { padding:18px } 
        img { border:0px; vertical-align:middle; padding:0px; margin:0px; } 
        input, button { font-family:"Arial", "Tahoma", "微软雅黑", "雅黑"; border:0;
        vertical-align:middle; margin:8px; line-height:18px; font-size:18px } 
        .btns {width:136px; height:33px; background:url("button2.jpg") no-repeat left top; color:#FFF; }
        .btn{width:136px;height:33px;line-height:18px;font-size:18px;
        background:url("button2.jpg") no-repeat left top;color:#FFF;padding-bottom:4px}
    </style>
</head> 
<body background="purchase_background.jpg">
<?php include 'top.html' ?>
<?php include 'table_style.html' ?>
<p style="text-align:center;font-size:25;margin-top:60px">
<?php
    echo "直达";
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>价格</th>";
    echo "\t\t<th>运行时长</th>";
    echo "\t\t<th>出发时间</th>";
    echo "\t\t<th>出发站</th>";
    echo "\t\t<th>到达站</th>";
    echo "\t\t<th>余票</th>";
    echo "\t\t<th>购票</th>";
    echo "\t</tr>\n";
    $purchurse_number1 =0 ;
    while($line = pg_fetch_array($result, null, PGSQL_NUM))
    {   
        if($purchurse_number1 < 10)
        {
            $purchurse_number1 ++ ;
            echo "\t<tr>\n";
            for($i=0;$i<6;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            }
            echo "\t\t<td>".$line[8]."</td>\n";
            echo "\t\t<td><a href=\"purchurseapp1.php?purchurse_number1=$purchurse_number1\">购买</a></td>\n";
            echo "\t</tr>\n";
        }       
    }
    echo "</table>\n";

///////////////////////////////////////////////////////////////////////
    echo "<br>换乘";

    $q10 = "
    
SELECT 
RES.depart_station_name,
RES.transfer_station1_name,
RES.tid1,
RES.price1,
RES. de_time,
RES. ar_tf_time,
RES.transfer_station2_name,
RES.arrive_station_name,
RES.tid2,
RES.price2,
RES. de_tf_time,
RES. ar_time,
RES.transfer_city,
RES.price_total,
RES.transfer_day,
RES.travel_time,
RES. sc1_crossday,
RES. sc2_crossday,
RES.depart_station,
RES.transfer_station1,
RES.transfer_station2,
RES.arrive_station,
min(ES1.$inputtype2) as left_yz1,
min(ES2.$inputtype2) as left_yz2

FROM 
Empty_Seat as ES1,
Empty_Seat as ES2,
Train_Table as TT1, 
Train_Table as TT2, 
Train_Table as TT3,
Train_Table as TT4, 
Train_Table as TT5, 
Train_Table as TT6,
( 


SELECT
SCI1.ISC_sname    as depart_station_name,
SCI3.ISC_sname    as transfer_station1_name,
SCI4.ISC_sname    as transfer_station2_name,
SCI2.ISC_sname    as arrive_station_name,
SC1.SC_depart_sid as depart_station,
SC1.SC_arrive_sid as transfer_station1,
SC2.SC_depart_sid as transfer_station2,
SC2.SC_arrive_sid as arrive_station,
TT1.TT_depart_time as de_time,
TT2.TT_arrive_time as ar_tf_time,
TT3.TT_depart_time as de_tf_time,
TT4.TT_arrive_time as ar_time,
SC1.SC_crossday as sc1_crossday,
SC2.SC_crossday as sc2_crossday,
SCI3.ISC_cname as transfer_city,
SC1.SC_tid as tid1,
SC2.SC_tid as tid2,
TT2.$inputtype1-TT1.$inputtype1 as price1,
TT4.$inputtype1-TT3.$inputtype1 as price2,
TT4.$inputtype1-TT3.$inputtype1+TT2.$inputtype1-TT1.$inputtype1 as price_total,
case 
   when ((TT4.TT_arrive_time-TT1.TT_depart_time )>interval '0 min') 
then TT4.TT_arrive_time-TT1.TT_depart_time 
   else TT4.TT_arrive_time-TT1.TT_depart_time  + interval '24 hour' 
end  as travel_time,
case when (TT3.TT_depart_time-TT2.TT_arrive_time> interval '0 min') then 0 else 1 end  as transfer_day
FROM 
Station_Connection as SC1,
Station_Connection as SC2,
ID_Station_City as SCI1,--始发站
ID_Station_City as SCI2,--终到站
ID_Station_City as SCI3, --换乘下车站
ID_Station_City as SCI4, --换乘上车站
Train_Table as TT1,--始发站
Train_Table as TT2,--换乘下车站
Train_Table as TT3,--换乘上车站
Train_Table as TT4,--终到站

Train as T1,--第一次列车
Train as T2 --第二次列车
WHERE
--始发终到站
SCI1.ISC_cname='$start' and
SCI2.ISC_cname='$end' and
SCI1.ISC_sid=SC1.SC_depart_sid and
SCI2.ISC_sid=SC2.SC_arrive_sid
and
--基本换乘逻辑
-- SC1.SC_depart_sid=443 and
-- SC1.SC_arrive_sid=SC2.SC_depart_sid and
SCI3.ISC_cname=SCI4.ISC_cname and
SCI3.ISC_sid=SC1.SC_arrive_sid and
SCI4.ISC_sid=SC2.SC_depart_sid and
-- SC2.SC_arrive_sid=59 and
SC1.SC_tid!=SC2.SC_tid
-- and
and
--禁止始发站/终到站同城市换乘
SCI1.ISC_cname!=SCI3.ISC_cname and
SCI2.ISC_cname!=SCI4.ISC_cname
and
--连接对应车次
TT1.TT_tid=SC1.SC_tid and
TT2.TT_tid=SC1.SC_tid and
TT3.TT_tid=SC2.SC_tid and
TT4.TT_tid=SC2.SC_tid and
TT1.TT_sid=SC1.SC_depart_sid and
TT2.TT_sid=SC1.SC_arrive_sid and
TT3.TT_sid=SC2.SC_depart_sid and
TT4.TT_sid=SC2.SC_arrive_sid and 
TT1.TT_depart_time>'00:00:00'
and
--换乘时间条件
-- TT3.TT_depart_time-TT2.TT_arrive_time
(
   (
       (
           SC1.SC_arrive_sid=SC2.SC_depart_sid --同站换乘
       )
       and
       (
           (
               (interval '60 min'<TT3.TT_depart_time-TT2.TT_arrive_time) and
               (interval '240 min'>TT3.TT_depart_time-TT2.TT_arrive_time)
           )
           or
           (
               (interval '60 min'<interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time) and
               (interval '240 min'>interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time)
           )
       )
   )
   OR
   (
       (
           SC1.SC_arrive_sid!=SC2.SC_depart_sid --异站换乘
       )
       and
       (
           (
               (interval '120 min'<TT3.TT_depart_time-TT2.TT_arrive_time) and
               (interval '240 min'>TT3.TT_depart_time-TT2.TT_arrive_time)
           )
           or
           (
               (interval '120 min'<interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time) and
               (interval '240 min'>interval '24 hour'+TT3.TT_depart_time-TT2.TT_arrive_time)
           )
       )
   )
)
--不可上车/下车站判断
and
(
   T1.T_tid=SC1.SC_tid and
   T2.T_tid=SC2.SC_tid
)
and
(
   (TT1.TT_sid=T1.T_start_sid)
   or
   (
       TT1.TT_sid!=T1.T_start_sid and
       TT1.$inputtype1!=0
   )
)
and
(
   (TT3.TT_sid=T2.T_start_sid)
   or
   (
       TT3.TT_sid!=T2.T_start_sid and
       TT3.$inputtype1!=0
   )
)
and
TT2.$inputtype1!=0 
and
TT4.$inputtype1!=0

ORDER BY 
price_total,
case 
   when ((TT2.TT_arrive_time-TT1.Tt_depart_time)>interval '0 min') 
   then TT2.TT_arrive_time-TT1.Tt_depart_time
   else TT2.TT_arrive_time-TT1.Tt_depart_time + interval '24 hour' 
   end,
TT1.Tt_depart_time

LIMIT 20
) as RES
WHERE 
ES1.ES_tid=RES.tid1 and
ES1.ES_tid=TT1.TT_tid and
ES1.ES_tid=TT2.TT_tid and
ES1.ES_tid=TT3.TT_tid and
ES1.ES_date  ='$inputdate' and 
TT1.TT_sid=RES.depart_station and
TT2.TT_sid=RES.transfer_station1 and
TT3.TT_sid=ES1.ES_current_sid and
(TT3.TT_count>=TT1.TT_count) and
(TT3.TT_count<TT2.TT_count) 
and
ES2.ES_tid=RES.tid2 and
ES2.ES_tid=TT4.TT_tid and
ES2.ES_tid=TT5.TT_tid and
ES2.ES_tid=TT6.TT_tid and
ES2.ES_date  ='$inputdate' and 
TT4.TT_sid=RES.transfer_station2 and
TT5.TT_sid=RES.arrive_station and
TT6.TT_sid=ES2.ES_current_sid and
(TT6.TT_count>=TT4.TT_count) and
(TT6.TT_count<TT5.TT_count) 
GROUP BY
RES.depart_station_name,
RES.transfer_station1_name,
RES.tid1,
RES.price1,
RES. de_time,
RES. ar_tf_time,
RES.transfer_station2_name,
RES.arrive_station_name,
RES.tid2,
RES.price2,
RES. de_tf_time,
RES. ar_time,
RES.transfer_city,
RES.price_total,
RES.transfer_day,
RES.travel_time,
RES. sc1_crossday,
RES. sc2_crossday,
RES.depart_station,
RES.transfer_station1,
RES.transfer_station2,
RES.arrive_station
ORDER BY 
RES.price_total,
RES.travel_time
;
     
    ";
    $result=pg_query($dbconn,$q10)or die('Q10 failed: ' . pg_last_error());

    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>出发站1</th>";
    echo "\t\t<th>到达站1</th>";
    echo "\t\t<th>车次1</th>";
    echo "\t\t<th>价格1</th>";
    echo "\t\t<th>出发时间</th>";
    echo "\t\t<th>到达时间1</th>";
    echo "\t\t<th>出发站</th>";
    echo "\t\t<th>到达站2</th>";
    echo "\t\t<th>车次2</th>";
    echo "\t\t<th>价格2</th>";
    echo "\t\t<th>出发时间2</th>";
    echo "\t\t<th>到达时间2</th>";
    echo "\t\t<th>中转城市</th>";
    echo "\t\t<th>总价</th>";
    echo "\t\t<th>总运行时长</th>";
    echo "\t\t<th>余票</th>";
    echo "\t\t<th>购票</th>";

    echo "\t</tr>\n";
    $purchurse_number =0 ;
    while($purchurse_number <=10)
    {   
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $purchurse_number ++ ;
        echo "\t<tr>\n";
        //for($i=0;$i<8;$i++)
        //{
         //   echo "\t\t<td>".$line[$i]."</td>\n";
        //}
        //echo "\t\t<td>".$line[0]."</td>\n";
        //echo "\t\t<td>".$line[1]."</td>\n";
        for($i=0;$i<14;$i++)
        {
            echo "\t\t<td>".$line[$i]."</td>\n";
        }
        echo "\t\t<td>".$line[15]."</td>\n";
        echo "\t\t<td>".$line[22]."</td>\n";
        echo "\t\t<td><a href=\"purchurseapp2.php?purchurse_number=$purchurse_number\">购买</a></td>\n";
        echo "\t</tr>\n";
    }
    echo "</table>\n";



    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);
?>
<p style="text-align:center;font-size:15">
    <a href="trainadvanced.html">
    <input type="button" class="btn" value="返回" onmouseover="this.style.backgroundPosition='left -36px'"
            onmouseout="this.style.backgroundPosition='left top'" />    
    <a>
</p>
</body>
</html>