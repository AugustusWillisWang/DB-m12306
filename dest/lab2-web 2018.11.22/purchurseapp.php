<?php 
session_start(); 
$train=$_SESSION['train'];
$type=$_SESSION['type'];
$inputdate=$_SESSION['inputdate'];
$inputtype=$_SESSION['inputtype'];
$inputtype2=$_SESSION['inputtype2'];

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
        .btns {width:136px; height:33px; background:url("button2.jpg") no-repeat left top; color:#FFF; }
        .btn{width:136px;height:33px;line-height:18px;font-size:18px;
        background:url("button2.jpg") no-repeat left top;color:#FFF;padding-bottom:4px}
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
    </style>
    <?php //include 'table_style.html' ?>
</head> 
<body background="purchase_background.jpg">
<p style="text-align:center;font-size:35;margin-top:60px">
购买车票
</p>
<p style="text-align:auto;font-size:25;margin-top:40px">
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
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        echo "\t<tr>\n";
        for($i=0;$i<6;$i++)
        {
            if($i != 3)
                echo "\t\t<td>".$line[$i]."</td>\n";
        }
        if($line[6] != "0")
        {
            if($line[7] != "0")
            {
                echo "\t\t<td>".$line[6]."</td>\n";
                echo "\t\t<td>".$line[7]."</td>\n";
            }
            else
            {
                echo "\t\t<td>-</td>\n";
                echo "\t\t<td>".$line[7]."</td>\n";
            }
        }
        else{
            echo "\t\t<td>-</td>\n";
            echo "\t\t<td>-</td>\n";
        }
        
        echo "\t</tr>\n";
    }
    echo "</table>\n";
    $station = $_GET['station'];
    //echo $station;
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
 
    echo"&nbsp;&nbsp;&nbsp;&nbsp;";
    echo"<form action=\"afterpurchurse.php\" method=\"post\">";
    echo"<select class=\"btns\" onmouseover=\"this.style.backgroundPosition='left -36px'\"
    onmouseout=\"this.style.backgroundPosition='left top'\" name=\"destination_buy\">";
    $number=0;
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number++;
        if($number == $station)
            echo"<option class=\"btns\" onmouseover=\"this.style.backgroundPosition='left -36px'\"
            onmouseout=\"this.style.backgroundPosition='left top'\"  value=".$number." selected=\"selected\">".$line[2]."</option>";
        else
            echo"<option  class=\"btns\" onmouseover=\"this.style.backgroundPosition='left -36px'\"
            onmouseout=\"this.style.backgroundPosition='left top'\"  value=".$number.">".$line[2]."</option>";
    }
	echo"</select>";
    echo"
    <input type=\"submit\" class=\"btns\" onmouseover=\"this.style.backgroundPosition='left -36px'\"
    onmouseout=\"this.style.backgroundPosition='left top'\"  value=\"购买\" />
    <a href=\"111.html\">
    <input type=\"button\" class=\"btn\" value=\"取消\" onmouseover=\"this.style.backgroundPosition='left -36px'\"
            onmouseout=\"this.style.backgroundPosition='left top'\" />
    </a>
    ";
    echo"</form>";
    
    echo"";

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
    </a>
</p>
<?php include 'top.html' ?>
</body>
</html>


