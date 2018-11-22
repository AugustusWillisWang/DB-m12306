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
<body background="control_background.jpg"></body>
<?php include 'top.html' ?>
    <p style="text-align:center;font-size:40;margin-top:60px">
        <strong>后台</strong>
    </p><br>
    <p style="text-align:center;font-size:20;">
    <?php
    $instruction = $_GET['instruction'];
    if($instruction == "1")
    {
        $query1 = "select count(*) from Orders;";
        $result1 = pg_query($query1) or die('Query failed: ' . pg_last_error());
        $line1 = pg_fetch_array($result1, null, PGSQL_NUM)
            or die('fetch_fail: ' . pg_last_error());
        echo "\t\t总订单数\n";
        echo "\t\t".$line1[0]."\n";
    }
    else if($instruction == "2")
    {
        $query2 = "select sum(O_price) from Orders;";
        //$query2 = "select count(*) from Orders;";
        $result2 = pg_query($dbconn,$query2) or die('Query failed: ' . pg_last_error());
        $line2 = pg_fetch_array($result2, null, PGSQL_NUM)
            or die('fetch_fail: ' . pg_last_error());
        echo "\t\t总票价\n";
        echo "\t\t".$line2[0]."\n";
    }
    else if($instruction == "3")
    {
        $query = "select O_tid1, count(O_tid1)+count(O_tid2) as sum_cnt
        from Orders 
        group by O_tid1
        order by sum_cnt desc;
        ";
        echo "\t\t热点车次\n";
        $result = pg_query($dbconn,$query) or die('Query failed: ' . pg_last_error());
        echo "<table>\n";
        echo "\t<tr>\n";
        echo "\t\t<th>车次</th>";
        echo "\t\t<th>订票数</th>";
        echo "\t</tr>\n";
        $number =0;
        for($number =0;$number <=9;$number ++)
        {
            $line = pg_fetch_array($result, null, PGSQL_NUM);
            if(!$line)
                break;
            echo "\t<tr>\n";
            for($i=0;$i<2;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            } 
            echo "\t</tr>\n";
        }
        echo "</table>";
    }
    else if($instruction == "4")
    {
        echo "\t\t用户列表\n";
        $query = "SELECT 
        P_pid,
        P_phone,
        P_pname,
        P_uname,
        P_credit_card
        FROM Passenger;
        ";
        $result4 = pg_query($dbconn,$query) or die('Query failed: ' . pg_last_error());
        echo "<table>\n";
        echo "\t<tr>\n";
        echo "\t\t<th>序号</th>";
        echo "\t\t<th>手机</th>";
        echo "\t\t<th>姓名</th>";
        echo "\t\t<th>用户名</th>";
        echo "\t\t<th>信用卡</th>";
        echo "\t</tr>\n";
        while($line = pg_fetch_array($result4, null, PGSQL_NUM)) 
        {
            $i=0;
            echo "\t<tr>\n";
            for($i=0;$i<5;$i++)
            {
                if($i == 3)
                    echo "\t\t<td><a href=\"user_order.php?targetuser=$line[$i]\">".$line[$i]."</td>\n";
                else
                    echo "\t\t<td>".$line[$i]."</td>\n";
            } 
            echo "\t</tr>\n";
        }
        echo "</table>";
    }

    // Free resultset
    pg_free_result($result);
        
    // Closing connection
    pg_close($dbconn);
    ?>
    <br>
    <a href="admin.html">
        <input type="button" class="btn" value="返回" onmouseover="this.style.backgroundPosition='left -36px'"
                onmouseout="this.style.backgroundPosition='left top'" />
    </a>
    </p><br>
</body>
</html>