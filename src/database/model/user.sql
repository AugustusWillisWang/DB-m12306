-- 添加用户

-- CREATE TABLE Passenger(
--     P_pid int,
--     P_phone int,
--     P_pname char(20),
--     P_uname char(30),
--     P_credit_card int,
--     primary key (P_pid)
-- );

INSERT INTO Passenger
VALUES(
    P_pid,
    P_phone,
    P_pname,
    P_uname,
    P_credit_card
);

INSERT INTO Passenger
VALUES(
    42,
    18818881888,
    'Dio',
    '迪奥',
    233323333333333
);

SELECT 
    P_pid,
    P_phone,
    P_pname,
    P_uname,
    P_credit_card
FROM Passenger;

SELECT 
    P_pid,
    P_phone,
    P_pname,
    P_uname,
    P_credit_card
FROM Passenger
WHERE P_pid=%pid;