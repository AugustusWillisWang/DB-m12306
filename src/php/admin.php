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
    echo"<a href=\"adminapp.php?instruction=\"1\"\">总订单数</a><br>";
    echo"<a href=\"adminapp.php?instruction=\"2\"\">总票价</a><br>";
    echo"<a href=\"adminapp.php?instruction=\"3\"\">热点车次</a><br>";
    echo"<a href=\"adminapp.php?instruction=\"4\"\">用户列表</a><br>";
    //echo"<a href=\"adminapp.php?instruction=\"5\"\">查询用户订单</a><br>";
    ?>
    </p><br>
</body>
</html>