<?php
session_start(); 
$date2 = $_SESSION['$order_date2'];
$date1 = $_SESSION['$order_date1'];
$username = $_SESSION['username'];
$order_number = $_GET['order_number'];
$inputdate1 = date("Y-m-d", $date1);
$inputdate2 = date("Y-m-d", $date2);
$dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
/*echo $inputdate2;
echo "<br>";
echo $inputdate1;
echo "<br>";
echo $userid;
echo "<br>";*/
//echo $order_number;

//查询用户身份证
$query = "
SELECT P_pid
        FROM Passenger
        WHERE P_uname='$username';
        ";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$line = pg_fetch_array($result, null, PGSQL_NUM);
$userid = $line[0];

$query = "SELECT
        O_oid, O_order_date, O_tid1,
        scid.ISC_sname as depart_station, 
        scia.ISC_sname as arrive_station, 
        O_price,
        O_valid,
        O_type1
    FROM ID_Station_City as scid, ID_Station_City as scia, Orders  
    WHERE O_start_sid=scid.ISC_sid 
        and O_arrive_sid=scia.ISC_sid
        and O_order_date<=to_date('$inputdate2','YY-MM-DD')
        and O_order_date>=to_date('$inputdate1','YY-MM-DD')
        and O_pid=$userid;
        ";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
$number =0;
while($number < $order_number) 
{
    $line = pg_fetch_array($result, null, PGSQL_NUM);
    $number ++;
}

$o_id = $line[0];
$tid = $line[2];
$type = $line[7];
$date = $line[1];
echo $o_id;
echo $tid;

    if($type =="hardseat")
        {
            $o_inputtype = "ES_left_yz";
            $o_inputtype2 = "ES_left_yz+1";
        }
        else if($type =="softseat")
        {
            $o_inputtype = "ES_left_rz";
            $o_inputtype2 = "ES_left_rz+1";
        }
        else if($type =="hardbed_top")
        {
            $o_inputtype = "ES_left_yws";
            $o_inputtype2 = "ES_left_yws+1";
        }
        else if($type =="hardbed_middle")
        {
            $o_inputtype = "ES_left_ywz";
            $o_inputtype2 = "ES_left_ywz+1";
        }
        else if($type =="hardbed_bottom")
        {
           $o_inputtype = "ES_left_ywx";
            $o_inputtype2 = "ES_left_ywx+1";
        }
        else if($type =="softbed_top")
        {
            $o_inputtype = "ES_left_rws";
            $o_inputtype2 = "ES_left_rws+1";
        }
        else
        {
            $o_inputtype = "ES_left_rwx";
            $o_inputtype2 = "ES_left_rwx+1";
        }
echo $o_inputtype;
echo $o_inputtype2;
    
$query = "
UPDATE Orders
SET O_valid=0
WHERE O_oid=$o_id;";
$result = pg_query($query) or die('Q1 failed: ' . pg_last_error());

$query = "UPDATE Empty_Seat
SET $o_inputtype=$o_inputtype2
FROM Train_Table as TT1, Train_Table as TT2, Train_Table as TT3, Orders
WHERE 
    ES_tid=O_tid1 and
    ES_tid=TT1.TT_tid and
    ES_tid=TT2.TT_tid and
    ES_tid=TT3.TT_tid and
    TT1.TT_sid=O_start_sid1 and
    TT2.TT_sid=O_arrive_sid1 and
    TT3.TT_sid=ES_current_sid and
    ES_date=O_date1 and
    (TT3.TT_count>=TT1.TT_count) and
    (TT3.TT_count<TT2.TT_count)and
    O_oid=$o_id;";

$result = pg_query($query) or die('Q2 failed: ' . pg_last_error());
?>    

