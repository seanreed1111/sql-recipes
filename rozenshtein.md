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

CREATE TABLE professor (
    name varchar(10),
    department varchar(10),
    salary integer,
    age integer
);

CREATE TABLE schedule (
    studentid integer,
    courseid varchar(5)
);

CREATE TABLE teach (
    instructor varchar(10),
    courseid varchar(5)
);

```

### We see that there are five tables in our database that are of interest to us: `student`, `course`, `professor`, `schedule`, and `teach`

## Discussion Question: What kinds of questions are we going to be able to ask of the data in each of these tables? 

## It is CRUCIAL that you understand and identify what information is in which table BEFORE you try to do anything complicated in SQL! It is important to spend time getting to know the structure of your data before diving in. Don't be hasty! 

### The one thing about SQL is that you can use simple SQL statements to figure out what data you have, before you start to think about complicated questions, even if you don't have access to a nice neat list of tables like the one above.

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

## Discussion Question: What do you think might be a potential advantage of INCLUDING the `LIMIT` statement rather than leaving it off like in the query below?

```sql
SELECT * 
FROM student;
```


```
E1. Who takes (the course with the course number) CS112? (By "Who" we mean that we want the student num­ bers retrieved. If we want the names retrieved, we will explicitly say so.)
E2. What are student numbers and names of students who
takeCS112?
E3. Who takes CS112 or CS114?
E4. Who takes both CS112 and CS114? 
E5. Who does not take CS112?
E6. Who takes a course which is not CS112?
E7. Who takes at least 2 courses (i.e., at least 2 courses with different course numbers)?
(Amore general question: Who takes at least 3, 4, 5,
etc., courses?)
E8. Who takes at most 2 courses?
    (More generally: 3, 4, 5, etc., courses?) 
E9. Who takes exactly 2 courses?
     (More generally: 3, 4, 5, etc., courses?) 
ElO. Who takes only CS112?
E11. Who takes either CS112 or CS114? 
E12. Who are the youngest students?
(Similarly, Who are the oldest students?)
E13. Who takes every course?
```





### Let's start with question `E1`: Who takes CS112?

```sql
--- E1 - Who takes CS112?
SELECT Sno
FROM Take
WHERE Cno = 'CS112'

-- NOTE: 'CS112' is a text string. So it is enclosed in SINGLE QUOTES.
-- Please use SINGLE QUOTES when you are writing SQL queries.
```


```sql
--- Answer E2
SELECT Student.Sno, Student.Sname FROM Student, Take
WHERE (Student.Sno = Take.Sno)
AND (Take.Cno = "CS112")
```
```sql
SELECT DISTINCT Sno
FROM Take
WHERE (Cno = "CS112") OR (Cno = "CS114")
-- Answer E3 - Who takes CS112 or CS114?
```
```sql
SELECT DISTINCT Sno
FROM Take
WHERE (Cno IN ("CS112", "CS114"))
-- Answer E3 - Who takes CS112 or CS114?
```

```sql
--- this is wrong Who takes both CS112 and CS114?
SELECT Sno
FROM Take
WHERE (Cno = 'CS112')
AND (Cno = 'CS114')

```

```sql
SELECT X.Sno
FROM Take X, Take WHERE (X.Sno = Take.Sno)
AND (X.Cno = "CS112") AND (Take.Cno = "CS114")

-- E4 - Who takes both C5112 and CS114?
```

### Before proceeding further, we want to make several com­ ments regarding the use of aliases. First, the choice of alias names is completely arbitrary as long as they do not conflict with each other or with any real table name used in a query.

### Second, aliases are opaque- a technical term meaning that an alias completely covers and hides the name of the under­ lying table. Thus, from the point of view of the SELECT and WHERE clauses, the query of Figure 6.4 involves two tables: one named X and the other named Take.
    
### Third, it is always permitted to alias tables, even if not really necessary. Indeed, to save on typing, SQL program­ mers often use short aliases for long, meaningful table names given to them by well-meaning database designers. 

### Finally, we note that aliases are an essential feature of SQL. Without them, standard questions involving the both-and construct and self-joins could not have been asked as Type 1 queries.

```sql
--- Who takes a course which is not CS112?

SELECT Sno
FROM Take
WHERE (Cno != 'CS112')
```

```sql
SELECT X.Sno
FROM Take X, Take WHERE (X.Sno = Take.Sno)
AND (X.Cno != Take.Cno)

-- E7 - Who takes at least 2 courses? 
```
```sql
SELECT X.Sno
FROM Take X, Take Y, Take WHERE (X.Sno = Y.Sno)
AND (Y.Sno = Take.Sno)
AND (X.Cno != Y.Cno)
AND (Y.Cno != Take.Cno) AND (X.Cno != Take.Cno)

-- Who takes at least 3 courses?
```

### A sample Type 2 query is shown below

### We begin the discussion by first explaining its syntax, then introduc­ ing the Type 2 evaluation mechanism, and finally tracing this query to determine the question it poses.

```sql
SELECT Sno, Sname FROM Student 
WHERE Sno IN
    (SELECT Sno
    FROM Take
    WHERE Cno = 'CS112')
-- A sample Type 2 SQL query.
```
### Syntactically, a Type 2 SQL query is a collection of several non-correlated component queries, with some of them nested in the WHERE clauses of the others. (The meaning of the term "non-correlated"will be explained in a moment.)

### Theoretically, there is no limit on the number of nesting lev­els or on the number of component queries involved. On a practical level, however, SQL compilers do impose some limitations in this regard (e.g., no more than 16 nesting lev­ els or 256 component queries), but these rarely present any real problems.

### In the above example, we have two component queries. The inner query (called the subquery) is nested in the WHERE clause of the outer query (called the main query), and the queries are connected by the list-membership operator `IN`. 

### A query is called non-correlated if all column references in it are local- i.e., all columns come from, or are bound to, the tables in the local FROM clause. Any non-local column ref­ erence is called a correlation, and the query containing it becomes correlated.

### In determining these column-to-table bindings, SQL follows the standard "inside-out, try the local scope first" scope rules. Specifically, given a column reference, SQL first tries to find some table in the local FROM clause containing that column. If the column reference also involves a prefix­ either a table name or an alias- then SQL also looks for the match on that prefix. Three alternative outcomes are then possible.

1. SQL finds a single such table and successfully binds that column reference to that table.
2. SQL finds several such tables. Then column reference
is ambiguous and the appropriate error message is generated.
3. SQL does not find any such table in the local FROM
clause. Then column reference is not local. SQL then looks at the next outer scope- i.e., at the FROM clause in the immediately enclosing query, and attempts to bind that column reference to a table in that FROM clause.

### This process continues (using the same three possibilities) until either a column reference is successfully bound, or an ambiguity is found, or the binding process "falls off" the main query, in which case the column reference cannot be bound at all, and the appropriate error is declared.

### Given this process and the query of Figure 10.1, columns Sno and Cno in its subquery are bound to the inner Take table, and columns Sno and Sname in its main query are bound to the outer Student table, thus making all bindings local, the component queries non-correlated, and this entire query of Type 2.

### The formal syntactic condition for a multi-level (i.e., with subqueries) query to be of 'Type 2 is presented in Figure 10.2.

### A query with subqueries is of Type 2 if every component query in it is non-correlated or, equivalently, if every column reference in it is local.

The evaluation mechanism for Type 2 queries is presented below:

## To execute a Type 2 query, execute its component queries in the "inside-out" order- i.e., with the inner-most nested subquery first, replacing each query by its result as it gets evaluated.

In case of the query above, ie

```sql
SELECT Sno, Sname FROM Student 
WHERE Sno IN
    (SELECT Sno
    FROM Take
    WHERE Cno = 'CS112')
```

The subquery is
```sql
SELECT Sno FROM Take WHERE (Cno = "CS112")
```
### This is a regular Type 1 query, is executed first. Its answer is then substituted into its place in the main query, which is executed next.

```sql
SELECT Sno, Sname FROM Student WHERE (Sno IN( ...))
```
### Note that, at this point, the main query has been reduced to a simple Type 1 query. Also note that, since the subquery retrieves a single column in its SELECT clause, the answer to it is just a list of values. Thus, the use of the list membership operator IN as the inter­ query connector is quite appropriate.

### We note that Type 2 queries fundamentally involve multiple data passes - one for each component query. In this case, the first pass is through table Take in the subquery, and the second pass is through table Student in the main query.

Finally, returning once more to the entire query, what question does it answer?

```sql
SELECT Sno, Sname FROM Student 
WHERE Sno IN
    (SELECT Sno
    FROM Take
    WHERE Cno = 'CS112')
```
### Answer: What are the student numbers and names of students who take CS112?

### Using Type 2 to Implement Real Negation
### Questions involving real negation need two passes through the data, using the fol­lowing general strategy:

To pose a question `"Who does not do X?"`
1. identify and select those who actually do X; and
2. remove them from the list of those who potentially maydoX.

### Since Type 2 queries fundamentally involve multiple data passes, they give us exactly what is necessary to implement real negation in SQL. Consider the query below.

```sql
SELECT Sno
FROM Student WHERE NOT (Sno IN
(SELECT Sno
FROM Take
WHERE (Cno = "CS112")))
```

### But how is this query evaluated, and what question does it pose?

### Since this is a Type 2 query, it is evaluated inside-out. Again, the subquery is the same as query Ql and poses question El- Who takes CS112? Because of the NOT opera­ tor in its WHERE clause, the main query now retrieves the student numbers of all other students- i.e., those student numbers that are not on the list generated by the subquery. Thus, the full query corresponds to the ques­tion `Who does not take CS112?`- i.e., our standard question E5.

Using the solution to question E5 as a foundation, it is now quite easy to generate solutions to questions E5 through
E11. Specifically, question E5- Who takes at most 2 courses?-is posed by query QB of Figure 12.1.

```sql
-- Question E5 Who takes at most 2courses?
SELECT Sno
FROM Student
WHERE NOT (Sno IN
(SELECT X.Sno
FROM Take X, Take Y,Take
WHERE (X.Sno = Y.Sno)
AND (Y.Sno = Take.Sno)
AND  (X.Cno != Y.Cno)
AND (Y.Cno != Take.Cno) AND (X.Cno I= Take.Cno)))
```

### This query is based on rephrasing question ES as Who does not take at least 3 courses? The subquery here poses the ques­tion `Who takes at least 3 courses?` The NOT in the main WHERE clause achieves the desired negation.

### We note that this query will retrieve students who do not take any courses. This is appropriate, since "at most 2" means O (!), 1 or 2.


### By using Take instead of Student in the main FROM clause we can change this query to ask a related question `Who  takes some (i.e., at least 1), but at most 2, courses? In other words, Who takes 1 or 2 courses?`

```sql
-- Question E9- Who takes exactly 2 courses?

SELECT X.Sno
FROM Take X, Take WHERE (X.Sno = Take.Sno)
AND (X.Cno < Take.Cno)
AND NOT (X.Sno IN
(SELECT X.Sno
FROM Take X, Take Y, Take WHERE (X.Sno = Y.Sno)
AND (Y.Sno = Take.Sno) AND (X.Cno < Y.Cno)
AND (Y.Cno < Take.Cno)))
```

### This query is based on rephrasing question E9 as Who takes at least 2 courses and does not take at least 3 courses? The main query poses Who takes at least 2 courses? and is copied from query Q7. 0/ve have used the less-than operator in its condi­ tion to remove duplicates from the final answer. The sub­ query again poses Who takes at least 3 courses? (Here, we have used less-than operators for conciseness.) The NOT in the main WHERE clause again achieves the desired negation.

### We note that even though we have used the same alias name X in both the main query and in the subquery, because of the scope rules, no confusion arises.