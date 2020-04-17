drop table if exists student;
create table student (
  id integer,
	name varchar(10),
	age integer
);

-- Replaces courses in original schema
drop table if exists course;
create table course (
	id varchar(5),
	name varchar(10),
	credits integer
);

drop table if exists professor;
create table professor (
	name varchar(10),
	department varchar(10),
	salary integer,
	age integer
);

-- replaces Take in original schema
drop table if exists schedule;
create table schedule (
	student_id integer,
	course_id varchar(5)
);

drop table if exists teach;
create table teach (
	professor_name varchar(10),
	course_id varchar(5)
);
-- Changes Gillian's age to 18
insert into student values (1, 'LISA', 20);
insert into student values (2, 'CHUCK', 21);
insert into student values (3, 'CHLOE', 20);
insert into student values (4, 'MAGGIE', 19);
insert into student values (5, 'STEVE', 22);
insert into student values (6, 'IAN', 18);
insert into student values (7, 'BRIAN', 21);
insert into student values (8, 'KAY', 20);
insert into student values (9, 'GILLIAN', 18);
insert into student values (10, 'BOB', 21);

insert into course values ('CL101', 'PHYSICS', 4);
insert into course values ('CL105', 'CALCULUS', 4);
insert into course values ('CL109', 'HISTORY', 4);

insert into professor values ('CHOI', 'SCIENCE', 40000, 45);
insert into professor values ('GUNN', 'HISTORY', 30000, 60);
insert into professor values ('MAYER', 'MATH', 40000, 55);
insert into professor values ('POMEL', 'SCIENCE', 50000, 65);
insert into professor values ('FEUER', 'MATH', 40000, 40);

insert into schedule values (1, 'CL101');
insert into schedule values (1, 'CL105');
insert into schedule values (1, 'CL109');
insert into schedule values (2, 'CL101');
insert into schedule values (3, 'CL101');
insert into schedule values (3, 'CL109');
insert into schedule values (4, 'CL101');
insert into schedule values (4, 'CL105');
insert into schedule values (5, 'CL105');
insert into schedule values (6, 'CL105');
insert into schedule values (6, 'CL109');

insert into teach values ('CHOI', 'CL101');
insert into teach values ('CHOI', 'CL101');
insert into teach values ('CHOI', 'CL101');
insert into teach values ('POMEL', 'CL105');
insert into teach values ('MAYER', 'CL101');
insert into teach values ('MAYER', 'CL109');