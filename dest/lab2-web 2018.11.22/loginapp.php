<?php 
session_start(); 
$_SESSION['username']=$_POST["username"];
$_SESSION['whether_online']='1';
?>

<html>
<head>
    <style type="text/css">
        body {background-size: 100%}
    </style>
</head> 
<body background="login_background.jpg">
<?php include 'top.html' ?>
<p style="text-align:center;font-size:25;margin-top:350px">
        
        <?php 
        $username=$_POST["username"];
        settype($username,"string");
        $username_input = trim($username);
        $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
            or die('Could not connect: ' . pg_last_error());
        $query="SELECT count(*)
        FROM Passenger
        WHERE P_uname='$username';
        ";
        $result=pg_query($dbconn,$query)or die('uname_fail: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM)
            or die('fetch_fail: ' . pg_last_error()); 
        if($line[0] == 0)
        {
            echo"未被注册的账户=-=<br>";
            header("Refresh:3;url=login.html");
        }
        else
        {
            if($_POST["username"]=="admin")
                header("Refresh:3;url=admin.html");
            else
                header("Refresh:3;url=111.html");
            echo"欢迎~>.<~<br>";
            echo $_POST["username"];
        }       
        ?>
</p>
<p style="text-align:center;font-size:15；">
3秒后自动跳转
</p>

</body>
</html>