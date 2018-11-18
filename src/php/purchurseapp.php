<?php 
session_start(); 
$train=$_SESSION['train'];
$type=$_SESSION['type'];
$inputdate=$_SESSION['inputdate'];
$inputtype=$_SESSION['inputtype'];

    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
    $query = "select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,ES_date, $inputtype
    from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND TT_tid=ES_tid AND tt_sid=ISC_sid and TT_tid='$train' and ES_date='$inputdate' ORDER by TT_depart_time;
    ";
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
<p style="text-align:center;font-size:40;margin-top:40px">
购买车票
</p>
<p style="text-align:auto;font-size:25;margin-top:40px">
车次信息
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
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        echo "\t<tr>\n";
        for($i=0;$i<6;$i++)
        {
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

    echo"<form action=\"afterpurchurse.php\" method=\"post\">";
    echo"<select name=\"destination_buy\">";
    $number=0;
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number++;
        if($number == $station)
            echo"<option value=".$number." selected=\"selected\">".$line[1]."</option>";
        else
            echo"<option value=".$number.">".$line[1]."</option>";
    }
	echo"</select>";
	echo"<input type=\"submit\" value=\"购买\" />";
    echo"</form>";
    
    echo"<a href=\"111.html\">取消<a>";

    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);
?>
</p>
<p style="text-align:center;font-size:15">
    <a href="train.html">返回<a>
</p>
</body>
</html>


