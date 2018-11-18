<?php
echo"<form action=\"test2.php\" method=\"post\">";
                echo"<select name=\"1\">";
                $number=0;
                $station=4;
                while ($number<6) {
                    $number++;
                if($number == $station)
                  echo"<option value=".$number." selected=\"selected\">".$number."</option>";
                else
                    echo"<option value=".$number.">".$number."</option>";
                }
                    echo"	</select>";
                    echo"	<input type=\"submit\" value=\"购买\" />";
                echo"</form>";