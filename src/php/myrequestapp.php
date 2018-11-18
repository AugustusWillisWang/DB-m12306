<?php 
session_start(); 
$username=$_SESSION['username'];
$whether_online=$_SESSION['whether_online'];
$dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
?>

<html>
<head>
    <style type="text/css">
        body {background-size: 100%}
    </style>
</head> 
<body>
<?php
    if($date1)
        $date1  = strtotime($_POST["date1"]);
    else
        $date1  = strtotime('today');
    $inputdate1 = date("Y-m-d", $date1);
    if($date2)
        $date2  = strtotime($_POST["date2"]);
    else
        $date2  = strtotime('tomorrow');
    $inputdate2 = date("Y-m-d", $date2);
    if($whether_online != "1")
        echo "请先登录";
    else
    {
        //查询用户身份证
        $query = "
        SELECT P_pid
                FROM Passenger
                WHERE P_uname='$username';
                ";
        $result = pg_query($query) or die('Query failed: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $userid = $line[0];
        //echo $inputdate1.$inputdate2;

        $query = "SELECT
        O_oid, O_order_date, 
        scid.ISC_sname as depart_station, 
        scia.ISC_sname as arrive_station, 
        O_price,
        O_valid
    FROM ID_Station_City as scid, ID_Station_City as scia, Orders  
    WHERE O_start_sid=scid.ISC_sid 
        and O_arrive_sid=scia.ISC_sid
        and O_order_date<=to_date('$inputdate2','YY-MM-DD')
        and O_order_date>=to_date('$inputdate1','YY-MM-DD')
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

        echo "用户名：";
        echo $username;
    }  
?>
<p style="text-align:center;font-size:15">
    <a href="myrequest.html">返回<a>
</p>
</body>
</html>


