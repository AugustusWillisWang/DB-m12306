<?php 
session_start(); 
    $train = trim($_POST["train"]);
    $type = trim($_POST["type"]);
    if($type =="hardseat")
    {
        $inputtype = "TT_price_yz";
        $inputtype2= "ES_left_yz";
    }
    else if($type =="softseat")
    {
        $inputtype = "TT_price_rz";
        $inputtype2= "ES_left_rz";
    }
    else if($type =="hardbed_top")
    {
        $inputtype = "TT_price_yws";
        $inputtype2= "ES_left_yws";
    }
    else if($type =="hardbed_middle")
    {
        $inputtype = "TT_price_ywz";
        $inputtype2= "ES_left_ywz";
    }
    else if($type =="hardbed_bottom")
    {
        $inputtype = "TT_price_ywx";
        $inputtype2= "ES_left_ywx";
    }
    else if($type =="softbed_top")
    {
        $inputtype = "TT_price_rws";
        $inputtype2= "ES_left_rws";
    }
    else
    {
        $inputtype = "TT_price_rwx";
        $inputtype2= "ES_left_rwx";
    }
    if($_POST["date"])
        $date  = strtotime($_POST["date"]);
    else
        $date  = strtotime("tomorrow");
    $inputdate = date("Y-m-d", $date);
    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
    $query = "SELECT 
    RES.TT_count, 
    RES.TT_tid, 
    ISC_sname,
    RES.TT_sid, 
    RES.TT_arrive_time, 
    RES.TT_depart_time, 
    RES.$inputtype,
    min($inputtype2) as left_yz
FROM Empty_Seat,
    Train_Table as TT1, 
    Train_Table as TT2, 
    Train_Table as TT3,
    ID_Station_City,
    Train,
    ( 
        SELECT 
            TT_count, TT_tid, TT_sid, TT_arrive_time, TT_depart_time, $inputtype
        FROM Train_Table
        WHERE TT_tid='$train'
        ORDER BY TT_count
    ) as RES
WHERE 
    ES_tid='$train' and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    T_tid=ES_tid and
    ISC_sid=RES.TT_sid and
    ES_date='$inputdate' and
    (
        (
            TT1.TT_sid=T_start_sid and
            TT2.TT_sid=RES.TT_sid and
            TT3.TT_sid=ES_current_sid and
            (TT3.TT_count>=TT1.TT_count) and
            (TT3.TT_count<TT2.TT_count)
        )
        OR
        (
            TT1.TT_sid=T_start_sid and
            TT2.TT_sid=T_start_sid and
            TT3.TT_sid=T_start_sid and
            ES_current_sid=T_start_sid
        )
    )
GROUP BY
    RES.TT_count, 
    RES.TT_tid, 
    ISC_sname,
    RES.TT_sid, 
    RES.TT_arrive_time, 
    RES.TT_depart_time, 
    RES.$inputtype
ORDER BY RES.TT_count
;
    ";


    
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $_SESSION['train']=$train;
    $_SESSION['type']=$type;
    $_SESSION['inputdate']=$inputdate;
    $_SESSION['inputtype']=$inputtype;
    $_SESSION['inputtype2']=$inputtype2;
    $_SESSION['whether_advanced']="0";
?>

<html>
<head>
    <meta charset="UTF-8">
    <style type="text/css">
        body {background-size: 100%}
        a:link,a:visited{
            text-decoration:none;  /*超链接无下划线*/
            }
        div { padding:18px } 
        img { border:0px; vertical-align:middle; padding:0px; margin:0px; } 
        input, button { font-family:"Arial", "Tahoma", "微软雅黑", "雅黑"; border:0;
        vertical-align:middle; margin:8px; line-height:18px; font-size:18px } 
        .btn{width:136px;height:33px;line-height:18px;font-size:18px;
        background:url("button2.jpg") no-repeat left top;color:#FFF;padding-bottom:4px}
    </style>
</head> 
<?php include 'top.html' ?>
<?php include 'table_style.html' ?>
<body background="purchase_background.jpg" >
<p style="text-align:center;font-size:25;margin-top:60px">
<?php
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>序号</th>";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>车站</th>";
    echo "\t\t<th>到站时间</th>";
    echo "\t\t<th>出站时间</th>";
    echo "\t\t<th>票价</th>";
    echo "\t\t<th>余票</th>";
    echo "\t</tr>\n";
    $number =0;
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number ++;
        echo "\t<tr>\n";
        for($i=0;$i<6;$i++)
        {
            if($i != 3)
                echo "\t\t<td>".$line[$i]."</td>\n";
        }
        if($line[6] != "0")
        {
            if($line[7] > "0")
            {
                echo "\t\t<td>".$line[6]."</td>\n";
                echo "\t\t<td><a href=\"purchurseapp.php?station=$number\">".$line[7]."</a></td>\n";
            }
            else
            {
                echo "\t\t<td>-</td>\n";
                echo "\t\t<td>售罄</td>\n";
            }
        }
        else{
            echo "\t\t<td>-</td>\n";
            echo "\t\t<td>-</td>\n";
        }
        
        echo "\t</tr>\n";
    }
    echo "</table>\n";
    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);
?>
</p>
<p style="text-align:center;font-size:15">
    <a href="train.html">
    <input type="button" class="btn" value="返回" onmouseover="this.style.backgroundPosition='left -36px'"
         onmouseout="this.style.backgroundPosition='left top'" />
    <a>
</p>
</body>
</html>
