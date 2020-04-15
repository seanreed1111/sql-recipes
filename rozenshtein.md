```sql

SELECT Sno
FROM Take
WHERE (Cno = "CS112")

--- E1 - Who takes CS112?
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
--- wrong E4
SELECT Sno
FROM Take
WHERE (Cno = "CS112")
AND (Cno = "CS114")
-- First incorrect attempt at question E4 - Who takes both CS112 and CS114?
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
```

