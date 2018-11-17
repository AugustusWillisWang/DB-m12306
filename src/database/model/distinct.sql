SELECT count(*)
FROM Passenger
WHERE P_phone=$phone;

SELECT count(*)
FROM Passenger
WHERE P_pid=$pid;

-- ex: 

SELECT count(*)
FROM Passenger
WHERE P_phone=18818881888;

SELECT count(*)
FROM Passenger
WHERE P_phone=18818881881;

SELECT count(*)
FROM Passenger
WHERE P_pid=42;

SELECT count(*)
FROM Passenger
WHERE P_pid=41;