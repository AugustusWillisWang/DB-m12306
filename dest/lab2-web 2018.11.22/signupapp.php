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
        $dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
            or die('Could not connect: ' . pg_last_error());
        $username = $_POST["username"];
        $name = $_POST["name"];
        $idcard = $_POST["idcard"];
        $phonenumber = $_POST["phonenumber"];
        $visa = $_POST["visa"];
        $code = $_POST["code"];
        $i=0;
        $whether_wrong =0;
        while($idcard[$i])
            $i++;

        $query="SELECT count(*)
            FROM Passenger
            WHERE P_pid=$idcard;        
            ";
        $result=pg_query($dbconn,$query)or die('pid_fail: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM)
            or die('fetch_fail: ' . pg_last_error()); 
        if($i != 18)
        {
            echo"身份证信息错误";
            header("Refresh:3;url=signup.html");
            $whether_wrong =1;
        }
        else if($line[0]!=0)
        {
            echo"身份证已被注册";
            header("Refresh:3;url=signup.html");
            $whether_wrong =1;
        }

        $i=0;
        while($phonenumber[$i])
            $i++;
        $query="SELECT count(*)
            FROM Passenger
            WHERE P_phone=$phonenumber;
            ";
        $result=pg_query($dbconn,$query)or die('pid_fail: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM)
            or die('fetch_fail: ' . pg_last_error()); 
        if($i != 11)
        {
            echo"手机信息错误";
            header("Refresh:3;url=signup.html");
            $whether_wrong =1;
        }
        else if($line[0]!=0)
        {
            echo"手机号已被注册";
            header("Refresh:3;url=signup.html");
            $whether_wrong =1;
        }

        $i=0;
        while($visa[$i])
            $i++;
        if($i != 16)
        {
            echo"信用卡信息错误";
            header("Refresh:3;url=signup.html");
            $whether_wrong =1;
        }
        if($whether_wrong == 0){
            echo"注册成功！";
        
            $username_input = trim($username);
            $name_input =trim($name) ;
            $idcard_input = trim ($idcard);
            $phonenumber_input = trim($phonenumber);
            $visa_input = trim($visa);
            $code_input = trim($code);

            $query="INSERT INTO Passenger
            VALUES(
                $idcard_input,
                $phonenumber_input,
                '$name_input',
                '$username_input',
                $visa_input
            );";
            $result=pg_query($dbconn,$query)or die('insert_fail: ' . pg_last_error());
            header("Refresh:3;url=login.html");
        }
        ?>
    </p>
<p style="text-align:center;font-size:15；">
3秒后自动跳转页面
</p>
</body>
</html>