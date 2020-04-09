# Retrieving Data

## Querying data from SQL tables is probably the most common task you will perform as a developer or data analyst, and maybe even as a DBA—though probably not as the ETL (Extraction, Transformation, and Loading) tool expert. Quite often, you may query only one table for a small subset of rows, but sooner or later you will have to join multiple tables together. That’s the beauty of a relational database, WHERE the access paths to the data are not fixed: you can join tables that have common columns, or even tables that do not have common columns (at your own peril!).



## Problem
## You want to retrieve specific row and column data from a specific table.

## Solution
Issue a SELECT statement that includes a WHERE clause. 

```sql
SELECT 
    first_name, 
    last_name, 
FROM 
    employee
WHERE 
    department_id = 22 
AND 
    salary < 7500;
```

To show up an employee MUST be listed in the department with a department_id of 22 AND have a salary below 7500.


Other Boolean operators are `OR` and `NOT` and these follow normal logical  rules. See below

```sql
SELECT 
    employee_id, 
    first_name, 
    last_name, 
    hire_date, 
    salary 
FROM 
    employee
WHERE 
    department_id = 50
AND 
    (salary < 2500 or salary > 7500);
```
This query seeks the same columns as the first, this time focusing on those members of department 50 whose salary is either less than 2500, or more than 7500.
---
Selecting All Columns FROM a Table
Problem
You want to retrieve all columns FROM a table, but you don’t want to take the time to type all the column names as part of your SELECT statement.

Solution
Use the asterisk (*) placeholder, to represent all columns for a table. 
```sql
SELECT *
FROM employee
WHERE department_id = 50 and salary < 7500;
```
---
# Sorting Your Results
## Problem
## You want to see data FROM a query sorted in a particular way. For example, they would like to see employee sorted alphabetically by surname, and then first name.

## Solution
The `ORDER BY` clause to allow you to sort the results of your queries.
```sql
SELECT 
    employee_id, 
    first_name, 
    last_name, 
    hire_date, 
    salary 
FROM 
    employee
WHERE 
    salary > 5000
ORDER BY 
    last_name, first_name;
```

---

# Selecting FROM the Results of Another Query
## Problem
## You need to treat the results of a query as if they were the contents of a table. You don't want to store the intermediate results as you need them freshly generated every time you run your query.

## Solution
## A query can included in the FROM clause of a statement, with the results referred to using a table alias.

```sql
SELECT 
    query.department_name 
FROM
    (SELECT 
        department_id, 
        department_name 
    FROM department
    WHERE location_id != 1700
    ) AS query;
```

---

# Basing a WHERE Condition on a Query
## Problem
## You need to query the data FROM a table, but one of your criteria will be dependent on data FROM another table at the time the query runs—and you want to avoid hard-coding criteria. Specifically, you want to find all departments with offices in North America for the purposes of reporting.

## Solution
## The DEPARTMENT table lists departments, and the LOCATION table lists locations. So, using the `IN` keyword, you can do this:

```sql
SELECT 
    department_name 
FROM 
    department 
WHERE 
    location_id 
IN 
    (SELECT 
        location_id
    FROM 
        location
    WHERE country_id = 'US' or country_id = 'CA'
    );
```

---

# Finding and EliMINating NULLs in Queries
## Problem
## You need to report how many of your employee have a commission percentage as part of their remuneration, together with the number that get only a fixed salary. You track this using the COMMISSION_PCT field of the employee table.


## Solution
## The employee table allows the `commission_pct` to be NULL. Two queries can be used to find those whose commission percent IS NULL and those whose commission percent is non-NULL. First, here’s the query that finds employee with NULL commission percent:

```sql
SELECT 
    first_name, 
    last_name 
FROM employee
WHERE 
    commission_pct IS NULL;
```
## Now here’s the query that finds non-NULL commission-percentage holders:

```sql
SELECT 
    first_name, 
    last_name 
FROM employee
WHERE 
    commission_pct IS NOT NULL;
```

---
# Sorting as a Person Expects
## Problem
## Your textual data has been stored in a mix of uppercase, lowercase, and sentence case. You need to sort this data alphabetically as a person normally would, in a case-insensitive fashion.

---

# Enabling Other Sorting and Comparison Options
## Problem
## You need to perform case-insensitive comparisons and other sorting operations on textual data that has been stored in an assortment of uppercase, lowercase, and sentence case.

---

# SUMmarizing the Values in a Column
## Problem
## You need to SUMmarize data in a column in some way. For example, you have been asked to report on the average salary paid per employee, as well as the total salary budget, number of employee, highest and lowest earners, and more.

## Solution
## You don’t need to calculate a total and count the number of employee separately to deterMINe the average salary. The AVG function calculates average salary for you, as shown in the next SELECT statement.

```sql
SELECT AVG(salary) FROM employee;
AVG(SALARY)
6473.36449
```
## Note there is no WHERE clause in our recipe, meaning all rows in the employee table are assessed to calculate the overall average for the table’s rows. Functions such as AVG are termed aggregate functions, and there are many such functions at your disposal.


----

# SUMmarizing with COUNT( )
## Problem
## You want to count the number of rows in a table, the number of rows that match certain conditions, or the number of times that particular values occur.

## Solution
Use the COUNT( ) function.

## Discussion
## To display the contents of the rows in a table, you can use a `SELECT *` statement, but to count them instead, use `SELECT COUNT(*)`. Without a WHERE clause, the statement counts all the rows in the table.

```sql
SELECT COUNT(*) FROM states;
```
```
+----------+
| COUNT(*) |
+----------+
|   50 |
+----------+
```

## To count only the number of rows that match certain conditions, include an appropriate `WHERE` clause in a `SELECT COUNT(*)` statement. The conditions can be chosen to make `COUNT(*)` useful for answering many kinds of questions, for example:

## How many times did drivers travel more than 200 miles in a day?
```sql
SELECT COUNT(*) 
FROM driver_log 
WHERE miles_driven > 200;
```

## How many days did Suzi drive?
```sql
SELECT COUNT(*) 
FROM driver_log 
WHERE name = 'Suzi';
```

## How many states did the United States consist of at the beginning of the 20th century?
```sql
SELECT COUNT(*) 
FROM states 
WHERE statehood < '1900-01-01'::date;
```

## How many of those states joined the Union in the 19th century?
```sql
SELECT COUNT(*) 
FROM states
WHERE statehood 
BETWEEN '1800-01-01'::date AND '1899-12-31'::date;
```

## The COUNT( ) function actually has two forms. The form we’ve been using, COUNT(*), counts rows. The other form, COUNT( expr ), takes a column name or expression argument and counts the number of non-NULL values. The following statement shows how to produce both a row count for a table and a count of the number of non-NULL values its columns, using `AS` to make column aliases for readability:

```sql
SELECT 
    COUNT(*) AS all_ct, 
    COUNT(driver_name) AS name_ct,
    COUNT(truck_id) AS id_ct,
    COUNT(miles_driven) miles_ct, 
    COUNT(start_date) AS start_dt_ct,
    COUNT(end_date) AS end_dt_ct
FROM driver_log;
```
## output
```
 all_ct | name_ct | id_ct | miles_ct | start_dt_ct | end_dt_ct
--------+---------+-------+----------+-------------+-----------
   4044 |    4044 |  4044 |     4044 |        4044 |      3999
```

## The output above shows us that the `end_date` column contains 45 NULLs.


---

# SUMmarizing with MIN( ) and MAX( )
## Problem
## You need to deterMINe the smallest or largest of a set of values.

## Solution
## Use MIN( ) to find the smallest value, MAX( ) to find the largest.

## Discussion
## Finding smallest or largest values is somewhat akin to sorting, except that instead of producing an entire set of sorted values, you SELECT only a single value at one end or the other of the sorted range. This kind of operation applies to questions about smallest, largest, oldest, newest, most expensive, least expensive, and so forth. One way to find such values is to use the MIN( ) and MAX( ) functions.

## Because MIN( ) and MAX( ) deterMINe the extreme values in a set, they’re useful for characterizing ranges:
## What date range is represented by the rows in the mail table? What are the smallest and largest messages sent?
```sql
SELECT
    MIN(time_val) AS earliest, 
    MAX(time_val) AS latest,
    MIN(size) AS smallest, 
    MAX(size) AS largest
FROM mail;
```

```
+---------------------+---------------------+----------+---------+
| earliest            | latest              | smallest | largest |
+---------------------+---------------------+----------+---------+
| 2006-05-11 10:15:08 | 2006-05-19 22:21:51 |   271    | 2394482 |
+---------------------+---------------------+----------+---------+
```

## What are the shortest and longest trips in the driver_log table?

```sql
SELECT 
    MIN(miles) AS shortest, 
    MAX(miles) AS longest
FROM driver_log;
```


## What are the lowest and highest U.S. state populations?
```sql
SELECT 
    MIN(population) AS 'fewest people', 
    MAX(population) AS 'most people'
FROM states;
```

## MIN( ) and MAX( ) need not be applied directly to column values. They also work with expressions or values that are derived FROM column values. For example, to find the lengths of the shortest and longest state names, do this:

```sql
SELECT
MIN(LENGTH(name)) AS shortest,
MAX(LENGTH(name)) AS longest
FROM states;
```
+----------+---------+
| shortest | longest |
+----------+---------+
|   4      | 14      |
+----------+---------+


---

# SUMmarizing with SUM( ) and AVG( )
## Problem
## You need to add a set of numbers or find their average.

## Solution
## Use the SUM( ) or AVG( ) functions.

## Discussion
## SUM( ) and AVG( ) produce the total and average (mean) of a set of values:
## What is the total amount of mail traffic and the average size of each message?

```sql
SELECT 
    SUM(size) AS 'total traffic',
    AVG(size) AS 'average message size'
FROM mail;
```
+---------------+----------------------+
| total traffic | average message size |
+---------------+----------------------+
|   3798185     |   237386.5625        |
+---------------+----------------------+

## How many miles did the drivers in the driver_log table travel? What was the aver- age number of miles traveled per day?

```sql
SELECT
    SUM(miles) AS 'total miles',
    AVG(miles) AS 'average miles/day'
FROM driver_log;
```
```
+-------------+-------------------+
| total miles | average miles/day |
+-------------+-------------------+
|   2166      |  216.6000         |
+-------------+-------------------+
```

## What is the total population of the United States?
```sql
SELECT SUM(pop) FROM states;
```

---

## Using DISTINCT to EliMINate Duplicates
## Problem
## You want to know which values are present in a set of values, without displaying duplicate values multiple times. Or you want to know how many distinct values there are.

## Solution
## Use `DISTINCT` to SELECT unique values to count them.

## Discussion
## One summary operation that doesn’t use aggregate functions is to deterMINe which values or rows are contained in a dataset by eliMINating duplicates. Do this with DISTINCT. DISTINCT is useful for boiling down a query result, and often is combined with ORDER BY to place the values in more mean- ingful order. For example, to deterMINe the names of the drivers listed in the driver_log table, use the following statement:

```sql
SELECT DISTINCT name FROM driver_log ORDER BY name;
```
```
+-------+
| name |
+-------+
| Ben   |
| Henry |
| Suzi |
+-------+
```
## A statement without `DISTINCT` produces the same names, but is not nearly as easy to understand, even with a small dataset:

```sql
SELECT name FROM driver_log;
```
```
+-------+
| name |
+-------+
| Ben   |
| Suzi |
| Henry |
| Henry |
| Ben   |
| Henry |
| Suzi |
| Henry |
| Ben   |
| Henry |
+-------+
```

## To deterMINe how many different drivers there are, use COUNT(DISTINCT):
```
SELECT COUNT(DISTINCT name) FROM driver_log;
```
+----------------------+
| COUNT(DISTINCT name) |
+----------------------+
|   3                  |
+----------------------+
## Note: `COUNT(DISTINCT)` ignores NULL values. When used with multiple columns, `DISTINCT` shows the different combinations of values in the columns and `COUNT(DISTINCT)` counts the number of combinations. The following statements show the different sender/recipient pairs in the mail table and how many such pairs there are:

```sql
SELECT DISTINCT sender, recipient 
FROM mail
ORDER BY 
    sender, recipient;
```

## Output
```
+---------+---------+
| sender | recipient |
+---------+---------+
| barb  | barb  |
| barb  | tricia |
| gene  | barb  |
| gene  | gene  |
| gene  | tricia |
| phil  | barb  |
| phil  | phil  |
| phil  | tricia |
| tricia | gene |
| tricia | phil |
+---------+---------+
```

```sql
SELECT COUNT(DISTINCT sender, recipient) FROM mail;
```

```
+----------------------------------+
| COUNT(DISTINCT sender, recipient) |
+----------------------------------+
|   10                             |
+----------------------------------+
```

```
DISTINCT works with expressions, too, not just column values. To deterMINe the num- ber of hours of the day during which messages in the mail are sent, count the distinct HOUR( ) values:
```

```sql
SELECT COUNT(DISTINCT HOUR(t)) FROM mail;
```
```
+-------------------------+
| COUNT(DISTINCT HOUR(t)) |
+-------------------------+
|   12                    |
+-------------------------+
```

---

## Problem
## You want to know the values for other columns in the row that contains a minimum or maximum value.


## Solution
## Use two statements and a user-defined variable. Or use a subquery. Or use a join.

## Discussion
## MIN( ) and MAX( ) find the endpoints of a range of values, but sometimes when finding a minimum or maximum value, you’re also interested in other values FROM the row in which the value occurs. For example, you can find the largest state population like this:

```sql
SELECT MAX(population) FROM states;
```
```
+-----------------+
| MAX(population) |
+-----------------+
| 35893799        |
+-----------------+
```

## But that doesn’t show you which state has this population. The obvious attempt at getting that information looks like this:

## Note: This does NOT work
```sql
SELECT 
    MAX(population), name 
FROM states 
WHERE pop = MAX(population);
```

## Aggregate functions such as MIN( ) and MAX( ) CANNOT BE USED in WHERE clauses. Instead, do this:
```sql
SELECT 
    MAX(population), name 
FROM states 
WHERE pop = (SELECT MAX(population) FROM states);
```

---

## Problem
## You want to calculate a summary for each subgroup of a set of rows, not an overall summary value.

## Solution
## Use a GROUP BY clause to arrange rows into groups.

## Discussion
## The summary statements shown so far calculate summary values over all rows in the result set. For example, the following statement deterMINes the number of records in the mail table, and thus the total number of mail messages that have been sent:
```sql
SELECT COUNT(*) FROM mail;
```

```
+----------+
| COUNT(*) |
+----------+
|   16     |
+----------+
```

## Sometimes it’s desirable to break a set of rows into subgroups and SUMmarize each group. Do this by using aggregate functions in conjunction with a GROUP BY clause. To deterMINe the number of messages per sender, group the rows by sender name, count how many times each name occurs, and display the names with the counts:
```sql
SELECT sender, COUNT(*) FROM mail
GROUP BY sender;
```
+---------+----------+
| sender  | COUNT(*) |
+---------+----------+
| barb    |   3      |
| gene    |   6      |
| phil    |   5      |
| tricia  |   2      |
+---------+----------+
That query SUMmarizes the same column that is used for grouping (`sender`), but that’s not always necessary. Suppose that you want a quick characterization of the mail table, showing for each `sender` listed in it the total amount of traffic sent (in bytes) and the average number of bytes per message. In this case, you still use the `sender` column to place the rows in groups, but the summary functions operate on the size values:

```sql
SELECT sender,
SUM(size) AS 'total bytes',
AVG(size) AS 'bytes per message'
FROM mail GROUP BY sender;
```

```
Output
+---------+-------------+-------------------+
| sender | total bytes | bytes per message |
+---------+-------------+-------------------+
| barb    |   156696    |    52232.0000     |
| gene    |  1033108    |   172184.6667     |
| phil    |    18974    |     3794.8000     |
| tricia  |  2589407    |  1294703.5000     |
+---------+-------------+-------------------+
```
## Use as many grouping columns as necessary to achieve as fine-grained a summary as you require. The earlier query that shows the number of messages per sender is a coarse summary. To be more specific and find out how many messages each sender sent from each host, use two grouping columns. This produces a result with nested groups (groups within groups):

SELECT sender, srchost, COUNT(sender) FROM mail
GROUP BY sender, srchost;
+---------+---------+----------------+
| sender  | srchost | COUNT(sender) |
+---------+---------+----------------+

+---------+---------+----------------+

+---------+----------+
| sender  | COUNT(*) |
+---------+----------+
| barb    |   3      |
| gene    |   6      |
| phil    |   5      |
| tricia  |   2      |
+---------+----------+

## The preceding examples in this section have used COUNT( ), SUM( ), and AVG( ) for per- group SUMmaries. You can use MIN( ) or MAX( ), too. With a GROUP BY clause, they will tell you the smallest or largest value per group. The following query groups mail table rows by message sender, displaying for each the size of the largest message sent and the date of the most recent message:

```sql
SELECT sender, MAX(size), MAX(t) FROM mail GROUP BY sender;
```
```
Output
+---------+-----------+---------------------+
| sender | MAX(size) | MAX(t)  |
+---------+-----------+---------------------+
| barb  |   98151 | 2006-05-14 14:42:21 |
| gene  |   998532 | 2006-05-19 22:21:51 |
| phil  |   10294 | 2006-05-17 12:49:23 |
| tricia |  2394482 | 2006-05-14 17:03:01 |
+---------+-----------+---------------------+
```
## You can GROUP BY multiple columns and display a maximum for each combination of values in those columns. This query finds the size of the largest message sent BETWEEN each pair of sender and recipient values listed in the mail table:

```sql
SELECT 
    sender, 
    recipient, 
    MAX(size) 
FROM mail 
GROUP BY 
    sender, recipient;
```
```
+---------+---------+-----------+
| sender | recipient | MAX(size) |
+---------+---------+-----------+

+---------+---------+-----------+
```

## Watch out for the following trap! Make sure you only select nonsummary table columns that are **related** to the grouping columns. 
## Suppose that you want to know the longest trip per driver in the driver_log table. That’s produced by this query:

```sql
SELECT name, MAX(miles) AS 'longest trip'
FROM driver_log GROUP BY name;
```
```
+-------+--------------+
| name  | longest trip |
+-------+--------------+
| Ben   |   152        |
| Henry |   300        |
| Suzi |    502        |
+-------+--------------+
```
## But what if you also want to show the date on which each driver’s longest trip occurred? Can you just add travel_date to the output column list? Sorry, that won’t work!
```sql
-- This doesn't work
SELECT 
    name, 
    travel_date, 
    MAX(miles) AS 'longest trip'
FROM driver_log 
GROUP BY name;
```
## The query does produce a result but not all dates are correct!!! 
## So what’s going on? Why does the MAX() statement produce incorrect results? This happens because when you include a GROUP BY clause in a query, the only values that you can SELECT are the `grouped` columns or summary values calculated FROM the grouped column. 
## If you display additional table columns, they’re not tied to the grouped columns and the values displayed for them are indeterMINate!
So, since `travel_date` is not in the `GROUP BY`, SQL will not display the correct date!! 

For the problem at hand, one way to produce the desired results is as follows:

```sql
-- Correct way to get name, date, and miles of longest trip
SELECT d.name, d.travel_date, d.miles AS 'longest trip'
FROM driver_log AS d
INNER JOIN
    (SELECT 
        name, 
        MAX(miles) AS miles 
    FROM driver_log 
    GROUP BY name
    ) as t
USING (name, miles) 
ORDER BY name;
```
```
Output
+-------+------------+--------------+
| name  | travel_date  | longest trip |
+-------+------------+--------------+
| Ben   | 2006-08-30 |  152         |
| Henry | 2006-08-29 |  300         |
| Suzi  | 2006-09-02 |  502         |
+-------+------------+--------------+
```

---

## SUMmaries and NULL Values
## Problem
## You’re SUMmarizing a set of values that may include NULL values and you need to know how to interpret the results.

## Solution
## Understand how aggregate functions handle NULL values.

## Most aggregate functions ignore NULL values. Suppose that you have a table experiment that records experimental results for subjects who are to be given four tests each and that lists the test score as NULL for those tests that have not yet been adMINistered:
```sql
SELECT 
    subject, 
    test, 
    score 
FROM 
    experiment 
ORDER BY 
    subject, test;
```
```
Output
+---------+------+-------+
| subject | test | score |
+---------+------+-------+
| Jane    | A    |   47  |
| Jane    | B    |   50  |
| Jane    | C    |  NULL |
| Jane    | D    |  NULL |
| Marvin  | A    |   52  |
| Marvin  | B    |   45  |
| Marvin  | C    |   53  |
| Marvin  | D    |  NULL |
+---------+------+-------+
```
#By using a GROUP BY clause to arrange the rows by subject name, the number of tests taken by each subject, as well as the total, average, lowest, and highest scores can be calculated like this:

```sql
SELECT 
    subject,
    COUNT(score) AS n,
    SUM(score) AS total,
    AVG(score) AS average,
    MIN(score) AS  lowest,
    MAX(score) AS  highest
FROM experiment 
GROUP BY subject;
```
```
+---------+---+-------+---------+--------+---------+
| subject | n | total | average | lowest | highest |
+---------+---+-------+---------+--------+---------+
| Jane    | 2 |   97  | 48.5000 |  47    |    50   |
| Marvin  | 3 | 150   | 50.0000 | 45     |    53   |
+---------+---+-------+---------+--------+---------+
```
## You can see FROM the results in the column labeled n (number of tests) that the query counts only five values, even though the table contains eight. Why? Because the values in that column correspond to the number of non-NULL test scores for each subject. The other summary columns display results that are calculated only FROM the non-NULL scores as well.

## It makes a lot of sense for aggregate functions to ignore NULL values. If they followed the usual SQL arithmetic rules, adding NULL to any other value would produce a NULL result. That would make aggregate functions really difficult to use because you’d have to filter out NULL values every time you performed a summary, to avoid getting a NULL result. Ugh. By ignoring NULL values, aggregate functions become a lot more convenient.

## However, be aware that even though aggregate functions may ignore NULL values, some of them can still produce NULL as a result. This happens if there’s nothing to SUMmarize, which occurs if the set of values is empty or contains only NULL values. The following query is the same as the previous one, with one small difference. It selects only NULL test scores, so there’s nothing for the aggregate functions to operate on:

```sql
SELECT 
    subject,
    COUNT(score) AS n,
    SUM(score) AS total,
    AVG(score) AS average,
    MIN(score)   AS  lowest,
    MAX(score)  AS  highest
FROM experiment 
WHERE 
    score IS NULL 
GROUP BY subject;
```
```
+---------+---+-------+---------+--------+---------+
| subject | n | total | average | lowest | highest |
+---------+---+-------+---------+--------+---------+
| Jane    | 0 | NULL | NULL   | NULL  | NULL  |
| Marvin  | 0 | NULL | NULL | NULL  | NULL  |
+---------+---+-------+---------+--------+---------+
```

## For COUNT( ), the number of scores per subject is zero and is reported that way. On the other hand, SUM( ) , AVG( ), MIN( ), and MAX( ) return NULL when there are no values to SUMmarize. If you don’t want these functions to produce NULL in the query output, use `COALESCE( )` to map their results appropriately:

```sql
SELECT 
    subject,
    COUNT(score) AS n,
    COALESCE(SUM(score),0) AS total,
    COALESCE(AVG(score),0) AS average,
    COALESCE(MIN(score),'Unknown') AS lowest,
    COALESCE(MAX(score),'Unknown') AS highest
FROM experiment 
WHERE 
    score IS NULL 
GROUP BY 
    subject;
```
```
+---------+---+-------+---------+---------+---------+
| subject | n | total | average | lowest  | highest |
+---------+---+-------+---------+---------+---------+
| Jane  | 0 |   0 |  0.0000 | Unknown | Unknown |
| Marvin  | 0 | 0 |  0.0000 | Unknown | Unknown |
+---------+---+-------+---------+---------+---------+
```

## COUNT( ) is somewhat different with regard to NULL values than the other aggregate functions. Like other aggregate functions, COUNT( expr ) counts only non-NULL values, but COUNT(*) counts rows, regardless of their content. You can see the difference BETWEEN the forms of COUNT( ) like this:

```sql
SELECT 
    COUNT(*), 
    COUNT(score) 
FROM experiment;
```
```
+----------+--------------+
| COUNT(*) | COUNT(score) |
+----------+--------------+
|   8      | 5            |
+----------+--------------+
```
This tells us that there are eight rows in the experiment table but that only five of them have the score value filled in. The different forms of COUNT( ) can be very useful for counting missing values. Just take the difference:
```sql
SELECT 
    COUNT(*) - COUNT(score) AS missing 
FROM experiment;
```
```
+---------+
| missing |
+---------+
|   3     |
+---------+
```
## Missing and nonmissing counts can be deterMINed for subgroups as well. The following query does so for each subject, providing an easy way to assess the extent to which the experiment has been completed:
```sql
SELECT 
    subject,
    COUNT(*) AS total,
    COUNT(score) AS 'nonmissing',
    COUNT(*) - COUNT(score) AS missing
FROM experiment 
GROUP BY subject;
```
```
+---------+-------+-------------+---------+
| subject | total | nonmissing  | missing |
+---------+-------+-------------+---------+
| Jane    |     4 |           2 |       2 |
| Marvin  |     4 |           3 |       1 |
+---------+-------+-------------+---------+
```

---

# Selecting Only Groups with Certain Characteristics
## Problem
## You want to calculate group SUMmaries using AVG, MIN, MAX, etc, but display the results only for those groups that match certain criteria.

## Solution
## Use a HAVING clause.

## Discussion
## You’re familiar with the use of `WHERE` to specify conditions that individual rows must satisfy to be select by a statement. It’s natural, therefore, to use WHERE to write conditions that involve summary values. 
## The only trouble is that it doesn’t work! If you want to identify drivers in the `driver_log` table who drove more than three days, you’d probably first think to write the statement like this:

```sql
-- This doesn't work
SELECT COUNT(*), name
FROM driver_log
WHERE COUNT(*) > 3
GROUP BY name;
```

## The problem here is that `WHERE` specifies the initial constraints that deterMINe which rows to `SELECT`, but the value of `COUNT( )` can be deterMINed only after the rows have been selected. The solution is to put the `COUNT( )` expression in a `HAVING` clause instead. HAVING is analogous to WHERE, but it applies to group characteristics rather than to single rows. That is, `HAVING` operates on the already selected and grouped set of rows, applying additional constraints based on aggregate function results that aren’t known during the initial selection process. The preceding query therefore should be written like this:

```sql
-- This is correct
SELECT 
    COUNT(*), name
FROM 
    driver_log
GROUP BY 
    name
HAVING 
    COUNT(*) > 3;
```
```
+----------+-------+
| COUNT(*) | name |
+----------+-------+
|   5      | Henry |
+----------+-------+
```

## When you use HAVING, you can still include a WHERE clause —- but only to SELECT rows, not to test summary values. 
## HAVING can refer to aliases, so the previous query can be rewritten like this:

```sql
SELECT COUNT(*) AS count, name
FROM driver_log
GROUP BY name
HAVING count > 3;
```

```
+-------+-------+
| count | name  |
+-------+-------+
|   5   | Henry |
+-------+-------+
```


---

# Using Counts to DeterMINe Whether Values Are Unique
## Problem
## You want to know whether table values are unique.

## Solution
## Use HAVING in conjunction with COUNT( ).

## Discussion
## DISTINCT eliMINates duplicates but doesn’t show which values actually were duplicated in the original data. You can use HAVING to find unique values in situations to which DISTINCT does not apply. HAVING can tell you which values were unique or nonunique.
## The following statements show the days on which only one driver was active, and the days on which more than one driver was active. They’re based on using HAVING and COUNT( ) to deterMINe which travel_date values are unique or nonunique:
```sql
SELECT travel_date, COUNT(travel_date)
FROM driver_log
GROUP BY travel_date
HAVING COUNT(travel_date) = 1;
```
```
+------------+------------------+
| travel_date  | COUNT(travel_date) |
+------------+------------------+
| 2006-08-26 |  1 |
| 2006-08-27 |  1 |
| 2006-09-01 |  1 |
+------------+------------------+
```
```sql
SELECT travel_date, COUNT(travel_date)
FROM driver_log
GROUP BY travel_date
HAVING COUNT(travel_date) > 1;
```
```
+------------+------------------+
| travel_date  | COUNT(travel_date) |
+------------+------------------+
| 2006-08-29 |  3 |
| 2006-08-30 |  2 |
| 2006-09-02 |  2 |
+------------+------------------+
```
## This technique works for combinations of values, too. For example, to find message sender/recipient pairs BETWEEN whom only one message was sent, look for combinations that occur only once in the mail table:
```sql
SELECT sender, recipient
FROM mail
GROUP BY sender, recipient
HAVING COUNT(*) = 1;
```
```
+---------+---------+
| sender | recipient|
+--------+----------+
| barb   | barb     |
| gene   | tricia   |
| phil   | barb     |
| tricia | gene     |
| tricia | phil     |
+---------+---------+
```
##  Note that this query doesn’t print the count. The first two examples did so, to show that the counts were being used properly, but you can refer to an aggregate value in a HAVING clause without including it in the output column list.


---

# Grouping by Expression Results
## Problem
## You want to group rows into subgroups based on values calculated FROM an expression.

## Solution
## Put the expression in the GROUP BY clause.
## Discussion
## GROUP BY, like ORDER BY, can refer to expressions. This means you can use calculations as the basis for grouping. For example, to find the distribution of the lengths of state names, use those lengths as the grouping characteristic:
```sql
SELECT 
    CHAR_LENGTH(name), 
    COUNT(*)
FROM states 
GROUP BY CHAR_LENGTH(name);
```

### As with ORDER BY, you can write the grouping expression directly in the GROUP BY clause, or use an alias for the expression (if it appears in the output column list), and refer to the alias in the GROUP BY.
### You can GROUP BY multiple expressions if you like. To find days of the year on which more than one state joined the Union, GROUP BY statehood month and day, and then use HAVING and COUNT( ) to find the nonunique combinations:
```sql
SELECT
    date_part('month', statehood) AS month,
    date_part('day', statehood) AS day,
    COUNT(*) AS count
FROM states 
GROUP BY 
    month, day 
HAVING count > 1;
```
```
+----------+------+-------+
| month    | day  | count |
+----------+------+-------+
| February |  14  |     2 |
| June     |   1  |     2 |
| March    |   1  |     2 |
| May      |  29  |     2 |
| November |   2  |     2 |
+----------+------+-------+
```

---

# Categorizing Noncategorical Data
## Problem
## You need to SUMmarize a set of values that are not naturally categorical.
## Solution
## Use an expression to group the values into categories.

## Discussion
## One important application for group rows by expression results is to provide categories for values that are not particularly categorical. This is useful because `GROUP BY` works best for columns with repetitive values. For ex- ample, you might attempt to perform a population analysis by grouping rows in the states table using values in the pop column. As it happens, that does not work very well due to the high number of distinct values in the column. In fact, they’re all distinct, as the following query shows:

```sql
SELECT 
    COUNT(population), 
    COUNT(DISTINCT population) 
FROM states;
```
+------------+------------------------------------+
| COUNT(population) | COUNT(DISTINCT population)  |
+------------+------------------------------------+
|   50              |           50                |
+------------+------------------------------------+
## In situations like this, WHERE values do not group nicely into a small number of sets, you can use a transformation that forces them into categories. Begin by deterMINing the range of population values:
```sql
SELECT 
    MIN(population), 
    MAX(population) 
FROM states;
```
+----------+----------+
| MIN(pop) | MAX(pop) |
+----------+----------+
|   506529 | 35893799 |
+----------+----------+
You can see from that result that if you divide the pop values by five million, they’ll group into six categories—a reasonable number. (The category ranges will be 1 to 5,000,000, 5,000,001 to 10,000,000, and so forth.) To put each population value in the proper category, divide by five million, and use the integer result:
```sql
-- This is not correct
SELECT 
    FLOOR(pop/5000000) AS 'MAX population (millions)',
    COUNT(*) AS 'number of states'
FROM 
    states 
GROUP BY 
    'MAX population (millions)';
```

## Hmm. That’s not quite right. The expression groups the population values into a small number of categories, all right, but doesn’t report the category values properly. Let’s try multiplying the FLOOR( ) results by five:
```sql
-- This is not correct
SELECT FLOOR(pop/5000000)*5 AS 'MAX population (millions)',
COUNT(*) AS 'number of states'
FROM states GROUP BY 'MAX population (millions)';
```

## That still isn’t correct. The maximum state population was 35,893,799, which should go into a category for 40 million, not one for 35 million. The problem here is that the category-generating expression groups values toward the lower bound of each category. To group values toward the upper bound instead, use the following technique. For categories of size n, you can place a value x into the proper category using this expression: FLOOR((x+(n-1))/n)
## So the final form of our query looks like this:
```sql
-- This is correct
SELECT 
    FLOOR((pop+4999999)/5000000)*5 AS 'MAX population (millions)',
    COUNT(*) AS 'number of states'
FROM states 
GROUP BY 
    'MAX population (millions)';
```

## The result shows clearly that the majority of U.S. states have a population of five million or less. This technique works for all kinds of numeric values.
## In some instances, it may be more appropriate to categorize groups on a logarithmic scale. 
## For example, the state population values can be treated that way as follows:

```sql
SELECT 
    FLOOR(LOG10(pop)) AS 'log10(population)',
    COUNT(*) AS 'number of states'
FROM states 
GROUP BY 
    'log10(population)';
```
```
+-------------------+------------------+
| log10(population) | number of states |
+-------------------+------------------+
|   5               |                7 |
|   6               |               35 |
|   7               |                8 |
+-------------------+------------------+
```
## The query shows the number of states that have populations measured in hundreds of thousands, millions, and tens of millions, respectively.

# How Repetitive Is a Set of Values?
## To assess how much repetition is present in a set of values, use the ratio of COUNT(DISTINCT) and COUNT( ). If all values are unique, both counts will be the same and the ratio will be 1. This is the case for the t values in the mail table and the pop values in the states table:
```sql
SELECT COUNT(DISTINCT t) / COUNT(t) FROM mail;
```
```
+------------------------------+
| COUNT(DISTINCT t) / COUNT(t) |
+------------------------------+
|   1.0000                     |
+------------------------------+
```
```sql
SELECT COUNT(DISTINCT pop) / COUNT(pop) FROM states;
```
+----------------------------------+
| COUNT(DISTINCT pop) / COUNT(pop) |
+----------------------------------+
|   1.0000                         |
+----------------------------------+
#For a more repetitive set of values, COUNT(DISTINCT) will be less than COUNT( ), and the ratio will be smaller:
```sql
SELECT COUNT(DISTINCT name) / COUNT(name) FROM driver_log;
```
```
+------------------------------------+
| COUNT(DISTINCT name) / COUNT(name) |
+------------------------------------+
|   0.3000 |
+------------------------------------+
```
## What’s the practical use for this ratio? A result close to zero indicates a high degree of repetition, which means the values will group into a small number of categories natu- rally. A result of 1 or close to it indicates many unique values.

---

# Finding Smallest or Largest summary Values
## Problem
## You want to compute per-group summary values but display only the smallest or largest of them.

## Solution
## Add a LIMIT clause to the statement.

## Discussion
## MIN( ) and MAX( ) find the values at the endpoints of a range of values, but if you want to know the extremes of a set of summary values, those functions won’t work. The arguments to MIN( ) and MAX( ) cannot be other aggregate functions. For example, you can easily find per-driver mileage totals:
```sql
SELECT name, SUM(miles)
FROM driver_log
GROUP BY name;
```
```
+-------+------------+
| name  | SUM(miles) |
+-------+------------+
| Ben   |   362 |
| Henry |   911 |
| Suzi |    893 |
+-------+------------+
```
## But this doesn’t work if you want to SELECT only the row for the driver with the most miles:
```sql
-- This doesn't work
SELECT name, SUM(miles)
FROM driver_log
GROUP BY name
HAVING SUM(miles) = MAX(SUM(miles));
```

## Instead, you have to order the rows with the largest SUM( ) values first, and use LIMIT to SELECT the first row:
```sql
SELECT 
    name, 
    SUM(miles) AS 'total miles'
FROM driver_log
GROUP BY 
    name
ORDER BY 
    'total miles' DESC 
LIMIT 1;
```
```
+-------+-------------+
| name  | total miles |
+-------+-------------+
| Henry |   911       |
+-------+-------------+
```

## Note that if there is more than one row with the given summary value, a LIMIT 1 query won’t tell you that. For example, you might attempt to ascertain the most common initial letter for state names like this:

```sql
SELECT 
    LEFT(name,1) AS letter, 
    COUNT(*) AS count 
FROM states
GROUP BY 
    letter 
ORDER BY 
    count DESC 
LIMIT 1;
```
+--------+-------+
| letter | count |
+--------+-------+
| M       |    8 |
+--------+-------+
## But eight state names also begin with N. If you need to know *all* of most-frequent values when there may be more than one of them, find the maximum count first, and then SELECT those values with a count that matches the maximum:
SET @MAX = (SELECT COUNT(*) FROM states
GROUP BY LEFT(name,1) ORDER BY COUNT(*) DESC LIMIT 1);

```sql
SELECT 
    LEFT(name,1) AS letter, 
    COUNT(*) AS count 
    FROM 
        states
GROUP BY 
    letter 
HAVING 
    count = (
        SELECT COUNT(*) 
        FROM states
        GROUP BY LEFT(name,1) 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
        );
```
```
+--------+-------+
| letter | count |
+--------+-------+
| M      | 8     |
| N      | 8     |
+--------+-------+
```
## Alternatively, put the maximum-count calculation in a subquery and combine the statements into one:
```sql
SELECT 
    LEFT(name,1) AS letter, 
    COUNT(*) AS count,
    FROM states
GROUP BY  
    letter  
HAVING  count =
        (SELECT  COUNT(*)  
        FROM states
        GROUP BY LEFT(name,1) 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
        );
```
```
+--------+-------+
| letter | count |
+--------+-------+
| M | 8 |
| N | 8 |
+--------+-------+
```

---

# Date-Based SUMmaries
## Problem
## You want to produce a summary based on date or time values.

## Solution
## Use GROUP BY to place temporal values into categories of the appropriate duration. Often this involves using expressions to EXTRACT the significant parts of dates or times.

## Discussion
## To put rows in time order, use an ORDER BY clause to sort a column that has a temporal type. If instead you want to SUMmarize rows based on groupings into time intervals, you need to deterMINe how to categorize each row into the proper interval and use GROUP BY to group them accordingly.
## For example, to deterMINe how many drivers were on the road and how many miles were driven each day, group the rows in the driver_log table by date:
```sql
SELECT 
    travel_date,
    COUNT(*) AS 'number of drivers', 
    SUM(miles) AS 'miles logged'
FROM driver_log 
GROUP BY travel_date;
```

## However, this summary will grow lengthier as you add more rows to the table. At some point, the number of distinct dates likely will become so large that the summary fails to be useful, and you’d probably decide to change the category size FROM daily to weekly or monthly.
## When a temporal column contains so many distinct values that it fails to categorize well, it’s typical for a summary to group rows using expressions that map the relevant parts of the date or time values onto a smaller set of categories. 
## For example, to produce a time-of-day summary for rows in the mail table, do this:
```sql
SELECT HOUR(t) AS hour,
COUNT(*) AS 'number of messages',
SUM(size) AS 'number of bytes sent'
FROM mail
GROUP BY hour;
```

## To produce a day-of-week summary instead, use the date_part() function:
```sql
SELECT 
    date_part('dow', t) AS weekday,
    COUNT(*) AS 'number of messages',
    SUM(size) AS 'number of bytes sent'
FROM mail
GROUP BY weekday;
```

## Note that the result includes an entry only for hours of the day actually represented in the data. 

---
# SUMmarizing Data for Different Groups
## Problem
## You want to SUMmarize data in a column, but you don’t want to SUMmarize over all the rows in a table. You want to divide the rows into groups, and then SUMmarize the column separately for each group. For example, you need to know the average salary paid per department.

## Solution
## Use SQL’s GROUP BY feature to group common subsets of data together to apply functions like COUNT, MIN, MAX, SUM, and AVG. This SQL statement shows how to use an aggregate function on subgroups of your data with GROUP BY.

```sql
SELECT department_id, AVG(salary) FROM employee
GROUP BY department_id;
```

---

# Grouping Data by Multiple Fields
## Problem
## You need to report data grouped by multiple values simultaneously. For example, an HR department may need to report on minimum, average, and maximum SALARY by DEPARTMENT_ID and JOB_ID.

## Solution
## GROUP BY capabilities extend to an arbitrary number of columns and expressions, so we can extend the previous recipe to encompass our new grouping requirements. We know what we want aggregated: the SALARY value aggregated three different ways. That leaves the DEPARTMENT_ID and JOB_ID to be grouped. We also want our results ordered so we can see different JOB_ID values in the same department in context, FROM highest SALARY to lowest. The next SQL statement achieves this by adding the necessary criteria to the GROUP BY and ORDER BY clauses.

```sql
SELECT 
    department_id, 
    job_id, 
    MIN(salary), 
    AVG(salary), 
    MAX(salary) 
FROM 
    employee
GROUP BY 
    department_id, 
    job_id
ORDER BY 
    department_id, 
    MAX(salary) desc;
```

---

# Using ORDER BY to Sort Query Results
## Problem
## Output rows FROM a query don’t come out in the order you want.

## Solution
## Add an ORDER BY clause to the query to sort the result rows.

## Discussion
## The contents of the driver_log and mail tables shown in the chapter introduction are disorganized and difficult to make any sense of. The exception is that the values in the id and t columns are in order, but that’s just coincidental. Rows do tend to be returned FROM a table in the order they were originally inserted, but only until the table is subjected to delete and update operations. Rows inserted after that are likely to be returned in the middle of the result set somewhere. Many SQL users notice this disturbance in row retrieval order, which leads them to ask, “How can I store rows in my table so they come out in a particular order when I retrieve them?” The answer to this question is, “That’s the wrong question.” Storing rows is the server’s job, and you should let the server do it. Besides, even if you can specify storage order, how would that help you if you want to see results sorted in different orders at different times?
## When you `SELECT` rows, they’re pulled out of the database and returned in whatever order the server happens to use. This order might change, even for statements that don’t sort rows, depending on which index the server happens to use when it executes a statement, because the index can affect the retrieval order. Even if your rows appear to come out in the proper order naturally, a relational database makes no guarantee about the order in which it returns rows—unless you tell it how. To arrange the rows from a query result into a specific order, sort them by adding an `ORDER BY` clause to your `SELECT` statement. Without `ORDER BY`, you may find that the retrieval order changes when you modify the contents of your table. With an `ORDER BY` clause, SQL will always sort rows the way you indicate.
## ORDER BY has the following general characteristics:
## You can sort using a single column of values or multiple columns.
## You can sort any column in either ascending order (the default) or descending order.
## You can refer to sort columns by name or by using an alias.
## This section shows some basic sorting techniques, such as how to name the sort columns and specify the sort direction. The following sections illustrate how to perform more complex sorts. 
## The following set of examples demonstrates how to sort on a single column or multiple columns and how to sort in ascending or descending order. The examples SELECT the rows in the driver_log table but sort them in different orders so that you can compare the effect of the different ORDER BY clauses.

```sql
-- This query produces a single-column sort using the driver name:
SELECT * 
FROM driver_log 
ORDER BY name;
```
```
+--------+-------+------------+-------+
| rec_id | name  | travel_date  | miles |
+--------+-------+------------+-------+
|   1 | Ben | 2006-08-30 |  152 |
|   9 | Ben | 2006-09-02 |  79 |
|   5 | Ben | 2006-08-29 |  131 |
|   8 | Henry | 2006-09-01 |    197 |
|   6 | Henry | 2006-08-26 |    115 |
|   4 | Henry | 2006-08-27 |    96 |
|   3 | Henry | 2006-08-29 |    300 |
|   10 | Henry | 2006-08-30 |   203 |
|   7 | Suzi  | 2006-09-02 |    502 |
|   2 | Suzi  | 2006-08-29 |    391 |
+--------+-------+------------+-------+
```

## The default sort direction is ascending. You can make the direction for an ascending sort explicit by adding ASC after the sorted column’s name:
```sql
SELECT * FROM driver_log ORDER BY name ASC;
```
## The opposite (or reverse) of ascending order is descending order, specified by adding DESC after the sorted column’s name:

```sql
SELECT * FROM driver_log ORDER BY name DESC;
```

## If you closely examine the output from the queries just shown, you’ll notice that although the rows are sorted by name, the rows for any given name aren’t in any special order. (The travel_date values aren’t in date order for Henry or Ben, for example.) That’s because SQL doesn’t sort something unless you tell it to.
## The overall order of rows returned by a query is indeterMINate unless you specify an ORDER BY clause.
## Within a group of rows that sort together based on the values in a given column, the order of values in other columns also is indeterMINate unless you name them in the ORDER BY clause.
## To more fully control output order, specify a multiple-column sort by listing each col- umn to use for sorting, separated by commas. The following query sorts in ascending ORDER BY name and by travel_date within the rows for each name:
```sql
SELECT * FROM driver_log ORDER BY name, travel_date;
```
```
+--------+-------+------------+-------+
| rec_id | name  | travel_date  | miles |
+--------+-------+------------+-------+
|   5 | Ben | 2006-08-29 |  131 |
|   1 | Ben | 2006-08-30 |  152 |
|   9 | Ben | 2006-09-02 |  79 |
|   6 | Henry | 2006-08-26 |    115 |
|   4 | Henry | 2006-08-27 |    96 |
|   3 | Henry | 2006-08-29 |    300 |
|   10 | Henry | 2006-08-30 |   203 |
|   8 | Henry | 2006-09-01 |    197 |
|   2 | Suzi  | 2006-08-29 |    391 |
|   7 | Suzi  | 2006-09-02 |    502 |
+--------+-------+------------+-------+
```

## Multiple-column sorts can be descending as well, but DESC must be specified after each column name to perform a fully descending sort.
```sql
SELECT * 
FROM driver_log 
ORDER BY name DESC, travel_date DESC;
```
```
Multiple-column `ORDER BY` clauses can perform mixed-order sorting WHERE some col- umns are sorted in ascending order and others in descending order. The following query sorts by name in descending order and then by travel_date in ascending order for each name.
```

```sql
SELECT * FROM driver_log ORDER BY name DESC, travel_date;
```

## The `ORDER BY` clauses in the queries shown thus far refer to the sorted columns by name. You can also name the columns by using aliases. That is, if an output column has an alias, you can refer to the alias in the `ORDER BY` clause:

```sql
SELECT 
    name, 
    travel_date, 
    miles AS distance 
FROM driver_log
ORDER BY distance;
```
+-------+------------+----------+
| name  | travel_date  | distance |
+-------+------------+----------+

| Henry | 2006-08-30 |  203 |
| Henry | 2006-08-29 |  300 |
| Suzi  | 2006-08-29 |  391 |
| Suzi  | 2006-09-02 |  502 |
+-------+------------+----------+

## Columns specified by aliases can be sorted in either ascending or descending order, just like named columns.

```sql
SELECT 
    name, 
    travel_date, 
    miles AS distance 
FROM driver_log
ORDER BY distance DESC;
```

# Using Expressions for Sorting
## Problem
## You want to sort a query result based on values calculated FROM a column, rather than using the values actually stored in the column.

## Solution
## Put the expression that calculates the values in the ORDER BY clause.
## Discussion
## One of the columns in the mail table shows how large each mail message is, in bytes:

```sql
SELECT * FROM mail;
```
```
+---------------------+---------+---------+---------+---------+---------+
| t | sender | srchost | recipient | dsthost | size  |
+---------------------+---------+---------+---------+---------+---------+
| 2006-05-11 10:15:08 | barb    | saturn  | tricia | mars   |   58274 |
| 2006-05-12 12:48:13 | tricia | mars   | gene  | venus | 194925 |
| 2006-05-12 15:02:49 | phil    | mars  | phil  | saturn |  1048 |
| 2006-05-13 13:59:18 | barb    | saturn  | tricia | venus  |   271 |
...
```
## Suppose that you want to retrieve rows for “big” mail messages (defined as those larger than 50,000 bytes), but you want them to be displayed and sorted by sizes in terms of kilobytes, not bytes. In this case, the values to sort are calculated by an expression: FLOOR((size+1023)/1024)
## Wondering about the +1023 in the FLOOR( ) expression? That’s there so that size values group to the nearest upper boundary of the 1024-byte categories. Without it, the values `GROUP BY` lower boundaries (for example, a 2047-byte message would be reported as HAVING a size of 1 kilobyte rather than 2).
## There are two ways to use an expression for sorting query results. First, you can put the expression directly in the `ORDER BY` clause:

```sql
SELECT t, sender, FLOOR((size+1023)/1024)
FROM mail WHERE size > 50000
ORDER BY FLOOR((size+1023)/1024);
```
```
+---------------------+---------+-------------------------+
| t                   | sender  | FLOOR((size+1023)/1024) |
+---------------------+---------+-------------------------+
| 2006-05-11 10:15:08 | barb    |   57                    |
| 2006-05-14 14:42:21 | barb    |   96                    |
| 2006-05-12 12:48:13 | tricia |    191                   |
| 2006-05-15 10:25:52 | gene    |   976                   |
| 2006-05-14 17:03:01 | tricia |    2339                  |
+---------------------+---------+-------------------------+
```
## Second, if you are sorting by an expression named in the output column list, you can give it an alias and refer to the alias in the ORDER BY clause:

```sql
SELECT 
    t, 
    sender, 
    FLOOR((size+1023)/1024) AS kilobytes
FROM mail 
WHERE 
    size > 50000
ORDER BY 
    kilobytes;
```

## Although you can write the `ORDER BY` clause either way, there are at least two reasons you might prefer to use the alias method:
## It’s easier to write the alias in the `ORDER BY` clause than to repeat the (rather cumbersome) expression and if you change one, you’ll need to change the other. The alias may be useful for display purposes, to provide a more meaningful column label. Note how the third column heading for the second of the two preceding queries is more meaningful.

---

# Displaying One Set of Values While Sorting by Another
## Problem
## You want to sort a result set using values that you’re not selecting.

## Solution
## That’s not a problem. You can use columns in the `ORDER BY` clause that don’t appear in the output column list.

## Discussion
## `ORDER BY` is not limited to sorting only those columns named in the output column list. It can sort using values that are “hidden” (that is, not displayed in the query output). This technique is commonly used when you have values that can be represented dif- ferent ways and you want to display one type of value but sort by another. For example, you may want to display mail message sizes not in terms of bytes, but as strings such as 103K for 103 kilobytes. You can convert a byte count to that kind of value using this expression:`CONCAT(FLOOR((size+1023)/1024),'K')`
## However, such values are strings, so they sort lexically, not numerically. If you use them for sorting, a value such as 96K sorts after 2339K, even though it represents a smaller number:

```sql
SELECT t, sender,
CONCAT(FLOOR((size+1023)/1024),'K') AS size_in_K
FROM mail WHERE size > 50000
ORDER BY size_in_K;
```
+---------------------+---------+-----------+
| t                   | sender  | size_in_K |
+---------------------+---------+-----------+
| 2006-05-12 12:48:13 | tricia  | 191K      |
| 2006-05-14 17:03:01 | tricia  | 2339K     |
| 2006-05-11 10:15:08 | barb    | 57K       |
| 2006-05-14 14:42:21 | barb    | 96K       |
| 2006-05-15 10:25:52 | gene    | 976K      |
+---------------------+---------+-----------+

## To achieve the desired output order, display the string, but use the actual numeric size for sorting:

```sql
SELECT t, sender,
CONCAT(FLOOR((size+1023)/1024),'K') AS size_in_K
FROM mail WHERE size > 50000
ORDER BY size;
```
```
+---------------------+---------+-----------+
| t                   | sender  | size_in_K |
+---------------------+---------+-----------+
| 2006-05-11 10:15:08 | barb    |     57K   |
| 2006-05-14 14:42:21 | barb    |     96K   |
| 2006-05-12 12:48:13 | tricia |      191K  |
| 2006-05-15 10:25:52 | gene    |     976K  |
| 2006-05-14 17:03:01 | tricia |     2339K  |
+---------------------+---------+-----------+
```
## Displaying values as strings but sorting them as numbers also can bail you out of some otherwise difficult situations. Members of sports teams typically are assigned a jersey number, which normally you might think should be stored using a numeric column. Not so fast! Some players like to have a jersey number of zero (0), and some like double-zero (00). If a team happens to have players with both numbers, you cannot represent them using a numeric column, because both values will be treated as the same number. The way out of the problem is to store jersey numbers as strings:

```sql
CREATE TABLE roster (
name CHAR(30),   # player name 
jersey_num CHAR(3)    # jersey number
);
```
## Then the jersey numbers will display the same way you enter them, and 0 and 00 will be treated as distinct values. Unfortunately, although representing numbers as strings solves the problem of distinguishing 0 and 00, it introduces a different problem. Suppose that a team has the following players:

```sql
SELECT name, jersey_num FROM roster;
```
```
+-----------+------------+
| name      | jersey_num |
+-----------+------------+
| Lynne     | 29         |
| Ella      | 0          |
| Elizabeth | 100        |
| Nancy     | 00         |
| Jean      | 8          |
| Sherry    | 47         |
+-----------+------------+
```

## The problem occurs when you try to sort the team members by jersey number. If those numbers are stored as strings, they’ll sort lexically, and lexical order often differs FROM numeric order. That’s certainly true for the team in question:

```sql
SELECT name, jersey_num FROM roster ORDER BY jersey_num;
```
```
+-----------+------------+
| name  | jersey_num |
+-----------+------------+
| Ella  | 0 |
| Nancy | 00    |
| Elizabeth | 100   |
| Lynne | 29    |
| Sherry    | 47    |
| Jean  | 8 |
+-----------+------------+
```

## The values 100 and 8 are out of place. But that’s easily solved. Display the string values, but use the numeric values for sorting. To accomplish this, add zero to the jersey_num values to force a string-to-number conversion:

```sql
-- this might not work??
SELECT 
    name, 
    jersey_num 
FROM roster 
ORDER BY jersey_num+0;
```
+-----------+------------+
| name  | jersey_num |
+-----------+------------+
| Ella  | 0 |
| Nancy | 00    |
| Jean  | 8 |
| Lynne | 29    |
| Sherry    | 47    |
| Elizabeth | 100   |
+-----------+------------+

## The technique of displaying one value but sorting by another is also useful when you want to display composite values that are formed FROM multiple columns but that don’t sort the way you want. For example, the mail table lists message senders using separate sender and srchost values. If you want to display message senders FROM the mail table as email addresses in sender@srchost format with the username first, you can construct those values using the following expression: `CONCAT(sender,'@',srchost)`
## However, those values are no good for sorting if you want to treat the hostname as more significant than the username. Instead, sort the results using the underlying column values rather than the displayed composite values:

```sql
SELECT t, CONCAT(sender,'@',srchost) AS sender, size
FROM mail WHERE size > 50000
ORDER BY srchost, sender;
```
```
+---------------------+---------------+---------+
| t | sender    | size  |
+---------------------+---------------+---------+
| 2006-05-15 10:25:52 | gene@mars   |  998532 |
| 2006-05-12 12:48:13 | tricia@mars |  194925 |
| 2006-05-11 10:15:08 | barb@saturn |   58274 |
| 2006-05-14 17:03:01 | tricia@saturn | 2394482 |
| 2006-05-14 14:42:21 | barb@venus  |   98151 |
+---------------------+---------------+---------+
```

## The same idea commonly is applied to sorting people’s names. Suppose that you have a table names that contains last and first names. To display rows sorted by last name first, the query is straightforward when the columns are displayed separately:

```sql
SELECT last_name, first_name FROM name
ORDER BY last_name, first_name;
```
```
+-----------+------------+
| last_name | first_name |
+-----------+------------+
| Blue  | Vida  |
| Brown | Kevin |
| Gray  | Pete  |
| White | Devon |
| White | Rondell   |
+-----------+------------+
```

## If instead you want to display each name as a single string composed of the first name, a space, and the last name, you can begin the query like this:
`SELECT CONCAT(first_name,' ',last_name) AS full_name FROM name` ...
But then how do you sort the names so they come out in the last name order? The answer is to display the composite names, but refer to the constituent values in the `ORDER BY` clause:

```sql
SELECT CONCAT(first_name,' ',last_name) AS full_name
FROM name
ORDER BY last_name, first_name;
```
```
+---------------+
| full_name     |
+---------------+
| Vida Blue     |
| Kevin Brown   |
| Pete Gray     |
| Devon White   |
| Rondell White |
+---------------+
```

---

# Sorting by Calendar Day
## Problem
## You want to sort by day of the calendar year.

## Solution
## Sort using the month and day of date values, ignoring the year.

## Discussion
## Sorting in calendar order differs from sorting by date. You need to ignore the year part of the dates and sort using only the month and day to order rows in terms of where they fall during the calendar year. Suppose that you have an event table that looks like this when values are ordered by actual date of occurrence:

```sql
SELECT  date,  description  FROM  event  ORDER  BY date;
```
```
+------------+-------------------------------------+
| date  | description   |
+------------+-------------------------------------+
| 1215-06-15 | Signing of the Magna Carta   |
| 1732-02-22 | George Washington's birthday |
| 1776-07-14 | Bastille Day |
| 1789-07-04 | US Independence Day  |
| 1809-02-12 | Abraham Lincoln's birthday   |
| 1919-06-28 | Signing of the Treaty of Versailles |
| 1944-06-06 | D-Day at Normandy Beaches    |
| 1957-10-04 | Sputnik launch date  |
| 1958-01-31 | Explorer 1 launch date   |
| 1989-11-09 | Opening of the Berlin Wall   |
+------------+-------------------------------------+
```

## To put these items in calendar order, sort them by month, and then by day within month:

```sql
SELECT 
    date, 
    description 
FROM event
ORDER BY date_part('month',date), date_part('day',date);
```
+------------+-------------------------------------+
| date       | description                         |
+------------+-------------------------------------+
| 1958-01-31 | Explorer 1 launch date              |
| 1809-02-12 | Abraham Lincoln's birthday          |
| 1732-02-22 | George Washington's birthday        |
| 1944-06-06 | D-Day at Normandy Beaches           |
| 1215-06-15 | Signing of the Magna Carta          |
| 1919-06-28 | Signing of the Treaty of Versailles |
| 1789-07-04 | US Independence Day                 |
| 1776-07-14 | Bastille Day                        |
| 1957-10-04 | Sputnik launch date                 |
| 1989-11-09 | Opening of the Berlin Wall          |
+------------+-------------------------------------+

# Sorting by Day of Week
## Problem
## You want to sort rows in day-of-week order.

## Solution
Use date_part('dow', field) to convert a date column to its numeric day-of-week value.

# Sorting by Time of Day
## Problem
## You want to sort rows in time-of-day order.

## Solution
## Pull out the hour, minute, and second from the column that contains the time, and use them for sorting.

## Discussion


---

# Sorting by Fixed-Length Substrings
## Problem
## You want to sort using parts of a column that occur at a given position within the column.

## Solution
## Pull out the parts you need with LEFT(), MID(), or RIGHT(), and sort them.

## Discussion
## Suppose that you have a housewares table that acts as a catalog for houseware furnish- ings, and that items are identified by 10-character ID values consisting of three subparts: a three-character category abbreviation (such as DIN for “dining room” or KIT for “kitchen”), a five-digit serial number, and a two-character country code indicating WHERE the part is manufactured:

```sql
SELECT * FROM housewares;
```
```
+------------+------------------+
| id         | description      |
+------------+------------------+
| DIN40672US | dining table     |
| KIT00372UK | garbage disposal |
| KIT01729JP | microwave oven   |
| BED00038SG | bedside lamp     |
| BTH00485US | shower stall     |
| BTH00415JP | lavatory         |
+------------+------------------+
```
## This is not necessarily a good way to store complex ID values, and later we’ll consider how to represent them using separate columns. But for now, assume that the values must be stored as just shown. If you want to sort rows from this table based on the id values, just use the entire column value:

```sql
SELECT * FROM housewares ORDER BY id;
```
```
+------------+------------------+
| id    | description           |
+------------+------------------+
| BED00038SG | bedside lamp     |
| BTH00415JP | lavatory         |
| BTH00485US | shower stall     |
| DIN40672US | dining table     |
| KIT00372UK | garbage disposal |
| KIT01729JP | microwave oven   |
+------------+------------------+
```

## But you might also have a need to sort on any of the three subparts (for example, to sort by country of manufacture). For that kind of operation, it’s helpful to use functions that pull out pieces of a column, such as `LEFT()`, `MID()`, and `RIGHT()`. These functions can be used to break apart the id values into their three components:

```sql
SELECT 
    id,
    LEFT(id,3) AS category,
    MID(id,4,5) AS serial,
    RIGHT(id,2) AS  country
FROM housewares;
```
```
Any of those fixed-length substrings of the id values can be used for sorting, either alone or in combination. To sort by product category, EXTRACT the category value and use it in the `ORDER BY` clause:
```

```sql
SELECT * FROM housewares ORDER BY LEFT(id,3);
```
```
+------------+------------------+
| id         | description      |
+------------+------------------+
| BED00038SG | bedside lamp     |
| BTH00485US | shower stall     |
| BTH00415JP | lavatory         | 
| DIN40672US | dining table     |
| KIT00372UK | garbage disposal |
| KIT01729JP | microwave oven   |
+------------+------------------+
```
## To sort rows by product serial number, use `MID()` to EXTRACT the middle five characters from the `id` values, beginning with the fourth:

```sql
SELECT * FROM housewares ORDER BY MID(id,4,5);
```
```
+------------+------------------+
| id         | description      |
+------------+------------------+
| BED00038SG | bedside lamp     |
| KIT00372UK | garbage disposal |
| BTH00415JP | lavatory         |
| BTH00485US | shower stall     |
| KIT01729JP | microwave oven   |
| DIN40672US | dining table     |
+------------+------------------+
```

## This appears to be a numeric sort, but it’s actually a string sort, because MID() returns strings. It just so happens that the lexical and numeric sort order are the same in this case because the “numbers” have leading zeros to make them all the same length.
## To sort by country code, use the rightmost two characters of the id values:

```sql
SELECT * FROM housewares ORDER BY RIGHT(id,2);
```
```
+------------+------------------+
| id         | description      |
+------------+------------------+
| KIT01729JP | microwave oven   |
| BTH00415JP | lavatory         |
| BED00038SG | bedside lamp     |
| KIT00372UK | garbage disposal |
| DIN40672US | dining table     |
| BTH00485US | shower stall     |
+------------+------------------+
```

## You can also sort using combinations of substrings. For example, to sort by country code and serial number, the query looks like this:

```sql
SELECT * 
FROM housewares 
ORDER BY RIGHT(id,2), MID(id,4,5);
```
```
+------------+------------------+
| id         | description      |
+------------+------------------+
| BTH00415JP | lavatory         |
| KIT01729JP | microwave oven   |
| BED00038SG | bedside lamp     |
| KIT00372UK | garbage disposal |
| BTH00485US | shower stall     |
| DIN40672US | dining table     |
+------------+------------------+
```


---

# Ignoring Groups in Aggregate Data Sets
## Problem
## You want to ignore certain groups of data based on the outcome of aggregate functions or grouping actions. In effect, you’d really like another where clause to work after the `GROUP BY` clause, providing criteria at the group or aggregate level.

## Solution
SQL provides the `HAVING` clause to apply criteria to grouped data. For our recipe, we solve the problem of finding minimum, average, and maximum salary for people performing the same job in each of the departments in the employee table. Importantly, we only want to see these aggregate values where more than one person performs the same job in a given department. The next SQL statement uses an expression in the `HAVING` clause to solve our problem.

```sql
SELECT 
    department_id, 
    job_id, 
    MIN(salary), 
    AVG(salary), 
    MAX(salary), 
    COUNT(*) 
FROM 
    employee
GROUP BY 
    department_id, job_id 
HAVING COUNT(*) > 1;
```

## The HAVING clause criteria can be arbitrarily complex, so you can use multiple criteria of different sorts.

```sql
SELECT 
    department_id, 
    job_id, 
    MIN(salary), 
    AVG(salary), 
    MAX(salary), 
    COUNT(*) 
FROM employee
GROUP BY 
    department_id, job_id 
HAVING 
    COUNT(*) > 1
    AND MIN(salary) BETWEEN 2500 AND 17000 
    AND AVG(salary) != 5000
    AND MAX(salary)/MIN(salary) < 2;
```

---

# Working with Per-Group and Overall summary Values Simultaneously
## Problem
## You want to produce a report that requires different levels of summary detail. Or you want to compare per-group summary values to an overall summary value.

## Solution
## Use two statements that retrieve different levels of summary information. Or use a subquery to retrieve one summary value and refer to it in the outer query that refers to other summary values. If it’s necessary only to display multiple summary levels, with `ROLLUP` might be sufficient.

## Discussion
## Sometimes a report involves different levels of summary information. For example, the following report displays the total number of miles per driver from the driver_log table, along with each driver’s miles as a percentage of the total miles in the entire table:

```
+-------+--------------+------------------------+
| name  | miles/driver | percent of total miles |
+-------+--------------+------------------------+
| Ben   |   362        |                16.7128 |
| Henry |   911        |                42.0591 |
| Suzi |    893        |                41.2281 |
+-------+--------------+------------------------+
```
## The percentages represent the ratio of each driver’s miles to the total miles for all drivers. To perform the percentage calculation, you need a per-group summary to get each driver’s miles and also an overall summary to get the total miles. This query to get the overall mileage total:

```sql
-- This query gets the overall mileage total
SELECT SUM(miles) AS total FROM driver_log;
```
```
+-------------+
| total miles |
+-------------+
|   2166      |
+-------------+
```

## Now, calculate the per-group values and use the overall total to compute the percentages:

```sql
SELECT name,
SUM(miles) AS 'miles/driver',
(SUM(miles)*100)/(SELECT SUM(miles) FROM driver_log)
 AS 'percent of total miles'
FROM driver_log GROUP BY name;
```
```
+-------+--------------+------------------------+
| name  | miles/driver | percent of total miles |
+-------+--------------+------------------------+
| Ben   |   362 |   16.7128 |
| Henry |   911 |   42.0591 |
| Suzi |    893 |   41.2281 |
+-------+--------------+------------------------+
```

## Another type of problem that uses different levels of summary information occurs when you want to compare per-group summary values with the corresponding overall SUM- mary value. Suppose that you want to deterMINe which drivers had a lower average miles per day than the group average. Calculate the overall average in a subquery, and then compare each driver’s average to the overall average using a `HAVING` clause:

```sql
SELECT 
    name, 
    AVG(miles) AS driver_avg 
FROM 
    driver_log
GROUP BY 
    name
HAVING 
    driver_avg < (SELECT AVG(miles) FROM driver_log);
```
```
+-------+------------+
| name  | driver_avg |
+-------+------------+
| Ben   |   120.6667 |
| Henry |   182.2000 |
+-------+------------+
```

## If you just want to display different summary values (and not perform calculations involving one summary level against another), add `WITH ROLLUP` to the `GROUP BY` clause:

```sql
SELECT name, SUM(miles) AS 'miles/driver'
FROM driver_log GROUP BY name WITH ROLLUP;
```
```
+-------+--------------+
| name  | miles/driver |
+-------+--------------+
| Ben   |   362 |
| Henry |   911 |
| Suzi |    893 |
| NULL |    2166 |
+-------+--------------+
```

```sql
SELECT name, AVG(miles) AS driver_AVG FROM driver_log
GROUP BY name WITH ROLLUP;
```
```
+-------+------------+
| name  | driver_AVG |
+-------+------------+
| Ben   |   120.6667 |
| Henry |   182.2000 |
| Suzi |    446.5000 |
| NULL |    216.6000 |
+-------+------------+
```

## In each case, the output row with NULL in the name column represents the overall SUM or average calculated over all drivers.
`WITH ROLLUP` can present multiple levels of summary, if you `GROUP BY` more than one column. The following statement shows the number of mail messages sent between each pair of users:

```sql
SELECT sender, recipient, COUNT(*)
FROM mail GROUP BY sender, recipient;
```

## Adding `WITH ROLLUP` causes the output to include an intermediate count for each sender value (these are the lines with NULL in the recipient column), plus an overall count at the end:

```sql
SELECT 
    sender, 
    recipient, 
    COUNT(*)
FROM 
    mail 
GROUP BY 
    sender, recipient 
WITH ROLLUP;
```

---

# Aggregating Data at Multiple Levels Using `ROLLUP`
## Problem
## You want to find totals, averages, and other aggregate figures, as well as subtotals in various dimensions for a report. You want to achieve this with as few statements as possible, preferably just one, rather than HAVING to issue separate statements to get each intermediate subtotal along the way.

## Solution
## You can calculate subtotals or other intermediate aggregates in SQL using the `CUBE`, `ROLLUP` and `grouping sets` features. For this recipe, we’ll assume some real-world requirements. We want to find average and total (SUMmed) salary figures by department and job category, and show meaningful higher-level averages and subtotals at the department level (regardless of job category), as well as a grand total and company-wide average for the whole organization.

```sql
SELECT 
    department_id, 
    job_id, 
    AVG(salary), 
    SUM(salary) 
    FROM employee
GROUP BY rollup (department_id, job_id);
```

## The `ROLLUP` function performs grouping at multiple levels, using a right-to-left method of rolling up through intermediate levels to any grand total or summation. In our recipe, this means that after performing normal grouping by `department_id` and `job_id`, the `ROLLUP` function rolls up all job_id values so that we see an average and sum for the department_id level across all jobs in a given department.
## `ROLLUP` then rolls up to the next (and highest) level in our recipe, rolling up all departments, in effect providing an organization-wide rollup. You can see the rolled up rows in bold in the output. Performing this rollup would be the equivalent of running three separate statements, such as the three that follow, and using `UNION` or application-level code to stitch the results together.

```sql
SELECT department_id, job_id, AVG(salary), SUM(salary) FROM employee
GROUP BY department_id, job_id;
SELECT department_id, AVG(salary), SUM(salary) FROM employee
GROUP BY department_id;
SELECT AVG(salary), SUM(salary) FROM employee;

```

## Careful observers will note that because `ROLLUP` works from right to left with the columns given, we don’t see values where departments are rolled up by job. We could achieve this using this version of the recipe.

```sql
SELECT department_id, job_id, AVG(salary), SUM(salary) FROM employee
GROUP BY rollup (job_id, department_id);
```
## In doing so, we get the `department_id` intermediate rollup we want, but lose the `job_id` intermediate rollup, seeing only `job_id` rolled up at the final level. To roll up in all dimensions, change the recipe to use the `CUBE` function.

```sql
SELECT 
    department_id, 
    job_id, 
    MIN(salary), 
    AVG(salary), 
    MAX(salary)
FROM 
    employee
GROUP BY 
    cube (department_id, job_id);
```

## The results show our rollups at each level, shown in bold in the partial results that follow.

## The power of both the `ROLLUP` and `CUBE` functions extends to as many “dimensions” as you need for your query. Admittedly, the term `cube` is meant to allude to the idea of looking at intermediate aggregations in three dimensions, but your data can often have more dimensions than that. Extending our recipe, we could cube a calculation of average salary by department, job, manager, and starting year.

```sql
SELECT 
    department_id, 
    job_id, 
    manager_id,
    date_part('year', hire_date) as 'START_YEAR', 
    AVG(salary) 
FROM employee
GROUP BY 
    cube (department_id, job_id, manager_id, date_part('year', hire_date));
```

---

# Using Aggregate Results in Other Queries
## Problem
## You want to use the output of a complex query involving aggregates and grouping as source data for another query.

## Solution
## SQL allows any query to be used as a subquery or inline view, including those containing aggregates and grouping functions. This is especially useful WHERE you’d like to specify group-level criteria compared against data FROM other tables or queries, and don’t have a ready-made view available.
## For our recipe, we’ll use an average salary calculation with rollups across department, job, and start year, as shown in this SELECT statement.

```sql
SELECT * FROM (
SELECT 
    department_id as 'dept', 
    job_id as 'job', 
    TO_CHAR(hire_date,'YYYY') as 'Start_Year', 
    AVG(salary) as 'avg_salary'
FROM employee
GROUP BY 
    rollup (department_id, job_id, TO_CHAR(hire_date,'YYYY'))) AS salcalc 
WHERE 
    salcalc.start_year > '1990'
OR  salcalc.start_year IS NULL 
ORDER BY 1,2,3,4;

```

## How It Works
## Our recipe uses the aggregated and grouped results of the subquery as an inline view, which we then SELECT FROM and apply further criteria. In this case, we could avoid the subquery approach by using a more complex HAVING clause like this.
## HAVING TO_CHAR(hire_date,'YYYY') > '1990' or TO_CHAR(hire_date,'YYYY') IS NULL

## Avoiding a subquery here works only because we’re comparing our aggregates with literals. If we wanted to find averages for jobs in departments WHERE someone had previously held the job, we’d need to reference the HR.JOBHISTORY table. Depending on the business requirement, we might get lucky and be able to construct our join, aggregates, groups, and HAVING criteria in one statement. By treating the results of the aggregate and grouping query as input to another query, we get better readability, and the ability to code even more complexity than the HAVING clause allows.

---

# Counting Members in Groups and Sets
## Problem
## You need to count members of a group, groups of groups, and other set-based collections. You also need to include and exclude individual members and groups dynamically based on other data at the same time. For instance, you want to count how many jobs each employee has held during their time at the organization, based on the number of promotions they’ve had within the company.


## Solution
## SQL’s COUNT feature can be used to count materialized results as well as actual rows in tables. The next SELECT statement uses a subquery to count the instances of jobs held across tables, and then SUMmarizes those counts. In effect, this is a count of counts against data resulting FROM a query, rather than anything stored directly in SQL.

```sql
SELECT jh.JobsHeld, COUNT(*) as StaffCount FROM
(SELECT u.employee_id, COUNT(*) as JobsHeld FROM
(SELECT employee_id FROM employee union all
SELECT employee_id FROM hr.job_history) u GROUP BY u.employee_id) jh
GROUP BY jh.JobsHeld;
```

## How It Works
## The key to our recipe is the flexibility of the COUNT function, which can be used for far more than just physically counting the number of rows in a table. You can count anything you can represent in a result. This means you can count derived data, inferred data, and transient calculations and determinations. Our recipe uses nested subSELECTs and counts at two levels, and is best understood starting FROM the inside and working out.
## We know an employee’s current position is tracked in the employee table, and that each instance of previous positions with the organization is recorded in the HR.JOB_HISTORY table. We can’t just count the entries in HR.JOB_HISTORY and add one for the employee’ current positions, because staff who have never changed jobs don’t have an entry in `job_history`.
## Instead, we perform a `UNION ALL` of the employee_id values across both employee and `job_history`, building a basic result set that repeats an `employee_id` for every position an employee has held.

---

# Finding Duplicates and Unique Values in a Table
## Problem
## You need to test if a given data value is unique in a table—that is, it appears only once.


## Solution
## SQL supports the standard `HAVING` clause for select statements, and the `COUNT` function, which together can identify single instances of data in a table or result. The following `SELECT` statement solves the problem of finding if the surname 'Fay' is unique in the employee table.

```sql
SELECT 
    last_name, 
    COUNT(*) 
FROM employee
WHERE last_name = 'Fay' 
GROUP BY last_name 
HAVING COUNT(*) = 1;
```
## Because there is exactly one `last_name` value of 'Fay', we get a count of 1 and therefore see results.

## How It Works
## Only unique combinations of data will group to a count of 1. For instance, we can test if the surname King is unique:

```sql
SELECT 
    last_name, 
    COUNT(*) 
FROM employee
WHERE last_name = 'King' 
GROUP BY last_name 
HAVING COUNT(*) = 1;
```

## This statement returns no results, meaning that the count of people with a surname of King is not 1; it’s some other number like 0, 2, or more. The statement first determines which rows have a last_name value of 'King'. It then groups by last_name and counts the hits encountered. Lastly, the `HAVING` clause tests to see if the count of rows with a last_name of 'King' was equal to 1. Only those results are returned, so a surname is unique only if you see a result.
## If we remove the `HAVING` clause as in the next select statement, we’ll see how many Kings are in the employee table.

```sql
SELECT last_name, COUNT(*) FROM employee
WHERE last_name = 'King' GROUP BY last_name;
```

## Two people have a surname of 'King', thus it isn’t unique and didn’t show up in our test for uniqueness.
## The same technique can be extended to test for unique combinations of columns. We can expand our recipe to test if someone’s complete name, based on the combination of first_name and last_name, is unique. This SELECT statement includes both columns in the criteria, testing to see if 'Lindsey Smith' is a unique full name in the employee table.

```sql
SELECT 
    first_name, 
    last_name, 
    COUNT(*) 
FROM employee
WHERE 
    first_name = 'Lindsey' 
AND 
    last_name = 'Smith'
GROUP BY first_name, last_name 
HAVING COUNT(*) = 1;
```


## You can write similar recipes that use string concatenation, self-joins, and a number of other methods.

---

# Accessing Values From Subsequent or Preceding Rows
## Problem
## You would like to query data to produce an ordered result, but you want to include calculations based on preceding and following rows in the result set. For instance, you want to perform calculations on event- style data based on events that occurred earlier and later in time.

## Solution
## SQL supports the `LAG` and `LEAD` analytical functions to provide access to multiple rows in a table or expression, utilizing preceding/following logic—and you won’t need to resort to joining the source data to itself. Our recipe assumes you are trying to tackle the business problem of visualizing the trend in hiring of staff over time. The `LAG` function can be used to see which employee’s hiring followed another, and also to calculate the elapsed time between hiring.

```sql
SELECT 
    first_name, 
    last_name, 
    hire_date,
    LAG(hire_date, 1, '01-JUN-1987') OVER (ORDER BY hire_date) AS Prev_Hire_Date, 
    hire_date - LAG(hire_date, 1, '01-JUN-1987') OVER (ORDER BY hire_date) as Days_Between_Hires 
FROM employee
ORDER BY hire_date;
```

## Our query returns 107 rows, linking the employee in the order they were hired (though not necessarily preserving the implicit sort for display or other purposes), and showing the time delta BETWEEN each joining the organization.

## How It Works
## The `LAG` and `LEAD` functions are like most other analytical and windowing functions in that they operate once the base non-analytic portion of the query is complete. SQL performs a second pass over the intermediate result set to apply any analytical predicates. In effect, the non-analytic components are evaluated first, as if this query had been run.

## The analytic function(s) are then processed, providing the results you’ve seen. Our recipe uses the `LAG` function to compare the current row of results with a preceding row. The general format is the best way to understand LAG, and has the following form.

> `LAG` (column or expression, preceding row offset, default for first row)

## The column or expression is mostly self-explanatory, as this is the table data or computed result over which you want `LAG` to operate. The preceding row offset portion indicates the relative row prior to the current row the `LAG` should act against. In our case, the value ‘1’ means the row that is one row before the current row. The default for `LAG` indicates what value to use as a precedent for the first row, as there is no row zero in a table or result. We’ve chosen the arbitrary date of 01-JUN-1987 as a notional date on which the organization was founded. You could use any date, date calculation, or date-returning function here. SQL will supply a NULL value if you don’t specify the first row’s precedent value.
## The `OVER` analytic clause then dictates the order of data against which to apply the analytic function,and any partitioning of the data into windows or subsets (not shown in this recipe). Astute readers will realize that this means our recipe could have included a general ORDER BY clause that sorted the data for presentation in a different order from the hire_date ordering used for the `LAG` function. This gives you the most flexibility to handle general ordering and analytic `LAG` and `LEAD`  in different ways for the same statement. We’ll show an example of this later in this chapter. And remember, you should never rely on the implicit sorting that analytic functions use. This can and will change in the future, so you are best advised to always include ORDER BY for sorting whereever explicitly required.
## The `LEAD`  function works in a nearly identical fashion to LAG, but instead tracks following rows rather than preceding ones. We could rewrite our recipe to show hires along with the HIRE_DATE of the next employee, and a similar elapsed-time window between their employment dates, as in this SELECT statement.

```sql
SELECT 
    first_name, 
    last_name, 
    hire_date,
    LEAD(hire_date, 1, NOW()::date) OVER (ORDER BY hire_date) AS Next_Hire_Date, 
    LEAD(hire_date, 1, NOW()::date) over (ORDER BY hire_date) - hire_date AS Days_BETWEEN_Hires 
FROM employee;
```

## The pattern of dates is very intuitive now that you’ve seen the `LAG` example. With `LEAD`, the key difference is the effect of the default value in the third parameter.

In contrast to `LAG`, where the default provides a notional starting point for the first row’s comparison, `LEAD`  uses the default value to provide a hypothetical end point for the last row in the forward-looking chain. In this recipe, we are comparing how many days have elapsed between employee being hired. It makes sense for us to compare the last employee hired (in this case, Sundita Kumar) with the current date using `NOW()::date` function. This is a quick and easy finishing flourish to calculate the days that have elapsed since hiring the last employee.
---
# Assigning Ranking Values to Rows in a Query Result
## Problem
## The results from a query need to be allocated an ordinal number representing their positions in the result. You do not want to have to insert and track these numbers in the source data.

## Solution
## SQL provides the `RANK` analytic function to generate a ranking number for rows in a result set. `RANK` is applied as a normal OLAP-style function to a column or derived expression. For the purposes of this recipe, we’ll assume that the business would like to `RANK` employee by salary, from highest-paid down. The following `SELECT` statement uses the `RANK` function to assign these values.

```sql
SELECT 
    employee_id, 
    salary, 
    RANK() OVER (ORDER BY salary DESC) AS Salary_RANK 
FROM employee;
```

## Our query produces results FROM the highest earner at 24000 per month, right down to the employee in 107th place earning 2100 per month, as these abridged results show.

## How It Works
## `RANK` acts like any other analytic function, operating in a second pass over the result set once non- analytic processing is complete. In this recipe, the EMPLOYEE_ID and SALARY values are selected (there are no WHERE predicates to filter the table’s data, so we get everyone employed in the organization). The analytic phase then orders the results in descending ORDER BY salary, and computes the `RANK` value on the results starting at 1.
## Note carefully how the `RANK` function has handled equal values. Two employee with salary of 17000 are given equal `RANK` of 2. The next employee, at 14000, has a `RANK` of 4. This is known as sparse ranking, WHERE tied values “consume” place holders. In practical terms, this means that our equal second-place holders conSUMe both second and third place, and the next available `RANK` to provide is 4.
## You can use an alternative to sparse ranking called dense ranking. SQL supports this using the `DENSE_RANK` analytical function. Observe what happens to the recipe when we switch to dense ranking.

```sql
SELECT employee_id, salary, DENSE_RANK() over (ORDER BY salary desc) as Salary_Rank
FROM employee;
```
We now see the “missing” consecutive `RANK` values.

---

# Finding First and Last Values within a Group
## Problem
## You want to calculate and display aggregate information like minimum and maximum for a group, along with detail information for each member. You want don’t want to repeat effort to display the aggregate and detail values.


## Solution
##SQL provides the analytic functions FIRST and LAST to calculate the leading and ending values in any ordered sequence. Importantly, these do not require grouping to be used, unlike explicit aggregate functions such as MIN and MAX that work without OLAP features.

---

# Performing Aggregations over Moving Windows
## Problem
## You need to provide static and moving summaries or aggregates based on the same data. For example, as part of a sales report, you need to provide a monthly summary of sales order amounts, together with a moving three- month average of sales amounts for comparison.

## Solution
## SQL provides moving or rolling window functions as part of the analytical function set. This gives you the ability to reference any number of preceding rows in a result set, the current row in the result set, and any number of following rows in a result set. Our initial recipe uses the current row and the three preceding rows to calculate the rolling average of order values.

```sql
SELECT 
    TO_CHAR(order_date, 'MM') as OrderMonth, SUM(order_total) as MonthTotal, 
    AVG(SUM(order_total)) OVER (ORDER BY TO_CHAR(order_date, 'MM') rows BETWEEN 3 preceding and current row) AS RollingQtrAverage
FROM orders
WHERE order_date BETWEEN '01-JAN-1999' and '31-DEC-1999' 
GROUP BY TO_CHAR(order_date, 'MM')
ORDER BY 1;
```

## We see the month, the associated total, and the calculated rolling three-month average in our results.

## You might notice January (OrderMonth 01) is missing. This isn’t a quirk of this approach: rather it’s because the OE.ORDERS table has no orders recorded for this month in 1999.


## How It Works
## Our SELECT statement for a rolling average starts by Selecting some straightforward values. The month number is EXTRACTed FROM the ORDER_DATE field using the TO_CHAR() function with the MM format string to obtain the month’s number. We choose the month number rather than the name so that the output is sorted as a person would expect.

## Next up is a normal aggregate of the ORDER_TOTAL field using the traditional SUM function. No magic there. We then introduce an OLAP AVG function, which is where the detail of our rolling average is managed. That part of the statement looks like this.

```sql
AVG(SUM(order_total)) OVER (ORDER BY TO_CHAR(order_date, 'MM') rows BETWEEN 3 preceding AND current row) AS RollingQtrAverage
```

## All of that text is to generate our result column, the ROLLINGQTRAVERAGE. Breaking the sections down will illustrate how each part contributes to the solution. The leading functions, AVG(SUM(ORDER_TOTAL)), suggest we are going to sum the ORDER_TOTAL values and then take their average. That is correct to an extent, but SQL isn’t just going to calculate a normal average or SUM. These are OLAP AVG and SUM functions, so their scope is governed by the OVER clause.
## The `OVER` clause starts by instructing SQL to perform the calculations based on the order of the formatted ORDER_DATE field—that’s what ORDER BY TO_CHAR(ORDER_DATE, 'MM') achieves, effectively ordering the calculations by the values 02 to 12 (remember, there’s no data for January 1999 in the database). Finally, and most importantly, the ROWS element tells SQL the size of the window of rows over which it should calculate the driving OLAP aggregate functions. In our case, that means over how many months should the ORDER_TOTAL values be SUMmed and then averaged. Our recipe instructs SQL to use the results FROM the third-last row through to the current row. This is one interpretation of three-month rolling average, though technically it’s actually generating an average over four months. If what you want is really a three-month average —the last two months plus the current month—you’d change the ROWS BETWEEN element to read rows BETWEEN 2 preceding and current row.
## This brings up an interesting point. This recipe assumes you want a rolling average computed over historic data. But some business requirements call for a rolling window to track trends based on data not only prior to a point in time, but also after that point. For instance, we might want to use a three-month window but base it on the previous, current, and following months. The next version of the recipe shows exactly this ability of the windowing function, with the key changes in bold.

```sql
SELECT 
    TO_CHAR(order_date, 'MM') as OrderMonth, 
    SUM(order_total) as MonthTotal, 
    AVG(SUM(order_total)) OVER (ORDER BY TO_CHAR(order_date, 'MM') ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING) as AVGTrend
FROM orders
WHERE 
    order_date BETWEEN '01-JAN-1999' and '31-DEC-1999' 
GROUP BY TO_CHAR(order_date, 'MM')
ORDER BY 1;
```
Our output changes as you’d expect, as the monthly ORDER_TOTAL values are now grouped differently for the calculation.


## The newly designated AVGTREND value is calculated as described, using both preceding and following rows. Both our original recipe and this modified version are rounded out with a WHERE clause to SELECT only data from the `ORDERS` table for the year 1999. We `GROUP BY` the derived month number so that our traditional sum of ORDER_TOTAL in the second field of the results aggregates correctly, and finish up ordering logically by the month number.

---

# Removing Duplicate Rows Based on a Subset of Columns
## Problem
## Data needs to be cleansed FROM a table based on duplicate values that are present only in a subset of rows.

## Solution
## Historically there were SQL-specific solutions for this problem that used the `ROWNUM` feature. However, this can become awkward and complex if you have multiple groups of duplicates and want to remove the excess data in one pass. Instead, you can use SQL’s ROW_NUMBER OLAP function with a DELETE statement to efficiently remove all duplicates in one pass.
## To illustrate our recipe in action, we’ll first introduce several new staff members that have the same FIRST_NAME and LAST_NAME as some existing employee. These INSERT statements create our problematic duplicates.

```sql
insert into employee
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(210, 'Janette', 'King', 'JKING2', '650.555.8880', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);


Insert into employee
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(211, 'Patrick', 'Sully', 'PSULLY2', '650.555.8881', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);
Insert into employee
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
Values
(212, 'Allen', 'McEwen', 'AMCEWEN2', '650.555.8882', '25-MAR-2009', 'SA_REP', 3500, 0.25, 145, 80);
commit;
```

## To show that we do indeed have some duplicates, a quick SELECT shows the rows in question.

```sql
SELECT 
    employee_id, 
    first_name, 
    last_name 
FROM employee
WHERE 
    first_name IN ('Janette','Patrick','Allan') 
    AND last_name IN ('King','Sully','McEwen')
ORDER BY 
    first_name, last_name;
```
```
EMPLOYEE_ID FIRST_NAME  LAST_NAME
----------- ----------- ----------
158 Allan   McEwen
212 Allan   McEwen
210 Janette King
156 Janette King
211 Patrick Sully
```

## If you worked in HR, or were one of these people, you might be concerned with the unpredictable consequences and want to see the duplicates removed. With our problematic data in place, we can introduce the SQL to remove the “extra” Janette King, Patrick Sully, and Allen McEwen.

```sql
delete FROM employee WHERE rowid in
(SELECT rowid FROM
(SELECT first_name, last_name, rowid, row_number() over
(partition by first_name, last_name ORDER BY employee_id) staff_row
FROM employee) WHERE staff_row > 1);
```

## When run, this code does indeed claim to remove three rows, presumably our duplicates. To check, we can repeat our quick query to see which rows match those three names. We see this set of results.

```
EMPLOYEE_ID FIRST_NAME LAST_NAME
Allan   McEwen
Janette King
Patrick Sully
```

##Our DELETE has succeeded, based on finding duplicates for a subset of columns only.

## How It Works
## Our recipe uses both the ROW_NUMBER OLAP function and SQL’s internal ROWID value for uniquely identifying rows in a table. The query starts with exactly the kind of DELETE syntax you’d assume.

```sql
DELETE FROM employee WHERE rowid IN
-- (… nested subqueries here …)
```
## As you’d expect, we’re asking SQL to delete rows FROM employee WHERE the ROWID value matches the values we detect for duplicates, based on criteria evaluating a subset of columns. In our case, we use subqueries to precisely identify duplicates based on FIRST_NAME and LAST_NAME.
## To understand how the nested subqueries work, it’s easiest to start with the innermost subquery, which looks like this.

```sql
SELECT first_name, last_name, rowid, row_number() over
(partition by first_name, last_name ORDER BY employee_id) staff_row
FROM employee
```
## We’ve intentionally added the columns FIRST_NAME and LAST_NAME to this innermost subquery to make the recipe understandable as we work through its logic. Strictly speaking, these are superfluous to the logic, and the innermost subquery could be written without them to the same effect. If we execute just this innermost query (with the extra columns selected for clarity), we see these results.


## All 110 staff FROM the employee table have their FIRST_NAME, LAST_NAME and ROWID returned. The ROW_NUMBER() function then works over sets of FIRST_NAME and LAST_NAME driven by the PARTITION BY instruction. This means that for every unique FIRST_NAME and LAST_NAME, ROW_NUMBER will start a running count of rows we’ve aliased as STAFF_ROW. When a new FIRST_NAME and LAST_NAME combination is observed, the STAFF_ROW counter resets to 1.
## In this way, the first 'Janette King' has a STAFF_ROW value of 1, the second 'Janette King' entry has a STAFF_ROW value of 2, and if there were a third and fourth such repeated name, they’d have STAFF_ROW values of 3 and 4 respectively. With our identically-named staff now numbered, we move to the next outermost subSELECT, which queries the results FROM above.

```sql
SELECT rowid 
FROM SELECT
    (SELECT 
        first_name, 
        last_name, 
        rowid, 
        row_number() over (partition by first_name, last_name 
            ORDER BY first_name, last_name) AS staff_row
    FROM employee) 
WHERE staff_row > 1
```

# FIX THIS SECTION 
This outer query looks simple, because it is! We simply SELECT the ROWID values FROM the results of our innermost query, WHERE the calculated STAFF_ROW value is greater than 1. That means that we only SELECT the ROWID values for the second Janette King, Allan McEwen, and Patrick Sully, like this.
ROWID
AAARAgAAFAAAABYAA4 AAARAgAAFAAAABYAA6 AAARAgAAFAAAABYAA5

Armed with those ROWID values, the DELETE statement knows exactly which rows are the duplicates, based on only a comparison and count of FIRST_NAME and LAST_NAME.
The beauty of this recipe is the basic structure translates very easily to deleting data based on any such column-subset duplication. The format stays the same, and only the table name and a few column names need to be changed. Consider this a pseudo-SQL template for all such cases.
delete FROM <your_table_here>
WHERE rowid in (SELECT rowid FROM
(SELECT rowid, row_number() over
(partition by <first_duplicate_column>, <second_duplicate_column>, <etc.>
ORDER BY <desired ordering column>)


duplicate_row_count FROM <your_table_here>)
WHERE duplicate_row_count > 1)
/
Simply plug in the value for your table in place of the marker <your_table_here>, and the columns you wish to use to deterMINe duplication in place of equivalent column placeholders, and you’re in business!

---

# Finding Sequence Gaps in a Table
## Problem
## You want to find all gaps in the sequence of numbers or in dates and times in your data. The gaps could be in dates recorded for a given action, or in some other data with a logically consecutive nature.

## Solution
## SQL’s `LAG` and `LEAD`  OLAP functions let you compare the current row of results with a preceding row. The general format of `LAG` looks like this 
###`LAG` (column or expression, preceding row offset, default for first row)

##The column or expression is the value to be compared with lagging (preceding) values. The preceding row offset indicates how many rows prior to the current row the `LAG` should act against. We’ve used ‘1’ in the following listing to mean the row one prior to the current row. The default for `LAG` indicates what value to use as a precedent for the first row, as there is no row zero in a table or result. We instruct SQL to use 0 as the default anchor value, to handle the case WHERE we look for the day prior to the first of the month.
## The WITH query alias approach can be used in almost all situations WHERE a subquery is used, to relocate the subquery details ahead of the main query. This aids readability and refactoring of the code if required at a later date.
## This recipe looks for gaps in the sequence of days on which orders were made for the month of November 1999:

```sql
WITH salesdays AS
    (SELECT EXTRACT(day FROM order_date) AS next_sale, 
        LAG(EXTRACT(day FROM order_date),1,0) OVER (ORDER BY EXTRACT(day FROM order_date)) AS prev_sale 
        FROM orders
    WHERE order_date BETWEEN '01-NOV-1999'::date and '30-NOV-1999'::date
    ) 

SELECT 
    prev_sale, 
    next_sale
FROM salesdays
WHERE next_sale - prev_sale > 1 
ORDER BY prev_sale;
```

## Our query exposes the gaps, in days, between sales for the month of November 1999.


## The results indicate that after an order was recorded on the first of the month, no subsequent order was recorded until the 10th. Then a four-day gap followed to the 14th, and so on. An astute sales manager might well use this data to ask what the sales team was doing on those gap days, and why no orders came in!

## How It Works
## The query starts by using the `WITH` clause to name a subquery with an alias in an out-of-order fashion. The subquery is then referenced with an alias, in this case `salesdays`.
## The SALESDAYS subquery calculates two fields. First, it uses the `EXTRACT` function to return the numeric day value FROM the ORDER_DATE date field, and labels this data as NEXT_SALE. The `LAG` OLAP function is then used to calculate the number for the day in the month (again using the `EXTRACT` method) of the ORDER_DATE of the preceding row in the results, which becomes the PREV_SALE result value. This makes more sense when you visualize the output of just the subquery SELECT statement

```sql
SELECT 
    EXTRACT(day FROM order_date) AS next_sale, 
    LAG(EXTRACT(day FROM order_date),1,0) OVER (ORDER BY EXTRACT(day FROM order_date)) AS prev_sale 
FROM orders
WHERE 
    order_date BETWEEN '01-NOV-1999'::date and '30-NOV-1999'::date
```

## Starting with the anchor value of 0 in the LAG, we see the day of the month for a sale as NEXT_SALE, and the day of the previous sale as PREV_SALE. You can probably already visually spot the gaps, but it’s much easier to let SQL do that for you too. This is WHERE our outer query does its very simple arithmetic.
## The driving query over the SALESDAYS subquery SELECTs the PREV_SALE and NEXT_SALE values FROM the results, based on this predicate.
### `WHERE next_sale - prev_sale > 1`

## We know the days of sales are consecutive if they’re out by more than one day. We wrap up by ordering the results by the PREV_SALE column, so that we get a natural ordering FROM start of month to end of month.
## Our query could have been written the traditional way, with the subquery in the FROM clause like this.

```sql
SELECT 
    prev_sale, 
    next_sale
FROM (
    SELECT EXTRACT(day FROM order_date) AS next_sale, 
    LAG(EXTRACT(day FROM order_date),1,0) OVER (ORDER BY EXTRACT(day FROM order_date)) AS prev_sale 
    FROM orders
    WHERE order_date BETWEEN '01-NOV-1999'::date and '30-NOV-1999'::date
    ) 
WHERE next_sale - prev_sale > 1
ORDER BY prev_sale
```

## The approach to take is largely a question of style and readability. We prefer the WITH approach on those occasions WHERE it greatly increases the readability of your SQL statements.



---

# Stacking Query Results Vertically

## Problem
## You want to combine the results FROM two SELECT statements into a single result set.


## Solution
## Use the UNION operator. UNION combines the results of two or more queries and removes duplicates FROM the entire result set. In SQL’s mythical company, the employee in the employee_ACT table need to be merged with employee FROM a recent corporate acquisition. The recently acquired company’s employee table employee_new has the same exact format as the existing employee_act table, so it should be easy to use UNION to combine the two tables into a single result set as follows:

SELECT 
    employee_id, 
    first_name, 
    last_name 
FROM employee_act 

UNION

SELECT 
    employee_id, 
    first_name, 
    last_name 
FROM employee_new 
ORDER BY employee_id;




# Using UNION removes the duplicate rows. You can have one ORDER BY at the end of the query to order the results. In this example, the two employee tables have two rows in common (some people need to work two or three jobs to make ends meet!), so instead of returning 11 rows, the UNION query returns nine.

# How It Works
# Note that for the UNION operator to remove duplicate rows, all columns in a given row must be equal to the same columns in one or more other rows. When SQL processes a UNION, it must perform a sort/merge to deterMINe which rows are duplicates. Thus, your execution time will likely be more than running each SELECT individually. If you know there are no duplicates within and across each SELECT statement, you can use UNION ALL to combine the results without checking for duplicates.
# If there are duplicates, it will not cause an error; you will merely get duplicate rows in your result set.

---

# Writing an Optional Join

## Problem
## You are joining two tables by one or more common columns, but you want to make sure to return all rows in the first table regardless of a matching row in the second. For example, you are joining the employee and department tables, but some employee lack department assignments.

Solution
Use an `OUTER JOIN`. In SQL’s sample database, the HR user maintains the employee and DEPARTMENT tables; assigning a department to an employee is optional. There are 107 employee in the employee table. Using a standard join BETWEEN employee and DEPARTMENTS only returns 106 rows, however, since one employee is not assigned a department. To return all rows in the employee table, you can use LEFT OUTER JOIN to include all rows in the employee table and matching rows in DEPARTMENTS, if any:

```sql
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    department_id, 
    department_name 
FROM employee
LEFT OUTER JOIN 
    departments USING(department_id);
```

## How It Works
## When two tables are joined using `LEFT OUTER JOIN`, the query returns all the rows in the table to the left of the `LEFT OUTER JOIN` clause, as you might expect. Rows in the table on the right side of the `LEFT OUTER JOIN`clause are matched when possible. If there is no match, columns FROM the table on the right side will contain NULL values in the results.

## As you might expect, there is a RIGHT OUTER JOIN as well (in both cases, the OUTER keyword is optional). You can rewrite the solution as follows:

```sql
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    department_id, 
    department_name 
FROM departments
RIGHT OUTER JOIN 
    employee USING(department_id);
```
The results are identical, and which format you use depends on readability and style.


---

## Making a Join Optional in Both Directions
## Problem
## All of the tables in your query have at least a few rows that don’t match rows in the other tables, but you still want to return all rows FROM all tables and show the mismatches in the results. For example, you want to reduce the number of reports by including mismatches FROM both tables instead of HAVING one report for each scenario.

## Solution
## Use FULL OUTER JOIN. As you might expect, a full outer join BETWEEN two or more tables will return all rows in each table of the query and match WHERE possible. You can use FULL OUTER JOIN with the employee and DEPARTMENT table as follows:

```sql
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    department_id, 
    department_name 
FROM employee
FULL OUTER JOIN 
    departments using(department_id);
```


## Note: The OUTER keyword is optional when using a FULL, LEFT, or RIGHT join. It does add documentation value to your query, making it clear that mismatched rows FROM one or both tables will be in the results.


## Using `FULL OUTER JOIN` is a good way to view, at a glance, mismatches between two tables. In the preceding output, you can see an employee without a department as well as several departments that have no employee.

## You can tweak the `FULL OUTER JOIN` to produce only the mismatched records as follows:

```sql
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    department_id, 
    department_name 
FROM 
    employee
FULL OUTER JOIN 
    departments USING(department_id) 
    WHERE 
        employee_id IS NULL OR department_name IS NULL;
```

---

# Finding Rows in One Table That Match Rows in Another
## Problem
## You need to write a query that uses information FROM more than one table.

## Solution
Use a join—that is, a query that lists multiple tables in its `FROM` clause and tells SQL how to match information from them.

## Discussion
## The essential idea behind a join is that it combines rows in one table with rows in one or more other tables. Joins enable you to combine information FROM multiple tables when each table contains only part of the information in which you’re interested. Output rows FROM a join contain more information than rows FROM either table by itself.

## A complete join that produces all possible row combinations is called a Cartesian product. For example, joining each row in a 100-row table to each row in a 200-row table produces a result containing 100 × 200, or 20,000 rows. With larger tables, or joins BETWEEN more than two tables, the result set for a Cartesian product can easily become immense. Because of that, and because you rarely want all the combinations anyway, a join normally includes an ON or USING clause that specifies how to join rows BETWEEN tables. (This requires that each table have one or more columns of common information that can be used to link them together logically.) You can also include a WHERE clause that restricts which of the joined rows to SELECT. Each of these clauses narrows the focus of the query.

## This recipe introduces basic join syntax and demonstrates how joins help you answer specific types of questions when you are looking for matches BETWEEN tables. Later recipes show how to identify mismatches BETWEEN tables and how to compare a table to itself. The examples assume that you have an art collection and use the following two tables to record your acquisitions. artist lists those painters whose works you want to collect, and painting lists each painting that you’ve actually purchased:

```sql
CREATE TABLE artist (
a_id INT UNSIGNED NOT NULL AUTO_INCREMENT, # artist ID
name  VARCHAR(30) NOT NULL, # artist name PRIMARY KEY (a_id),
UNIQUE (name)
);

CREATE TABLE painting (
a_id  INT UNSIGNED NOT NULL,    # artist ID p_id INT UNSIGNED NOT NULL AUTO_INCREMENT, # painting ID
title VARCHAR(100) NOT NULL,    # title of painting
state VARCHAR(2) NOT NULL,  # state WHERE purchased
price INT UNSIGNED, # purchase price (dollars) INDEX (a_id),
PRIMARY KEY (p_id)
);
```

## You’ve just begun the collection, so the tables contain only the following rows:
```sql
SELECT * FROM artist ORDER BY a_id;
```

```
+------+----------+
| a_id | name   |
+------+----------+
|   1 | Da Vinci |
|   2 | Monet   |
|   3 | Van Gogh |
|   4 | Picasso |
|   5 | Renoir  |
+------+----------+
```

### Each table contains partial information about your collection. For example, the artist table doesn’t tell you which paintings each artist produced, and the painting table lists artist IDs but not their names. To use the information in both tables, you can ask MySQL to show you various combinations of artists and paintings by writing a query that performs a join. A join names two or more tables after the FROM keyword. In the output column list, you can name columns FROM any or all the joined tables, or use expressions that are based on those columns, tbl_name.* to SELECT all columns FROM a given table, or * to SELECT all columns FROM all tables.
## The simplest join involves two tables and SELECTs all columns FROM each. With no restrictions, the join generates output for all combinations of rows (that is, the Cartesian product). The following complete join BETWEEN the artist and painting tables shows this:
```sql
SELECT * FROM artist, painting;
```
+------+----------+------+------+-------------------+-------+-------+
| a_id | name   | a_id | p_id | title   | state | price |
+------+----------+------+------+-------------------+-------+-------+

+------+----------+------+------+-------------------+-------+-------+

## A complete join generally is not useful: it produces a lot of output, and the result is not meaningful. Clearly, you’re not maintaining these tables to match every artist with every painting, which is what the preceding statement does. An unrestricted join in this case produces nothing of value.

## To answer questions meaningfully, you must combine the two tables in a way that produces only the relevant matches. Doing so is a matter of including appropriate join conditions. For example, to produce a list of paintings together with the artist names, you can associate rows FROM the two tables using a simple WHERE clause that matches up values in the artist ID column that is common to both tables and that serves as the link BETWEEN them:

```sql
-- This works, but don't do this
SELECT * 
FROM 
    artist, painting
WHERE 
    artist.a_id = painting.a_id;
```

## The above query works, but it is much more common and considered best practice to use  `INNER JOIN` rather than the comma operator and indicate the matching conditions with an `ON` clause:

```sql
-- DO THIS. YOUR FIRST JOIN
SELECT * 
FROM artist 
INNER JOIN 
    painting
ON 
    artist.a_id = painting.a_id;
```

## In the special case that the matched columns have the same name in both tables AND are compared using the = operator, you can use an `INNER JOIN` with a `USING` clause instead. This requires no table qualifiers, and each join column is named only once:

```sql
SELECT * 
FROM artist 
INNER JOIN painting
USING(a_id);
```

## Note:  when you write a query with a USING clause, SELECT * returns only one instance of each join column (a_id).

## Any of `ON`, `USING`, or `WHERE` can include comparisons, so how do you know which join conditions to put in each clause? As a rule of thumb, it’s conventional and expected for you to use `ON` or `USING` to specify how to join the tables, and the `WHERE` clause to restrict which of the joined rows to SELECT. 

## For example, to join tables based on the a_id column, but SELECT only rows for paintings obtained in Kentucky, use an ON (or USING) clause to match the rows in the two tables, and a WHERE clause to test the state column:

```sql
SELECT * 
FROM 
    artist 
INNER JOIN 
    painting
ON 
    artist.a_id = painting.a_id
WHERE 
    painting.state = 'KY';
```

## The preceding queries use `SELECT *` to select all columns. To be more selective about which columns a statement should display, provide a list that names only those columns in which you’re interested:

```sql
SELECT 
    artist.name, 
    painting.title, 
    painting.state, 
    painting.price
FROM 
    artist 
INNER JOIN 
    painting
ON 
    artist.a_id = painting.a_id
WHERE 
    painting.state = 'KY';
```

## You’re not limited to two tables when writing joins. Suppose that you prefer to see complete state names rather than abbreviations in the preceding query result. Suppose you have a states table that maps state abbreviations to names. You can add it to the previous query to display names:

```sql
SELECT 
    artist.name, 
    painting.title, 
    states.name, 
    painting.price
FROM 
    artist 
INNER JOIN 
    painting 
INNER JOIN 
    states
ON 
    artist.a_id = painting.a_id 
AND 
    painting.state = states.abbrev;
```

## Another common use of three-way joins is for enumerating many-to-many relation- ships. 
## By including appropriate conditions in your joins, you can answer very specific questions, such as the following:

### Which paintings did Van Gogh paint? 

## To answer this question, use the a_id value to find matching rows, add a `WHERE` clause to restrict output to those rows that contain the artist name, and `SELECT` the title from those rows:

```sql
SELECT 
    painting.title
FROM 
    artist 
INNER JOIN 
    painting 
ON 
    artist.a_id = painting.a_id
WHERE 
    artist.name = 'Van Gogh';
```
+-------------------+
| title             |
+-------------------+
| Starry Night      |
| The Potato Eaters |
| The Rocks         |
+-------------------+

### Here's another question: Who painted the Mona Lisa? 

## Again you use the a_id column to join the rows, but this time the WHERE clause restricts output to those rows that contain the title, and you SELECT the artist name from those rows:

```sql
SELECT 
    artist.name
FROM 
    artist 
INNER JOIN 
    painting 
ON 
    artist.a_id = painting.a_id
WHERE 
    painting.title = 'The Mona Lisa';
```
```
+----------+
| name  |
+----------+
| Da Vinci |
+----------+
```

## Which artists’ paintings did you purchase in Kentucky or Indiana? This is somewhat similar to the previous statement, but it tests a different column (a_id) in the painting table to determine which rows to join with the artist table:

```sql
SELECT DISTINCT artist.name
FROM 
    artist 
INNER JOIN 
    painting 
ON 
    artist.a_id = painting.a_id
WHERE 
    painting.state IN ('KY','IN');
```

```
+----------+
| name     |
+----------+
| Da Vinci |
| Van Gogh |
+----------+
```

## The statement also uses DISTINCT to display each artist name just once. Try it with- out DISTINCT and you’ll see that Van Gogh is listed twice; that’s because you obtained two Van Goghs in Kentucky.

## Joins can also be used with aggregate functions to produce summaries. For example, to find out how many paintings you have per artist, use this statement:

```sql
SELECT 
    artist.name, 
    COUNT(*) AS 'number of paintings'
FROM 
    artist 
INNER JOIN 
    painting 
ON 
    artist.a_id = painting.a_id
GROUP BY 
    artist.name;
```

```
+----------+---------------------+
| name  | number of paintings |
+----------+---------------------+
| Da Vinci |    2 |
| Renoir    |   1 |
| Van Gogh |    3 |
+----------+---------------------+
```

## A more elaborate statement might also show how much you paid for each artist’s paintings, in total and on average:

```sql
SELECT 
    artist.name,
    COUNT(*) AS 'number of paintings',
    SUM(painting.price) AS 'total price',
    AVG(painting.price) AS 'average price'
FROM 
    artist 
INNER JOIN 
    painting 
ON artist.a_id = painting.a_id
GROUP BY artist.name;
```

```
+----------+---------------------+-------------+---------------+
| name  | number of paintings | total price | average price |
+----------+---------------------+-------------+---------------+
| Da Vinci |    2 | 121 |   60.5000 |
| Renoir    |   1 | 64 |    64.0000 |
| Van Gogh |    3 | 148 |   49.3333 |
+----------+---------------------+-------------+---------------+
```

## Note that the summary statements produce output only for those artists in the artist table for whom you actually have acquired paintings. (For example, Monet is listed in the artist table but is not present in the summary because you don’t have any of his paintings yet.) If you want the summary to include all artists, even if you have none of their paintings yet, you must use a different kind of join—specifically, an outer join:
## Joins written with the comma operator or INNER JOIN are inner joins, which means that they produce a result only for values in one table that match values in another table.
## An outer join can produce those matches as well, but also can show you which values in one table are missing FROM the other. 

The `table_name.column_name` notation that qualifies a column name with a table name is **always strongly preferred** in a join.  SQL allows you to just use `column_name` if the name appears in only one of the joined tables, but  best practice says you should only do it when you are pulling data from one table. In that case, SQL can determine without ambiguity which table the column comes from, and no table name qualifier is necessary. 

## We can’t do that for the following join. Both tables have an `a_id` column, so the column reference is ambiguous:

```sql
-- This WILL NOT RUN, gives an error
SELECT * 
FROM artist 
INNER JOIN 
painting 
ON a_id = a_id;
```

## By contrast, the following query is unambiguous. Each instance of `a_id` is qualified with the appropriate table name, only artist has a name column, and only painting has title and state columns. To make the meaning of a statement clearer to human readers, it’s often useful to qualify column names with table names even when that’s not strictly necessary as far as SQL is concerned. In other words, you should **ALWAYS** include the table name for columns when you do a join for proper documentation. Your future self will thank you later!

```sql
-- Preferred readable query
SELECT 
    artist.name, 
    painting.title, 
    painting.state 
FROM 
    artist 
INNER JOIN 
    painting
ON 
    artist.a_id = painting.a_id;
```

```
+----------+-------------------+-------+
| name  | title | state |
+----------+-------------------+-------+
| Da Vinci | The Last Supper    | IN    |
| Da Vinci | The Mona Lisa  | MI    |
| Van Gogh | Starry Night   | KY    |
| Van Gogh | The Potato Eaters | KY |
| Van Gogh | The Rocks  | IA    |
| Renoir    | Les Deux Soeurs   | NE    |
+----------+-------------------+-------+
```

## You will also see aliases used in lieu of table names, like this:

```sql
-- less readable single letter table alias using `AS` keyword
SELECT 
    a.name, 
    p.title, 
    s.name, 
    p.price
FROM artist AS a 
INNER JOIN painting AS p 
INNER JOIN states AS s 
ON 
    a.a_id = p.a_id 
AND 
    p.state = s.abbrev;
```

## In `AS` alias clauses, the word `AS` is actually optional. So, online and in books you might see the above written like this: 

```sql
-- less readable single letter table alias without using `AS` keyword
SELECT 
    a.name, 
    p.title, 
    s.name, 
    p.price
FROM artist a 
INNER JOIN painting p 
INNER JOIN states s 
ON 
    a.a_id = p.a_id 
AND 
    p.state = s.abbrev;
```

For complicated statements that SELECT many columns it is true that aliases can save a lot of typing. But since it is easier to read more complex queries with proper, clear aliases, learn how to type! In addition, aliases are not only convenient but necessary for some types of statements, as will become evident when we get to the topic of self-joins (Recipe 12.3).

---

Finding Rows with No Match in Another Table
Problem
You want to find rows in one table that have no match in another. Or you want to produce a list on the basis of a join BETWEEN tables, and you want the list to include an entry for every row in the first table, even when there are no matches in the second table.

Solution
Use an outer join—a LEFT JOIN or a RIGHT JOIN.

Discussion
Recipe 12.1 focused on inner joins, which are joins that find matches BETWEEN two tables. However, the answers to some questions require deterMINing which rows do not have a match (or, stated another way, which rows have values that are missing FROM the other table). For example, you might want to know which artists in the artist table you don’t yet have any paintings by. The same kind of question occurs in other contexts. Some examples:
You’re working in sales. You have a list of potential customers, and another list of people who have placed orders. To focus your efforts on people who are not yet actual customers, you want to find people in the first list who are not in the second.
You have one list of baseball players, and another list of players who have hit home runs, and you want to know which players in the first list have not hit a home run. The answer is deterMINed by finding those players in the first list who are not in the second.
For these types of questions, it’s necessary to use an outer join. Like an inner join, an outer join can find matches BETWEEN tables. But unlike an inner join, an outer join can also deterMINe which rows in one table have no match in another. Two types of outer join are LEFT JOIN and RIGHT JOIN.
To see why outer joins are useful, let’s consider the problem of deterMINing which artists in the artist table are missing FROM the painting table. At present, the tables are small, so it’s easy to exaMINe them visually:
SELECT * FROM artist ORDER BY a_id;
+------+----------+
| a_id | name   |
+------+----------+
|   1 | Da Vinci |
|   2 | Monet   |
|   3 | Van Gogh |
|   4 | Picasso |
|   5 | Renoir  |
+------+----------+
SELECT * FROM painting ORDER BY a_id, p_id;
+------+------+-------------------+-------+-------+
| a_id | p_id | title   | state | price |
+------+------+-------------------+-------+-------+

+------+------+-------------------+-------+-------+
By looking at the tables, you can see that you have no paintings by Monet or Picasso (there are no painting rows with an a_id value of 2 or 4). But as you acquire more paintings and the tables get larger, it won’t be so easy to eyeball them and answer the question by inspection. Can you answer it using SQL? Sure, although first attempts at a solution generally look something like the following statement, which uses a not- equal condition to look for mismatches BETWEEN the two tables:
SELECT * FROM artist INNER JOIN painting
ON artist.a_id != painting.a_id;
+------+----------+------+------+-------------------+-------+-------+
| a_id | name   | a_id | p_id | title   | state | price |
+------+----------+------+------+-------------------+-------+-------+

|   4 | Picasso |   5 | 6 | Les Deux Soeurs | NE    |   64 |
+------+----------+------+------+-------------------+-------+-------+
That output obviously is not correct. (For example, it falsely indicates that each painting was painted by several different artists.) The problem is that the statement produces a list of all combinations of values FROM the two tables in which the artist ID values aren’t the same, WHEREas what you really need is a list of values in artist that aren’t present at all in painting. The trouble here is that an inner join can only produce results based on combinations of values that are present in both tables. It can’t tell you anything about values that are missing FROM one of them.
When faced with the problem of finding values in one table that have no match in (or that are missing FROM) another table, you should get in the habit of thinking, “Aha, that’s a LEFT JOIN problem.” A LEFT JOIN is one type of outer join: it’s similar to an inner join in that it attempts to match rows in the first (left) table with the rows in the second (right) table. But in addition, if a left table row has no match in the right table, a LEFT JOIN still produces a row—one in which all the columns FROM the right table are set to NULL. This means you can find values that are missing FROM the right table by looking for NULL. It’s easier to understand how this happens by working in stages. Begin with an inner join that displays matching rows:
SELECT * FROM artist INNER JOIN painting
ON artist.a_id = painting.a_id;
+------+----------+------+------+-------------------+-------+-------+
| a_id | name   | a_id | p_id | title   | state | price |
+------+----------+------+------+-------------------+-------+-------+

+------+----------+------+------+-------------------+-------+-------+
In this output, the first a_id column comes FROM the artist table and the second one comes FROM the painting table.
Now compare that result with the output you get FROM a LEFT JOIN. A LEFT JOIN is written much like an INNER JOIN:
SELECT * FROM artist LEFT JOIN painting
ON artist.a_id = painting.a_id;
+------+----------+------+------+-------------------+-------+-------+
| a_id | name   | a_id | p_id | title   | state | price |
+------+----------+------+------+-------------------+-------+-------+

|   5 | Renoir  |   5 | 6 | Les Deux Soeurs | NE    |   64 |
+------+----------+------+------+-------------------+-------+-------+
The output is similar to that FROM the inner join, except that the LEFT JOIN also produces at least one output row for every artist row, including those that have no painting table match. For those output rows, all the columns FROM painting are set to NULL. These are rows that the inner join does not produce.
Next, to restrict the output only to the nonmatched artist rows, add a WHERE clause that looks for NULL values in any painting column that cannot otherwise contain NULL. This filters out the rows that the inner join produces, leaving those produced only by the outer join:
SELECT * FROM artist LEFT JOIN painting
ON artist.a_id = painting.a_id
WHERE painting.a_id IS NULL;
+------+---------+------+------+-------+-------+-------+
| a_id | name   | a_id | p_id | title | state | price |
+------+---------+------+------+-------+-------+-------+
|   2 | Monet   | NULL | NULL | NULL | NULL | NULL |
|   4 | Picasso | NULL | NULL | NULL  | NULL  |  NULL |
+------+---------+------+------+-------+-------+-------+
Finally, to show only the artist table values that are missing FROM the painting table, shorten the output column list to include only columns FROM the artist table. The result is that the LEFT JOIN lists those left-table rows containing a_id values that are not present in the right table:
SELECT artist.* FROM artist LEFT JOIN painting
ON artist.a_id = painting.a_id
WHERE painting.a_id IS NULL;
+------+---------+
| a_id | name   |
+------+---------+
|   2 | Monet   |
|   4 | Picasso |
+------+---------+
A similar kind of operation can be used to report each left-table value along with an indicator as to whether it’s present in the right table. To do this, perform a LEFT JOIN that counts the number of times each left-table value occurs in the right table. A count of zero indicates that the value is not present. The following statement lists each artist FROM the artist table and shows whether you have any paintings by the artist:
SELECT artist.name,
IF(COUNT(painting.a_id)>0,'yes','no') AS 'in collection'
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
GROUP   BY  artist.name;
+----------+---------------+
| name  | in collection |
+----------+---------------+
| Da Vinci | yes    |
| Monet | no    |
| Picasso | no  |
| Renoir    | yes   |
| Van Gogh | yes    |
+----------+---------------+
A RIGHT JOIN is another kind of outer join. It is like LEFT JOIN but reverses the roles of the left and right tables. Semantically, RIGHT JOIN forces the matching process to pro- duce a row FROM each table in the right table, even in the absence of a corresponding row in the left table. Syntactically, tbl1 LEFT JOIN tbl2 is equivalent to tbl2 RIGHT JOIN tbl1. This means that you would rewrite the preceding LEFT JOIN as follows to convert it to a RIGHT JOIN that produces the same results:
SELECT artist.name,
IF(COUNT(painting.a_id)>0,'yes','no') AS 'in collection'
FROM painting RIGHT JOIN artist ON artist.a_id = painting.a_id
GROUP   BY  artist.name;
+----------+---------------+
| name  | in collection |
+----------+---------------+
| Da Vinci | yes    |
| Monet | no    |
| Picasso | no  |
| Renoir    | yes   |
| Van Gogh | yes    |
+----------+---------------+
ElseWHERE in this book, I’ll generally refer only to LEFT JOIN for brevity, but such refer- ences apply to RIGHT JOIN as well if you reverse the roles of the tables.


See Also
As shown in this section, LEFT JOIN is useful for finding values with no match in another table or for showing whether each value is matched. LEFT JOIN may also be used to
produce a summary that includes all items in a list, even those for which there’s nothing to SUMmarize. This is very common for characterizing the relationship BETWEEN a master table and a detail table. For example, a LEFT JOIN can produce “total sales per customer” reports that list all customers, even those who haven’t bought anything during the summary period. (See Recipe 12.4 for information about master-detail lists.)
You can also use LEFT JOIN to perform consistency checking when you receive two datafiles that are supposed to be related, and you want to deterMINe whether they really are. (That is, you want to check the integrity of their relationship.) Import each file into a MySQL table, and then run a couple of LEFT JOIN statements to deterMINe whether there are unattached rows in one table or the other—that is, rows that have no match in the other table. Recipe 12.13 discusses how to identify (and optionally delete) these unattached rows.

---

Comparing a Table to Itself
Problem
You want to compare rows in a table to other rows in the same table. For example, you want to find all paintings in your collection by the artist who painted The Potato Eat- ers. Or you want to know which states listed in the states table joined the Union in the same year as New York. Or you want to know which states did not join the Union in the same year as any other state.

Solution
Problems that require comparing a table to itself involve an operation known as a self- join. It’s performed much like other joins, except that you must always use table aliases so that you can refer to the same table different ways within the statement.

Discussion
A special case of joining one table to another occurs when both tables are the same. This is called a self-join. Although many people find the idea confusing or strange to think about at first, it’s perfectly legal. It’s likely that you’ll find yourself using self-joins quite often because they are so important.
A tip-off that you need a self-join is when you want to know which pairs of elements in a table satisfy some condition. For example, suppose that your favorite painting is The Potato Eaters, and you want to identify all the items in your collection that were done by the artist who painted it. Do so as follows:
Identify the row in the painting table that contains the title The Potato Eaters, so that you can refer to its a_id value.
Use the a_id value to match other rows in the table that have the same a_id value.
Display the titles FROM those matching rows.
The artist ID and painting titles that we begin with look like this:
SELECT a_id, title FROM painting ORDER BY a_id;
+------+-------------------+
| a_id | title  |
+------+-------------------+
|   1 | The Last Supper |
|   1 | The Mona Lisa   |
|   3 | Starry Night    |
|   3 | The Potato Eaters |
|   3 | The Rocks   |
|   5 | Les Deux Soeurs |
+------+-------------------+
A two-step method for picking out the right titles without a join is to look up the artist’s ID with one statement and then use the ID in a second statement to SELECT rows that match it:
SELECT @id := a_id FROM painting WHERE title = 'The Potato Eaters';
+-------------+
| @id := a_id |
+-------------+
|   3 |
+-------------+
SELECT title FROM painting WHERE a_id = @id;
+-------------------+
| title |
+-------------------+
| Starry Night  |
| The Potato Eaters |
| The Rocks |
+-------------------+
A different solution that requires only a single statement is to use a self-join. The trick to this lies in figuring out the proper notation to use. First attempts at writing a state- ment that joins a table to itself often look something like this:
SELECT title
FROM painting INNER JOIN painting
ON a_id = a_id;
WHERE title = 'The Potato Eaters';
ERROR 1066 (42000): Not unique table/alias: 'painting'
The problem with that statement is that the column references are ambiguous. MySQL can’t tell which instance of the painting table any given column name refers to. The solution is to give at least one instance of the table an alias so that you can distinguish column references by using different table qualifiers. The following statement shows how to do this, using the aliases p1 and p2 to refer to the painting table different ways:
SELECT p2.title
FROM painting AS p1 INNER JOIN painting AS p2
ON p1.a_id = p2.a_id
WHERE p1.title = 'The Potato Eaters';
+-------------------+
| title |
+-------------------+
| Starry Night  |
| The Potato Eaters |
| The Rocks |
+-------------------+
The statement output illustrates something typical of self-joins: when you begin with a reference value in one table instance (The Potato Eaters) to find matching rows in a second table instance (paintings by the same artist), the output includes the reference value. That makes sense: after all, the reference matches itself. If you want to find only other paintings by the same artist, explicitly exclude the reference value FROM the output:
SELECT p2.title
FROM painting AS p1 INNER JOIN painting AS p2
ON p1.a_id = p2.a_id
WHERE p1.title = 'The Potato Eaters' AND p2.title != 'The Potato Eaters';
+--------------+
| title |
+--------------+
| Starry Night |
| The Rocks |
+--------------+
A more general way to exclude the reference value without naMINg it literally is to specify that you don’t want output rows to have the same title as the reference, whatever that title happens to be:
SELECT p2.title
FROM painting AS p1 INNER JOIN painting AS p2
ON p1.a_id = p2.a_id
WHERE p1.title = 'The Potato Eaters' AND p2.title != p1.title
+--------------+
| title |
+--------------+
| Starry Night |
| The Rocks |
+--------------+
The preceding statements use comparisons of ID values to match rows in the two table instances, but any kind of value can be used. For example, to use the states table to answer the question “Which states joined the Union in the same year as New York?,” perform a temporal pairwise comparison based on the year part of the dates in the table’s statehood column:
SELECT s2.name, s2.statehood
FROM states AS s1 INNER JOIN states AS s2
ON YEAR(s1.statehood) = YEAR(s2.statehood)
WHERE s1.name = 'New York'
ORDER BY s2.name;
+----------------+------------+
| name  | statehood |
+----------------+------------+
| Connecticut   | 1788-01-09 |
| Georgia   | 1788-01-02 |
| Maryland  | 1788-04-28 |
| Massachusetts  | 1788-02-06 |
| New Hampshire  | 1788-06-21 |
| New York  | 1788-07-26 |
| South Carolina | 1788-05-23 |
| Virginia  | 1788-06-25 |
+----------------+------------+
Here again, the reference value (New York) appears in the output. If you want to prevent that, add to the ON expression a term that explicitly excludes the reference:
SELECT s2.name, s2.statehood
FROM states AS s1 INNER JOIN states AS s2
ON YEAR(s1.statehood) = YEAR(s2.statehood) AND s1.name != s2.name
WHERE s1.name = 'New York'
ORDER BY s2.name;
+----------------+------------+
| name  | statehood |
+----------------+------------+
| Connecticut   | 1788-01-09 |
| Georgia   | 1788-01-02 |
| Maryland  | 1788-04-28 |
| Massachusetts  | 1788-02-06 |
| New Hampshire  | 1788-06-21 |
| South Carolina | 1788-05-23 |
| Virginia  | 1788-06-25 |
+----------------+------------+
Like the problem of finding other paintings by the painter of The Potato Eaters, the statehood problem can be solved by using a user-defined variable and two statements. That will always be true when you’re seeking matches for just one particular row in your table. Other problems require finding matches for several rows, in which case the two-statement method will not work. Suppose that you want to find each pair of states that joined the Union in the same year. In this case, the output potentially can include any pair of rows FROM the states table. There is no fixed reference value, so you cannot store the reference in a variable. A self-join is perfect for this problem:
SELECT YEAR(s1.statehood) AS year,
s1.name AS name1, s1.statehood AS statehood1,
s2.name AS name2, s2.statehood AS statehood2
FROM states AS s1 INNER JOIN states AS s2
ON YEAR(s1.statehood) = YEAR(s2.statehood) AND s1.name != s2.name
ORDER BY year, s1.name, s2.name;
+------+----------------+------------+----------------+------------+
| year | name1  | statehood1 | name2    | statehood2 |
+------+----------------+------------+----------------+------------+


+------+----------------+------------+----------------+------------+
The condition in the ON clause that requires state pair names not to be identical elimi- nates the trivially duplicate rows showing that each state joined the Union in the same year as itself. But you’ll notice that each remaining pair of states still appears twice. For example, there is one row that lists Delaware and New Jersey, and another that lists New Jersey and Delaware. This is often the case with self-joins: they produce pairs of rows that contain the same values, but for which the values are not in the same order. For techniques that eliMINate these “near duplicates” FROM the query result, see Rec- ipe 14.5.
Some self-join problems are of the “Which values are not matched by other rows in the table?” variety. An instance of this is the question “Which states did not join the Union in the same year as any other state?” Finding these states is a “nonmatch” problem, which is the type of problem that typically involves a LEFT JOIN. In this case, the solution uses a LEFT JOIN of the states table to itself:
SELECT s1.name, s1.statehood
FROM states AS s1 LEFT JOIN states AS s2
ON YEAR(s1.statehood) = YEAR(s2.statehood) AND s1.name != s2.name
WHERE s2.name IS NULL
ORDER BY s1.name;
+----------------+------------+
| name  | statehood |
+----------------+------------+

| North Carolina | 1789-11-21 |
| Ohio  | 1803-03-01 |
| Oklahoma  | 1907-11-16 |
| Oregon    | 1859-02-14 |
| Rhode Island  | 1790-05-29 |
| Tennessee | 1796-06-01 |
| Utah  | 1896-01-04 |
| Vermont   | 1791-03-04 |
| West Virginia  | 1863-06-20 |
| Wisconsin | 1848-05-29 |
+----------------+------------+
For each row in the states table, the statement SELECTs rows in which the state has a statehood value in the same year, not including that state itself. For rows HAVING no such match, the LEFT JOIN forces the output to contain a row anyway, with all the s2 columns set to NULL. Those rows identify the states with no other state that joined the Union in the same year.

---
Producing Master-Detail Lists and SUMmaries
Problem
Two related tables have a master-detail relationship, and you want to produce a list that shows each master row with its detail rows or a list that produces a summary of the detail rows for each master row.

Solution
This is a one-to-many relationship. The solution to this problem involves a join, but the type of join depends on the question you want answered. To produce a list con- taining only master rows for which some detail row exists, use an inner join based on the primary key in the master table. To produce a list that includes entries for all master rows, even those that have no detail rows, use an outer join.

Discussion
It’s often useful to produce a list FROM two related tables. For tables that have a master- detail or parent-child relationship, a given row in one table might be matched by several rows in the other. This recipe suggests some questions of this type that you can ask (and answer), using the artist and painting tables FROM earlier in the chapter.
One form of master-detail question for these tables is, “Which artist painted each painting?” This is a simple inner join that matches each painting row to its corre- sponding artist row based on the artist ID values:
SELECT artist.name, painting.title
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id
ORDER BY name, title;
+----------+-------------------+
| name  | title |
+----------+-------------------+
| Da Vinci | The Last Supper    |
| Da Vinci | The Mona Lisa  |
| Renoir    | Les Deux Soeurs   |
| Van Gogh | Starry Night   |
| Van Gogh | The Potato Eaters |
| Van Gogh | The Rocks  |
+----------+-------------------+
An inner join suffices as long as you want to list only master rows that have detail rows. However, another form of master-detail question you can ask is, “Which paintings did each artist paint?” That question is similar but not quite identical. It will have a different answer if there are artists listed in the artist table that are not represented in the painting table, and the question requires a different statement to produce the proper answer. In that case, the join output should include rows in one table that have no match in the other. That’s a form of “find the nonmatching rows” problem that requires an outer join (Recipe 12.2). Thus, to list each artist row, whether there are any paint ing rows for it, use a LEFT JOIN:
SELECT artist.name, painting.title
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
ORDER BY name, title;
+----------+-------------------+
| name  | title |
+----------+-------------------+
| Da Vinci | The Last Supper    |
| Da Vinci | The Mona Lisa  |
| Monet | NULL  |
| Picasso | NULL    |
| Renoir    | Les Deux Soeurs   |
| Van Gogh | Starry Night   |
| Van Gogh | The Potato Eaters |
| Van Gogh | The Rocks  |
+----------+-------------------+
The rows in the result that have NULL in the title column correspond to artists that are listed in the artist table for whom you have no paintings.
The same principles apply when producing SUMmaries using master and detail tables. For example, to SUMmarize your art collection by number of paintings per painter, you might ask, “How many paintings are there per artist in the painting table?” To find the answer based on artist ID, you can count up the paintings easily with this statement:
SELECT a_id, COUNT(a_id) AS count FROM painting GROUP BY a_id;
+------+-------+
| a_id | count |
+------+-------+
|   1 | 2 |
|   3 | 3 |
|   5 | 1 |
+------+-------+
Of course, that output is essentially meaningless unless you have all the artist ID num- bers memorized. To display the artists by name rather than ID, join the painting table to the artist table:
SELECT artist.name AS painter, COUNT(painting.a_id) AS count
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id
GROUP BY artist.name;
+----------+-------+
| painter  | count |
+----------+-------+
| Da Vinci |    2 |
| Renoir    |   1 |
| Van Gogh |    3 |
+----------+-------+
On the other hand, you might ask, “How many paintings did each artist paint?” This is the same question as the previous one (and the same statement answers it), as long as every artist in the artist table has at least one corresponding painting table row. But if you have artists in the artist table that are not yet represented by any paintings in your collection, they will not appear in the statement output. To produce a count- per-artist summary that includes even artists with no paintings in the painting table, use a LEFT JOIN:
SELECT artist.name AS painter, COUNT(painting.a_id) AS count
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
GROUP BY artist.name;
+----------+-------+
| painter  | count |
+----------+-------+
| Da Vinci |    2 |
| Monet |   0 |
| Picasso | 0 |
| Renoir    |   1 |
| Van Gogh |    3 |
+----------+-------+
Beware of a subtle error that is easy to make when writing that kind of statement. Suppose that you write the COUNT( ) function slightly differently, like so:
SELECT artist.name AS painter, COUNT(*) AS count
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
GROUP BY artist.name;
+----------+-------+
| painter  | count |
+----------+-------+
| Da Vinci |    2 |
| Monet |   1 |
| Picasso | 1 |
| Renoir    |   1 |
| Van Gogh |    3 |
+----------+-------+
Now every artist appears to have at least one painting. Why the difference? The cause of the problem is that the statement uses COUNT(*) rather than COUNT(painting.a_id). The way LEFT JOIN works for unmatched rows in the left table is that it generates a row with all the columns FROM the right table set to NULL. In the example, the right table is painting. The statement that uses COUNT(painting.a_id) works correctly, because COUNT
( expr ) counts only non-NULL values. The statement that uses COUNT(*) works incor- rectly because it counts rows, even those containing NULL that correspond to missing artists.
LEFT JOIN is suitable for other types of SUMmaries as well. To produce additional col- umns showing the total and average values of the paintings for each artist in the artist table, use this statement:
SELECT artist.name AS painter,
COUNT(painting.a_id) AS 'number of paintings',
SUM(painting.price) AS 'total price',
AVG(painting.price) AS 'average price'
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
GROUP BY artist.name;
+----------+---------------------+-------------+---------------+
| painter  | number of paintings | total price | average price |
+----------+---------------------+-------------+---------------+

+----------+---------------------+-------------+---------------+
Note that COUNT( ) is zero for artists that are not represented, but SUM( ) and AVG( ) are NULL. The latter two functions return NULL when applied to a set of values with no non- NULL values. To display a SUM or average value of zero in that case, modify the statement to test the value of SUM( ) or AVG( ) with COALESCE( ):
SELECT artist.name AS painter,
COUNT(painting.a_id) AS 'number of paintings',
COALESCE(SUM(painting.price),0) AS 'total price',
COALESCE(AVG(painting.price),0) AS 'average price'
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id
GROUP BY artist.name;
+----------+---------------------+-------------+---------------+
| painter  | number of paintings | total price | average price |
+----------+---------------------+-------------+---------------+

+----------+---------------------+-------------+---------------+


```sql
SELECT 
    CASE WHEN expression IS NULL 
            THEN replacement 
            ELSE expression 
    END AS column_alias;
```
---

Enumerating a Many-to-Many Relationship
Problem
You want to display a relationship BETWEEN tables when rows in either table might be matched by multiple rows in the other table.
Solution
This is a many-to-many relationship. It requires a third table for associating your two primary tables and a three-way join to list the correspondences BETWEEN them.

Discussion
The artist and painting tables used in earlier sections are related in a one-to-many relationship: a given artist may have produced many paintings, but each painting was created by only one artist. One-to-many relationships are relatively simple and the two tables in the relationship can be joined with a key that is common to both tables.
Even simpler is the one-to-one relationship, which often is used to perform lookups that map one set of values to another. For example, the states table contains name and abbrev columns that list full state names and their corresponding abbreviations:
SELECT name, abbrev FROM states;
+----------------+--------+
| name  | abbrev |
+----------------+--------+

This one-to-one relationship can be used to map state name abbreviations in the painting table, which contains a state column indicating the state in which each paint- ing was purchased. With no mapping, painting entries can be displayed like this:
SELECT title, state FROM painting ORDER BY state;
+-------------------+-------+
| title | state |
+-------------------+-------+
| The Rocks | IA    |
| The Last Supper   | IN    |
| Starry Night  | KY    |
| The Potato Eaters | KY    |
| The Mona Lisa | MI    |
| Les Deux Soeurs   | NE    |
+-------------------+-------+
If you want to see the full state names rather than abbreviations, exploit the one-to-one relationship that exists BETWEEN the two that is enumerated in the states table. Join that table to the painting table as follows, using the abbreviation values that are com- mon to the two tables:
SELECT painting.title, states.name AS state
FROM painting INNER JOIN states ON painting.state = states.abbrev
ORDER BY state;
+-------------------+----------+
| title | state |
+-------------------+----------+
| The Last Supper   | Indiana |
| The Rocks | Iowa  |
| Starry Night  | Kentucky |
| The Potato Eaters | Kentucky |
| The Mona Lisa | Michigan |
| Les Deux Soeurs   | Nebraska |
+-------------------+----------+
A more complex relationship BETWEEN tables is the many-to-many relationship, which occurs when a row in one table may have many matches in the other, and vice versa. To illustrate such a relationship, this is the point at which database books typically devolve into the “parts and suppliers” problem. (A given part may be available through several suppliers; how can you produce a list showing which parts are available FROM which suppliers?) However, HAVING seen that example far too many times, I prefer to use a different illustration. So, even though conceptually it’s really the same idea, let’s use the following scenario: you and a bunch of your friends are avid enthusiasts of euchre, a four-handed card game played with two teams of partners. Each year, you all get together, pair off, and run a friendly tournament. Naturally, to avoid controversy about how different players might remember the results of each tournament, you record the pairings and outcomes in a database. One way to store the results is with a table that is set up as follows, WHERE for each tournament year, you record the team names, win-loss records, players, and player cities of residence:
SELECT * FROM euchre ORDER BY year, wins DESC, player;
+----------+------+------+--------+----------+-------------+
| team  | year | wins | losses | player | player_city |
+----------+------+------+--------+----------+-------------+

+----------+------+------+--------+----------+-------------+
As shown by the table, each team has multiple players, and each player has participated in multiple teams. The table captures the nature of this many-to-many relationship, but it’s also in nonnormal form, because each row unnecessarily stores quite a bit of repetitive information. (Information for each team is recorded multiple times, as is information about each player.) A better way to represent this many-to-many relation- ship is to use multiple tables:
Store each team name, year, and record once in a table named euchre_team.
Store each player name and city of residence once in a table named
euchre_player.
Create a third table, euchre_link, that stores team-player associations and serves as a link, or bridge, BETWEEN the two primary tables. To MINimize the information stored in this table, assign unique IDs to each team and player within their respec- tive tables, and store only those IDs in the euchre_link table.
The resulting team and player tables look like this:
SELECT * FROM euchre_team;
+----+----------+------+------+--------+
| id | name | year | wins | losses |
+----+----------+------+------+--------+
|  1 | Kings    | 2005 |    10 |    2 |
|  2 | Crowns   | 2005 |    7 | 5 |
|  3 | Stars    | 2005 |    4 | 8 |
|  4 | Sceptres | 2005 |    3 | 9 |
|  5 | Kings    | 2006 |    8 | 4 |
|  6 | Crowns   | 2006 |    9 | 3 |
|  7 | Stars    | 2006 |    5 | 7 |
|  8 | Sceptres | 2006 |    2 | 10 |
+----+----------+------+------+--------+
SELECT * FROM euchre_player;
+----+----------+---------+
| id | name | city  |
+----+----------+---------+
|  1 | Ben  | Cork  |
|  2 | Billy    | York  |
|  3 | Tony | Derry |
|  4 | Melvin   | Dublin |
|  5 | Franklin | Bath  |
|  6 | Wallace  | Cardiff |
|  7 | Nigel    | London |
|  8 | Maurice | Leeds  |
+----+----------+---------+
The euchre_link table associates teams and players as follows:
SELECT * FROM euchre_link;
+---------+-----------+
| team_id | player_id |
+---------+-----------+


+---------+-----------+
To answer questions about the teams or players using these tables, you need to perform a three-way join, using the link table to relate the two primary tables to each other. Here are some examples:
List all the pairings that show the teams and who played on them. This statement enumerates all the correspondences BETWEEN the euchre_team and euchre_player tables and reproduces the information that was originally in the nonnormal euchre table:
SELECT t.name, t.year, t.wins, t.losses, p.name, p.city
FROM euchre_team AS t INNER JOIN euchre_link AS l
INNER JOIN euchre_player AS p
ON t.id = l.team_id AND p.id = l.player_id
ORDER BY t.year, t.wins DESC, p.name;
+----------+------+------+--------+----------+---------+
| name  | year | wins | losses | name   | city  |
+----------+------+------+--------+----------+---------+

+----------+------+------+--------+----------+---------+
List the members for a particular team (the 2005 Crowns):
SELECT p.name, p.city
FROM euchre_team AS t INNER JOIN euchre_link AS l
INNER JOIN euchre_player AS p
ON t.id = l.team_id AND p.id = l.player_id
AND t.name = 'Crowns' AND t.year = 2005;
+--------+--------+
| name  | city  |
+--------+--------+
| Tony  | Derry |
| Melvin | Dublin |
+--------+--------+
List the teams that a given player (Billy) has been a member of:
SELECT t.name, t.year, t.wins, t.losses
FROM euchre_team AS t INNER JOIN euchre_link AS l
INNER JOIN euchre_player AS p
ON t.id = l.team_id AND p.id = l.player_id
WHERE p.name = 'Billy';
+----------+------+------+--------+
| name  | year | wins | losses |
+----------+------+------+--------+
| Kings | 2005 |    10 |    2 |
| Sceptres | 2006 | 2 | 10 |
+----------+------+------+--------+

---

Finding Rows Containing Per-Group minimum or maximum Values
Problem
You want to find which row within each group of rows in a table contains the maximum or minimum value for a given column. For example, you want to deterMINe the most expensive painting in your collection for each artist.

Solution
Create a temporary table to hold the per-group maximum or minimum values, and then join the temporary table with the original one to pull out the matching row for each group. If you prefer a single-query solution, use a subquery in the FROM clause rather than a temporary table.

Discussion
Many questions involve finding largest or smallest values in a particular table column, but it’s also common to want to know what the other values are in the row that contains the value. For example, when you are using the artist and painting tables, it’s possible to answer questions like “What is the most expensive painting in the collection, and who painted it?” One way to do this is to store the highest price in a user-defined variable and then use the variable to identify the row containing the price so that you can retrieve other columns FROM it:
SET @MAX_price = (SELECT MAX(price) FROM painting);
SELECT artist.name, painting.title, painting.price
FROM artist INNER JOIN painting
ON painting.a_id = artist.a_id
WHERE painting.price = @MAX_price;
+----------+---------------+-------+
| name  | title | price |
+----------+---------------+-------+
| Da Vinci | The Mona Lisa |    87 |
+----------+---------------+-------+
The same thing can be done by creating a temporary table to hold the maximum price and then joining it with the other tables:
CREATE TABLE tmp SELECT MAX(price) AS MAX_price FROM painting;
SELECT artist.name, painting.title, painting.price
FROM artist INNER JOIN painting INNER JOIN tmp
ON painting.a_id = artist.a_id
AND painting.price = tmp.MAX_price;
+----------+---------------+-------+
| name  | title | price |
+----------+---------------+-------+
| Da Vinci | The Mona Lisa |    87 |
+----------+---------------+-------+
The techniques of using a user-defined variable or a temporary table as just shown were illustrated originally in Recipe 8.5. Their use here is similar except that now we are applying them to multiple tables.
On the face of it, using a temporary table and a join is just a more complicated way of answering the question than with a user-defined variable. Does this technique have any practical value? Yes, it does, because it leads to a more general technique for answering more difficult questions. The previous statements show information only for the single most expensive painting in the entire painting table. What if your question is, “What is the most expensive painting for each artist?” You can’t use a user-defined variable to answer that question, because the answer requires finding one price per artist, and a variable can hold only a single value at a time. But the technique of using a temporary table works well, because the table can hold multiple rows, and a join can find matches for all of them.
To answer the question, SELECT each artist ID and the corresponding maximum painting price into a temporary table. The table will contain not just the maximum painting price but the maximum within each group, WHERE “group” is defined as “paintings by a given artist.” Then use the artist IDs and prices stored in the tmp table to match rows in the painting table, and join the result with the artist table to get the artist names:
CREATE TABLE tmp
SELECT a_id, MAX(price) AS MAX_price FROM painting GROUP BY a_id;
SELECT artist.name, painting.title, painting.price
FROM artist INNER JOIN painting INNER JOIN tmp
ON painting.a_id = artist.a_id
AND painting.a_id = tmp.a_id
AND painting.price = tmp.MAX_price;
+----------+-------------------+-------+
| name  | title | price |
+----------+-------------------+-------+
| Da Vinci | The Mona Lisa  |   87 |
| Van Gogh | The Potato Eaters |    67 |
| Renoir    | Les Deux Soeurs   |   64 |
+----------+-------------------+-------+
To obtain the same result with a single statement, use a subquery in the FROM clause that retrieves the same rows contained in the temporary table:
SELECT artist.name, painting.title, painting.price
FROM artist INNER JOIN painting INNER JOIN
(SELECT a_id, MAX(price) AS MAX_price FROM painting GROUP BY a_id)
 AS tmp
ON painting.a_id = artist.a_id
AND painting.a_id = tmp.a_id
AND painting.price = tmp.MAX_price;
+----------+-------------------+-------+
| name  | title | price |
+----------+-------------------+-------+
| Da Vinci | The Mona Lisa  |   87 |
| Van Gogh | The Potato Eaters |    67 |
| Renoir    | Les Deux Soeurs   |   64 |
+----------+-------------------+-------+
Yet another way to answer maximum-per-group questions is to use a LEFT JOIN that joins a table to itself. The following statement identifies the highest-priced painting per artist ID (we are using IS NULL to SELECT all the rows FROM p1 for which there is no row in p2 with a higher price):
SELECT p1.a_id, p1.title, p1.price
FROM  painting  AS  p1  LEFT  JOIN  painting  AS p2
ON  p1.a_id  =  p2.a_id  AND   p1.price  <  p2.price
WHERE p2.a_id IS NULL;
+------+-------------------+-------+
| a_id | title  | price |
+------+-------------------+-------+
|   1 | The Mona Lisa   |   87 |
|   3 | The Potato Eaters | 67 |
|   5 | Les Deux Soeurs |   64 |
+------+-------------------+-------+
To display artist names rather than ID values, join the result of the LEFT JOIN to the
artist table:
SELECT artist.name, p1.title, p1.price
FROM  painting  AS  p1  LEFT  JOIN  painting  AS p2
ON  p1.a_id  =  p2.a_id  AND   p1.price  <  p2.price
INNER JOIN artist ON p1.a_id = artist.a_id
WHERE p2.a_id IS NULL;
+----------+-------------------+-------+
| name  | title | price |
+----------+-------------------+-------+
| Da Vinci | The Mona Lisa  |   87 |
| Van Gogh | The Potato Eaters |    67 |
| Renoir    | Les Deux Soeurs   |   64 |
+----------+-------------------+-------+
The self–LEFT JOIN method is perhaps somewhat less intuitive than using a temporary table or a subquery.
The techniques just shown work for other kinds of values, such as temporal values. Consider the driver_log table that lists drivers and trips that they’ve taken:
SELECT name, travel_date, miles
FROM driver_log
ORDER BY name, travel_date;
+-------+------------+-------+
| name  | travel_date  | miles |
+-------+------------+-------+
| Ben   | 2006-08-29 |  131 |
| Ben   | 2006-08-30 |  152 |
| Ben   | 2006-09-02 |  79 |
| Henry | 2006-08-26 |  115 |
| Henry | 2006-08-27 |  96 |
| Henry | 2006-08-29 |  300 |
| Henry | 2006-08-30 |  203 |
| Henry | 2006-09-01 |  197 |
| Suzi  | 2006-08-29 |  391 |
| Suzi  | 2006-09-02 |  502 |
+-------+------------+-------+
One type of maximum-per-group problem for this table is “show the most recent trip for each driver.” It can be solved with a temporary table like this:
CREATE TABLE tmp
SELECT name, MAX(travel_date) AS travel_date
FROM driver_log GROUP BY name;
SELECT driver_log.name, driver_log.travel_date, driver_log.miles
FROM driver_log INNER JOIN tmp
ON driver_log.name = tmp.name AND driver_log.travel_date = tmp.travel_date
ORDER BY driver_log.name;
+-------+------------+-------+
| name  | travel_date  | miles |
+-------+------------+-------+
| Ben   | 2006-09-02 |  79 |
| Henry | 2006-09-01 |  197 |
| Suzi  | 2006-09-02 |  502 |
+-------+------------+-------+
You can also use a subquery in the FROM clause like this:
SELECT driver_log.name, driver_log.travel_date, driver_log.miles
FROM driver_log INNER JOIN
(SELECT name, MAX(travel_date) AS travel_date
FROM driver_log GROUP BY name) AS tmp
ON driver_log.name = tmp.name AND driver_log.travel_date = tmp.travel_date
ORDER BY driver_log.name;
+-------+------------+-------+
| name  | travel_date  | miles |
+-------+------------+-------+
| Ben   | 2006-09-02 |  79 |
| Henry | 2006-09-01 |  197 |
| Suzi  | 2006-09-02 |  502 |
+-------+------------+-------+
Which technique is better: the temporary table or the subquery in the FROM clause? For small tables, there might not be much difference either way. If the temporary table or subquery result is large, a general advantage of the temporary table is that you can index it after creating it and before using it in a join.

See Also
This recipe shows how to answer maximum-per-group questions by Selecting summary information into a temporary table and joining that table to the original one or by using a subquery in the FROM clause. These techniques have application in many contexts. One of them is calculation of team standings, WHERE the standings for each group of teams are deterMINed by comparing each team in the group to the team with the best record. Recipe 12.7 discusses how to do this.


---

Computing Team Standings
Problem
You want to compute team standings FROM their win-loss records, including the games- behind (GB) values.

Solution
DeterMINe which team is in first place, and then join that result to the original rows.

Discussion
Standings for sports teams that compete against each other typically are ranked ac- cording to who has the best win-loss record, and the teams not in first place are assigned a “games-behind” value indicating how many games out of first place they are. This section shows how to calculate those values. The first example uses a table containing a single set of team records to illustrate the logic of the calculations. The second example uses a table containing several sets of records (that is, the records for all teams in both divisions of a league, for both halves of the season). In this case, it’s necessary to use a join to perform the calculations independently for each group of teams.
Consider the following table, standings1, which contains a single set of baseball team records (they represent the final standings for the Northern League in the year 1902):
SELECT team, wins, losses FROM standings1
ORDER BY wins-losses DESC;
+-------------+------+--------+
| team  | wins | losses |
+-------------+------+--------+

| Grand Forks | 28 |    26 |
| Devils Lake | 19 |    31 |
| Cavalier  |   15 |    32 |
+-------------+------+--------+
The rows are sorted by the win-loss differential, which is how to place teams in order FROM first place to last place. But displays of team standings typically include each team’s winning percentage and a figure indicating how many games behind the leader all the other teams are. So let’s add that information to the output. Calculating the percentage is easy. It’s the ratio of wins to total games played and can be deterMINed using this expression:
wins / (wins + losses)
This expression involves division by zero when a team has not played any games yet. For simplicity, I’ll assume a nonzero number of games, but if you want to handle this condition, generalize the expression as follows:
IF(wins=0,0,wins/(wins+losses))
This expression uses the fact that no division at all is necessary unless the team has won at least one game.
DeterMINing the games-behind value is a little trickier. It’s based on the relationship of the win-loss records for two teams, calculated as the average of two values:
The number of games the second-place team must win to have the same number of wins as the first-place team
The number of games the first-place team must lose to have the same number of losses as the second-place team
For example, suppose two teams A and B have the following win-loss records:
+------+------+--------+
| team | wins | losses |
+------+------+--------+
| A |   17 |    11 |
| B |   14 |    12 |
+------+------+--------+
Here, team B has to win three more games, and team A has to lose one more game for the teams to be even. The average of three and one is two, thus B is two games behind
A. Mathematically, the games-behind calculation for the two teams can be expressed like this:
((winsA - winsB) + (lossesB - lossesA)) / 2
With a little rearrangement of terms, the expression becomes:
((winsA - lossesA) - (winsB - lossesB)) / 2
The second expression is equivalent to the first, but it has each factor written as a single team’s win-loss differential, rather than as a comparison BETWEEN teams. This makes it easier to work with, because each factor can be deterMINed independently FROM a single
team record. The first factor represents the first-place team’s win-loss differential, so if we calculate that value first, all the other teams GB values can be deterMINed in relation to it.
The first-place team is the one with the largest win-loss differential. To find that value and save it in a variable, use this statement:
SET @wl_diff = (SELECT MAX(wins-losses) FROM standings1);

Then use the differential as follows to produce team standings that include winning percentage and GB values:
SELECT team, wins AS W, losses AS L,
wins/(wins+losses) AS PCT,
(@wl_diff - (wins-losses)) / 2 AS GB
FROM standings1
ORDER BY wins-losses DESC, PCT DESC;
+-------------+------+------+--------+---------+
| team  | W | L | PCT   | GB    |
+-------------+------+------+--------+---------+
| Winnipeg  |   37 |    20 | 0.6491 |  0.0000 |
| Crookston |   31 |    25 | 0.5536 |  5.5000 |
| Fargo |   30 |    26 | 0.5357 |  6.5000 |
| Grand Forks | 28 |    26 | 0.5185 |  7.5000 |
| Devils Lake | 19 |    31 | 0.3800 | 14.5000 |
| Cavalier  |   15 |    32 | 0.3191 | 17.0000 |
+-------------+------+------+--------+---------+
There are a couple of MINor formatting issues that can be addressed at this point. Typ- ically, standings listings display percentages to three decimal places, and the GB value to one decimal place (with the exception that the GB value for the first-place team is displayed as -). To display n decimal places, TRUNCATE( expr , n ) can be used. To display the GB value for the first-place team appropriately, put the expression that calculates the GB column within a call to IF( ) that maps 0 to a dash:
SELECT team, wins AS W, losses AS L,
TRUNCATE(wins/(wins+losses),3) AS PCT,
IF(@wl_diff = wins-losses,
 '-',TRUNCATE((@wl_diff - (wins-losses))/2,1)) AS GB
FROM standings1
ORDER BY wins-losses DESC, PCT DESC;
+-------------+------+------+-------+------+
| team  | W | L | PCT   | GB    |
+-------------+------+------+-------+------+
| Winnipeg  |   37 |    20 | 0.649 | -  |
| Crookston |   31 |    25 | 0.553 | 5.5 |
| Fargo |   30 |    26 | 0.535 | 6.5 |
| Grand Forks | 28 |    26 | 0.518 | 7.5 |
| Devils Lake | 19 |    31 | 0.380 | 14.5 |
| Cavalier  |   15 |    32 | 0.319 | 17.0 |
+-------------+------+------+-------+------+
These statements order the teams by win-loss differential, using winning percentage as a tie-breaker in case there are teams with the same differential value. It would be simpler just to sort by percentage, of course, but then you wouldn’t always get the correct ordering. It’s a curious fact that a team with a lower winning percentage can actually be higher in the standings than a team with a higher percentage. (This generally occurs early in the season, when teams may have played highly disparate numbers of games, relatively speaking.) Consider the case in which two teams, A and B, have the following rows:
+------+------+--------+
| team | wins | losses |
+------+------+--------+
| A |   4 | 1 |
| B |   2 | 0 |
+------+------+--------+
Applying the GB and percentage calculations to these team records yields the following result, in which the first-place team actually has a lower winning percentage than the second-place team:
+------+------+------+-------+------+
| team | W  | L | PCT   | GB    |
+------+------+------+-------+------+
| A |   4 | 1 | 0.800 | -   |
| B |   2 | 0 | 1.000 | 0.5 |
+------+------+------+-------+------+
The standings calculations shown thus far can be done without a join. They involve only a single set of team records, so the first-place team’s win-loss differential can be stored in a variable. A more complex situation occurs when a dataset includes several sets of team records. For example, the 1997 Northern League had two divisions (Eastern and Western). In addition, separate standings were maintained for the first and second halves of the season, because season-half winners in each division played each other for the right to compete in the league championship. The following table, standings2, shows what these rows look like, ordered by season half, division, and win-loss differential:
SELECT half, division, team, wins, losses FROM standings2
ORDER BY half, division, wins-losses DESC;
+------+----------+-----------------+------+--------+
| half | division | team    | wins | losses |
+------+----------+-----------------+------+--------+


+------+----------+-----------------+------+--------+
Generating the standings for these rows requires computing the GB values separately for each of the four combinations of season half and division. Begin by calculating the win-loss differential for the first-place team in each group and saving the values into a separate firstplace table:
CREATE TABLE firstplace
SELECT half, division, MAX(wins-losses) AS wl_diff
FROM standings2
GROUP BY half, division;

Then join the firstplace table to the original standings, associating each team record with the proper win-loss differential to compute its GB value:
SELECT wl.half, wl.division, wl.team, wl.wins AS W, wl.losses AS L,
TRUNCATE(wl.wins/(wl.wins+wl.losses),3) AS PCT,
IF(fp.wl_diff = wl.wins-wl.losses,
 '-',TRUNCATE((fp.wl_diff - (wl.wins-wl.losses)) / 2,1)) AS GB
FROM standings2 AS wl INNER JOIN firstplace AS fp
ON wl.half = fp.half AND wl.division = fp.division
ORDER BY wl.half, wl.division, wl.wins-wl.losses DESC, PCT DESC;
+------+----------+-----------------+------+------+-------+------+
| half | division | team    | W | L | PCT   | GB    |
+------+----------+-----------------+------+------+-------+------+

+------+----------+-----------------+------+------+-------+------+
That output is somewhat difficult to read, however. To make it easier to understand, you’d likely execute the statement FROM within a program and reformat its results to display each set of team records separately. Here’s some Perl code that does that by beginning a new output group each time it encounters a new group of standings. The
code assumes that the join statement has just been executed and that its results are available through the statement handle $sth:
my ($cur_half, $cur_div) = ("", "");
while (my ($half, $div, $team, $wins, $losses, $pct, $gb)
= $sth->fetchrow_array ())
{
if ($cur_half ne $half || $cur_div ne $div) # new group of standings?
{
# print standings header and remember new half/division values print "\n$div Division, season half $half\n";
printf "%-20s %3s %3s %5s %s\n", "Team", "W", "L", "PCT", "GB";
$cur_half = $half;
$cur_div = $div;
}
printf "%-20s %3d %3d %5s %s\n", $team, $wins, $losses, $pct, $gb;
}
The reformatted output looks like this:


This code comes FROM the script calc_standings.pl in the joins directory of the recipes distribution. That directory also contains a PHP script, calc_standings.php, that pro- duces output in the form of HTML tables, which you might prefer for generating standings in a web environment.

---

Using a Join to Fill or Identify Holes in a List
Problem
You want to produce a summary for each of several categories, but some of them are not represented in the data to be SUMmarized. Consequently, the summary has missing categories.

Solution
Create a reference table that lists each category and produce the summary based on a LEFT JOIN BETWEEN the list and the table containing your data. Then every category in the reference table will appear in the result, even those not present in the data to be SUMmarized.

Discussion
When you run a summary query, normally it produces entries only for the values that are actually present in the data. Let’s say you want to produce a time-of-day summary for the rows in the mail table. That table looks like this:
SELECT * FROM mail;
+---------------------+---------+---------+---------+---------+---------+
| t | sender | srchost | recipient | dsthost | size  |
+---------------------+---------+---------+---------+---------+---------+
| 2006-05-11 10:15:08 | barb    | saturn  | tricia | mars   |   58274 |
| 2006-05-12 12:48:13 | tricia | mars   | gene  | venus | 194925 |
| 2006-05-12 15:02:49 | phil    | mars  | phil  | saturn |  1048 |
| 2006-05-13 13:59:18 | barb    | saturn  | tricia | venus  |   271 |
| 2006-05-14 09:31:37 | gene    | venus | barb  | mars  |   2291 |
| 2006-05-14 11:52:17 | phil    | mars  | tricia | saturn | 5781 |
...
To deterMINe how many messages were sent for each hour of the day, use the following statement:
SELECT HOUR(t) AS hour, COUNT(HOUR(t)) AS count
FROM mail GROUP BY hour;
+------+-------+
| hour | count |
+------+-------+

|   22 |    1 |
|   23 |    1 |
+------+-------+
Here, the summary category is hour of the day. However, the summary is “incomplete” in the sense that it includes entries only for those hours of the day represented in the mail table. To produce a summary that includes all hours of the day, even those during which no messages were sent, create a reference table that lists each category (that is, each hour):
CREATE TABLE ref (h INT);
INSERT INTO ref (h)
VALUES(0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),
(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23);

Then join the reference table to the mail table using a LEFT JOIN:
SELECT ref.h AS hour, COUNT(mail.t) AS count
FROM ref LEFT JOIN mail ON ref.h = HOUR(mail.t)
GROUP BY hour;
+------+-------+
| hour | count |
+------+-------+

+------+-------+
Now the summary includes an entry for every hour of the day because the LEFT JOIN forces the output to include a row for every row in the reference table, regardless of the contents of the mail table.
The example just shown uses the reference table with a LEFT JOIN to fill in holes in the category list. It’s also possible to use the reference table to detect holes in the dataset— that is, to deterMINe which categories are not present in the data to be SUMmarized. The following statement shows those hours of the day during which no messages were sent by looking for reference rows for which no mail table rows have a matching cate- gory value:
SELECT ref.h AS hour
FROM ref LEFT JOIN mail ON ref.h = HOUR(mail.t)
WHERE mail.t IS NULL;
+------+
| hour |
+------+

+------+
Reference tables that contain a list of categories are quite useful for summary state- ments, but creating such tables manually is MINd-numbing and error-prone. You might find it preferable to write a script that uses the endpoints of the range of category values to generate the reference table for you. In essence, this type of script acts as an iterator that generates a row for each value in the range. The following Perl script, make_date_list.pl, shows an example of this approach. It creates a reference table con- taining a row for every date in a particular date range. It also indexes the table so that it will be fast in large joins.
#!/usr/bin/perl
# make_date_list.pl - create a table with an entry for every date in # a given date range. The table can be used in a LEFT JOIN when
# producing a summary, to make sure that every date appears in the # summary, regardless of whether the data to be SUMmarized actually # contains any values for a given day.
# Usage: make_date_list.pl db_name tbl_name col_name MIN_date MAX_date use strict;
use warnings; use DBI;

# ... process command-line options (not shown) ...

# Check number of arguments
@ARGV == 5 or die "$usage\n";
my ($db_name, $tbl_name, $col_name, $MIN_date, $MAX_date) = @ARGV; # ... connect to database (not shown) ...
# DeterMINe the number of days spanned by the date range.

my $days = $dbh->SELECTrow_array (qq{ SELECT DATEDIFF(?,?) + 1 },
undef, $MAX_date, $MIN_date);

print "minimum date: $MIN_date\n"; print "maximum date: $MAX_date\n";
print "Number of days spanned by range: $days\n"; die "Date range is too small\n" if $days < 1;

# Drop table if it exists, and then recreate it

$dbh->do ("DROP TABLE IF EXISTS $db_name.$tbl_name");
$dbh->do (qq{
CREATE TABLE $db_name.$tbl_name
($col_name DATE NOT NULL, PRIMARY KEY ($col_name))
});
# Populate table with each date in the date range my $sth = $dbh->prepare (qq{
INSERT INTO $db_name.$tbl_name ($col_name) VALUES(? + INTERVAL ? DAY)
});
foreach my $i (0 .. $days-1)
{
$sth->execute ($MIN_date, $i);
}
Reference tables generated by make_date_list.pl can be used for per-date SUMmaries or to find dates not represented in the table. Suppose that you want to SUMmarize the driver_log table to deterMINe how many drivers were on the road each day. The table has these rows:
SELECT * FROM driver_log ORDER BY rec_id;
+--------+-------+------------+-------+
| rec_id | name  | travel_date  | miles |
+--------+-------+------------+-------+

+--------+-------+------------+-------+
A simple summary looks like this:
SELECT travel_date, COUNT(travel_date) AS drivers
FROM driver_log GROUP BY travel_date;
+------------+---------+
| travel_date  | drivers |
+------------+---------+

+------------+---------+
However, that summary does not show dates when no drivers were active. To generate a complete summary that includes the missing dates, use make_date_list.pl. FROM the simple summary just shown, we can tell the minimum and maximum dates, so generate a reference table named ref with a date column d that spans those dates:
% make_date_list.pl cookbook ref d 2006-08-26 2006-09-02
minimum date: 2006-08-26
maximum date: 2006-09-02
Number of days spanned by range: 8
After creating the reference table, use it in the following statement to generate the complete summary:
SELECT ref.d, COUNT(driver_log.travel_date) AS drivers
FROM ref LEFT JOIN driver_log ON ref.d = driver_log.travel_date
GROUP BY d;
+------------+---------+
| d | drivers |
+------------+---------+

+------------+---------+
This second summary includes additional rows that show those dates when no drivers were active. To list only those no-driver dates, use this statement:
SELECT ref.d
FROM ref LEFT JOIN driver_log ON ref.d = driver_log.travel_date
WHERE driver_log.travel_date IS NULL
ORDER BY d;
+------------+
| d |
+------------+
| 2006-08-28 |
| 2006-08-31 |
+------------+

----

Calculating Successive-Row Differences
Problem
You have a table containing successive cumulative values in its rows, and you want to compute the differences BETWEEN pairs of successive rows.

Solution
Use a self-join that matches up pairs of adjacent rows and calculates the differences BETWEEN members of each pair.

Discussion
Self-joins are useful when you have a set of absolute (or cumulative) values that you want to convert to relative values representing the differences BETWEEN successive pairs of rows. For example, if you take an automobile trip and write down the total miles traveled at each stopping point, you can compute the difference BETWEEN successive points to deterMINe the distance FROM one stop to the next. Here is such a table that shows the stops for a trip FROM San Antonio, Texas to Madison, Wisconsin. Each row shows the total miles driven as of each stop:
SELECT seq, city, miles FROM trip_log ORDER BY seq;
+-----+------------------+-------+
| seq | city    | miles |
+-----+------------------+-------+

+-----+------------------+-------+
A self-join can convert these cumulative values to successive differences that represent the distances FROM each city to the next. The following statement shows how to use the sequence numbers in the rows to match pairs of successive rows and compute the differences BETWEEN each pair of mileage values:
SELECT t1.seq AS seq1, t2.seq AS seq2,
t1.city AS city1, t2.city AS city2,
t1.miles AS miles1, t2.miles AS miles2,
t2.miles-t1.miles AS dist
FROM trip_log AS t1 INNER JOIN trip_log AS t2
ON t1.seq+1 = t2.seq
ORDER BY t1.seq;
+------+------+------------------+------------------+--------+--------+------+
| seq1 | seq2 | city1   | city2 | miles1 | miles2 | dist |
+------+------+------------------+------------------+--------+--------+------+
|   1 | 2 | San Antonio, TX | Dallas, TX    |   0 | 263 | 263 |

+------+------+------------------+------------------+--------+--------+------+
The presence of the seq column in the trip_log table is important for calculating suc- cessive difference values. It’s needed for establishing which row precedes another and matching each row n with row n +1. The implication is that a table should include a sequence column that has no gaps if you want to perform relative-difference calcula- tions FROM absolute or cumulative values. If the table contains a sequence column but there are gaps, renumber it. If the table contains no such column, add one. Recipes
11.5 and 11.10 describe how to perform these operations.
A somewhat more complex situation occurs when you compute successive differences for more than one column and use the results in a calculation. The following table, player_stats, shows some cumulative numbers for a baseball player at the end of each month of his season. ab indicates the total at-bats, and h the total hits the player has had as of a given date. (The first row indicates the starting point of the player’s season, which is why the ab and h values are zero.)
SELECT id, date, ab, h, TRUNCATE(COALESCE(h/ab,0),3) AS ba
FROM player_stats ORDER BY id;
+----+------------+-----+----+-------+
| id | date | ab | h | ba   |
+----+------------+-----+----+-------+
|  1 | 2006-04-30 | 0 |  0 | 0.000 |
|  2 | 2006-05-31 |  38 | 13 | 0.342 |
|  3 | 2006-06-30 | 109 | 31 | 0.284 |
|  4 | 2006-07-31 | 196 | 49 | 0.250 |
|  5 | 2006-08-31 | 304 | 98 | 0.322 |
+----+------------+-----+----+-------+
The last column of the query result also shows the player’s batting average as of each date. This column is not stored in the table but is easily computed as the ratio of hits to at-bats. The result provides a general idea of how the player’s hitting performance changed over the course of the season, but it doesn’t give a very informative picture of how the player did during each individual month. To deterMINe that, it’s necessary to calculate relative differences BETWEEN pairs of rows. This is easily done with a self-join that matches each row n with row n +1 to calculate differences BETWEEN pairs of at-bats and hits values. These differences enable computation of batting average during each month:
SELECT
t1.id AS id1, t2.id AS id2,
t2.date,
t1.ab AS ab1, t2.ab AS ab2,
t1.h AS h1, t2.h AS h2,
t2.ab-t1.ab AS abdiff,
t2.h-t1.h AS hdiff,
 TRUNCATE(COALESCE((t2.h-t1.h)/(t2.ab-t1.ab),0),3)     AS     ba
FROM  player_stats  AS  t1  INNER  JOIN  player_stats  AS  t2
ON t1.id+1 = t2.id
ORDER BY t1.id;
+-----+-----+------------+-----+-----+----+----+--------+-------+-------+
| id1 | id2 | date  | ab1 | ab2 | h1 | h2 | abdiff | hdiff | ba |
+-----+-----+------------+-----+-----+----+----+--------+-------+-------+

+-----+-----+------------+-----+-----+----+----+--------+-------+-------+
These results show much more clearly than the original table that the player started off well but had a slump in the middle of the season, particularly in July. They also indicate just how strong his performance was in August.


---

Finding Cumulative SUMs and Running Averages
Problem
You have a set of observations measured over time and want to compute the cumulative SUM of the observations at each measurement point. Or you want to compute a running average at each point.

Solution
Use a self-join to produce the sets of successive observations at each measurement point, and then apply aggregate functions to each set of values to compute its SUM or average.

Discussion
Recipe 12.9 illustrates how a self-join can produce relative values FROM absolute values. A self-join can do the opposite as well, producing cumulative values at each successive stage of a set of observations. The following table shows a set of rainfall measurements taken over a series of days. The values in each row show the observation date and the amount of precipitation in inches:
SELECT date, precip FROM rainfall ORDER BY date;
+------------+--------+
| date  | precip |
+------------+--------+
| 2006-06-01 |  1.50 |
| 2006-06-02 |  0.00 |
| 2006-06-03 |  0.50 |
| 2006-06-04 |  0.00 |
| 2006-06-05 |  1.00 |
+------------+--------+
To calculate cumulative rainfall for a given day, add that day’s precipitation value with the values for all the previous days. For example, deterMINe the cumulative rainfall as of 2006-06-03 like this:
SELECT SUM(precip) FROM rainfall WHERE date <= '2006-06-03';
+-------------+
| SUM(precip) |
+-------------+
|   2.00 |
+-------------+
If you want the cumulative figures for all days that are represented in the table, it would be tedious to compute the value for each of them separately. A self-join can do this for all days with a single statement. Use one instance of the rainfall table as a reference, and deterMINe for the date in each row the SUM of the precip values in all rows occurring up through that date in another instance of the table. The following statement shows the daily and cumulative precipitation for each day:
SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date;
+------------+--------------+-------------+
| date  | daily precip | cum. precip |
+------------+--------------+-------------+

+------------+--------------+-------------+
The self-join can be extended to display the number of days elapsed at each date, as well as the running averages for amount of precipitation each day:
SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip',
COUNT(t2.precip) AS 'days elapsed',
AVG(t2.precip) AS 'AVG. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date;
+------------+--------------+-------------+--------------+-------------+
| date  | daily precip | cum. precip | days elapsed | AVG. precip |
+------------+--------------+-------------+--------------+-------------+

+------------+--------------+-------------+--------------+-------------+
In the preceding statement, the number of days elapsed and the precipitation running averages can be computed easily using COUNT( ) and AVG( ) because there are no missing days in the table. If missing days are allowed, the calculation becomes more compli- cated, because the number of days elapsed for each calculation no longer will be the same as the number of rows. You can see this by deleting the rows for the days that had no precipitation to produce a couple of “holes” in the table:
DELETE FROM rainfall WHERE precip = 0;
SELECT date, precip FROM rainfall ORDER BY date;
+------------+--------+
| date  | precip |
+------------+--------+
| 2006-06-01 |  1.50 |
| 2006-06-03 |  0.50 |
| 2006-06-05 |  1.00 |
+------------+--------+
Deleting those rows doesn’t change the cumulative SUM or running average for the dates that remain, but it does change how they must be calculated. If you try the self-join again, it yields incorrect results for the days-elapsed and average precipitation columns:
SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip',
COUNT(t2.precip) AS 'days elapsed',
AVG(t2.precip) AS 'AVG. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date;
+------------+--------------+-------------+--------------+-------------+
| date  | daily precip | cum. precip | days elapsed | AVG. precip |
+------------+--------------+-------------+--------------+-------------+
| 2006-06-01 |  1.50 |  1.50 |  1 | 1.500000 |
| 2006-06-03 |  0.50 |  2.00 |  2 | 1.000000 |
| 2006-06-05 |  1.00 |  3.00 |  3 | 1.000000 |
+------------+--------------+-------------+--------------+-------------+
To fix the problem, it’s necessary to deterMINe the number of days elapsed a different way. Take the minimum and maximum date involved in each SUM and calculate a days- elapsed value FROM them using the following expression:
DATEDIFF(MAX(t2.date),MIN(t2.date)) + 1
That value must be used for the days-elapsed column and for computing the running averages. The resulting statement is as follows:
SELECT t1.date, t1.precip AS 'daily precip',
SUM(t2.precip) AS 'cum. precip',
 DATEDIFF(MAX(t2.date),MIN(t2.date))   +   1   AS   'days elapsed',
SUM(t2.precip)  /  (DATEDIFF(MAX(t2.date),MIN(t2.date))  +  1)
AS 'AVG. precip'
FROM rainfall AS t1 INNER JOIN rainfall AS t2
ON t1.date >= t2.date
GROUP BY t1.date;
+------------+--------------+-------------+--------------+-------------+
| date  | daily precip | cum. precip | days elapsed | AVG. precip |
+------------+--------------+-------------+--------------+-------------+
| 2006-06-01 |  1.50 |  1.50 |  1 | 1.500000 |
| 2006-06-03 |  0.50 |  2.00 |  3 | 0.666667 |
| 2006-06-05 |  1.00 |  3.00 |  5 | 0.600000 |
+------------+--------------+-------------+--------------+-------------+
As this example illustrates, calculation of cumulative values FROM relative values re- quires only a column that enables rows to be placed into the proper order. (For the rainfall table, that’s the date column.) Values in the column need not be sequential, or even numeric. This differs FROM calculations that produce difference values FROM cumulative values (Recipe 12.9), which require that a table have a column that contains an unbroken sequence.
The running averages in the rainfall examples are based on dividing cumulative pre- cipitation SUMs by number of days elapsed as of each day. When the table has no gaps, the number of days is the same as the number of values SUMmed, making it easy to find successive averages. When rows are missing, the calculations become more complex. What this demonstrates is that it’s necessary to consider the nature of your data and calculate averages appropriately. The next example is conceptually similar to the pre- vious ones in that it calculates cumulative SUMs and running averages, but it performs the computations yet another way.
The following table shows a marathon runner’s performance at each stage of a 26- kilometer run. The values in each row show the length of each stage in kilometers and how long the runner took to complete the stage. In other words, the values pertain to intervals within the marathon and thus are relative to the whole:
SELECT stage, km, t FROM marathon ORDER BY stage;
+-------+----+----------+
| stage | km | t    |
+-------+----+----------+
|   1 |  5 | 00:15:00 |
|   2 |  7 | 00:19:30 |
|   3 |  9 | 00:29:20 |
|   4 |  5 | 00:17:50 |
+-------+----+----------+
To calculate cumulative distance in kilometers at each stage, use a self-join that looks like this:
SELECT t1.stage, t1.km, SUM(t2.km) AS 'cum. km'
FROM marathon AS t1 INNER JOIN marathon AS t2
ON t1.stage >= t2.stage
GROUP BY t1.stage;
+-------+----+---------+
| stage | km | cum. km |
+-------+----+---------+
|   1 | 5 | 5 |
|   2 | 7 | 12 |
|   3 | 9 | 21 |
|   4 | 5 | 26 |
+-------+----+---------+
Cumulative distances are easy to compute because they can be SUMmed directly. The calculation for accumulating time values is a little more involved. It’s necessary to con- vert times to seconds, total the resulting values, and convert the SUM back to a time value. To compute the runner’s average speed at the end of each stage, take the ratio of cumulative distance over cumulative time. Putting all this together yields the fol- lowing statement:
SELECT t1.stage, t1.km, t1.t,
SUM(t2.km) AS 'cum. km',
SEC_TO_TIME(SUM(TIME_TO_SEC(t2.t))) AS 'cum. t',
SUM(t2.km)/(SUM(TIME_TO_SEC(t2.t))/(60*60)) AS 'AVG. km/hour'
FROM marathon AS t1 INNER JOIN marathon AS t2
ON t1.stage >= t2.stage
GROUP BY t1.stage;
+-------+----+----------+---------+----------+--------------+
| stage | km | t    | cum. km | cum. t  | AVG. km/hour |
+-------+----+----------+---------+----------+--------------+

+-------+----+----------+---------+----------+--------------+
We can see FROM this that the runner’s average pace increased a little during the second stage of the race, but then (preSUMably as a result of fatigue) decreased thereafter.


----

Using a Join to Control Query Output Order
Problem
You want to sort a statement’s output using a characteristic of the output that cannot be specified using ORDER BY . For example, you want to sort a set of rows by subgroups, putting first those groups with the most rows and last those groups with the fewest rows. But “number of rows in each group” is not a property of individual rows, so you can’t use it for sorting.

Solution
Derive the ordering information and store it in an auxiliary table. Then join the original table to the auxiliary table, using the auxiliary table to control the sort order.

Discussion
Most of the time when you sort a query result, you use an ORDER BY clause that names which column or columns to use for sorting. But sometimes the values you want to sort by aren’t present in the rows to be sorted. This is the case when you want to use group characteristics to order the rows. The following example uses the rows in the driver_log table to illustrate this. The table contains these rows:
SELECT * FROM driver_log ORDER BY rec_id;
+--------+-------+------------+-------+
| rec_id | name  | travel_date  | miles |
+--------+-------+------------+-------+

+--------+-------+------------+-------+
The preceding statement sorts the rows using the ID column, which is present in the rows. But what if you want to display a list and sort it on the basis of a summary value not present in the rows? That’s a little trickier. Suppose that you want to show each driver’s rows by date, but place those drivers who drive the most miles first. You can’t do this with a summary query, because then you wouldn’t get back the individual driver rows. But you can’t do it without a summary query, either, because the summary values are required for sorting. The way out of the dilemma is to create another table con- taining the summary value per driver and then join it to the original table. That way you can produce the individual rows and also sort them by the summary values.
To SUMmarize the driver totals into another table, do this:
CREATE TABLE tmp
SELECT name, SUM(miles) AS driver_miles FROM driver_log GROUP BY name;

This produces the values we need to put the names in the proper total-miles order:
SELECT * FROM tmp ORDER BY driver_miles DESC;
+-------+--------------+
| name  | driver_miles |
+-------+--------------+
| Henry |   911 |
| Suzi |    893 |
| Ben   |   362 |
+-------+--------------+
Then use the name values to join the summary table to the driver_log table, and use the driver_miles values to sort the result. The following statement shows the mileage totals in the result. That’s only to clarify how the values are being sorted. It’s not actually necessary to display them; they’re needed only for the ORDER BY clause.
SELECT tmp.driver_miles, driver_log.*
FROM driver_log INNER JOIN tmp
ON driver_log.name = tmp.name
ORDER BY tmp.driver_miles DESC, driver_log.travel_date;
+--------------+--------+-------+------------+-------+
| driver_miles | rec_id | name  | travel_date  | miles |
+--------------+--------+-------+------------+-------+

+--------------+--------+-------+------------+-------+
To avoid using the temporary table, SELECT the same rows using a subquery in the
FROM clause:
SELECT tmp.driver_miles, driver_log.*
FROM driver_log INNER JOIN
(SELECT name, SUM(miles) AS driver_miles
FROM driver_log GROUP BY name) AS tmp
ON driver_log.name = tmp.name
ORDER BY tmp.driver_miles DESC, driver_log.travel_date;
+--------------+--------+-------+------------+-------+
| driver_miles | rec_id | name  | travel_date  | miles |
+--------------+--------+-------+------------+-------+

+--------------+--------+-------+------------+-------+


---

Combining Several Result Sets in a Single Query
Problem
You want to SELECT rows FROM several tables, or several sets of rows FROM a single table
—all as a single result set.

Solution
Use a UNION operation to combine multiple SELECT results into one.

Discussion
A join is useful for combining columns FROM different tables side by side. It’s not so useful when you want a result set that includes a set of rows FROM several tables, or
multiple sets of rows FROM the same table. These are instances of the type of operation for which a UNION is useful. A UNION enables you to run several SELECT statements and combine their results. That is, rather than running multiple queries and receiving mul- tiple result sets, you receive a single result set.
Suppose that you have two tables that list prospective and actual customers, and a third that lists vendors FROM whom you purchase supplies, and you want to create a single mailing list by merging names and addresses FROM all three tables. UNION provides a way to do this. assume that the three tables have the following contents:
SELECT * FROM prospect;
+---------+-------+------------------------+
| fname | lname | addr  |
+---------+-------+------------------------+
| Peter | Jones | 482 Rush St., Apt. 402 |
| Bernice | Smith | 916 Maple Dr.   |
+---------+-------+------------------------+
SELECT * FROM customer;
+-----------+------------+---------------------+
| last_name | first_name | address  |
+-----------+------------+---------------------+
| Peterson | Grace  | 16055 SeMINole Ave. |
| Smith | Bernice   | 916 Maple Dr. |
| Brown | Walter    | 8602 1st St.  |
+-----------+------------+---------------------+
SELECT * FROM vendor;
+-------------------+---------------------+
| company   | street    |
+-------------------+---------------------+
| ReddyParts, Inc.  | 38 Industrial Blvd. |
| Parts-to-go, Ltd. | 213B Commerce Park. |
+-------------------+---------------------+
The tables have columns that are similar but not identical. prospect and customer use different names for the first name and last name columns, and the vendor table includes only a single name column. None of that matters for UNION; all you need to do is make sure to SELECT the same number of columns FROM each table, and in the same order. The following statement illustrates how to SELECT names and addresses FROM the three tables all at once:
SELECT fname, lname, addr FROM prospect
UNION
SELECT first_name, last_name, address FROM customer
UNION
SELECT company, '', street FROM vendor;
+-------------------+----------+------------------------+
| fname | lname | addr  |
+-------------------+----------+------------------------+
| Peter | Jones | 482 Rush St., Apt. 402 |
| Bernice   | Smith | 916 Maple Dr. |
| Grace | Peterson | 16055 SeMINole Ave.    |
| Walter    | Brown | 8602 1st St.  |
| ReddyParts, Inc. |    | 38 Industrial Blvd.   |
| Parts-to-go, Ltd. |   | 213B Commerce Park.   |
+-------------------+----------+------------------------+
The column names in the result set are taken FROM the names of the columns retrieved by the first SELECT statement. Notice that, by default, a UNION eliMINates duplicates; Bernice Smith appears in both the prospect and customer tables, but only once in the final result. If you want to SELECT all rows, including duplicates, follow each UNION key- word with ALL:
SELECT fname, lname, addr FROM prospect
UNION ALL
SELECT first_name, last_name, address FROM customer
UNION ALL
SELECT company, '', street FROM vendor;
+-------------------+----------+------------------------+
| fname | lname | addr  |
+-------------------+----------+------------------------+
| Peter | Jones | 482 Rush St., Apt. 402 |
| Bernice   | Smith | 916 Maple Dr. |
| Grace | Peterson | 16055 SeMINole Ave.    |
| Bernice   | Smith | 916 Maple Dr. |
| Walter    | Brown | 8602 1st St.  |
| ReddyParts, Inc. |    | 38 Industrial Blvd.   |
| Parts-to-go, Ltd. |   | 213B Commerce Park.   |
+-------------------+----------+------------------------+
Because it’s necessary to SELECT the same number of columns FROM each table, the SELECT for the vendor table (which has just one name column) retrieves a dummy (emp- ty) last name column. Another way to SELECT the same number of columns is to combine the first and last name columns FROM the prospect and customer tables into a single column:
SELECT CONCAT(lname,', ',fname) AS name, addr FROM prospect
UNION
SELECT CONCAT(last_name,', ',first_name), address FROM customer
UNION
SELECT company, street FROM vendor;
+-------------------+------------------------+
| name  | addr  |
+-------------------+------------------------+
| Jones, Peter  | 482 Rush St., Apt. 402 |
| Smith, Bernice    | 916 Maple Dr. |
| Peterson, Grace   | 16055 SeMINole Ave.   |
| Brown, Walter | 8602 1st St.  |
| ReddyParts, Inc.  | 38 Industrial Blvd.   |
| Parts-to-go, Ltd. | 213B Commerce Park.   |
+-------------------+------------------------+
To sort the result set, place each SELECT statement within parentheses and add an ORDER BY clause after the final one. Any columns specified by name in the ORDER BY should refer to the column names used in the first SELECT, because those are the names used for the columns in the result set. For example, to sort by name, do this:
(SELECT CONCAT(lname,', ',fname) AS name, addr FROM prospect)
UNION
(SELECT CONCAT(last_name,', ',first_name), address FROM customer)
UNION
(SELECT company, street FROM vendor)
ORDER BY name;
+-------------------+------------------------+
| name  | addr  |
+-------------------+------------------------+
| Brown, Walter | 8602 1st St.  |
| Jones, Peter  | 482 Rush St., Apt. 402 |
| Parts-to-go, Ltd. | 213B Commerce Park.   |
| Peterson, Grace   | 16055 SeMINole Ave.   |
| ReddyParts, Inc.  | 38 Industrial Blvd.   |
| Smith, Bernice    | 916 Maple Dr. |
+-------------------+------------------------+
It’s possible to ensure that the results FROM each SELECT appear consecutively, although you must generate an extra column to use for sorting. Enclose each SELECT within pa- rentheses, add a sort-value column to each one, and place an ORDER BY at the end that sorts using that column:
(SELECT 1 AS sortval, CONCAT(lname,', ',fname) AS name, addr
FROM prospect)
UNION
(SELECT 2 AS sortval, CONCAT(last_name,', ',first_name) AS name, address
FROM customer)
UNION
(SELECT 3 AS sortval, company, street FROM vendor)
ORDER BY sortval;
+---------+-------------------+------------------------+
| sortval | name    | addr  |
+---------+-------------------+------------------------+
|   1 | Jones, Peter    | 482 Rush St., Apt. 402 |
|   1 | Smith, Bernice  | 916 Maple Dr. |
|   2 | Peterson, Grace | 16055 SeMINole Ave.   |
|   2 | Smith, Bernice  | 916 Maple Dr. |
|   2 | Brown, Walter   | 8602 1st St.  |
|   3 | ReddyParts, Inc.  | 38 Industrial Blvd. |
|   3 | Parts-to-go, Ltd. | 213B Commerce Park. |
+---------+-------------------+------------------------+
If you also want the rows within each SELECT sorted, include a secondary sort column in the ORDER BY clause. The following query sorts by name within each SELECT:
(SELECT 1 AS sortval, CONCAT(lname,', ',fname) AS name, addr
FROM prospect)
UNION
(SELECT 2 AS sortval, CONCAT(last_name,', ',first_name) AS name, address
FROM customer)
UNION
(SELECT 3 AS sortval, company, street FROM vendor)
ORDER BY sortval, name;
+---------+-------------------+------------------------+
| sortval | name    | addr  |
+---------+-------------------+------------------------+
|   1 | Jones, Peter    | 482 Rush St., Apt. 402 |
|   1 | Smith, Bernice  | 916 Maple Dr. |
|   2 | Brown, Walter   | 8602 1st St.  |
|   2 | Peterson, Grace | 16055 SeMINole Ave.   |
|   2 | Smith, Bernice  | 916 Maple Dr. |
|   3 | Parts-to-go, Ltd. | 213B Commerce Park. |
|   3 | ReddyParts, Inc.  | 38 Industrial Blvd. |
+---------+-------------------+------------------------+
Similar syntax can be used for LIMIT as well. That is, you can limit the result set as a whole with a trailing LIMIT clause, or for individual SELECT statements. Typically, LIMIT is combined with ORDER BY. Suppose that you want to SELECT a lucky prizewinner for some kind of promotional giveaway. To SELECT a single winner at random FROM the combined results of the three tables, do this:
(SELECT CONCAT(lname,', ',fname) AS name, addr FROM prospect)
UNION
(SELECT CONCAT(last_name,', ',first_name), address FROM customer)
UNION
(SELECT company, street FROM vendor)
ORDER BY RAND() LIMIT 1;
+-----------------+---------------------+
| name  | addr  |
+-----------------+---------------------+
| Peterson, Grace | 16055 SeMINole Ave. |
+-----------------+---------------------+
To SELECT a single winner FROM each table and combine the results, do this instead:
(SELECT CONCAT(lname,', ',fname) AS name, addr
FROM prospect ORDER BY RAND() LIMIT 1)
UNION
(SELECT CONCAT(last_name,', ',first_name), address
FROM customer ORDER BY RAND() LIMIT 1)
UNION
(SELECT company, street
FROM vendor ORDER BY RAND() LIMIT 1);
+------------------+---------------------+
| name  | addr  |
+------------------+---------------------+
| Smith, Bernice    | 916 Maple Dr. |
| ReddyParts, Inc. | 38 Industrial Blvd. |
+------------------+---------------------+
If that result surprises you (“Why didn’t it pick three rows?”), remember that Bernice is listed in two tables and that UNION eliMINates duplicates. If the first and second SELECT statements each happen to pick Bernice, one instance will be eliMINated and the final result will have only two rows. (If there are no duplicates among the three tables, the statement will always return three rows.) You could of course assure three rows in all cases by using UNION ALL.

---

Identifying and Removing Mismatched or Unattached Rows
Problem
You have two datasets that are related, but possibly imperfectly so. You want to de- terMINe whether there are records in either dataset that are “unattached” (not matched by any record in the other dataset), and perhaps remove them if so. This might occur, for example, when you receive data FROM an external source and must check it to verify its integrity.

Solution
Use a LEFT JOIN to identify unmatched values in each table. If there are any and you want to get rid of them, use a multiple-table DELETE statement. It’s also possible to identify or remove nonmatching rows by using NOT IN subqueries.

Discussion
Inner joins are useful for identifying relationships, and outer joins are useful for iden- tifying the lack of relationship. This property of outer joins is valuable when you have datasets that are supposed to be related but for which the relationship might be imperfect.
Mismatches BETWEEN datasets can occur if you receive two datafiles FROM an external source that are supposed to be related but for which the integrity of the relationship actually is imperfect. It can also occur as an anticipated consequence of a deliberate action. Suppose that an online discussion board uses a parent table that lists discussion topics and a child table that rows the articles posted for each topic. If you purge the child table of old article rows, that may result in any given topic row in the parent table no longer HAVING any children. If so, the lack of recent postings for the topic indicates that it is probably dead and that the parent row in the topic table can be deleted, too. In such a situation, you delete a set of child rows with the explicit recognition that the operation may strand parent rows and cause them to become eligible for being deleted as well.
However you arrive at the point WHERE related tables have unmatched rows, you can analyze and modify them using SQL statements. Specifically, restoring their relation- ship is a matter of identifying the unattached rows and then deleting them:
To identify unattached rows, use a LEFT JOIN, because this is a “find unmatched rows” problem. (See Recipe 12.2 for information about LEFT JOIN.)
To delete rows that are unmatched, use a multiple-table DELETE statement that specifies which rows to remove using a similar LEFT JOIN.
The presence of unmatched data is useful to know about because you can alert whoever gave you the data. This may be a signal of a flaw in the data collection method that must be corrected. For example, with sales data, a missing region might mean that some regional manager didn’t report in and that the omission was overlooked.
The following example shows how to identify and remove mismatched rows using two datasets that describe sales regions and volume of sales per region. One dataset contains the ID and location of each sales region:
SELECT * FROM sales_region ORDER BY region_id;
+-----------+------------------------+
| region_id | name  |
+-----------+------------------------+
|   1 | London, United Kingdom |
|   2 | Madrid, Spain   |
|   3 | Berlin, Germany |
|   4 | Athens, Greece  |
+-----------+------------------------+
The other dataset contains sales volume figures. Each row contains the amount of sales for a given quarter of a year and indicates the sales region to which the row applies:
SELECT * FROM sales_volume ORDER BY region_id, year, quarter;
+-----------+------+---------+--------+
| region_id | year | quarter | volume |
+-----------+------+---------+--------+

+-----------+------+---------+--------+
A little visual inspection reveals that neither table is fully matched by the other. Sales regions 2 and 4 are not represented in the sales volume table, and the sales volume table contains rows for region 5, which is not in the sales region table. But we don’t want to check the tables by inspection. We want to find unmatched rows by using SQL state- ments that do the work for us.
Mismatch identification is a matter of using outer joins. For example, to find sales regions for which there are no sales volume rows, use the following LEFT JOIN:
SELECT sales_region.region_id AS 'unmatched region row IDs'
FROM sales_region LEFT JOIN sales_volume
 ON sales_region.region_id = sales_volume.region_id
WHERE sales_volume.region_id IS NULL;
+--------------------------+
| unmatched region row IDs |
+--------------------------+
|   2 |
|   4 |
+--------------------------+
Conversely, to find sales volume rows that are not associated with any known region, reverse the roles of the two tables:
SELECT sales_volume.region_id AS 'unmatched volume row IDs'
FROM sales_volume LEFT JOIN sales_region
 ON sales_volume.region_id = sales_region.region_id
WHERE sales_region.region_id IS NULL;
+--------------------------+
| unmatched volume row IDs |
+--------------------------+
|   5 |
|   5 |
+--------------------------+
In this case, an ID appears more than once in the list if there are multiple volume rows for a missing region. To see each unmatched ID only once, use SELECT DISTINCT:
SELECT DISTINCT sales_volume.region_id AS 'unmatched volume row IDs'
FROM sales_volume LEFT JOIN sales_region
 ON sales_volume.region_id = sales_region.region_id
WHERE sales_region.region_id IS NULL
+--------------------------+
| unmatched volume row IDs |
+--------------------------+
|   5 |
+--------------------------+
To get rid of unmatched rows, you can use their IDs in a multiple-table DELETE state- ment. To construct the proper multiple-table DELETE statement for removing unmatch- ed rows FROM a table, just take the SELECT statement that you use to identify those rows, and replace the stuff leading up to the FROM keyword with DELETE tbl_name. For example, the SELECT that identifies childless parents looks like this:
SELECT sales_region.region_id AS 'unmatched region row IDs' FROM sales_region LEFT JOIN sales_volume
ON sales_region.region_id = sales_volume.region_id WHERE sales_volume.region_id IS NULL;
The corresponding DELETE looks like this:
DELETE sales_region
FROM sales_region LEFT JOIN sales_volume
ON sales_region.region_id = sales_volume.region_id WHERE sales_volume.region_id IS NULL;
Conversely, the statement to identify parentless children is as follows:
SELECT sales_volume.region_id AS 'unmatched volume row IDs' FROM sales_volume LEFT JOIN sales_region
ON sales_volume.region_id = sales_region.region_id WHERE sales_region.region_id IS NULL;
And the corresponding DELETE statement removes them:
DELETE sales_volume
FROM sales_volume LEFT JOIN sales_region
ON sales_volume.region_id = sales_region.region_id WHERE sales_region.region_id IS NULL;
You can also identify or delete mismatched rows by using NOT IN subqueries. The state- ments to display or remove sales_region rows that match no sales_volume rows look like this:
SELECT region_id AS 'unmatched region row IDs' FROM sales_region
WHERE region_id NOT IN (SELECT region_id FROM sales_volume);

DELETE FROM sales_region
WHERE region_id NOT IN (SELECT region_id FROM sales_volume);
The statements to identify or delete mismatched sales_volume rows are similar but have the roles of the tables reversed:
SELECT region_id AS 'unmatched volume row IDs' FROM sales_volume
WHERE region_id NOT IN (SELECT region_id FROM sales_region);

DELETE FROM sales_volume
WHERE region_id NOT IN (SELECT region_id FROM sales_region);


----

performing a Join BETWEEN Tablesin Different Databases
Problem
You want to use tables in a join, but they’re not located in the same database.

Solution
Use database name qualifiers to tell MySQL WHERE to find the tables.
Discussion
Sometimes it’s necessary to perform a join on two tables that are located in different databases. To do this, qualify table and column names sufficiently so that MySQL knows what you’re referring to. Thus far, we have used the artist and painting tables with the implicit understanding that both are in the cookbook database, which means that we can simply refer to the tables without specifying any database name when cookbook is the default database. For example, the following statement uses the two tables to associate artists with their paintings:
SELECT artist.name, painting.title FROM artist INNER JOIN painting ON artist.a_id = painting.a_id;
But suppose instead that artist is in the db1 database and painting is in the db2 data- base. To indicate this, qualify each table name with a prefix that specifies which database it’s in. The fully qualified form of the join looks like this:
SELECT db1.artist.name, db2.painting.title FROM db1.artist INNER JOIN db2.painting ON db1.artist.a_id = db2.painting.a_id;
If there is no default database, or it is neither db1 nor db2, it’s necessary to use this fully qualified form. If the default database is either db1 or db2, you can dispense with the corresponding qualifiers. For example, if the default database is db1, you can omit the db1 qualifiers:
SELECT artist.name, db2.painting.title FROM artist INNER JOIN db2.painting ON artist.a_id = db2.painting.a_id;
Conversely, if the default database is db2, no db2 qualifiers are necessary:
SELECT db1.artist.name, painting.title FROM db1.artist INNER JOIN painting ON db1.artist.a_id = painting.a_id;



---

Referring to Join Output Column Names in Programs
Problem
You need to process the result of a join FROM within a program, but the column names in the result set aren’t unique.

Solution
Revise the query using column aliases so that each column has a unique name, or refer to the columns by position.

Discussion
Joins typically retrieve columns FROM related tables, so it’s not unusual for columns selected FROM different tables to have the same names. Consider the following join that shows the items in your art collection (originally seen in Recipe 12.1). For each painting, it displays artist name, painting title, the state in which you acquired the item, and how much it cost:
SELECT artist.name, painting.title, states.name, painting.price
FROM artist INNER JOIN painting INNER JOIN states
ON artist.a_id = painting.a_id AND painting.state = states.abbrev;
+----------+-------------------+----------+-------+
| name  | title | name  | price |
+----------+-------------------+----------+-------+
| Da Vinci | The Last Supper    | Indiana | 34 |
| Da Vinci | The Mona Lisa  | Michigan |    87 |
| Van Gogh | Starry Night   | Kentucky |    48 |
| Van Gogh | The Potato Eaters | Kentucky | 67 |
| Van Gogh | The Rocks  | Iowa  |   33 |
| Renoir    | Les Deux Soeurs   | Nebraska |    64 |
+----------+-------------------+----------+-------+
The statement is written using table qualifiers for each output column. Nevertheless, the column names in the output are not distinct because MySQL doesn’t include table names in the column headings. If you’re processing the result of the join FROM within one of your own programs and fetching rows into a data structure that references col- umn values by name, nonunique column names can cause some values to become inaccessible. The following Perl script fragment illustrates the difficulty:
$stmt = qq{
SELECT artist.name, painting.title, states.name, painting.price FROM artist INNER JOIN painting INNER JOIN states
ON artist.a_id = painting.a_id AND painting.state = states.abbrev
};
$sth = $dbh->prepare ($stmt);
$sth->execute ();
# DeterMINe the number of columns in result set rows two ways: # - Check the NUM_OF_FIELDS statement handle attribute
# - Fetch a row into a hash and see how many keys the hash contains
$count1 = $sth->{NUM_OF_FIELDS};
$ref = $sth->fetchrow_hashref ();
$count2 = keys (%{$ref});
print "The statement is: $stmt\n";
print "According to NUM_OF_FIELDS, the result set has $count1 columns\n"; print "The column names are: " . join sort (",", @{$sth->{NAME}})) . "\n"; print "According to the row hash size, the result set has $count2 columns\n"; print "The column names are: " . join sort (",", @{$sth->{NAME}})) . "\n";
The script issues the statement and then deterMINes the number of columns in the result, first by checking the NUM_OF_FIELDS attribute and then by fetching a row into a hash and counting the number of hash keys. Executing this script results in the fol- lowing output:
According to NUM_OF_FIELDS, the result set has 4 columns The column names are: name,name,title,price
According to the row hash size, the result set has 3 columns The column names are: name,price,title
There is a problem here: the column counts don’t match. The second count is 3 (not
4) because the nonunique column names cause multiple column values to be mapped onto the same hash element. As a result of these hash-key collisions, some of the values are lost. To solve this problem, make the column names unique by supplying aliases. For example, the statement can be rewritten like this:
SELECT
artist.name AS painter, painting.title, states.name AS state, painting.price
FROM artist INNER JOIN painting INNER JOIN states
ON artist.a_id = painting.a_id AND painting.state = states.abbrev
If you make that change and rerun the script, its output becomes:
According to NUM_OF_FIELDS, the result set has 4 columns The column names are: painter,price,state,title
According to the row hash size, the result set has 4 columns The column names are: painter,price,state,title
Now the two column counts are the same, which indicates that no values are lost when fetching into a hash.
Another way to address the problem that requires no column renaMINg is to fetch the row into something other than a hash. For example, you can fetch the row into an array and refer to the columns by ordinal position within the array:
while (my @val = $sth->fetchrow_array ())
{
print "painter: $val[0], title: $val[1], "
. "state: $val[2], price: $val[3]\n";
}
The name-clash problem just described might have different solutions in other lan- guages. For example, the problem doesn’t occur in quite the same way in Python scripts that use the MySQLdb module. Suppose that you retrieve a row using a dictionary, Python’s analog to a Perl hash (Recipe 2.4). In this case, MySQLdb notices clashing column names and places them in the dictionary using a key consisting of the table name and column name. Thus, for the following statement, the dictionary keys would be name, title, states.name, and price:
SELECT artist.name, painting.title, states.name, painting.price FROM artist INNER JOIN painting INNER JOIN states
ON artist.a_id = painting.a_id AND painting.state = states.abbrev
That means column values won’t get lost. Unfortunately, it’s still necessary to be aware of nonunique names. If you try to refer to column values using just the column names, you won’t get the results you expect for those names that are reported with a leading table name. This problem does not occur if you use aliases to make each column name unique because the dictionary entries will have the names that you assign.

---







---
3-6. Finding Matched Data Across Tables
Problem
You want to find the rows in common BETWEEN two or more tables or queries.

Solution
Use the INTERSECT operator. When you use INTERSECT, the resulting row set contains only rows that are in common BETWEEN the two tables or queries:
SELECT COUNT(*) FROM employee_act; COUNT(*)
6
SELECT COUNT(*) FROM employee_new; COUNT(*)
5


SELECT * FROM employee_act intersect
SELECT * FROM employee_new
;



How It Works
The INTERSECT operator, along with UNION, UNION ALL, and MINUS, joins two or more queries together. As of SQL Database 11g, these operators have equal precedence, and unless you override them with parentheses, they are evaluated in left-to-right order. Or, more intuitively since you usually don’t have two queries on one line, top-to-bottom order!


Tip Future ANSI SQL standards give the INTERSECT operator higher precedence than the other operators. Thus, to “bulletproof” your SQL code, use parentheses to explicitly specify evaluation order WHERE you use INTERSECT with other set operators.


To better understand how INTERSECT works, Figure 3-1 shows a Venn diagram representation of the
INTERSECT operation on two queries.

---
3-8. Finding Missing Rows
Problem
You have two tables, and you must find rows in the first table that are not in the second table. You want to compare all rows in each table, not just a subset of columns.

Solution
Use the MINUS set operator. The MINUS operator will return all rows in the first query that are not in the second query. The employee_BONUS table contains employee who have been given bonuses in the past,


and you need to find employee in the employee table who have not yet received bonuses. Use the MINUS
operator as follows to compare three selected columns FROM two tables:
SELECT employee_id, last_name, first_name FROM employee MINus
SELECT employee_id, last_name, first_name FROM employee_bonus
;



How It Works
Note that unlike the INTERSECT and UNION operators, the MINUS set operator is not commutative: the order of the operands (queries) is important! Changing the order of the queries in the solution will produce very different results.
If you wanted to note changes for the entire row, you could use this query instead:
SELECT * FROM employee MINus
SELECT * FROM employee_bonus
;
A Venn diagram may help to show how the MINUS operator works. Figure 3-2 shows the result of Query1 MINUS Query2. Any rows that overlap BETWEEN Query1 and Query2 are removed FROM the result set along with any rows in Query2 that do not overlap Query1. In other words, only rows in Query1 are returned less any rows in Query1 that exist in Query2.

---

3-12. Manipulating and Comparing NULLs in Join Conditions
Problem
You want to map NULL values in a join column to a default value that will match a row in the joined table, thus avoiding the use of an outer join.

Solution
Use the NVL function to convert NULL values in the foreign key column of the table to be joined to its parent table. In this example, holiday parties are scheduled for each department, but several employee do not have a department assigned. Here is one of them:

SELECT employee_id, first_name, last_name, department_id FROM employee
WHERE employee_id = 178
;


1 rows selected
To ensure that each employee will attend a holiday party, convert all NULL department codes in the
employee table to department 110 (Accounting) in the query as follows:
SELECT employee_id, first_name, last_name, d.department_id, department_name FROM employee e join departments d
on nvl(e.department_id,110) = d.department_id
;






107 rows selected

How It Works
Mapping columns with NULLs to non-NULL values in a join condition to avoid using an OUTER JOIN might still have performance problems, since the index on employee.DEPARTMENT_ID will not be used during the join (primarily because NULL columns are not indexed). You can address this new problem by using a function-based index (FBI). An FBI creates an index on an expression, and may use that index if the expression appears in a join condition or a WHERE clause. Here is how to create an FBI on the DEPARTMENT_ID column:
create index employee_dept_fbi on employee(nvl(department_id,110));


Tip As of SQL Database 11g, you can now use virtual columns as an alternative to FBIs. Virtual columns are derived FROM constants, functions, and columns FROM the same table. You can define indexes on the virtual columns, which the optimizer will use in any query as it would a regular column index.


Ultimately, the key to handling NULLs in join conditions is based on knowing your data. If at all possible, avoid joining on columns that may have NULLs, or ensure that every column you will join on has a default value when it is populated. If the column must have NULLs, use functions like NVL, NVL2, and COALESCE to convert NULLs before joining; you can create function-based indexes to offset any performance issues with joining on expressions. If that is not possible, understand the business rules about what NULLs mean in your database columns: do they mean zero, unknown, or not applicable? Your SQL code must reflect the business definition of columns that can have NULLs.

---

4-1. Deriving New Columns
Problem
You don’t want to store redundant data in your database tables, but you want to be able to create totals, derived values, or alternate formats for columns within a row.


Solution
In your SELECT statements, apply SQL built-in functions or create expressions on one or more columns in the table, creating a virtual column in the query results. For example, suppose you want to SUMmarize total compensation for an employee, combining salary and commissions.
In the sample tables included for the OE user FROM a default installation of SQL, the ORDER_ITEMS
table contains UNIT_PRICE and QUANTITY columns as follows:
SELECT * FROM order_items;


665 rows selected
To provide a line-item total in the query results, add an expression that multiplies unit price by quantity, as follows:
SELECT order_id, line_item_id, product_id,
unit_price, quantity, unit_price*quantity line_total_price FROM order_items;

---
[tablefunc extension](https://www.postgresql.org/docs/current/tablefunc.html)

---
[crosstab function](https://www.vertabelo.com/blog/creating-pivot-tables-in-postgresql-using-the-crosstab-function/)

---

[stack overflow using crosstab to make a pivot table](https://stackoverflow.com/questions/20618323/create-a-pivot-table-with-postgresql)

---
4-6. Concatenating Data for Readability
Problem
For reporting and readability purposes, you want to combine multiple columns into a single output column, eliMINating extra blank space and adding punctuation WHERE necessary.

Solution
Use SQL string concatenation functions or operators to save space in your report and make the output more readable. For example, in the employee table, you can use the || (two vertical bars) operator or the CONCAT function to combine the employee’s first and last name:

SELECT employee_id, last_name || ', ' || first_name full_name, email FROM employee
;






107 rows selected
The query concatenates the last name, a comma, and the first name into a single string, aliased as FULL_NAME in the results. If your platform’s character set does not support using || as a concatenation operator (as some IBM mainframe character sets do), or you might soon migrate your SQL to such a platform, you can make your code more platform-independent by using the CONCAT functions instead:

SELECT employee_id, concat(concat(last_name,', '),first_name) full_name, email FROM employee
;
Because the CONCAT function only supports two operands as of SQL Database 11g, concatenating more than two strings can make the code unreadable very fast!

How It Works
You can apply a number of different SQL built-in functions to make your output more readable; some SQL shops I’ve worked in relied solely on SQL*Plus for their reporting. Applying the appropriate functions and using the right SQL*Plus commands makes the output extremely readable, even with queries returning SQL objects, currency columns, and long character strings.
If your text-based columns have leading or trailing blanks (which of course should have been cleaned up on import or by the GUI form), or the column is a fixed-length CHAR column, you can get rid of leading and trailing blanks using the TRIM function, as in this example:

SELECT employee_id, trim(last_name) || ', ' || trim(first_name) full_name, email FROM employee
;
If you only want to trim leading or trailing blanks, you can use LTRIM or RTRIM respectively. If some of your employee don’t have first names (or last names), your output using any of the previous solutions would look a little odd:

SELECT employee_id, last_name || ', ' || first_name full_name, email FROM celebrity_employee
;




To remedy this situation, you can add the NVL2 function to your SELECT statement:
SELECT employee_id, trim(last_name) ||
nvl2(trim(first_name),', ','') || trim(first_name) full_name,
email
FROM employee
;
The NVL2 function evaluates the first argument TRIM(FIRST_NAME). If it IS NOT NULL, it returns ', ', otherwise it returns a NULL (empty string), so that our celebrity employee won’t have a phantom comma at the end of their name:



Finally, you can also take advantage of the INITCAP function to fix up character strings that might have been entered in all caps or have mixed case. If your employee table had some rows with last name and first name missing, you could derive most of the employee names FROM the e-mail address by using a combination of SUBSTR, UPPER, and INITCAP as in this example:
SELECT employee_id, email,
upper(substr(email,1,1)) || ' ' || initcap(substr(email,2)) name FROM employee
;



This solution is not ideal if the e-mail address does not contain the complete employee name or if the employee’s last name has two parts, such as McDonald, DeVry, or DeHaan.

---
4-7. Translating Strings to Numeric Equivalents
Problem
In an effort to centralize your domain code management and further normalize the structure of your database tables, you want to clean up and convert some text-format business attributes to numeric equivalents. This will enhance reporting capabilities and reduce data entry errors in the future.

Solution
Use the CASE function to translate business keys or other intelligent numeric keys to numeric codes that are centrally stored in a domain code table. For example, the ORDERS table of the OE schema contains a column ORDER_MODE that currently has four possible values, identified in Table 4-1.

Table 4-1. Mapping the Text in the ORDER_MODE Column to Numeric Values



The second column of Table 4-1 contains the numeric value we want to map to for each of the possible values in the ORDER_MODE column. Here is the SQL you use to add the new column to the table:
alter table orders add (order_mode_num number);
SQL versions 9i and later include the CASE statement, which is essentially a way to more easily execute procedural code within the confines of the typically non-procedural SQL command language. The CASE statement has two forms: one for simpler scenarios with a single expression that is compared to a list of constants or expressions, and a second that supports evaluation of any combination of columns and expressions. In both forms, CASE returns a single result that is assigned to a column in the SELECT query or DML statement.
The recipe solution using the simpler form of the CASE statement is as follows:
update orders
set order_mode_num = case order_mode
when 'direct' then 1 when 'online' then 2 when 'walmart' then 3


when 'amazon' then 4 else 0
end
;
Once you run the UPDATE statement, you can drop the ORDER_MODE column after verifying that no other existing SQL references it.

How It Works
The CASE statement performs the same function as the older (but still useful in some scenarios) DECODE function, and is a bit more readable as well. For more complex comparisons, such as those evaluating more than one expression or column, you can use the second form of the CASE statement. In the second form, the CASE clause does not contain a column or expression; instead, each WHEN clause contains the desired comparison operation. Here is an example WHERE we want to assign a special code of 5 when the order is an employee order (the CUSTOMER_ID is less than 102):
update orders
set order_mode_num = case
when order_mode = 'direct' and customer_id < 102 then 5
when order_mode = 'direct' then 1 when order_mode = 'online' then 2 when order_mode = 'walmart' then 3 when order_mode = 'amazon' then 4 else 0
end
;

Note that in this scenario you need to check for the employee order first in the list of WHEN clauses, otherwise the ORDER_MODE column will be set to 1 and no customer orders will be fLAGged, since both conditions check for ORDER_MODE = 'direct'. For both DECODE and CASE, the evaluation and assignment stops as soon as SQL finds the first expression that evaluates to TRUE.
In the solution, the string 'direct' is translated to 1, 'online' is translated to 2, and so forth. If the ORDER_MODE column does not contain any of the strings in the list, the ORDER_MODE_NUM column is assigned 0.
Finally, reversing the mapping in a SELECT statement for reporting purposes is very straightforward: we can use CASE or DECODE with the text and numeric values reversed. Here is an example:

SELECT order_id, customer_id, order_mode_num, case order_mode_num
when 1 then 'Direct, non-employee' when 2 then 'Online'
when 3 then 'WalMart' when 4 then 'Amazon'
when 5 then 'Direct, employee' else 'unknown'
end order_mode_text


FROM orders
WHERE order_id in (2458,2397,2355,2356)
;


4 rows selected
The older DECODE statement is the most basic of the SQL functions that converts one set of values to another; you can convert numeric codes to human-readable text values or vice versa, as we do in the previous solutions. DECODE has been available in SQL since the earliest releases. DECODE has a variable number of arguments, but the arguments can be divided into three groups:
The column or expression to be translated
One or more pairs of values; the first value is the existing value and the second is the translated value
A single default value if the column or expression to be translated does not match the first value of any of the specified pairs
Here is the UPDATE statement using DECODE:
update orders
set order_mode_num = decode(order_mode,
'direct',1,
'online',2,
'walmart',3,
'amazon',4,
0)
;
105 rows updated
DECODE translates the ORDER_MODE column just as CASE does. If the values in the column do not match any of the values in the first of each pair of constants, DECODE returns 0.

---
5-2. Sorting on NULL Values
Problem
Results for a business report are sorted by department manager, but you need to find a way to override the sorting of NULLs so they appear WHERE you want at the beginning or end of the report.

Solution
SQL provides two extensions to the ORDER BY clause to enable SQL developers to treat NULL values separately FROM the known data, allowing any NULL entries to sort explicitly to the beginning or end of the results.
For our recipe, we’ll assume that the report desired is based on the department names and manager identifiers FROM the department table. This SQL SELECTs this data and uses the NULLS FIRST option to explicitly control NULL handling.

SELECT department_name, manager_id FROM department
ORDER BY manager_id NULLs first;

The results present the “unmanaged” departments first, followed by the departments with managers by MANAGER_ID. We’ve abbreviated the results to save trees.



How It Works
Normally, SQL sorts NULL values to the end of the results for default ascending sorts, and to the beginning of the results for descending sorts. The NULLS FIRST ORDER BY option, together with its complement, NULLS LAST, overrides SQL’s normal sorting behavior for NULL values and places them exactly WHERE you specify: either at the beginning or end of the results.
Your first instinct when presented with the problem of NULL values sorting to the “wrong” end of your data might be to simply switch FROM ascending to descending sort, or vice versa. But if you think about more complex queries, subSELECTs using ROWNUM or ROWID tricks, and other queries that need to


preserve data order while getting NULL values moved, you’ll see that NULLS FIRST and NULLS LAST have real utility. Using them guarantees WHERE the NULL values appear, regardless of how the data values are sorted.

---
5-4. Testing for the Existence of Data
Problem
You would like to compare the data in two related tables, to show WHERE matching data exists, and to also show WHERE matching data doesn’t exist.

Solution
SQL supports the EXISTS and NOT EXISTS predicates, allowing you to correlate the data in one table or expression with matching or missing data in another table or expression. We’ll use the hypothetical situation of needing to find which departments currently have managers. Phrasing this in a way that best illustrates the EXISTS solution, the next SQL statement finds all departments WHERE a manager is known to exist.

SELECT department_name FROM department d WHERE exists
(SELECT e.employee_id


FROM employee e
WHERE d.manager_id = e.employee_id);

The complement, testing for non-existence, is shown in the next statement. We ask to find all departments in department with a manager that does not exist in the data held in employee.

SELECT department_name FROM department d WHERE not exists (SELECT e.employee_id FROM employee e
WHERE d.manager_id = e.employee_id);

How It Works
In any database, including SQL, the EXISTS predicate answers the question, “Is there a relationship BETWEEN two data items, and by extension, what items in one set are related to items in a second set?” The NOT EXISTS variant tests the converse, “Can it definitively be said that no relationship exists BETWEEN two sets of data, based on a proposed criterion?” Each approach is referred to as correlation or a correlated subquery (literally, co-relation, sharing a relationship).
Interestingly, SQL bases its decision on whether satisfying data exists solely on this premise: was a matching row found that satisfied the subquery’s predicates? It’s almost too subtle, so we’ll point out the obvious thing SQL isn’t seeking. What you SELECT in the inner correlated query doesn’t matter—it’s only the criteria that matter. So you’ll often see versions of existence tests that form their subSELECT by Selecting the value 1, the entire row using an asterisk, a literal value, or even NULL. Ultimately, it’s immaterial in this form of the recipe. The key point is the correlation expression. In our case, it’s WHERE D.MANAGER_ID = E.EMPLOYEE_ID.
This also helps explain what SQL is doing in the second half of the recipe, WHERE we’re looking for DEPARTMENT_NAME values for rows WHERE the MANAGER_ID doesn’t exist in the employee table. SQL drives the query by evaluating, for each row in the outer query, whether no rows are returned by the inner correlated query. SQL doesn’t care what data exists in other columns not in the correlation criteria. It pays to be careful using such NOT EXISTS clauses on their own—not because the logic won’t work but because against large data sets, the optimizer can decided to repeatedly scan the inner data in full, which might affect performance. In our example, so long as a manager’s ID listed for a department is not found in the employee table, the NOT EXISTS predicate will be satisfied, and department included in the results.


Caution Correlated subqueries satisfy an important problem-solving niche, but it’s crucial to remember the nature of NULL values when using either EXISTS or NOT EXISTS. NULL values are not equivalent to any other value, including other NULL values. This means that a NULL in the outer part of a correlated query will never satisfy the
correlation criterion for the inner table, view, or expression. In practice, this means you’ll see precisely the opposite effect as the one you might expect because the EXISTS test will always return false, even if both the inner and outer data sources have NULL values for the correlation, and NOT EXISTS will always return true. Not
what the lay person would expect.

---

5-5. Conditional Branching In One SQL Statement
Problem
In order to produce a concise result in one query, you need to change the column returned on a row-by- row basis, conditional on a value FROM another row. You want to avoid awkward mixes of unions, subqueries, aggregation, and other inelegant techniques.

Solution
For circumstances WHERE you need to conditionally branch or alternate BETWEEN source data, SQL provides the CASE statement. CASE mimics the traditional switch or case statement found in many programMINg languages like C or Java.
To bring focus to our example, we’ll assume our problem is far more tangible and straightforward. We want to find the date employee in the shipping department (with the DEPARTMENT_ID of 50) started their current job. We know their initial hire date with the firm is tracked in the HIRE_DATE column on the employee table, but if they’ve had a promotion or changed roles, the date when they commenced their new position can be inferred FROM the END_DATE of their previous position in the HR.JOB_HISTORY table. We need to branch BETWEEN HIRE_DATE or END_DATE for each employee of the shipping department accordingly, as shown in the next SQL statement.

SELECT e.employee_id, case
when old.job_id IS NULL then e.hire_date else old.end_date end
job_start_date
FROM employee e LEFT OUTER JOIN hr.job_history old on e.employee_id = old.employee_id
WHERE e.department_id = 50 ORDER BY e.employee_id;
Our results are very straightforward, hiding the complexity that went into picking the correct

JOB_START_DATE.




…

How It Works
Our recipe uses the CASE feature, in Search form rather than Simple form, to switch BETWEEN HIRE_DATE
and END_DATE values FROM the joined tables. In some respects, it’s easiest to think of this CASE operation


as a combination of two SELECT statements in one. For employee with no promotions, it’s as if we were Selecting as follows:
SELECT e.employee_id, e.hire_date…
WHEREas for employee that have had promotions, the CASE statement switches the SELECT to the following form:
SELECT e.employee_id, old.end_date…

The beauty is in not HAVING to explicitly code these statements yourself, and for far more complex uses of CASE, not HAVING to code many dozens or hundreds of statement combinations.
To explore the solution FROM the data’s perspective, the following SQL statement EXTRACTs the employee identifier and the hire and end dates using the same LEFT OUTER JOIN as our recipe.

SELECT e.employee_id, e.hire_date, old.end_date end FROM employee e LEFT OUTER JOIN hr.job_history old on e.employee_id = old.employee_id

WHERE e.department_id = 50 ORDER BY e.employee_id;



…
The results show the data that drove the CASE function’s decision in our recipe. The values in bold were the results returned by our recipe. For the first, second, fourth, and fifth rows shown, END_DATE FROM the HR.JOB_HISTORY table IS NULL, so the CASE operation returned the HIRE_DATE. For the third row, with EMPLOYEE_ID 122, END_DATE has a date value, and thus was returned in preference to HIRE_DATE when exaMINed by our original recipe. There is a shorthand form of the CASE statement known as the Simple CASE that only operates against one column or expression and has THEN clauses for possible values. This wouldn’t have suited us as SQL limits the use of NULL with the Simple CASE in awkward ways.

---

5-6. Conditional Sorting and Sorting By Function
Problem
While querying some data, you need to sort by an optional value, and WHERE that value is not present, you’d like to change the sorting condition to another column.


Solution
SQL supports the use of almost all of its expressions and functions in the ORDER BY clause. This includes the ability to use the CASE statement and simple and complex functions like arithmetic operators to dynamically control ordering. For our recipe, we’ll tackle a situation WHERE we want to show employee ordered by highest-paid to lowest-paid.
For those with a commission, we want to assume the commission is earned but don’t want to actually calculate and show this value; we simply want to order on the implied result. The following SQL leverages the CASE statement in the ORDER BY clause to conditionally branch sorting logic for those with and without a COMMISSION_PCT value.

SELECT employee_id, last_name, salary, commission_pct FROM employee
ORDER BY case
when commission_pct IS NULL then salary else salary * (1+commission_pct)
end desc;

We can see FROM just the first few rows of results how the conditional branching while sorting has worked.




…
Even though employee 101 and 102 have a higher base salary, the ORDER BY clause using CASE has correctly positioned employee 145 and 146 based on their included commission percentage.

How It Works
The SELECTion of data for our results follows SQL’s normal approach, so employee identifiers, last names, and so forth are fetched FROM the employee table. For the purposes of ordering the data using our CASE expression, SQL performs additional calculations that aren’t shown in the results. All the candidate result rows that have a non-NULL commission value have the product of COMMISSION_PCT and SALARY calculated and then used to compare with the SALARY figures for all other employee for ordering purposes.
The next SELECT statement helps you visualize the data SQL is deriving for the ordering calculation.

SELECT employee_id, last_name, commission_pct, salary, salary * (1+commission_pct) sal_x_comm
FROM employee;



…

The values in bold show the calculations SQL used for ordering when evaluating the data via the CASE expression in the ORDER BY clause. The general form of the CASE expression can be expressed simply as follows.
case
when <expression, column, etc.> then <expression, column, literal, etc.> when <expression, column, etc.> then <expression, column, literal, etc.>
…
else <default expression for unmatched cases> end

We won’t needlessly repeat what the SQL manual covers in plenty of detail. In short, the CASE expression evaluates the first WHEN clause for a match and if satisfied, performs the THEN expression. If the first WHEN clause isn’t satisfied, it tries the second WHEN clause, and so on. If no matches are found, the ELSE default expression is evaluated.

---

5-7. OvercoMINg Issues and Errors when SubSELECTs Return Unexpected Multiple Values
Problem
In working with data FROM a subSELECT, you need to deal with ambiguous situations WHERE in some cases the subSELECT will return a single (scalar) value, and in other cases multiple values.

Solution
SQL supports three expressions that allow a subSELECT to be compared based on a single column of results. The operators ANY, SOME, and ALL allow one or more single-column values FROM a subSELECT to be compared to data in an outer SELECT. Using these operators allows you to deal with situations WHERE you’d like to code your SQL to handle comparisons with flexible set sizes.
Our recipe focuses on using these expressions for a concrete business problem. The order-entry system tracks product information in the OE.PRODUCT_INFORMATION table, including the LIST_PRICE value. However, we know discounts are often offered, so we’d like to get an approximate idea of which items have never sold at full price. To do this, we could do a precise correlated subquery of every sale against list price. Before doing that, a very quick approximation can be done to see if any LIST_PRICE value is


higher than any known sale price for any item, indicated by the UNIT_PRICE column of the
OE.ORDER_ITEMS table. Our SELECT statement takes this form.
SELECT product_id, product_name FROM oe.product_information WHERE list_price > ALL
(SELECT unit_price FROM oe.order_items);
FROM this query, we see three results:
PRODUCT_ID  PRODUCT_NAME
2351    Desk - W/48/R
3003    Laptop 128/12/56/v90/110
2779    Desk - OS/O/F
These results mean at least three items—two desks and a laptop—have never sold a full price.

How It Works
Our example’s use of the ALL expression allows SQL to compare the UNIT_PRICE values FROM every sale, to see if any known sale price was greater than the LIST_PRICE for an item. Breaking down the steps that make this approach useful, we can first look at the subSELECT.

SELECT unit_price FROM oe.order_items

This is a very simple statement that returns a single-column result set of zero or more items, shown next in abbreviated form.
UNIT_PRICE
13
38
43
43
482.9
…
665 rows selected.
Based on those results, our outer SELECT statement compares each LIST_PRICE FROM the OE.PRODUCTION_INFORMATION table with every item in the list, as we are using the ALL expression. If the LIST_PRICE is greater than all of the returned values, the expression resolves to true, and the product is included in the results. WHERE even one of the UNIT_PRICE values returned exceeds the LIST_PRICE of an item, the expression is false and that row is discarded FROM further consideration.
If you review that logic, you’ll realize this is not a precise calculation of every item that didn’t sell for full price. Rather, it’s just a quick approximation, though one that shows off the ALL technique quite well.
The alternatives SOME and ANY, which are effectively synonyms, resolve the true/false deterMINation based on only needing one item in the subSELECT to satisfy the SOME/ANY condition. SQL will happily


accept more than one item matching the SOME/ANY criteria, but only needs to deterMINe one value to evaluate the subSELECT.


---
