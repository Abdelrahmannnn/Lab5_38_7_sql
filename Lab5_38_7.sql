

Create Schema COMPANY ;
use COMPANY ;



-- I created the database schema 

CREATE TABLE DEPT ( 
Dnumber int NOT NULL,  
Dname VARCHAR(30) NOT NULL,
Founded DATE ,
Mgr_ssn int not null,
Budget int  , 
PRIMARY KEY (Dnumber)  
);



CREATE TABLE EMPLOYEE ( 
Ssn int NOT NULL ,
Ename VARCHAR(30) NOT NULL,
Bdate DATE ,
Dno int  ,  
Salary int ,  
PRIMARY KEY (Ssn)
);


ALTER TABLE DEPT
ADD FOREIGN KEY(Mgr_ssn)
REFERENCES EMPLOYEE(Ssn) 
ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE EMPLOYEE
ADD FOREIGN KEY(Dno)
REFERENCES DEPT(Dnumber)
ON UPDATE CASCADE ON DELETE CASCADE;


-- I insert some values in tables 
INSERT INTO  EMPLOYEE VALUES ('120','Abdelrahman','2009-05-07',null,'3500') ;
INSERT INTO  EMPLOYEE VALUES ('105','Ahmed','2011-06-04',null,'4000') ;
INSERT INTO  EMPLOYEE VALUES ('150','Aly','2018-08-03',null,'3600') ;



INSERT INTO  DEPT VALUES ('1','Science','1950-05-08','105','50000') ;
INSERT INTO  DEPT VALUES ('2','Sports','1980-04-09','120','70000') ;


Update EMPLOYEE 
SET Dno='1'
WHERE Ssn='120' ;

Update EMPLOYEE 
SET Dno='1'
WHERE Ssn='105' ;

Update EMPLOYEE 
SET Dno='2'
WHERE Ssn='150' ;


--
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPT;



-- I created the function 

DROP function IF EXISTS `Count_Emp`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `Count_Emp`(NUMBER INT) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE Emp_Count INT;
select count(*) into  Emp_Count
FROM EMPLOYEE 
WHERE EMPLOYEE.Dno = NUMBER ;
RETURN Emp_Count;
END$$

DELIMITER ;


-- I created the procedure 

DROP procedure IF EXISTS `Check_Year`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Check_Year`()
BEGIN
UPDATE DEPT 
SET Founded = '1960-01-01'
WHERE YEAR(Founded) < 1960; 
END$$

DELIMITER ;



-- I created the trigger 

DROP TRIGGER IF EXISTS `company`.`employee_BEFORE_INSERT`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `employee_BEFORE_INSERT` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
	DECLARE Dnum INT;
    DECLARE Employees_Count INT;
    SET Dnum = NEW.Dno;
    SELECT COUNT(*) INTO Employees_Count 
    FROM EMPLOYEE
    WHERE Dno= Dnum;
    IF Employees_Count >= 8
    THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Sorry! Cannot insert as each department must not has more than 8 employees';
	END IF;
END$$



-- test the function 
SELECT Dnumber, Count_Emp(Dnumber) as Count_from_function
FROM DEPT 
GROUP BY Dnumber; 




-- test the trigger
INSERT INTO  EMPLOYEE VALUES ('130','Adel','2009-07-08','1','3800') ;
INSERT INTO  EMPLOYEE VALUES ('170','Ahmed','2013-07-04','1','3500') ;
INSERT INTO  EMPLOYEE VALUES ('190','Mohamed','2020-08-01','1','3600') ;
INSERT INTO  EMPLOYEE VALUES ('122','Abdallah','2009-05-02','1','3800') ;
INSERT INTO  EMPLOYEE VALUES ('179','Mostafa','2011-06-09','1','3100') ;
INSERT INTO  EMPLOYEE VALUES ('144','Mohamed','2018-01-03','1','3200') ;





select * from EMPLOYEE ;

-- so now department 1 has 8 employees so i will try to insert another employee in dep 1 but i  will get error
INSERT INTO  EMPLOYEE VALUES ('158','Mohamed','2018-01-03','1','3500') ;




-- test the procedure 
SET SQL_SAFE_UPDATES=0;
CALL Check_Year();
SELECT * FROM DEPT;












