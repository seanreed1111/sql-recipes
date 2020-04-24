```
# The Standard Questions (source: `The Essence of SQL by David Rozenshtein`)
### We begin our presentation of SQL with a list of standard questions.
### This list will be extended with additional standard questions as we proceed. 
```

### You have to understand what data you have and how it is organized BEFORE you can figure out what questions you can ask of it. So let's look at the organization of the data.

```sql
CREATE TABLE student (
    id integer,
    name varchar(10),
    age integer
);

CREATE TABLE course (
    id varchar(5),
    name varchar(10),
    credits integer
);

CREATE TABLE schedule (
    student_id integer,
    course_id varchar(5)
);

CREATE TABLE professor (
    name varchar(10),
    department varchar(10),
    salary integer,
    age integer
);

CREATE TABLE teach (
    professor_name varchar(10),
    course_id varchar(5)
);

```

### We see that there are five tables in our database that are of interest to us: `student`, `course`, `professor`, `schedule`, and `teach`

## Discussion Question: What kinds of questions are we going to be able to ask of the data in each of these tables? 

## Discussion Question: How are these tables connected to each other? How would you draw a diagram showing these connections?

## It is CRUCIAL that you understand and identify what information is in your database, and also understand how the data is distributed among the different tables. No two databases you encounter will be set up exactly the same, so you it is important to spend time getting to know something about the structure of your database and tables before diving in. Don't be hasty! 

### One good thing about SQL is that you can use simple SQL statements to figure out what data you have, before you start to think about complicated questions, even if you aren't given a nice neat list of tables like the one above.

### The way you find out what data is inside a table is by using the following command, inserting your table of interest for `table_name` (the number 3 is arbitrary. I personally like 3, but you could use 1 or 4 or 5 if you prefer):

```sql
SELECT * 
FROM table_name 
LIMIT 3;
```

## Discussion Question: What do you think the output of the following statement will look like given the `CREATE TABLE` statements above?

```sql
SELECT * 
FROM student 
LIMIT 3;
```

### output
```
 id | name  | age
----+-------+-----
  1 | LISA  |  20
  2 | CHUCK |  21
  3 | CHLOE |  20
```

## Discussion Question: What do you think might be a potential disadvantage of removing the `LIMIT` statement from the above query, like in the query below?

```sql
SELECT * 
FROM student;
```

### SQL allows us to answer questions about our data. In you future position as a data analyst, people will ask you all kinds of questions that they want to know about their customers, questions comparing this month's data to last month's, questions about who spends a lot or a little, and what kinds of products they spend the most money on, etc.

### If the data is available, **and** the data is reliable (Garbage In --> Garbage Out), you can use SQL to answer many or all of these questions once you get good at it. 

## Discussion: What sorts of questions could we ask about our professors? Please take a few minutes and write out some additional questions about them.

### To start off let's take a look at a few questions that we might ask about the students in our imaginary school.

```
E1. Who takes (the course with the course number) CL101? (By "Who" we mean that we want the student ids retrieved. If we want the names retrieved, we will explicitly say so.)
E2. What are student ids and names of students who take CL101?
E3. Who takes CL101 or CL109?
E4. Who takes both CL101 and CL109? 
E5. Who does not take CL101?
E6. Who takes a course which is not CL101?
E7. Who takes at least 2 courses (i.e., at least 2 courses with different course numbers)?
(A more general question: Who takes at least 3, 4, 5,
etc., courses?)
E8. Who takes at most 2 courses?
    (More generally: 3, 4, 5, etc., courses?) 
E9. Who takes exactly 2 courses?
     (More generally: 3, 4, 5, etc., courses?) 
ElO. Who takes only CL101?
E11. Who takes either CL101 or CL109? 
E12. Who are the youngest students?
(Similarly, Who are the oldest students?)
E13. Who takes every course?
```

### Note: The above is obviously not a random series of questions. These questions, although they all look fairly similar, require a different levels of complication wrt SQL queries. 

### We will start with `Type 1` Queries

---

# Introductionction to Type 1 Queries 

### Questions E1 and E2 fall into the category of what we will call `Type 1`queries. 
### IMPORTANT NOTE: The classification system we will use calls different queries `Type 1`, `Type 2`, and `Type 3` according to their properties. This classification is not used in the industry but I believe it is wonderful as a teaching tool. So don't expect anyone who hasn't read `The Essence of SQL` by David Rozenshtein to understand what a `Type 1`, `Type 2`, or `Type 3` query is before you explain it to them! 

### All `Type 1A` SQL queries have the following basic form:

```sql
SELECT 
  <list of desired columns> 
FROM 
  <table>
WHERE 
  <Boolean condition>;
```
### where `SELECT`, `FROM` and `WHERE` are SQL keywords designat­ing the three basic components, or clauses, of the query. 

## IMPORTANT NOTE: While SQL is generally case insensitive, the (weak) consensus is that SQL is easier to read when you put ALL SQL KEYWORDS IN UPPER CASE without exception. So, you are REQUIRED to put ALL SQL KEYWORDS IN UPPER CASE in this class. Only relax the requirement of putting ALL SQL KEYWORDS IN UPPER CASE if your current/future boss gives you a direct order to do so, and even then you should put up a decent fight against the change before agreeing.

### In thinking about, understanding, and composing `Type 1A` queries, ALWAYS CONSIDER THE `FROM` CLAUSE FIRST. 

### The `FROM` clause lists the table or tables that need to be considered to answer the ques­tion. To determine which tables should go in this list, pretend that you have to answer the question without a computer system, using just paper copies of the tables, and think of which of them you would actually need.

In question E1- Who takes CS112?- "Who" stands for stu­ dent numbers (Sno), and CS112 stands for a course number (Cno). Thus, since all relevant information is contained in table Take, the FROM clause becomes

FROM Take

Next, we consider the WHERE clause. It contains a Boolean condition which defines which rows from table(s) in the FROM clause should be retrieved by the query. For ques­ tion El this condition is for the course number to be CS112, thus making the WHERE clause
WHERE (Cno = "CS112")   m

(Whether one uses single or double quotes around string literals is usually system dependent. Also, while parenthe­ sis around conditions are often not required, we use them to improve readability.)

Finally, the SELECT clause lists the column(s) that define the structure of the answer. Since in this case we just want the student numbers retrieved, the SELECT clause becomes

SELECT Sno

The final query then takes the form shown in Figure 5.1.


SELECT Sno
FROM Take
WHERE (Cno = "CS112")

Figure 5.1: Query Q1for question E1 - Who takes CS112?


While it is true that this query does intuitively correspond to question El, intuition is not a reliable means for under­ standing SQL. So, to be safe in interpreting SQL queries, we introduce a conceptual device known as the query evaluation mechanism.

A query evaluation mechanism gives us a precise and for­ mal algorithm to trace queries.

This ability to trace is fundamental to all SQL
programming, since it is only by following the trace
that we can see how the answer is actually computed, and thus understand its true meaning.

Different types of SQL queries have different evaluation mechanisms. The Type 1 evaluation mechanism is shown in Figure5.2

1. Take a cross-product of all tables in the FROM clause­ i.e., create a temporary table consisting of all possible combinations of rows from all of the tables in the FROM clause. (If the FROM clause contains a single table, skip the cross-product and just use the table itself.)
2. Consider every row from the result of Step 1 exactly once, and evaluate the WHERE clause condition for it.
3. If the condition returns True in Step 2, formulate a resulting row according to the SELECT clause, and retrieve it.

Figure 5.2: The Type 1 SQL evaluation mechanism.


## `E1`: Who takes CL101?

```sql
--- E1 - Who takes CL101?
SELECT 
    student_id
FROM 
    schedule
WHERE 
    course_id = 'CL101';

-- NOTE: 'CL101' is a text string. So it is enclosed in SINGLE QUOTES.
-- Please use SINGLE QUOTES when you are writing SQL queries.
```
### NOTE: 'CL101' is a text string, so it is enclosed in single quotes. 
### Always use SINGLE QUOTES when you are writing text in SQL queries.


### All `Type 1B` SQL queries have the following basic form:

```sql
SELECT 
  <list of desired columns> 
FROM 
  <table1>
INNER JOIN 
  <table2>
ON
  <join parameters>
WHERE 
  <Boolean condition>;
```

### We will see later that there are different join types in SQL that can be substituted for `INNER JOIN` in `Type 1B` queries.

### Our Question `E2` from above (What are student ids and names of students who take CL101?) can be solved with a `Type 1B` query.

## `E2`: What are student ids and names of students who take CL101?
```sql
--- E2: What are student ids and names of students who take CL101?
SELECT 
    student.id, 
    student.name 
FROM 
    student
INNER JOIN 
    schedule
ON 
 student.id = schedule.student_id
WHERE 
    schedule.course_id = 'CL101';

```

### Here is the query's output, aka the answer to Question `E2`:
```
 id |  name
----+--------
  1 | LISA
  2 | CHUCK
  3 | CHLOE
  4 | MAGGIE
```


## Discussion Question: Describe in words how you believe SQL goes from the query to the output above. What order do you think it takes to find the answers?

---



## `E3`: Who takes CL101 or CL109?
```sql
-- Answer E3 - Who takes CL101 or CL109?
SELECT 
    student_id
FROM 
    schedule
WHERE 
    course_id = 'CL101' 
OR 
    course_id = 'CL109';
```

### Notice that the output of this query has some duplicated rows.
```
 student_id
------------
          1
          1
          2
          3
          3
          4
          6
```

### If you ever need to get rid of redundant rows in your output, you can add the keyword `DISTINCT` to your query. 
### Note: This will remove duplicates but it `slows down your query` if you have a lot of output, so only use when absolutely necessary. 

```sql
SELECT DISTINCT
    student_id
FROM 
    schedule
WHERE 
    course_id = 'CL101' 
OR 
    course_id = 'CL109';
```

### Output
```
 student_id
------------
          1
          2
          3
          4
          6
```




### You can use the keyword `IN` and put the choices inside of parentheses as an alternative to using `OR`. This can be useful and is preferred when you have a long list of things to include in your `WHERE` clause.

```sql
-- Answer E3 - Who takes CL101 or CL109?
SELECT DISTINCT 
    student_id
FROM 
    schedule
WHERE 
    course_id IN ('CL101', 'CL109');

```
### Output
```
 student_id
------------
          1
          2
          3
          4
          6
```



## `E4`: Who takes **both** CL101 and CL109?


### This is wrong
```sql
--- this is wrong 
-- bad approach to E4: Who takes **both** CL101 and CL109?
SELECT 
  course_id
FROM 
  schedule
WHERE 
  course_id = 'CL101'
AND 
  course_id = 'CL109';

```

## Discussion Question: Why are there zero rows as a result of the above query??
```
 course_id
-----------
(0 rows)
```


### To answer the question `Who takes both CL101 and CL109?` we need to join the `schedule` table with itself. When you join a table to a copy of itself, that is called a `self-join`.


### Let's look at the full schedule
```sql
SELECT * FROM schedule;
```

```
 student_id | course_id
------------+-----------
          1 | CL101
          1 | CL105
          1 | CL109
          2 | CL101
          3 | CL101
          3 | CL109
          4 | CL101
          4 | CL105
          5 | CL105
          6 | CL105
          6 | CL109
```



### Correct Answer: E4 - Who takes both CL101 and CL109?
```sql
-- E4 - Who takes both CL101 and CL109?
SELECT 
  schedule1.student_id
FROM 
  schedule AS schedule1
INNER JOIN 
  schedule AS schedule2
ON 
  schedule1.student_id = schedule2.student_id
AND
  schedule1.course_id = 'CL101'
AND
  schedule2.course_id = 'CL109';


```

```
 student_id
------------
          1
          3
```

### In order to do a self-join you MUST use aliases. 

### Discussion Question: Why do you think aliases are required for self-joins?


### Note: The choice of alias names is completely arbitrary as long as they do not conflict with each other or with any real table name used in a query.

### Second, aliases are opaque- a technical term meaning that an alias completely covers and hides the name of the under­lying table. Thus, from the point of view of the `SELECT` and `WHERE` clauses, the query involves two tables: one named `schedule1` and the other named `schedule2`. The query CANNOT reference the table named `schedule`.
    
### Third, it is always permitted to alias tables, even if not really necessary. Indeed, to save on typing, SQL program­ mers often use short aliases for long, meaningful table names given to them by well-meaning database designers. 

### Finally, we note that aliases are an `essential` feature of SQL. Without them, standard questions involving the both/and construct and self-joins could not have been asked as Type 1 queries.

---

### E5: Who does not take CL101?
### This question should be translated as 'Which students do not take CL101?'
### So, you must query the `STUDENT` table AND the `SCHEDULE` table!

```sql
SELECT id
FROM student
WHERE 
  id NOT IN 
        (SELECT 
          student_id 
        FROM 
          schedule 
        WHERE 
          schedule.course_id = 'CL101'
        );
```

### Here we have a nested subquery, our first one!
### The subquery is:

```sql
SELECT 
  student_id 
FROM 
  schedule 
WHERE 
  schedule.course_id = 'CL101';
```

### Pay close attention to how we have solved the problem of figuring out which students do not take CL101.
1. First, we figured out which students take CL101.
2. Then, we remove those students from our full student list.

### We found out who was `IN` the group in question, in this case 'CL101' students, and then we took them out, leaving us with those who were `NOT` in the group. You will be able to use this strategy over an over for many SQL queries of a similar structure!

---

Question `E6`: Who takes a course which is not CL101?

### Question `E6` sounds similar to `E5` but is much simpler! 
### Because we are starting with students who are taking courses, we are only concerned with the `schedule` table rather than both the  `student` and `schedule` tables.

```sql
--- E6 - Who takes a course which is not CL101?

SELECT id
FROM schedule
WHERE course_id != 'CL101'
```
---

Question E7 - Who takes at least 2 courses?

```sql
-- E7 - Who takes at least 2 courses? 

SELECT 
  schedule1.student_id
FROM 
  schedule AS schedule1
INNER JOIN 
  schedule AS schedule2
ON 
  schedule1.student_id = schedule2.student_id
AND 
  schedule1.course_id < schedule2.course_id;


```
### with duplicates
```
 student_id
------------
          1
          1
          1
          3
          4
          6
(6 rows)
```


### E7 - Who takes at least 2 courses? (Without Duplicates)
```sql
SELECT 
  schedule1.student_id
FROM 
  schedule AS schedule1
INNER JOIN 
  schedule AS schedule2
ON 
  schedule1.student_id = schedule2.student_id
AND 
  schedule1.course_id < schedule2.course_id
GROUP BY
  schedule1.student_id;
```

### Output - E7 - Who takes at least 2 courses? (Without Duplicates)
```
 student_id
------------
          1
          3
          4
          6
(4 rows)
```

---


## Introduction to Type 2 query

### We begin the discussion by first explaining its syntax, then introduc­ing the Type 2 evaluation mechanism, and finally tracing this query to determine the question it poses.

### A sample Type 2 SQL query.

```sql
SELECT id, name 
FROM student 
WHERE id IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101'
    );

```
## Definition: A **Type 2 SQL Query** is a collection of one or more non-correlated component queries, with some of them nested in the WHERE clauses of the others. (The meaning of the term "non-correlated" will be explained in a moment.)

### Theoretically, there is no limit on the number of nesting lev­els or on the number of component queries involved. On a practical level, however, SQL compilers do impose some limitations in this regard (e.g., no more than 16 nesting lev­els), but these rarely present any real problems.

### Our Sample Type 2 query has two component queries. The inner query (called the subquery) is nested in the WHERE clause of the outer query (called the main query), and the queries are connected by the list-membership operator `IN`. 

### Where is the Inner Query?
```sql
SELECT id, name FROM student 
WHERE id IN
    (<INNER QUERY>);
```

### Where is the Outer Query?
```sql
<OUTER QUERY> IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101');
```

### Now put the Outer and Inner Queries back together again. The Outer Query goes on the outside and the Inner Query on the inside!
```sql
SELECT id, name FROM student 
WHERE id IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101');

```

### What is a non-correlated query?
### Definition: A query is called **non-correlated** if all column references in it are local- i.e., all columns come from, or are bound to, the tables in the local `FROM` clause. Any non-local column ref­erence is called a correlation, and the query containing it becomes correlated.

### Alternative Definition: A Query is non-correlated when any **INNER QUERY** CAN BE RUN SEPARATELY ON ITS OWN IF DESIRED, i.e., IT HAS NO REFERENCE TO any of the columns, tables, or aliases in the *OUTER QUERY*!

### We see that the *Inner Query* (shown again below) works perfectly fine on a stand-alone basis and produces valid SQL output. 
### Therefore our sample query is *non-correlated*.

```sql
SELECT student_id 
FROM schedule
WHERE course_id = 'CL101';
```

### Output
```
 student_id
------------
          1
          2
          3
          4

```
### In oue 

### In determining these column-to-table bindings, SQL follows the standard "inside-out, try the local scope first" scope rules. Specifically, given a column reference, SQL first tries to find some table in the local FROM clause containing that column. If the column reference also involves a prefix­ either a table name or an alias, then SQL also looks for the match on that prefix. Three alternative outcomes are then possible.

1. SQL finds a single such table and successfully binds that column reference to that table.
2. SQL finds several such tables. Then column reference
is ambiguous and the appropriate error message is generated.
3. SQL does not find any such table in the local FROM
clause. Then column reference is not local. SQL then looks at the next outer scope- i.e., at the FROM clause in the immediately enclosing query, and attempts to bind that column reference to a table in that FROM clause.

### This process continues (using the same three possibilities) until either a column reference is successfully bound, or an ambiguity is found, or the binding process "falls off" the main query, in which case the column reference cannot be bound at all, and the appropriate error is declared.

### Given this process and the query of Figure 10.1, columns id and course_id in its subquery are bound to the inner schedule table, and columns id and name in its main query are bound to the outer Student table, thus making all bindings local, the component queries non-correlated, and this entire query of Type 2.

### The formal syntactic condition for a multi-level (i.e., with subqueries) query to be of 'Type 2 is presented in Figure 10.2.

### A query with subqueries is of Type 2 if every component query in it is non-correlated or, equivalently, if every column reference in it is local.

The evaluation mechanism for Type 2 queries is presented below:

## To execute a Type 2 query, execute its component queries in the "inside-out" order- i.e., with the inner-most nested subquery first, replacing each query by its result as it gets evaluated.

In case of the query above, ie

```sql
SELECT id, name FROM Student 
WHERE id IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101')
```

The subquery is
```sql
SELECT student_id FROM schedule WHERE (course_id = 'CL101')
```
### This is a regular Type 1 query, is executed first. Its answer is then substituted into its place in the main query, which is executed next.

```sql
SELECT id, name FROM Student WHERE (id IN( ...))
```
### Note that, at this point, the main query has been reduced to a simple Type 1 query. Also note that, since the subquery retrieves a single column in its SELECT clause, the answer to it is just a list of values. Thus, the use of the list membership operator IN as the inter­ query connector is quite appropriate.

### We note that Type 2 queries fundamentally involve multiple data passes - one for each component query. In this case, the first pass is through table schedule in the subquery, and the second pass is through table Student in the main query.

Finally, returning once more to the entire query, what question does it answer?

```sql
SELECT id, name FROM Student 
WHERE id IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101')
```
### Answer: What are the student numbers and names of students who take CL101?

### Using Type 2 to Implement Real Negation
### Questions involving real negation need two passes through the data, using the fol­lowing general strategy:

To pose a question `"Who does not do X?"`
1. identify and select those who actually do X; and
2. remove them from the list of those who potentially maydoX.

### Since Type 2 queries fundamentally involve multiple data passes, they give us exactly what is necessary to implement real negation in SQL. Consider the query below.

```sql
SELECT id
FROM Student WHERE id NOT IN
    (SELECT student_id
    FROM schedule
    WHERE course_id = 'CL101');
```

### But how is this query evaluated, and what question does it pose?

### Since this is a Type 2 query, it is evaluated inside-out. Again, the subquery is the same as query Ql and poses question El- Who takes CL101? Because of the NOT opera­ tor in its WHERE clause, the main query now retrieves the student numbers of all other students- i.e., those student numbers that are not on the list generated by the subquery. Thus, the full query corresponds to the ques­tion `Who does not take CL101?`- i.e., our standard question E5.

Using the solution to question E5 as a foundation, it is now quite easy to generate solutions to questions E5 through
E11. Specifically, question E5- Who takes at most 2 courses?-is posed by query QB of Figure 12.1.

```sql
-- Question E5 Who takes at most 2courses?
SELECT id
FROM Student
WHERE id NOT IN
(SELECT X.student_id
FROM schedule X, schedule Y,schedule
WHERE (X.student_id = Y.student_id)
AND (Y.student_id = schedule.student_id)
AND  (X.student_id != Y.student_id)
AND (Y.student_id != schedule.student_id) AND (X.student_id = schedule.student_id)));
```

### This query is based on rephrasing question ES as Who does not take at least 3 courses? The subquery here poses the ques­tion `Who takes at least 3 courses?` The NOT in the main WHERE clause achieves the desired negation.

### We note that this query will retrieve students who do not take any courses. This is appropriate, since "at most 2" means O (!), 1 or 2.


### By using `schedule` instead of `student` in the main FROM clause we can change this query to ask a related question `Who  takes some (i.e., at least 1), but at most 2, courses? In other words, Who takes 1 or 2 courses?`

```sql
-- Question E9- Who takes exactly 2 courses?

SELECT X.course_id
FROM schedule X, schedule WHERE (X.course_id = schedule.course_id)
AND (X.course_id < schedule.course_id)
AND NOT (X.course_id IN
(SELECT X.course_id
FROM schedule X, schedule Y, schedule WHERE (X.course_id = Y.course_id)
AND (Y.course_id = schedule.course_id) AND (X.course_id < Y.course_id)
AND (Y.course_id < schedule.course_id)))
```

### This query is based on rephrasing question E9 as Who takes at least 2 courses and does not take at least 3 courses? The main query poses Who takes at least 2 courses? and is copied from query Q7. 0/ve have used the less-than operator in its condi­ tion to remove duplicates from the final answer. The sub­ query again poses Who takes at least 3 courses? (Here, we have used less-than operators for conciseness.) The NOT in the main WHERE clause again achieves the desired negation.

### We note that even though we have used the same alias name X in both the main query and in the subquery, because of the scope rules, no confusion arises.

### Translating Your Request into SQL