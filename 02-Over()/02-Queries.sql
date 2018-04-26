'
Typically, OVER() is used to compare the current row with an aggregate. For example, we can compute the difference between an employee salary and the average salary
'

-- For each employee, find their first name, last name, salary and the sum of all salaries in the company.
select first_name, last_name, salary,
	sum(salary) over()
from employee;
>>>
first_name | last_name | salary |  sum  |
------------+-----------+--------+-------+
 Diane      | Turner    |   5330 | 94219 |
 Clarence   | Robinson  |   3617 | 94219 |
 Eugene     | Phillips  |   4877 | 94219 |

 
-- For each employee in table employee, select first and last name, years_worked, average of years spent in the company by all employees, and the difference between the years_worked and the average as difference 
SELECT first_name, last_name, years_worked,
  AVG(years_worked) OVER(),
  years_worked-AVG(years_worked) OVER() as difference
FROM employee;
>>>
first_name | last_name | years_worked |        avg         |     difference      |
------------+-----------+--------------+--------------------+---------------------+
 Diane      | Turner    |            4 | 3.3000000000000000 |  0.7000000000000000 |
 Clarence   | Robinson  |            2 | 3.3000000000000000 | -1.3000000000000000 |
 Eugene     | Phillips  |            2 | 3.3000000000000000 | -1.3000000000000000 |

 
 -- (CALCULATING PERCENTAGES) For all employees from department with department_id = 3, show their first_name, last_name, salary, the % of their salary to the SUM of all salaries in that department as percentage
SELECT first_name, last_name, salary,  
  (salary / SUM(salary) OVER())*100 as percentage
FROM employee
where department_id=3;
>>>
first_name | last_name | salary |       percentage        |
------------+-----------+--------+-------------------------+
 Larry      | Lee       |   2796 |  9.65569637738716027200 |
 Willie     | Patterson |   4771 | 16.47615429775183893400 |
 Janet      | Ramirez   |   3782 | 13.06074524294643782200 |
 Doris      | Bryant    |   6419 | 22.16735159028904928000 |
 Amy        | Williams  |   6261 | 21.62171495665987498700 |
 Keith      | Scott     |   4928 | 17.01833753496563870600 |
 
 
-- For each employee that earns more than 4000, show their first_name, last_name, salary and the number of all employees who earn more than 4000
select first_name, last_name, salary,
	count(*) OVER() 
from employee
where salary>4000;
>>>
first_name | last_name | salary | count |
------------+-----------+--------+-------+
 Diane      | Turner    |   5330 |    13 |
 Eugene     | Phillips  |   4877 |    13 |
 Philip     | Mitchell  |   5259 |    13 |
 
			-- For the above query, the normal query without window functions will be:
			select first_name, last_name, salary, (select count(*) from employee where salary>4000)
			from employee
			where salary>4000
			group by first_name, last_name, salary


'
OVER() means "for all rows in the query result". This "in the query result" part is very important – window functions work only on the rows returned by the query.

Here, this means we will get the salary of each IT department employee and the average salary in that department, and not in the entire company. That is a very important rule which we need to remember. Window functions are always executed AFTER the WHERE clause, so they work on whatever they find as the result.

Now, it might be tempting to use window functions in a WHERE clause. However, when we run a query, we will get an error message. We cannot put window functions in WHERE. Why? The window functions are applied AFTER the rows are selected. If the window functions were in a WHERE clause, we would get a circular dependency: in order to compute the window function, we have to filter the rows with WHERE, which requires to compute the window function.
'


----------
--REVIEW--
----------
'

* Use <window_function> OVER() to compute an aggregate for all rows in the query result.
* The window functions are applied after the rows are filtered by WHERE.
* The window functions are used to compute aggregates but keep details of individual rows at the same time.
* We cant use window functions in WHERE clauses.

'