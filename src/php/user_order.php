<?php
$dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
    or die('Could not connect: ' . pg_last_error());
?>

<html>
<head>
    <style type="text/css">
        body {background-size: 100%}
        form { margin:0px auto;
                margin-top:80px;}
    </style>
</head> 
<body background="control_background.jpg"></body>
    <p style="text-align:center;font-size:40;margin-top:40px">
        <strong>后台</strong>
    </p><br>
    <p style="text-align:center;font-size:20;">
    <?php
        $targetuser = $_GET['targetuser'];

        //查询用户身份证
        $query = "
        SELECT P_pid
                FROM Passenger
                WHERE P_uname='$targetuser';
                ";
        $result = pg_query($query) or die('Query failed: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $userid = $line[0];

        $query = "SELECT
        O_oid, O_order_date, 
        scid.ISC_sname as depart_station, 
        scia.ISC_sname as arrive_station, 
        O_price,
        O_valid
    FROM ID_Station_City as scid, ID_Station_City as scia, Orders  
    WHERE O_start_sid=scid.ISC_sid 
        and O_arrive_sid=scia.ISC_sid
        and O_pid=$userid;
    ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $number =0;
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>订单号</th>";
    echo "\t\t<th>日期</th>";
    echo "\t\t<th>出发站</th>";
    echo "\t\t<th>目的站</th>";
    echo "\t\t<th>价格</th>";
    echo "\t</tr>\n";
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number ++;
        echo "\t<tr>\n";
        if($line[5] == "1")
        {
            for($i=0;$i<5;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            }
            echo "\t\t<td></td>\n";
        }
        else
        {
            for($i=0;$i<5;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            }
            echo "\t\t<td>已取消</td>\n";
        }
        echo "\t</tr>\n";
    }
    echo "</table>\n";

    // Free resultset
    pg_free_result($result);
        
    // Closing connection
    pg_close($dbconn);
    ?>
    <br>
    <a href="login.html">返回</a>
    </p><br>
</body>
</html>