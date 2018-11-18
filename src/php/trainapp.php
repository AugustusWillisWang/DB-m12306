<?php 
session_start(); 
    $train = trim($_POST["train"]);
    $type = trim($_POST["type"]);
    if($type =="hardseat")
        $inputtype = "TT_price_yz,ES_left_yz";
    else if($type =="softseat")
        $inputtype = "TT_price_rz,ES_left_rz";
    else if($type =="hardbed_top")
        $inputtype = "TT_price_yws,ES_left_yws";
    else if($type =="hardbed_middle")
        $inputtype = "TT_price_ywz,ES_left_ywz";
    else if($type =="hardbed_bottom")
        $inputtype = "TT_price_ywx,ES_left_ywx";
    else if($type =="softbed_top")
        $inputtype = "TT_price_rws,ES_left_rws";
    else
        $inputtype = "TT_price_rwx,ES_left_rwx";
    if($_POST["date"])
        $date  = strtotime($_POST["date"]);
    else
        $date  = strtotime("tomorrow");
    $inputdate = date("Y-m-d", $date);
    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
    $query = "select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,ES_date, $inputtype
     from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND TT_tid=ES_tid AND tt_sid=ISC_sid and TT_tid='$train' and ES_date='$inputdate' ORDER by TT_depart_time;
    ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
$_SESSION['train']=$train;
$_SESSION['type']=$type;
$_SESSION['inputdate']=$inputdate;
$_SESSION['inputtype']=$inputtype;
$_SESSION['whether_advanced']="0";
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
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>车站</th>";
    echo "\t\t<th>到站时间</th>";
    echo "\t\t<th>出站时间</th>";
    echo "\t\t<th>运行时长</th>";
    echo "\t\t<th>日期</th>";
    echo "\t\t<th>票价</th>";
    echo "\t\t<th>余票</th>";
    echo "\t</tr>\n";
    $number =0;
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number ++;
        echo "\t<tr>\n";
        for($i=0;$i<6;$i++)
        {
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
<p style="text-align:center;font-size:15">
    <a href="train.html">返回<a>
</p>
</body>
</html>
