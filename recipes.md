# 1-1. Retrieving Data from a Table
## Problem
## You want to retrieve specific row and column data from a table.

## Solution
Issue a SELECT statement that includes a WHERE clause. The following is a straightforward SELECT statement querying a database table for particular column values, for those rows that match defined criteria

```sql
select employee_id, first_name, last_name, hire_date, salary from hr.employees
where department_id = 50 and salary < 7500;
```

Rows in the EMPLOYEES table must satisfy both tests to be included in our results. Meeting one, or the other, but not both will not satisfy our query, as we've used the AND Boolean operator to combine the criteria. In non-technical terms, this means an employee must be listed in the department with an ID of 50, as well as have a salary below 7500.


Other Boolean operators are OR and NOT, and these follow normal Boolean precedence rules and can be modified using parenthesis to alter logic explicitly. We can modify our first example to illustrate these operators in combination

select employee_id, first_name, last_name, hire_date, salary from hr.employees
where department_id = 50
and (salary < 2500 or salary > 7500);
his query seeks the same columns as the first, this time focusing on those members of department 50 whose salary is either less than 2500, or more than 7500.
---
1-2. Selecting All Columns from a Table
Problem
You want to retrieve all columns from a table, but you don’t want to take the time to type all the column names as part of your SELECT statement.

Solution
Use the asterisk (*) placeholder, to represent all columns for a table. For example:
select *
from hr.employees
where department_id = 50 and salary < 7500;
---
1-3. Sorting Your Results
Problem
Users want to see data from a query sorted in a particular way. For example, they would like to see employees sorted alphabetically by surname, and then first name.

Solution
The ORDER BY clause to allow you to sort the results of your queries.
select employee_id, first_name, last_name, hire_date, salary from hr.employees
where salary > 5000
order by last_name, first_name;
---
1-11. Selecting from the Results of Another Query
Problem
You need to treat the results of a query as if they were the contents of a table. You don't want to store the intermediate results as you need them freshly generated every time you run your query.

Solution
A query can included in the FROM clause of a statement, with the results referred to using a table alias.

select d.department_name from
(select department_id, department_name from hr.departments
where location_id != 1700) AS d;
---
1-12. Basing a Where Condition on a Query
Problem
You need to query the data from a table, but one of your criteria will be dependent on data from another table at the time the query runs—and you want to avoid hard-coding criteria. Specifically, you want to find all departments with offices in North America for the purposes of reporting.

Solution
In the HR schema, the DEPARTMENTS table lists departments, and the LOCATIONS table lists locations.

select department_name from hr.departments where location_id in (select location_id
from hr.locations
where country_id = 'US' or country_id = 'CA');
---
1-13. Finding and Eliminating NULLs in Queries
Problem
You need to report how many of your employees have a commission percentage as part of their remuneration, together with the number that get only a fixed salary. You track this using the COMMISSION_PCT field of the HR.EMPLOYEES table.


Solution
The structure of the HR.EMPLOYEE tables allows the COMMISSION_PCT to be NULL. Two queries can be used to find those whose commission percent is NULL and those whose commission percent is non-NULL. First, here’s the query that finds employees with NULL commission percent:

select first_name, last_name from hr.employees
where commission_pct is null;

Now here’s the query that finds non-NULL commission-percentage holders:

select first_name, last_name from hr.employees
where commission_pct is not null;
---
1-14. Sorting as a Person Expects
Problem
Your textual data has been stored in a mix of uppercase, lowercase, and sentence case. You need to sort this data alphabetically as a person normally would, in a case-insensitive fashion.
---
1-15. Enabling Other Sorting and Comparison Options
Problem
You need to perform case-insensitive comparisons and other sorting operations on textual data that has been stored in an assortment of uppercase, lowercase, and sentence case.
---
2-1. Summarizing the Values in a Column
Problem
You need to summarize data in a column in some way. For example, you have been asked to report on the average salary paid per employee, as well as the total salary budget, number of employees, highest and lowest earners, and more.

Solution
You don’t need to calculate a total and count the number of employees separately to determine the average salary. The AVG function calculates average salary for you, as shown in the next SELECT statement.


select avg(salary) from hr.employees;
AVG(SALARY)
6473.36449
Note there is no WHERE clause in our recipe, meaning all rows in the HR.EMPLOYEES table are assessed to calculate the overall average for the table’s rows.
Functions such as AVG are termed aggregate functions, and there are many such functions at your disposal.
---
2-2. Summarizing Data for Different Groups
Problem
You want to summarize data in a column, but you don’t want to summarize over all the rows in a table. You want to divide the rows into groups, and then summarize the column separately for each group. For example, you need to know the average salary paid per department.

Solution
Use SQL’s GROUP BY feature to group common subsets of data together to apply functions like COUNT, MIN, MAX, SUM, and AVG. This SQL statement shows how to use an aggregate function on subgroups of your data with GROUP BY.

select department_id, avg(salary) from hr.employees
group by department_id;
---
2-3. Grouping Data by Multiple Fields
Problem
You need to report data grouped by multiple values simultaneously. For example, an HR department may need to report on minimum, average, and maximum SALARY by DEPARTMENT_ID and JOB_ID.

Solution
Oracle’s GROUP BY capabilities extend to an arbitrary number of columns and expressions, so we can extend the previous recipe to encompass our new grouping requirements. We know what we want aggregated: the SALARY value aggregated three different ways. That leaves the DEPARTMENT_ID and JOB_ID to be grouped. We also want our results ordered so we can see different JOB_ID values in the same department in context, from highest SALARY to lowest. The next SQL statement achieves this by adding the necessary criteria to the GROUP BY and ORDER BY clauses.

Select department_id, job_id, min(salary), avg(salary), max(salary) From hr.employees
Group by department_id, job_id
Order by department_id, max(salary) desc;
---
2-4. Ignoring Groups in Aggregate Data Sets
Problem
You want to ignore certain groups of data based on the outcome of aggregate functions or grouping actions. In effect, you’d really like another WHERE clause to work after the GROUP BY clause, providing criteria at the group or aggregate level.

Solution
SQL provides the HAVING clause to apply criteria to grouped data. For our recipe, we solve the problem of finding minimum, average, and maximum salary for people performing the same job in each of the departments in the HR.EMPLOYEES table. Importantly, we only want to see these aggregate values where more than one person performs the same job in a given department. The next SQL statement uses an expression in the HAVING clause to solve our problem.

select department_id, job_id, min(salary), avg(salary), max(salary), count(*) from hr.employees
group by department_id, job_id having count(*) > 1;

The HAVING clause criteria can be arbitrarily complex, so you can use multiple criteria of different
sorts.

select department_id, job_id, min(salary), avg(salary), max(salary), count(*) from hr.employees
group by department_id, job_id having count(*) > 1
and min(salary) between 2500 and 17000 and avg(salary) != 5000
and max(salary)/min(salary) < 2;
---
2-5. Aggregating Data at Multiple Levels
Problem
You want to find totals, averages, and other aggregate figures, as well as subtotals in various dimensions for a report. You want to achieve this with as few statements as possible, preferably just one, rather than having to issue separate statements to get each intermediate subtotal along the way.

Solution
You can calculate subtotals or other intermediate aggregates in Oracle using the CUBE, ROLLUP and grouping sets features. For this recipe, we’ll assume some real-world requirements. We want to find average and total (summed) salary figures by department and job category, and show meaningful higher-level averages and subtotals at the department level (regardless of job category), as well as a grand total and company-wide average for the whole organization.

select department_id, job_id, avg(salary), sum(salary) from hr.employees
group by rollup (department_id, job_id);

The ROLLUP function performs grouping at multiple levels, using a right-to-left method of rolling up through intermediate levels to any grand total or summation. In our recipe, this means that after performing normal grouping by DEPARTMENT_ID and JOB_ID, the ROLLUP function rolls up all JOB_ID values so that we see an average and sum for the DEPARTMENT_ID level across all jobs in a given department.
ROLLUP then rolls up to the next (and highest) level in our recipe, rolling up all departments, in effect
providing an organization-wide rollup. You can see the rolled up rows in bold in the output.
Performing this rollup would be the equivalent of running three separate statements, such as the three that follow, and using UNION or application-level code to stitch the results together.

select department_id, job_id, avg(salary), sum(salary) from hr.employees
group by department_id, job_id;
select department_id, avg(salary), sum(salary) from hr.employees
group by department_id;
select avg(salary), sum(salary) from hr.employees;

Careful observers will note that because ROLLUP works from right to left with the columns given, we
don’t see values where departments are rolled up by job. We could achieve this using this version of the recipe.

select department_id, job_id, avg(salary), sum(salary) from hr.employees
group by rollup (job_id, department_id);
In doing so, we get the DEPARTMENT_ID intermediate rollup we want, but lose the JOB_ID intermediate rollup, seeing only JOB_ID rolled up at the final level. To roll up in all dimensions, change the recipe to use the CUBE function.

Select department_id, job_id, min(salary), avg(salary), max(salary) From hr.employees
Group by cube (department_id, job_id);
The results show our rollups at each level, shown in bold in the partial results that follow.




The power of both the ROLLUP and CUBE functions extends to as many “dimensions” as you need for your query. Admittedly, the term cube is meant to allude to the idea of looking at intermediate aggregations in three dimensions, but your data can often have more dimensions than that. Extending our recipe, we could “cube” a calculation of average salary by department, job, manager, and starting year.
Select department_id, job_id, manager_id,
extract(year from hire_date) as "START_YEAR", avg(salary) From hr.employees
Group by cube (department_id, job_id, manager_id, extract(year from hire_date));
---
2-6. Using Aggregate Results in Other Queries
Problem
You want to use the output of a complex query involving aggregates and grouping as source data for another query.

Solution
Oracle allows any query to be used as a subquery or inline view, including those containing aggregates and grouping functions. This is especially useful where you’d like to specify group-level criteria compared against data from other tables or queries, and don’t have a ready-made view available.
For our recipe, we’ll use an average salary calculation with rollups across department, job, and start year, as shown in this SELECT statement.
select * from (
select department_id as "dept", job_id as "job", to_char(hire_date,'YYYY') as "Start_Year", avg(salary) as "avsal"
from hr.employees
group by rollup (department_id, job_id, to_char(hire_date,'YYYY'))) salcalc where salcalc.start_year > '1990'
or salcalc.start_year is null order by 1,2,3,4;

How It Works
Our recipe uses the aggregated and grouped results of the subquery as an inline view, which we then select from and apply further criteria. In this case, we could avoid the subquery approach by using
a more complex HAVING clause like this.
having to_char(hire_date,'YYYY') > '1990' or to_char(hire_date,'YYYY') is null

Avoiding a subquery here works only because we’re comparing our aggregates with literals. If we wanted to find averages for jobs in departments where someone had previously held the job, we’d need to reference the HR.JOBHISTORY table. Depending on the business requirement, we might get lucky and be able to construct our join, aggregates, groups, and having criteria in one statement. By treating the results of the aggregate and grouping query as input to another query, we get better readability, and the ability to code even more complexity than the HAVING clause allows.
---

2-7. Counting Members in Groups and Sets
Problem
You need to count members of a group, groups of groups, and other set-based collections. You also need to include and exclude individual members and groups dynamically based on other data at the same time. For instance, you want to count how many jobs each employee has held during their time at the organization, based on the number of promotions they’ve had within the company.


Solution
Oracle’s COUNT feature can be used to count materialized results as well as actual rows in tables. The next SELECT statement uses a subquery to count the instances of jobs held across tables, and then summarizes those counts. In effect, this is a count of counts against data resulting from a query, rather than anything stored directly in Oracle.

select jh.JobsHeld, count(*) as StaffCount from
(select u.employee_id, count(*) as JobsHeld from
(select employee_id from hr.employees union all
select employee_id from hr.job_history) u group by u.employee_id) jh
group by jh.JobsHeld;

How It Works
The key to our recipe is the flexibility of the COUNT function, which can be used for far more than just physically counting the number of rows in a table. You can count anything you can represent in a result. This means you can count derived data, inferred data, and transient calculations and determinations. Our recipe uses nested subselects and counts at two levels, and is best understood starting from the inside and working out.
We know an employee’s current position is tracked in the HR.EMPLOYEES table, and that each instance of previous positions with the organization is recorded in the HR.JOB_HISTORY table. We can’t just count the entries in HR.JOB_HISTORY and add one for the employees’ current positions, because staff who have never changed jobs don’t have an entry in HR.JOB_HISTORY.
Instead, we perform a UNION ALL of the EMPLOYEE_ID values across both HR.EMPLOYEES and HR.JOB_HISTORY, building a basic result set that repeats an EMPLOYEE_ID for every position an employee has held.
---
2-8. Finding Duplicates and Unique Values in a Table
Problem
You need to test if a given data value is unique in a table—that is, it appears only once.


Solution
Oracle supports the standard HAVING clause for SELECT statements, and the COUNT function, which together can identify single instances of data in a table or result. The following SELECT statement solves the problem of finding if the surname Fay is unique in the HR.EMPLOYEES table.

select last_name, count(*) from hr.employees
where last_name = 'Fay' group by last_name having count(*) = 1;
With this recipe, we receive these results:
LAST_NAME   COUNT(*)
Fay 1
Because there is exactly one LAST_NAME value of Fay, we get a count of 1 and therefore see results.

How It Works
Only unique combinations of data will group to a count of 1. For instance, we can test if the surname King is unique:

select last_name, count(*) from hr.employees
where last_name = 'King' group by last_name having count(*) = 1;

This statement returns no results, meaning that the count of people with a surname of King is not 1; it’s some other number like 0, 2, or more. The statement first determines which rows have a LAST_NAME value of King. It then groups by LAST_NAME and counts the hits encountered. Lastly, the HAVING clause tests to see if the count of rows with a LAST_NAME of King was equal to 1. Only those results are returned, so a surname is unique only if you see a result.
If we remove the HAVING clause as in the next SELECT statement, we’ll see how many Kings are in the
HR.EMPLOYEES table.
select last_name, count(*) from hr.employees
where last_name = 'King' group by last_name;
LAST_NAME   COUNT(*)
King    2


Two people have a surname of King, thus it isn’t unique and didn’t show up in our test for uniqueness.
The same technique can be extended to test for unique combinations of columns. We can expand our recipe to test if someone’s complete name, based on the combination of FIRST_NAME and LAST_NAME, is unique. This SELECT statement includes both columns in the criteria, testing to see if Lindsey Smith is a unique full name in the HR.EMPLOYEES table.

select first_name, last_name, count(*) from hr.employees
where first_name = 'Lindsey' and last_name = 'Smith'
group by first_name, last_name having count(*) = 1;



You can write similar recipes that use string concatenation, self-joins, and a number of other methods.
---
2-11. Accessing Values from Subsequent or Preceding Rows
Problem
You would like to query data to produce an ordered result, but you want to include calculations based on preceding and following rows in the result set. For instance, you want to perform calculations on event- style data based on events that occurred earlier and later in time.

Solution
Oracle supports the LAG and LEAD analytical functions to provide access to multiple rows in a table or expression, utilizing preceding/following logic—and you won’t need to resort to joining the source data
to itself. Our recipe assumes you are trying to tackle the business problem of visualizing the trend in hiring of staff over time. The LAG function can be used to see which employee’s hiring followed another, and also to calculate the elapsed time between hiring.
select first_name, last_name, hire_date,
lag(hire_date, 1, '01-JUN-1987') over (order by hire_date) as Prev_Hire_Date, hire_date - lag(hire_date, 1, '01-JUN-1987') over (order by hire_date)
as Days_Between_Hires from hr.employees
order by hire_date;
Our query returns 107 rows, linking the employees in the order they were hired (though not necessarily preserving the implicit sort for display or other purposes), and showing the time delta between each joining the organization.

How It Works
The LAG and LEAD functions are like most other analytical and windowing functions in that they operate once the base non-analytic portion of the query is complete. Oracle performs a second pass over the intermediate result set to apply any analytical predicates. In effect, the non-analytic components are evaluated first, as if this query had been run.
select first_name, last_name, hire_date
-- placeholder for Prev_Hire_Date,
-- placehodler for Days_Between_Hires from hr.employees;
The results at this point would look like this if you could see them:


FIRST_NAME LAST_NAME HIRE_DATE PREV_HIRE DAYS_BETWEEN


The analytic function(s) are then processed, providing the results you’ve seen. Our recipe uses the LAG function to compare the current row of results with a preceding row. The general format is the best way to understand LAG, and has the following form.
lag (column or expression, preceding row offset, default for first row)

The column or expression is mostly self-explanatory, as this is the table data or computed result over which you want LAG to operate. The preceding row offset portion indicates the relative row prior to the current row the LAG should act against. In our case, the value ‘1’ means the row that is one row before the current row. The default for LAG indicates what value to use as a precedent for the first row, as there is no row zero in a table or result. We’ve chosen the arbitrary date of 01-JUN-1987 as a notional date on which the organization was founded. You could use any date, date calculation, or date-returning function here. Oracle will supply a NULL value if you don’t specify the first row’s precedent value.
The OVER analytic clause then dictates the order of data against which to apply the analytic function,
and any partitioning of the data into windows or subsets (not shown in this recipe). Astute readers will realize that this means our recipe could have included a general ORDER BY clause that sorted the data for presentation in a different order from the HIRE_DATE ordering used for the LAG function. This gives you the most flexibility to handle general ordering and analytic lag and lead in different ways for the same statement. We’ll show an example of this later in this chapter. And remember, you should never rely on the implicit sorting that analytic functions use. This can and will change in the future, so you are best advised to always include ORDER BY for sorting wherever explicitly required.
The LEAD function works in a nearly identical fashion to LAG, but instead tracks following rows rather than preceding ones. We could rewrite our recipe to show hires along with the HIRE_DATE of the next employee, and a similar elapsed-time window between their employment dates, as in this SELECT statement.
select first_name, last_name, hire_date,
lead(hire_date, 1, sysdate) over (order by hire_date) as Next_Hire_Date, lead(hire_date, 1, sysdate) over (order by hire_date) - hire_date
as Days_Between_Hires from hr.employees;

The pattern of dates is very intuitive now that you’ve seen the LAG example. With LEAD, the key difference is the effect of the default value in the third parameter.

In contrast to LAG, where the default provides a notional starting point for the first row’s comparison, LEAD uses the default value to provide a hypothetical end point for the last row in the forward-looking chain. In this recipe, we are comparing how many days have elapsed between employees being hired. It makes sense for us to compare the last employee hired (in this case, Sundita Kumar) with the current date using the SYSDATE function. This is a quick and easy finishing flourish to calculate the days that have elapsed since hiring the last employee.
---
2-12. Assigning Ranking Values to Rows in a Query Result
Problem
The results from a query need to be allocated an ordinal number representing their positions in the result. You do not want to have to insert and track these numbers in the source data.

Solution
Oracle provides the RANK analytic function to generate a ranking number for rows in a result set. RANK is applied as a normal OLAP-style function to a column or derived expression. For the purposes of this recipe, we’ll assume that the business would like to rank employees by salary, from highest-paid down. The following SELECT statement uses the rank function to assign these values.

select employee_id, salary, rank() over (order by salary desc) as Salary_Rank from hr.employees;

Our query produces results from the highest earner at 24000 per month, right down to the employee in 107th place earning 2100 per month, as these abridged results show.

How It Works
RANK acts like any other analytic function, operating in a second pass over the result set once non- analytic processing is complete. In this recipe, the EMPLOYEE_ID and SALARY values are selected (there are no WHERE predicates to filter the table’s data, so we get everyone employed in the organization). The analytic phase then orders the results in descending order by salary, and computes the rank value on the results starting at 1.
Note carefully how the RANK function has handled equal values. Two employees with salary of 17000
are given equal rank of 2. The next employee, at 14000, has a rank of 4. This is known as sparse ranking, where tied values “consume” place holders. In practical terms, this means that our equal second-place holders consume both second and third place, and the next available rank to provide is 4.
You can use an alternative to sparse ranking called dense ranking. Oracle supports this using the
DENSE_RANK analytical function. Observe what happens to the recipe when we switch to dense ranking.
select employee_id, salary, dense_rank() over (order by salary desc) as Salary_Rank
from hr.employees;
We now see the “missing” consecutive rank values.

---
2-13. Finding First and Last Values within a Group
Problem
You want to calculate and display aggregate information like minimum and maximum for a group, along with detail information for each member. You want don’t want to repeat effort to display the aggregate and detail values.


Solution
Oracle provides the analytic functions FIRST and LAST to calculate the leading and ending values in any ordered sequence. Importantly, these do not require grouping to be used, unlike explicit aggregate functions such as MIN and MAX that work without OLAP features.
For our recipe, we’ll assume the problem is a concrete one of displaying an employee’s salary, alongside the minimum and maximum salaries paid to the employee’s peers in their department. This SELECT statement does the work.

select department_id, first_name, last_name, min(salary)
over (partition by department_id) "MinSal", salary,
max(salary)
over (partition by department_id) "MaxSal" from hr.employees
order by department_id, salary;

This code outputs all employees and displays their salaries between the lowest and highest within their own department, as shown in the following partial output.


How It Works
The key to both the FIRST and LAST analytic functions is their ability to let you perform the grouping and ordering on one set of criteria, while leaving you free to order differently in the main body of the query, and optionally group or not as desired by other factors.
The OLAP window is partitioned over each department with the OVER clause
over (partition by department_id) “MinSal”
---
2-14. Performing Aggregations over Moving Windows
Problem
You need to provide static and moving summaries or aggregates based on the same data. For example, as part of a sales report, you need to provide a monthly summary of sales order amounts, together with a moving three- month average of sales amounts for comparison.

Solution
Oracle provides moving or rolling window functions as part of the analytical function set. This gives you the ability to reference any number of preceding rows in a result set, the current row in the result set, and any number of following rows in a result set. Our initial recipe uses the current row and the three preceding rows to calculate the rolling average of order values.

select to_char(order_date, 'MM') as OrderMonth, sum(order_total) as MonthTotal, avg(sum(order_total))
over
(order by to_char(order_date, 'MM') rows between 3 preceding and current row) as RollingQtrAverage
from oe.orders
where order_date between '01-JAN-1999' and '31-DEC-1999' group by to_char(order_date, 'MM')
order by 1;
We see the month, the associated total, and the calculated rolling three-month average in our results.

You might notice January (OrderMonth 01) is missing. This isn’t a quirk of this approach: rather it’s because the OE.ORDERS table has no orders recorded for this month in 1999.


How It Works
Our SELECT statement for a rolling average starts by selecting some straightforward values. The month number is extracted from the ORDER_DATE field using the TO_CHAR() function with the MM format string to obtain the month’s number. We choose the month number rather than the name so that the output is sorted as a person would expect.
Next up is a normal aggregate of the ORDER_TOTAL field using the traditional SUM function. No magic there. We then introduce an OLAP AVG function, which is where the detail of our rolling average is managed. That part of the statement looks like this.

avg(sum(order_total)) over (order by to_char(order_date, 'MM') rows between 3 preceding and current row) as RollingQtrAverage

All of that text is to generate our result column, the ROLLINGQTRAVERAGE. Breaking the sections down will illustrate how each part contributes to the solution. The leading functions, AVG(SUM(ORDER_TOTAL)), suggest we are going to sum the ORDER_TOTAL values and then take their average. That is correct to an extent, but Oracle isn’t just going to calculate a normal average or sum. These are OLAP AVG and SUM functions, so their scope is governed by the OVER clause.
The OVER clause starts by instructing Oracle to perform the calculations based on the order of the formatted ORDER_DATE field—that’s what ORDER BY TO_CHAR(ORDER_DATE, 'MM') achieves—effectively ordering the calculations by the values 02 to 12 (remember, there’s no data for January 1999 in the database). Finally, and most importantly, the ROWS element tells Oracle the size of the window of rows over which it should calculate the driving OLAP aggregate functions. In our case, that means over how many months should the ORDER_TOTAL values be summed and then averaged. Our recipe instructs Oracle to use the results from the third-last row through to the current row. This is one interpretation of three-
month rolling average, though technically it’s actually generating an average over four months. If what you want is really a three-month average —the last two months plus the current month—you’d change the ROWS BETWEEN element to read
rows between 2 preceding and current row
This brings up an interesting point. This recipe assumes you want a rolling average computed over historic data. But some business requirements call for a rolling window to track trends based on data not only prior to a point in time, but also after that point. For instance, we might want to use a three-month window but base it on the previous, current, and following months. The next version of the recipe
shows exactly this ability of the windowing function, with the key changes in bold.

select to_char(order_date, 'MM') as OrderMonth, sum(order_total) as MonthTotal, avg(sum(order_total)) over (order by to_char(order_date, 'MM')
rows between 1 preceding and 1 following) as AvgTrend
from oe.orders
where order_date between '01-JAN-1999' and '31-DEC-1999' group by to_char(order_date, 'MM')
order by 1
/
Our output changes as you’d expect, as the monthly ORDER_TOTAL values are now grouped differently for the calculation.




11 rows selected.
The newly designated AVGTREND value is calculated as described, using both preceding and following rows. Both our original recipe and this modified version are rounded out with a WHERE clause to select only data from the OE.ORDERS table for the year 1999. We group by the derived month number so that our traditional sum of ORDER_TOTAL in the second field of the results aggregates correctly, and finish up ordering logically by the month number.

---

2-15. Removing Duplicate Rows Based on a Subset of Columns
Problem
Data needs to be cleansed from a table based on duplicate values that are present only in a subset of rows.

Solution
Historically there were Oracle-specific solutions for this problem that used the ROWNUM feature. However, this can become awkward and complex if you have multiple groups of duplicates and want to remove the excess data in one pass. Instead, you can use Oracle’s ROW_NUMBER OLAP function with a DELETE statement to efficiently remove all duplicates in one pass.
To illustrate our recipe in action, we’ll first introduce several new staff members that have the same
FIRST_NAME and LAST_NAME as some existing employees. These INSERT statements create our problematic duplicates.
insert into hr.employees
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(210, 'Janette', 'King', 'JKING2', '650.555.8880', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);


Insert into hr.employees
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(211, 'Patrick', 'Sully', 'PSULLY2', '650.555.8881', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);
Insert into hr.employees
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(212, 'Allen', 'McEwen', 'AMCEWEN2', '650.555.8882', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);
commit;
To show that we do indeed have some duplicates, a quick SELECT shows the rows in question.
select employee_id, first_name, last_name from hr.employees
where first_name in ('Janette','Patrick','Allan') and last_name in ('King','Sully','McEwen')
order by first_name, last_name;
EMPLOYEE_ID FIRST_NAME  LAST_NAME
----------- ----------- ----------
158 Allan   McEwen
212 Allan   McEwen
210 Janette King
156 Janette King
211 Patrick Sully
Patrick Sully
If you worked in HR, or were one of these people, you might be concerned with the unpredictable consequences and want to see the duplicates removed. With our problematic data in place, we can introduce the SQL to remove the “extra” Janette King, Patrick Sully, and Allen McEwen.

delete from hr.employees where rowid in
(select rowid from
(select first_name, last_name, rowid, row_number() over
(partition by first_name, last_name order by employee_id) staff_row
from hr.employees) where staff_row > 1);

When run, this code does indeed claim to remove three rows, presumably our duplicates. To check, we can repeat our quick query to see which rows match those three names. We see this set of results.


EMPLOYEE_ID FIRST_NAME LAST_NAME
Allan   McEwen
Janette King
Patrick Sully
Our DELETE has succeeded, based on finding duplicates for a subset of columns only.

How It Works
Our recipe uses both the ROW_NUMBER OLAP function and Oracle’s internal ROWID value for uniquely identifying rows in a table. The query starts with exactly the kind of DELETE syntax you’d assume.

delete from hr.employees where rowid in
(… nested subqueries here …)
As you’d expect, we’re asking Oracle to delete rows from HR.EMPLOYEES where the ROWID value matches the values we detect for duplicates, based on criteria evaluating a subset of columns. In our case, we use subqueries to precisely identify duplicates based on FIRST_NAME and LAST_NAME.
To understand how the nested subqueries work, it’s easiest to start with the innermost subquery,
which looks like this.

select first_name, last_name, rowid, row_number() over
(partition by first_name, last_name order by employee_id) staff_row
from hr.employees
We’ve intentionally added the columns FIRST_NAME and LAST_NAME to this innermost subquery to make the recipe understandable as we work through its logic. Strictly speaking, these are superfluous to the logic, and the innermost subquery could be written without them to the same effect. If we execute just this innermost query (with the extra columns selected for clarity), we see these results.






110 rows selected.
All 110 staff from the HR.EMPLOYEES table have their FIRST_NAME, LAST_NAME and ROWID returned. The ROW_NUMBER() function then works over sets of FIRST_NAME and LAST_NAME driven by the PARTITION BY instruction. This means that for every unique FIRST_NAME and LAST_NAME, ROW_NUMBER will start a running count of rows we’ve aliased as STAFF_ROW. When a new FIRST_NAME and LAST_NAME combination is observed, the STAFF_ROW counter resets to 1.
In this way, the first Janette King has a STAFF_ROW value of 1, the second Janette King entry has a STAFF_ROW value of 2, and if there were a third and fourth such repeated name, they’d have STAFF_ROW values of 3 and 4 respectively. With our identically-named staff now numbered, we move to the next
outermost subselect, which queries the results from above.
select rowid from select
(select first_name, last_name, rowid, row_number() over
(partition by first_name, last_name order by first_name, last_name) staff_row
from hr.employees) where staff_row > 1

This outer query looks simple, because it is! We simply SELECT the ROWID values from the results of our innermost query, where the calculated STAFF_ROW value is greater than 1. That means that we only select the ROWID values for the second Janette King, Allan McEwen, and Patrick Sully, like this.
ROWID
AAARAgAAFAAAABYAA4 AAARAgAAFAAAABYAA6 AAARAgAAFAAAABYAA5

Armed with those ROWID values, the DELETE statement knows exactly which rows are the duplicates, based on only a comparison and count of FIRST_NAME and LAST_NAME.
The beauty of this recipe is the basic structure translates very easily to deleting data based on any such column-subset duplication. The format stays the same, and only the table name and a few column names need to be changed. Consider this a pseudo-SQL template for all such cases.
delete from <your_table_here>
where rowid in (select rowid from
(select rowid, row_number() over
(partition by <first_duplicate_column>, <second_duplicate_column>, <etc.>
order by <desired ordering column>)


duplicate_row_count from <your_table_here>)
where duplicate_row_count > 1)
/
Simply plug in the value for your table in place of the marker <your_table_here>, and the columns you wish to use to determine duplication in place of equivalent column placeholders, and you’re in business!

---
2-16. Finding Sequence Gaps in a Table
Problem
You want to find all gaps in the sequence of numbers or in dates and times in your data. The gaps could be in dates recorded for a given action, or in some other data with a logically consecutive nature.

Solution
Oracle’s LAG and LEAD OLAP functions let you compare the current row of results with a preceding row. The general format of LAG looks like this
Lag (column or expression, preceding row offset, default for first row)

The column or expression is the value to be compared with lagging (preceding) values. The preceding row offset indicates how many rows prior to the current row the LAG should act against. We’ve used ‘1’ in the following listing to mean the row one prior to the current row. The default for LAG indicates what value to use as a precedent for the first row, as there is no row zero in a table or result. We instruct Oracle to use 0 as the default anchor value, to handle the case where we look for the day prior to the first of the month.
The WITH query alias approach can be used in almost all situations where a subquery is used, to
relocate the subquery details ahead of the main query. This aids readability and refactoring of the code if required at a later date.
This recipe looks for gaps in the sequence of days on which orders were made for the month of November 1999:
with salesdays as
(select extract(day from order_date) next_sale, lag(extract(day from order_date),1,0)
over (order by extract(day from order_date)) prev_sale from oe.orders
where order_date between '01-NOV-1999' and '30-NOV-1999') select prev_sale, next_sale
from salesdays
where next_sale - prev_sale > 1 order by prev_sale;
Our query exposes the gaps, in days, between sales for the month of November 1999.


PREV_SALE NEXT_SALE


The results indicate that after an order was recorded on the first of the month, no subsequent order was recorded until the 10th. Then a four-day gap followed to the 14th, and so on. An astute sales manager might well use this data to ask what the sales team was doing on those gap days, and why no orders came in!

How It Works
The query starts by using the WITH clause to name a subquery with an alias in an out-of-order fashion. The subquery is then referenced with an alias, in this case SALESDAYS.
The SALESDAYS subquery calculates two fields. First, it uses the EXTRACT function to return the numeric day value from the ORDER_DATE date field, and labels this data as NEXT_SALE. The lag OLAP function is then used to calculate the number for the day in the month (again using the EXTRACT method) of the ORDER_DATE of the preceding row in the results, which becomes the PREV_SALE result value. This makes more sense when you visualize the output of just the subquery select statement

select extract(day from order_date) next_sale, lag(extract(day from order_date),1,0)
over (order by extract(day from order_date)) prev_sale from oe.orders
where order_date between '01-NOV-1999' and '30-NOV-1999'
The results would look like this if executed independently.
NEXT_SALE PREV_SALE


Starting with the anchor value of 0 in the lag, we see the day of the month for a sale as NEXT_SALE, and the day of the previous sale as PREV_SALE. You can probably already visually spot the gaps, but it’s much easier to let Oracle do that for you too. This is where our outer query does its very simple arithmetic.
The driving query over the SALESDAYS subquery selects the PREV_SALE and NEXT_SALE values from the results, based on this predicate.


where next_sale - prev_sale > 1

We know the days of sales are consecutive if they’re out by more than one day. We wrap up by ordering the results by the PREV_SALE column, so that we get a natural ordering from start of month to end of month.
Our query could have been written the traditional way, with the subquery in the FROM clause like
this.
select prev_sale, next_sale
from (select extract(day from order_date) next_sale, lag(extract(day from order_date),1,0)
over (order by extract(day from order_date)) prev_sale from oe.orders
where order_date between '01-NOV-1999' and '30-NOV-1999') where next_sale - prev_sale > 1
order by prev_sale
/
The approach to take is largely a question of style and readability. We prefer the WITH approach on those occasions where it greatly increases the readability of your SQL statements.




Querying data from Oracle tables is probably the most common task you will perform as a developer or data analyst, and maybe even as a DBA—though probably not as the ETL (Extraction, Transformation, and Loading) tool expert. Quite often, you may query only one table for a small subset of rows, but sooner or later you will have to join multiple tables together. That’s the beauty of a relational database, where the access paths to the data are not fixed: you can join tables that have common columns, or even tables that do not have common columns (at your own peril!).
In this chapter we’ll cover solutions for joining two or more tables and retrieving the results based on the existence of desired rows in both tables (equi-join), rows that may exist only in one table or the other (left or right outer joins), or joining two tables together and including all rows from both tables, matching where possible (full outer joins).
But wait, there’s more! Oracle (and the SQL language standard) contains a number of constructs that help you retrieve rows from tables based on the existence of the same rows in another table with the same column values for the selected rows in a query. These constructs include the INTERSECT, UNION, UNION ALL, and MINUS operators. The results from queries using these operators can in some cases be obtained using the standard table-join syntax, but if you’re working with more than just a couple of columns, the query becomes unwieldy, hard to read, and hard to maintain.
You may also need to update rows in one table based on matching or non-matching values in another table, so we’ll provide a couple of recipes on correlated queries and correlated updates using the IN/EXISTS SQL constructs as well.
Of course, no discussion of table manipulation would be complete without delving into the unruly
child of the query world, the Cartesian join. There are cases where you want to join two or more tables without a join condition, and we’ll give you a recipe for that scenario.
Most of the examples in this chapter are based on the schemas in the EXAMPLE tablespace created
during an Oracle Database installation when you specify “Include Sample Schemas.” Those sample schemas aren’t required to understand the solutions in this chapter, but they give you the opportunity to try out the solutions on a pre-populated set of tables and even delve further into the intricacies of table joins.

---

3-2. Stacking Query Results Vertically
Problem
You want to combine the results from two SELECT statements into a single result set.


Solution
Use the UNION operator. UNION combines the results of two or more queries and removes duplicates from the entire result set. In Oracle’s mythical company, the employees in the EMPLOYEES_ACT table need to be merged with employees from a recent corporate acquisition. The recently acquired company’s employee table EMPLOYEES_NEW has the same exact format as the existing EMPLOYEES_ACT table, so it should be easy to use UNION to combine the two tables into a single result set as follows:
select employee_id, first_name, last_name from employees_act;


select employee_id, first_name, last_name from employees_new;



select employee_id, first_name, last_name from employees_act union
select employee_id, first_name, last_name from employees_new order by employee_id
;




Using UNION removes the duplicate rows. You can have one ORDER BY at the end of the query to order the results. In this example, the two employee tables have two rows in common (some people need to work two or three jobs to make ends meet!), so instead of returning 11 rows, the UNION query returns nine.

How It Works
Note that for the UNION operator to remove duplicate rows, all columns in a given row must be equal to the same columns in one or more other rows. When Oracle processes a UNION, it must perform a sort/merge to determine which rows are duplicates. Thus, your execution time will likely be more than running each SELECT individually. If you know there are no duplicates within and across each SELECT statement, you can use UNION ALL to combine the results without checking for duplicates.
If there are duplicates, it will not cause an error; you will merely get duplicate rows in your result set.

---

3-3. Writing an Optional Join
Problem
You are joining two tables by one or more common columns, but you want to make sure to return all rows in the first table regardless of a matching row in the second. For example, you are joining the employee and department tables, but some employees lack department assignments.

Solution
Use an outer join. In Oracle’s sample database, the HR user maintains the EMPLOYEES and DEPARTMENTS tables; assigning a department to an employee is optional. There are 107 employees in the EMPLOYEES table. Using a standard join between EMPLOYEES and DEPARTMENTS only returns 106 rows, however, since one employee is not assigned a department. To return all rows in the EMPLOYEES table, you can use LEFT OUTER JOIN to include all rows in the EMPLOYEES table and matching rows in DEPARTMENTS, if any:

select employee_id, last_name, first_name, department_id, department_name from employees
left outer join departments using(department_id)
;


107 rows selected


There are now 107 rows in the result set instead of 106; Kimberely Grant is included even though she does not currently have a department assigned.

How It Works
When two tables are joined using LEFT OUTER JOIN, the query returns all the rows in the table to the left of the LEFT OUTER JOIN clause, as you might expect. Rows in the table on the right side of the LEFT OUTER JOIN clause are matched when possible. If there is no match, columns from the table on the right side will contain NULL values in the results.
As you might expect, there is a RIGHT OUTER JOIN as well (in both cases, the OUTER keyword is
optional). You can rewrite the solution as follows:

select employee_id, last_name, first_name, department_id, department_name from departments
right outer join employees using(department_id)
;
The results are identical, and which format you use depends on readability and style.
The query can be written using the ON clause as well, just as with an equi-join (inner join). And for versions of Oracle before 9i, you must use Oracle’s somewhat obtuse and proprietary outer-join syntax with the characters (+) on the side of the query that is missing rows, as in this example:

select employee_id, last_name, first_name, e.department_id, department_name from employees e, departments d
where e.department_id = d.department_id (+)
;
Needless to say, if you can use ANSI SQL-99 syntax, by all means do so for clarity and ease of maintenance.

---

3-4. Making a Join Optional in Both Directions
Problem
All of the tables in your query have at least a few rows that don’t match rows in the other tables, but you still want to return all rows from all tables and show the mismatches in the results. For example, you want to reduce the number of reports by including mismatches from both tables instead of having one report for each scenario.

Solution
Use FULL OUTER JOIN. As you might expect, a full outer join between two or more tables will return all rows in each table of the query and match where possible. You can use FULL OUTER JOIN with the EMPLOYEES and DEPARTMENTS table as follows:


select employee_id, last_name, first_name, department_id, department_name from employees
full outer join departments using(department_id)
;


123 rows selected


Note The OUTER keyword is optional when using a FULL, LEFT, or RIGHT join. It does add documentation value to your query, making it clear that mismatched rows from one or both tables will be in the results.


Using FULL OUTER JOIN is a good way to view, at a glance, mismatches between two tables. In the preceding output, you can see an employee without a department as well as several departments that have no employees.

How It Works
Trying to accomplish a full outer join before Oracle9i was a bit inelegant: you had to perform a UNION of two outer joins (a left and a right outer join) using the proprietary Oracle syntax as follows:

select employee_id, last_name, first_name, e.department_id, department_name from employees e, departments d
where e.department_id = d.department_id (+) union
select employee_id, last_name, first_name, e.department_id, department_name from employees e, departments d
where e.department_id (+) = d.department_id
;
Running two separate queries, then removing duplicates, takes more time to execute than using the
FULL OUTER JOIN syntax, where only one pass on each table is required.


You can tweak the FULL OUTER JOIN to produce only the mismatched records as follows:
select employee_id, last_name, first_name, department_id, department_name from employees
full outer join departments using(department_id) where employee_id is null or department_name is null
;

---
3-6. Finding Matched Data Across Tables
Problem
You want to find the rows in common between two or more tables or queries.

Solution
Use the INTERSECT operator. When you use INTERSECT, the resulting row set contains only rows that are in common between the two tables or queries:
select count(*) from employees_act; COUNT(*)
6
select count(*) from employees_new; COUNT(*)
5


select * from employees_act intersect
select * from employees_new
;



How It Works
The INTERSECT operator, along with UNION, UNION ALL, and MINUS, joins two or more queries together. As of Oracle Database 11g, these operators have equal precedence, and unless you override them with parentheses, they are evaluated in left-to-right order. Or, more intuitively since you usually don’t have two queries on one line, top-to-bottom order!


Tip Future ANSI SQL standards give the INTERSECT operator higher precedence than the other operators. Thus, to “bulletproof” your SQL code, use parentheses to explicitly specify evaluation order where you use INTERSECT with other set operators.


To better understand how INTERSECT works, Figure 3-1 shows a Venn diagram representation of the
INTERSECT operation on two queries.

---
3-8. Finding Missing Rows
Problem
You have two tables, and you must find rows in the first table that are not in the second table. You want to compare all rows in each table, not just a subset of columns.

Solution
Use the MINUS set operator. The MINUS operator will return all rows in the first query that are not in the second query. The EMPLOYEES_BONUS table contains employees who have been given bonuses in the past,


and you need to find employees in the EMPLOYEES table who have not yet received bonuses. Use the MINUS
operator as follows to compare three selected columns from two tables:
select employee_id, last_name, first_name from employees minus
select employee_id, last_name, first_name from employees_bonus
;



How It Works
Note that unlike the INTERSECT and UNION operators, the MINUS set operator is not commutative: the order of the operands (queries) is important! Changing the order of the queries in the solution will produce very different results.
If you wanted to note changes for the entire row, you could use this query instead:
select * from employees minus
select * from employees_bonus
;
A Venn diagram may help to show how the MINUS operator works. Figure 3-2 shows the result of Query1 MINUS Query2. Any rows that overlap between Query1 and Query2 are removed from the result set along with any rows in Query2 that do not overlap Query1. In other words, only rows in Query1 are returned less any rows in Query1 that exist in Query2.

---

3-12. Manipulating and Comparing NULLs in Join Conditions
Problem
You want to map NULL values in a join column to a default value that will match a row in the joined table, thus avoiding the use of an outer join.

Solution
Use the NVL function to convert NULL values in the foreign key column of the table to be joined to its parent table. In this example, holiday parties are scheduled for each department, but several employees do not have a department assigned. Here is one of them:

select employee_id, first_name, last_name, department_id from employees
where employee_id = 178
;


1 rows selected
To ensure that each employee will attend a holiday party, convert all NULL department codes in the
EMPLOYEES table to department 110 (Accounting) in the query as follows:
select employee_id, first_name, last_name, d.department_id, department_name from employees e join departments d
on nvl(e.department_id,110) = d.department_id
;






107 rows selected

How It Works
Mapping columns with NULLs to non-NULL values in a join condition to avoid using an OUTER JOIN might still have performance problems, since the index on EMPLOYEES.DEPARTMENT_ID will not be used during the join (primarily because NULL columns are not indexed). You can address this new problem by using a function-based index (FBI). An FBI creates an index on an expression, and may use that index if the expression appears in a join condition or a WHERE clause. Here is how to create an FBI on the DEPARTMENT_ID column:
create index employees_dept_fbi on employees(nvl(department_id,110));


Tip As of Oracle Database 11g, you can now use virtual columns as an alternative to FBIs. Virtual columns are derived from constants, functions, and columns from the same table. You can define indexes on the virtual columns, which the optimizer will use in any query as it would a regular column index.


Ultimately, the key to handling NULLs in join conditions is based on knowing your data. If at all possible, avoid joining on columns that may have NULLs, or ensure that every column you will join on has a default value when it is populated. If the column must have NULLs, use functions like NVL, NVL2, and COALESCE to convert NULLs before joining; you can create function-based indexes to offset any performance issues with joining on expressions. If that is not possible, understand the business rules about what NULLs mean in your database columns: do they mean zero, unknown, or not applicable? Your SQL code must reflect the business definition of columns that can have NULLs.

---

