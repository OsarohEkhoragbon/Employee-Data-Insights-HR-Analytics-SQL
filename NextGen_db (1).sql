--understanding the questions--
--understanding the tables that you need 
--understanding the columns that you Need
--understanding the syntax like aggregation, order by, filter(where, having clause),limit
--to be used

--employee retention analysis question

--Who are the top 5 highest serving employees?
--employee
--names and date(year or months)
--order by and limit

select first_name, last_name, hire_year, (2025- hire_year) as yearofservice from employee
order by yearofservice desc
limit 5;




---how many employees have been with the company for more than 5 years.just answered this for fun
--employee
--employee_id and hire YEAR
--count, as, greater than

select count(employee_id) as noofemployees from employee
where (2025- hire_year) > 5;





---What is the turnover rate for each department? 
---turnover and department
--departmentname and reason for leaving
--group by and order BY
--join



select d.department_name, count(t.reason_for_leaving) as turnoverrate from turnover t
join department d ON d.department_id = t.department_id
group by d.department_name
order by count(t.reason_for_leaving) desc;





---Which employees are at risk of leaving based on their performance?
--employees and performance
--firstname lastname and performance score
--join where order BY
--im using below 3.5 as the performance cap

select e.first_name, e.last_name, p.performance_score from employee e
join performance p on e.employee_id = p.employee_id
where p. performance_score < 3.5
order by performance_score;


--What are the main reasons employees are leaving the company?
--turnover
--distinct

select distinct reason_for_leaving from turnover;


--performance analysis question

--How many employees has left the company?
--turnover table
--reason for leaving 

select count(reason_for_leaving) as no_of_employee_that_left from turnover;



--How many employees have a performance score of 5.0 / below 3.5?
--performance table-
--no of perf 5.0
--no below 3.5
--where, count

select performance_score, count(performance_score) as noofemployeesscore from performance
where performance_score = 5.0 
group by performance_score
order by performance_score desc;


select count(performance_score) as "no_of_employees_score_below 3.5" from performance
where performance_score < 3.5;





--Which department has the most employees with a performance of 5.0 / below 3.5?
--dept and performance TABLE
--dept name and performance score
--common between them department_id
--join where group order clause
-- check seperate for no of perf score with 5.0 
---no with below 3.5

select department_name, count(performance_score) from department
join performance on department.department_id = performance.department_id
where performance_score = 5.0 
group by department_name
order by count(performance_score) desc;


select department_name, count(performance_score) from department
join performance on department.department_id = performance.department_id
where performance_score < 3.5 
group by department_name
order by count(performance_score) desc;



--What is the average performance score by department?
--performane and department
--dept name and performance score
--join group BY, order by
--avg 

select department_name, round(avg(p.performance_score), 2) as avgperformancescore from department d
join performance p on d.department_id = p.department_id
group by department_name
order by  round(avg(p.performance_score), 2) desc;


--salary analysis question

--What is the total salary expense for the company?
--salary TABLE
--sum on salary_amount
--as


select sum(salary_amount) as totalsalaryexpenses from salary;


--What is the average salary by job title?
--salary and employee
--join
--avg, group by

select job_title, round(avg(s.salary_amount),2) as avgsalary from salary s
join employee e on s.employee_id=e.employee_id
group by job_title;



--How many employees earn above 80,000?
--salary TABLE
--greater than 80000

--ie the total number earning 80001,90,000 and 10,000
select count(employee_id) as noofemployees, salary_amount from salary
where salary_amount > 80000
group by salary_amount;


 --or the total number earning above 80000

select count(employee_id) as noofemployees from salary
where salary_amount > 80000;



--How does performance correlate with salary across departments?
--performance, salary, and department table
--performance score salary amount
--join
--group BY


select d.department_name, round(avg(p.performance_score),2)as avgperformancescore, 
round(avg(s.salary_amount)) as avgsalary from salary s
join performance p on s.employee_id = p.employee_id
join department d on s.depaartment_id = d.department_id
group by d.department_name
order by d.department_name asc;





--other additional question

--Which employees have the lowest attendance rates/absent attendance?
--employee and attendance TABLE
--firstname, lastname, attendance status
--join
--sum
--case

SELECT e.first_name,e.last_name,
ROUND(SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS attendance_rate
FROM attendance a
JOIN employee e ON a.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY attendance_rate ASC
LIMIT 10;


SELECT e.first_name, e.last_name, a.attendance_status,COUNT(a.attendance_status) AS attendance_rate FROM attendance a
JOIN employee e ON a.employee_id = e.employee_id
WHERE a.attendance_status = 'Absent'
GROUP BY e.first_name, e.last_name, a.attendance_status
ORDER BY attendance_rate desc
limit 10;


---Do employees with high attendance get paid better?
--employee and attendance, salary TABLE
--employeeid, lastname, attendance status, salaryamount
--join
--sum
--case

SELECT e.employee_id, e.first_name, e.last_name, 
ROUND(SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_status), 2) AS attendance_rate,
s.salary_amount FROM employee e
JOIN attendance a ON e.employee_id = a.employee_id
join salary s on e.employee_id = s.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, s.salary_amount
ORDER BY attendance_rate DESC;


SELECT e.employee_id, e.first_name, e.last_name, 
(SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END)* 100) / COUNT(a.attendance_status) AS attendance_rate, 
s.salary_amount FROM employee e
JOIN attendance a ON e.employee_id = a.employee_id
join salary s on e.employee_id = s.employee_id
group by e.employee_id, e.first_name, e.last_name, s.salary_amount
ORDER BY attendance_rate DESC;



--Which department has the highest total salary or average salary
--department and salary
--sum and avg
--join

select department_name, sum(salary_amount) as highestsalary from salary s
join department d on s.depaartment_id = d.department_id
group by department_name
order by sum(salary_amount) desc;


select department_name, round(avg(salary_amount),2) as avgsalary from salary s
join department d on s.depaartment_id = d.department_id
group by department_name
order by avg(salary_amount) desc;

--What are the performance scores of employee with the highest salary
--performance and salary
--join
--group BY
--order BY

select performance_score, max(salary_amount) as highestsalary from salary s
join performance p on s.employee_id = p.employee_id
group by performance_score
order by performance_score desc;



--Which 5 employees have the highest salary
--employee and salary
--join
--order by


select e.first_name, e.last_name, s.salary_amount as highestsalary from salary s
join employee e on s.employee_id = e.employee_id
order by s.salary_amount desc
limit 5;


