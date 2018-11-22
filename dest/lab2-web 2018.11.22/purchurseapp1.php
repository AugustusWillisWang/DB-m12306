<?php
session_start(); 
    $username=$_SESSION['username'];
    $start = $_SESSION['p2_start'];
    $end = $_SESSION['p2_end'];
    $date = $_SESSION['p2_date'];
    $inputdate = date("Y-m-d", $date);
    //echo $inputdate;
    $type = $_SESSION['p2_type'];
    //echo $type;$inputtype2
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

    $query = "SELECT distinct 
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
    $result=pg_query($dbconn,$query)or die('Q10 failed: ' . pg_last_error());

    $number = $_GET['purchurse_number1'];
    //echo $number;

    $purchurse_number =1 ;
    while($purchurse_number <=$number)
    {   
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $purchurse_number ++ ;      
    }
    /*for($i=0;$i<23;$i++)
        {
            echo "\t\t<td>".$line[$i]."</td>\n";
    }*/

    $tid = $line[0];
    $price = $line[1];
    $q1="SELECT 
    RES.PT_tid,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.$inputtype,
    RES.SC_crossday,
    min($inputtype2) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ( 
        select DISTINCT 
        PT_tid,
        ID_Station_City1.ISC_sname as depart_sname,
        ID_Station_City2.ISC_sname as arrive_sname,
        Train_Table1.TT_depart_time,
        Train_Table2.TT_arrive_time,
        $inputtype,
        SC_crossday,
        -- NEWLY ADDED
        PT_depart_sid_f,
        PT_arrive_sid_f
        --,CC_day
        from Train_Table as Train_Table1,ID_Station_City as ID_Station_City1, ID_Station_City as ID_Station_City2 ,price_time,Train_Table as Train_Table2,Station_Connection
        where Train_Table1.TT_sid= PT_depart_sid_f and Train_Table2.TT_sid= PT_arrive_sid_f 
        and ID_Station_City1.ISC_sid=PT_depart_sid_f and  ID_Station_City2.ISC_sid=PT_arrive_sid_f
        and SC_depart_sid=PT_depart_sid_f  and SC_arrive_sid=PT_arrive_sid_f
        and Train_Table1.TT_tid='$tid' and Train_Table2.TT_tid=Train_Table1.TT_tid and PT_tid=Train_Table1.TT_tid
    ) as RES
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
    RES.PT_tid,
    RES.depart_sname,
    RES.arrive_sname,
    RES.TT_depart_time,
    RES.TT_arrive_time,
    RES.$inputtype,
    RES.SC_crossday
;
";
//echo "<br>";
    echo "直达";
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>出发站</th>";
    echo "\t\t<th>到达站</th>";
    echo "\t\t<th>出发时间</th>";
    echo "\t\t<th>到达时间</th>";
    //echo "\t\t<th>座位类型</th>";
    echo "\t</tr>\n";
    $result=pg_query($dbconn,$q1)or die('Q1 failed: ' . pg_last_error());
    $line2 = pg_fetch_array($result, null, PGSQL_NUM);
    echo "\t<tr>\n";
    for($i=0;$i<6;$i++)
        {
            echo "\t\t<td>".$line2[$i]."</td>\n";
    }
    echo "\t</tr>\n";
    echo "</table>\n";

    $train = $line2[0];
    $start = $line2[1];
    $end = $line2[2];
    //echo $start;
    //echo $end;

    //查询始发站id
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$start';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $start_id = $line[0];
    //查询终点站id
    $query="
    select ISC_sid 
    from ID_Station_City
    where ISC_sname='$end';";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $end_id = $line[0];
    
    //echo $start_id.$end_id."<br>";

    //生成订单号
    $query = "
    SELECT COUNT(*)+1
    FROM ORDERS; ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $o_id = $line[0];
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
    //echo $userid;

    $current_date=date('y-m-d',time());
    $query="
    INSERT INTO Orders
    VALUES(
        $o_id,
        $userid,

        to_date('$current_date','YY-MM-DD'),

        $start_id,
        $end_id,
        $price,

        to_date('$inputdate','YY-MM-DD'),
        '18:06',
        '$train',
        $start_id,
        $end_id,
        '$type'
    );";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());

    $query="UPDATE Empty_Seat
    SET $o_inputtype=$o_inputtype2
    FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3
    WHERE 
        ES_tid='$train' and
        ES_tid=TT1.TT_tid and
        ES_tid=TT2.TT_tid and
        ES_tid=TT3.TT_tid and
        TT1.TT_sid=$start_id and
        TT2.TT_sid=$end_id and
        TT3.TT_sid=ES_current_sid and
        (TT3.TT_count>=TT1.TT_count) and
        (TT3.TT_count<TT2.TT_count);
        ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());



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


