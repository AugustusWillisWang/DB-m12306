<?php
session_start(); 
    $username=$_SESSION['username'];
    $start = $_SESSION['p2_start'];
    $end = $_SESSION['p2_end'];
    $date = $_SESSION['p2_date'];
    $inputdate = date("Y-m-d", $date);
    //echo $inputdate;
    $type = $_SESSION['p2_type'];
    //echo $type;
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
    
        if($type =="hardseat")
        {
                $o_inputtype = "ES_left_yz";
                $o_inputtype2 = "ES_left_yz-1";
        }
        else if($type =="softseat")
        {
            $o_inputtype = "ES_left_rz";
            $o_inputtype2 = "ES_left_rz-1";
        }
        else if($type =="hardbed_top")
        {
            $o_inputtype = "ES_left_yws";
            $o_inputtype2 = "ES_left_yws-1";
        }
        else if($type =="hardbed_middle")
        {
            $o_inputtype = "ES_left_ywz";
            $o_inputtype2 = "ES_left_ywz-1";
        }
        else if($type =="hardbed_bottom")
        {
            $o_inputtype = "ES_left_ywx";
            $o_inputtype2 = "ES_left_ywx-1";
        }
        else if($type =="softbed_top")
        {
            $o_inputtype = "ES_left_rws";
            $o_inputtype2 = "ES_left_rws-1";
        }
        else
        {
            $o_inputtype = "ES_left_rwx";
            $o_inputtype2 = "ES_left_rwx-1";
        }
    
    if($type =="hardseat")
        $output = "硬座";
    else if($type =="softseat")
        $output = "软座";
    else if($type =="hardbed_top")
        $output = "硬卧上铺";
    else if($type =="hardbed_middle")
        $output = "硬卧中铺";
    else if($type =="hardbed_bottom")
        $output = "硬卧下铺";
    else if($type =="softbed_top")
        $output = "软卧上铺";
    else
        $output = "软卧下铺";


    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
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
    <?php include 'table_style.html' ?>
</head> 
<body background="purchase_background.jpg">
<?php include 'top.html' ?>
<p style="text-align:center;font-size:25;margin-top:60px">
<?php
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

    $number = $_GET['purchurse_number'];
    //echo $number;

    $purchurse_number =1;
    while($purchurse_number <=$number)
    {   
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $purchurse_number ++ ;      
    }
    
    $start1 =  $line[0];
    $end1 = $line[1];
    $train1 = $line[2];
    $price1 = $line[3];
    $start2 =  $line[6];
    $end2 = $line[7];
    $train2 = $line[8];
    $price2 = $line[9];

    $transfer = $line[14];
    $crossday1 = $line[16];
    $crossday2 = $line[17];
    $inputdate2 = $inputdate;
    $inputdate2[9]=$inputdate2[9] + $transfer;
    $arrivedate1 = $inputdate;
    $arrivedate1[9] = $arrivedate1[9] + $crossday1;
    $arrivedate2 = $inputdate2;
    $arrivedate2[9] = $arrivedate2[9] + $crossday2;
    //echo $inputdate2;
    //echo"<br>".$start1.$end1.$train1.$price1.$start2.$end2.$train2.$price2.$transfer.$crossday1.$crossday2;

    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次1</th>";
    echo "\t\t<th>出发地1</th>";
    echo "\t\t<th>到达地1</th>";
    echo "\t\t<th>出发日期1</th>";
    echo "\t\t<th>到达日期1</th>";
    echo "\t\t<th>车次2</th>";
    echo "\t\t<th>出发地2</th>";
    echo "\t\t<th>到达地2</th>";
    echo "\t\t<th>出发日期2</th>";
    echo "\t\t<th>到达日期2</th>";
    echo "\t\t<th>座位类型</th>";
    echo "\t</tr>\n";
    echo "\t<tr>\n";
    //for($i=0;$i<23;$i++)
    //{
        echo "\t\t<td>".$line[2]."</td>\n";
        echo "\t\t<td>".$line[0]."</td>\n";
        echo "\t\t<td>".$line[1]."</td>\n";
        echo "\t\t<td>".$inputdate."</td>\n";
        echo "\t\t<td>".$arrivedate1."</td>\n";
        echo "\t\t<td>".$line[8]."</td>\n";
        echo "\t\t<td>".$line[6]."</td>\n";
        echo "\t\t<td>".$line[7]."</td>\n";
        echo "\t\t<td>".$inputdate2."</td>\n";
        echo "\t\t<td>".$arrivedate2."</td>\n";
        echo "\t\t<td>".$output."</td>\n";
    //}
    echo "\t</tr>\n";
    echo "</table>\n";

    //查询始发站id
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$start1';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $start_id1 = $line[0];
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$start2';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $start_id2 = $line[0];
    //查询终点站id
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$end1';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $end_id1 = $line[0];
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$end2';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $end_id2 = $line[0];
    
    //echo "<br>".$start_id1."<br>".$end_id1."<br>".$start_id2."<br>".$end_id2."<br>";

    //生成订单号
    $query = "
    SELECT COUNT(*)+1
    FROM ORDERS; ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $o_id1 = $line[0];
    $query = "
    SELECT COUNT(*)+2
    FROM ORDERS; ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $o_id2 = $line[0];
    //echo $o_id;

    //查询用户身份证
    $query = "
    SELECT P_pid
            FROM Passenger
            WHERE P_uname='$username';
            ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $userid = $line[0];
    //echo $userid.$o_id;

    $current_date=date('y-m-d',time());

    $query="
    INSERT INTO Orders
    VALUES(
        $o_id1,
        $userid,

        to_date('$current_date','YY-MM-DD'),

        $start_id1,
        $end_id1,
        $price1,

        to_date('$inputdate','YY-MM-DD'),
        '18:06',
        '$train1',
        $start_id1,
        $end_id1,
        '$type'
    );";
    $result = pg_query($query) or die('Q1 failed: ' . pg_last_error());

    $query="UPDATE Empty_Seat
    SET $o_inputtype=$o_inputtype2
    FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
    WHERE 
        ES_tid='$train1' and
        ES_tid=TT1.TT_tid and
        ES_tid=TT2.TT_tid and
        ES_tid=TT3.TT_tid and
        TT1.TT_sid=$start_id1 and
        TT2.TT_sid=$end_id1 and
        TT3.TT_sid=ES_current_sid and
        (TT3.TT_count>=TT1.TT_count) and
        (TT3.TT_count<TT2.TT_count);
        ";
    $result = pg_query($query) or die('Q2 failed: ' . pg_last_error());

    $query="
    INSERT INTO Orders
    VALUES(
        $o_id2,
        $userid,

        to_date('$current_date','YY-MM-DD'),

        $start_id2,
        $end_id2,
        $price2,

        to_date('$inputdate2','YY-MM-DD'),
        '18:06',
        '$train2',
        $start_id2,
        $end_id2,
        '$type'
    );";
    $result = pg_query($query) or die('Q3 failed: ' . pg_last_error());

    $query="UPDATE Empty_Seat
    SET $o_inputtype=$o_inputtype2
    FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
    WHERE 
        ES_tid='$train2' and
        ES_tid=TT1.TT_tid and
        ES_tid=TT2.TT_tid and
        ES_tid=TT3.TT_tid and
        TT1.TT_sid=$start_id2 and
        TT2.TT_sid=$end_id2 and
        TT3.TT_sid=ES_current_sid and
        (TT3.TT_count>=TT1.TT_count) and
        (TT3.TT_count<TT2.TT_count);
        ";
    $result = pg_query($query) or die('Q4 failed: ' . pg_last_error());






    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);

    header("Refresh:5;url=111.html");
?>
<p style="text-align:center;font-size:25;margin-top:350px">
    <a href="111.html">
    <input type="button" class="btn" value="返回" onmouseover="this.style.backgroundPosition='left -36px'"
                onmouseout="this.style.backgroundPosition='left top'" />
    </a>
    <br>
    5秒后自动跳转
</p>
</body>
</html>


