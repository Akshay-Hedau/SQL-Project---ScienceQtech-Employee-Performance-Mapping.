-- ScienceQtech Employee Performance Mapping --
-- 1. Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv
--    into the employee database from the given resources.
create database Employee;
use Employee;
select * from employee.data_science_team;
select * from employee.proj_table;
select * from employee.emp_record_table;

-- 2. Create an ER diagram for the given employee database.

-- 3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
--    and make a list of employees and details of their department.
select Emp_ID,First_Name,Last_Name,Gender,Dept
from employee.emp_record_table;

-- 4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
--    * less than two
select Emp_ID,First_Name,Last_Name,Gender,Dept,Emp_Rating
from employee.emp_record_table
where Emp_Rating<2;
--    * greater than four 
select Emp_ID,First_Name,Last_Name,Gender,Dept,Emp_Rating
from employee.emp_record_table
where Emp_Rating>4;
--    * between two and four
select Emp_ID,First_Name,Last_Name,Gender,Dept,Emp_Rating
from employee.emp_record_table
where Emp_Rating>2 and EMP_RATING<4;

-- 5. Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department
--    from the employee table and then give the resultant column alias as NAME.
select First_Name,Last_Name,concat(First_Name,' ',Last_Name) as Name
from employee.emp_record_table;

-- 6. Write a query to list only those employees who have someone reporting to them. Also, show the number of
--    reporters (including the President).
select Manager_ID,COUNT(Emp_ID) as Number_Of_Reporters
from employee.emp_record_table
group by Manager_ID
order by Number_Of_Reporters DESC;

-- 7. Write a query to list down all the employees from the healthcare and finance departments using union. 
--    Take data from the employee record table.
select * 
from employee.emp_record_table
where Dept="HEALTHCARE"
union
select *
from employee.emp_record_table
where Dept="FINANCE";
 
 -- 8. Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
 --    and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating
 --    for the department.
 select Emp_ID,First_Name,Last_Name,Role,Dept,Emp_Rating,
 max(Emp_Rating) over (partition by Dept) Max_Employee_Rating_In_Dept
 from employee.emp_record_table;
 
 -- 9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from
 --    the employee record table.
 select Emp_ID,First_Name,Last_Name,Dept,Role,Salary,Emp_Rating,
 min(Salary) over (partition by Role) Min_Salary_In_Role,
 max(Salary) over (partition by Role) Max_Salary_In_Role
 from employee.emp_record_table
 order by salary desc;
 
 -- 10. Write a query to assign ranks to each employee based on their experience. Take data from the employee 
 --     record table.
 select Emp_ID,First_Name,Last_Name,Dept,Role,Salary,Exp,
 rank() over (order by Exp desc) Rank_By_Experience
 from employee.emp_record_table;
 
 -- 11. Write a query to create a view that displays employees in various countries whose salary is more than
 --     six thousand. Take data from the employee record table.
 create view Employee_View as
 select Emp_ID,First_Name,Last_Name,Dept,Role,Salary,Country
 from employee.emp_record_table
 where Salary>6000
 order by Salary Desc;
 select * from employee.employee_view;
 
 -- 12. Write a nested query to find employees with experience of more than ten years. Take data from the employee
 --     record table.
 select Emp_ID,First_Name,Last_Name,Dept,Role,Exp
 from employee.emp_record_table
 where Exp in ( select Exp 
                from employee.emp_record_table
                where Exp > 10 )
order by Exp Desc;

-- 13. Write a query to create a stored procedure to retrieve the details of the employees whose experience is
--     more than three years. Take data from the employee record table.
Delimiter &&
create procedure Exp_More_Than_3Years()
Begin
   Select * 
   From employee.emp_record_table
   Where Exp > 3
   order by Exp Desc;
End &&
Call Exp_More_Than_3Years();

-- 14. Write a query using stored functions in the project table to check whether the job profile assigned
--     to each employee in the data science team matches the organization’s set standard.
/* The standard being:
   For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
   For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
   For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
   For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
   For an employee with the experience of 12 to 16 years assign 'MANAGER'. */
select * from employee.data_science_team;
select * from employee.proj_table;
DELIMITER &&
CREATE FUNCTION EMPLOYEE_ROLE_MATCH(EXP INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
   DECLARE STANDARD_ROLE VARCHAR(50);
   IF EXP < 2 THEN SET STANDARD_ROLE ='JUNIOR DATA SCIENTIST';
   ELSEIF ( EXP >=2 and EXP <5) THEN SET STANDARD_ROLE ='ASSOCIATE DATA SCIENTIST';
   ELSEIF ( EXP >=5 and EXP <10) THEN SET STANDARD_ROLE ='SENIOR DATA SCIENTIST';
   ELSEIF ( EXP >=10 and EXP <12) THEN SET STANDARD_ROLE ='LEAD DATA SCIENTIST';
   ELSEIF ( EXP >=12 and EXP <16) THEN SET STANDARD_ROLE ='MANAGER';
   else Set Standard_Role = "Invalid Experience";
   END IF;
   RETURN (STANDARD_ROLE);
END &&
select e.Emp_ID,e.First_Name,e.Last_Name,d.Role,e.EXP,EMPLOYEE_ROLE_MATCH(e.EXP)
from employee.emp_record_table e
JOIN employee.data_science_team d
ON e.EMP_ID=d.EMP_ID;

-- 15. Create an index to improve the cost and performance of the query to find the employee whose 
--     FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
select * from employee.emp_record_table;
select Emp_ID,First_Name,Last_Name,Role,Dept
from employee.emp_record_table
where First_Name="Eric";
Explain 
select Emp_ID,First_Name,Last_Name,Role,Dept
from employee.emp_record_table
where First_Name="Eric";

Create Index indx on employee.emp_record_table(Emp_ID);
Explain 
select Emp_ID,First_Name,Last_Name,Role,Dept
from employee.emp_record_table
where First_Name="Eric";

-- 16. Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
--     (Use the formula: 5% of salary * employee rating).
select Emp_ID,First_Name,Last_Name,Role,Dept,Salary,Emp_Rating,
0.05*Salary*Emp_Rating as Bonus_Salary
from employee.emp_record_table
order by salary desc;

-- 17. Write a query to calculate the average salary distribution based on the continent and country. Take data 
--     from the employee record table.
select Emp_ID,First_Name,Last_Name,
Country,Avg(Salary) over (partition by Country) Avg_Salary_Country_Wise,
Continent,Avg(salary) over (partition by Continent) Avg_Salary_Cintinent_Wise
from employee.emp_record_table;