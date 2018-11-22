<?php 
session_start(); 
$train=$_SESSION['train'];
$type=$_SESSION['type'];
$inputdate=$_SESSION['inputdate'];
$inputtype=$_SESSION['inputtype'];
$username=$_SESSION['username'];

    $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
    $query = "select DISTINCT TT_tid,ISC_sname,TT_arrive_time,TT_depart_time,TT_time,ES_date, $inputtype
    from Train_Table,Empty_Seat,ID_Station_City where TT_sid=ES_current_sid AND TT_tid=ES_tid AND tt_sid=ISC_sid and TT_tid='$train' and ES_date='$inputdate' ORDER by TT_depart_time;
    ";
    $number = 0;
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $number++;
    //for($num)
    $start = $line[1];

    $destination = $_POST['destination_buy'];
    echo $destination."<br>";
    while($number<$destination)
    {
        $number++;
        $line = pg_fetch_array($result, null, PGSQL_NUM);
    }
    $end = $line[1];
    $price = $line[6];
    $time =$line[3];
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
    
    /*echo $start_id.$end_id."<br>";
    $query = "
    SELECT COUNT(*)+1
    FROM ORDERS; ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $o_id = $line[0];*/

    //生成订单号
    $query = "
    SELECT COUNT(*)+1
    FROM ORDERS; ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $o_id = $line[0];
    echo $o_id;
    echo $username.$o_id.$train.$start.$end.$type.$price.$inputdate.$time;

    //查询用户身份证
    $query = "
    SELECT P_pid
            FROM Passenger
            WHERE P_uname='$username';
            ";
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $userid = $line[0];
    echo $userid;       

    //当前日期
    $current_date=date('y-m-d',time());
    echo $current_date;

    if($type =="hardseat")
    {
            $inputtype = "ES_left_yz";
            $inputtype2 = "ES_left_yz-1";
    }
    else if($type =="softseat")
    {
        $inputtype = "ES_left_rz";
        $inputtype2 = "ES_left_rz-1";
    }
    else if($type =="hardbed_top")
    {
        $inputtype = "ES_left_yws";
        $inputtype2 = "ES_left_yws-1";
    }
    else if($type =="hardbed_middle")
    {
        $inputtype = "ES_left_ywz";
        $inputtype2 = "ES_left_ywz-1";
    }
    else if($type =="hardbed_bottom")
    {
        $inputtype = "ES_left_ywx";
        $inputtype2 = "ES_left_ywx-1";
    }
    else if($type =="softbed_top")
    {
        $inputtype = "ES_left_rws";
        $inputtype2 = "ES_left_rws-1";
    }
    else
    {
        $inputtype = "ES_left_rwx";
        $inputtype2 = "ES_left_rwx-1";
    }

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
SET $inputtype=$inputtype2
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
header("Refresh:0;url=111.html");
?>

<html>
<head>
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
<body background="">
<?php include 'top.html' ?>
<p style="text-align:center;font-size:25;margin-top:350px">
    3秒后自动跳转
</p>

</body>
</html>