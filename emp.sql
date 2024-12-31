## create a database
create database EmployeeTable;
use EmployeeTable;
## creating tables
create table employee_table
(
emp_id int PRIMARY KEY,
emp_name varchar(255),
department varchar(100),
position varchar(100),
hire_date date,
base_salary decimal(10,2)
);
create table attendence
(
attendence_id int PRIMARY KEY,
emp_id int,
attendence_date date,
att_status enum('Present','absent','leave'),
FOREIGN KEY (emp_id) REFERENCES employee_table(emp_id) on DELETE CASCADE
);
create table salary
(
salary_id int PRIMARY KEY,
emp_id int,
base_salary decimal(10,2),
bonus decimal(10,2),
deductions decimal(10,2),
month varchar(255),
year int,
FOREIGN KEY (emp_id) REFERENCES employee_table(emp_id) on DELETE CASCADE
);
create table payroll
(
payroll_id int PRIMARY KEY,
emp_id int,
total_salary decimal(10,2),
payment_date date,
FOREIGN KEY (emp_id) REFERENCES employee_table(emp_id) on DELETE CASCADE
);

## 1.Add New Employees
insert into employee_table values
(1, 'John Doe', 'Finance', 'Accountant', '2022-01-15', 55000.00),
(2, 'Jane Smith', 'Human Resources', 'HR Manager', '2021-07-01', 75000.00),
(3, 'Mark Taylor', 'IT', 'Software Engineer', '2023-03-10', 85000.00),
(4, 'Emily Brown', 'Marketing', 'Marketing Specialist', '2020-11-20', 60000.00),
(5, 'Michael Lee', 'Operations', 'Operations Manager', '2019-05-05', 70000.00);
select * from employee_table;

## 2.Update Employee Information
update employee_table
SET position = 'Lead Developer',
    base_salary = 85000.00,
    department = 'IT'
WHERE emp_id =1;
select * from employee_table;

## 3.Delete Employee Records
delete from employee_table 
where emp_id =2;
select * from employee_table;

## 4.Record daily attendance for employees, marking them as present, absent, or on leave.
## inserting the values to the table
insert into attendence values 
(101, 1, '2022-01-15', 'Present'),
(103, 3, '2023-03-10', 'Leave'),
(104, 4, '2020-11-20', 'Present'),
(105, 5, '2019-05-05', 'Absent');
select * from attendence;

insert into salary values 
(1001, 1, 55000.00, 5000.00, 2000.00, 'January', 2024),
(1002, 3, 85000.00, 10000.00, 4000.00, 'March', 2023),
(1003, 4, 60000.00, 3000.00, 1000.00, 'November', 2020),
(1004, 5, 70000.00, 4000.00, 1500.00, 'May', 2019);
select * from salary;

insert into payroll values
(1, 1, 55000.00, '2022-01-15'),
(3, 3, 8500.00, '2023-03-10'),
(4, 4, 60000.00, '2020-11-20'),
(5, 5, 70000.00, '2019-05-05');
select * from payroll;

##  5.Automatically calculate employee salaries based on base salary, attendance, bonuses, and deductions.
SELECT 
    employee_table.emp_id, 
    employee_table.emp_name, 
    salary.base_salary, 
    salary.bonus, 
    salary.deductions, 
    COUNT(CASE WHEN attendence.att_status = 'Present' THEN 1 ELSE NULL END) AS working_days, 
    (salary.base_salary + salary.bonus - salary.deductions) AS total_salary
FROM 
    employee_table
JOIN 
    salary ON employee_table.emp_id = salary.emp_id
LEFT JOIN 
    attendence ON employee_table.emp_id = attendence.emp_id
GROUP BY 
    employee_table.emp_id, 
    employee_table.emp_name, 
    salary.base_salary, 
    salary.bonus, 
    salary.deductions
LIMIT 0, 1000;

## 6.Allow users to add or update bonuses and deductions for each employee
UPDATE salary
SET bonus = 8000
WHERE emp_id = 3;
select * from salary;

## 7.Calculate and store payroll data for each employee, including total salary and payment date.
select emp_id,total_salary,payment_date from payroll order by emp_id;
## 8.Provide functionality to generate detailed pay slips for employees, showing salary breakdowns.
SELECT 
    employee_table.emp_id,
    employee_table.emp_name,
    salary.base_salary,
    salary.bonus,
    salary.deductions,
    (salary.base_salary + salary.bonus -salary.deductions) AS Total_Salary,
    payroll.payment_date
FROM 
    employee_table 
JOIN 
    salary  ON employee_table.emp_id = salary.emp_id
JOIN 
    payroll ON employee_table.emp_id = payroll.emp_id
WHERE 
    employee_table.emp_id; -- Replace 'EMPLOYEE_ID' with the specific employee ID or remove this line for all employees.

## 9.Create payroll summaries and reports, such as overall salary expenses, employee attendance, or monthly payroll distributions.
select emp_id,total_salary from payroll;
SELECT 
    e.emp_id, 
    e.emp_name, 
    COUNT(CASE WHEN a.att_status = 'Present' THEN 1 ELSE NULL END) AS total_present_days,
    COUNT(CASE WHEN a.att_status = 'Absent' THEN 1 ELSE NULL END) AS total_absent_days
FROM 
    employee_table e
LEFT JOIN 
    attendence a ON e.emp_id = a.emp_id
GROUP BY 
    e.emp_id, e.emp_name;

