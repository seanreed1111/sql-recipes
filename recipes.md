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
