drop table if exists student;
create table student (
  id integer,
	name text,
	age integer
);


drop table if exists course;
create table course (
	id text,
	name text,
	credits integer
);

drop table if exists professor;
create table professor (
	name text,
	department text,
	salary integer,
	age integer
);


drop table if exists schedule;
create table schedule (
	student_id integer,
	course_id text
);

drop table if exists teach;
create table teach (
	professor_name varchar(10),
	course_id varchar(5)
);

insert into student values
(1, 'LISA', 20),
(2, 'CHUCK', 21),
(3, 'CHLOE', 20),
(4, 'MAGGIE', 19),
(5, 'STEVE', 22),
(6, 'IAN', 18),
(7, 'BRIAN', 21),
(8, 'KAY', 20),
(9, 'GILLIAN', 18),
(10, 'BOB', 21);

insert into course values
('CL101', 'PHYSICS', 4),
('CL105', 'CALCULUS', 4),
('CL109', 'HISTORY', 4);

insert into professor values
('CHOI', 'SCIENCE', 40000, 45),
('GUNN', 'HISTORY', 30000, 60),
('MAYER', 'MATH', 40000, 55),
('POMEL', 'SCIENCE', 50000, 65),
('FEUER', 'MATH', 40000, 40);

insert into schedule (student_id, course_id) values
(1, 'CL101'),
(1, 'CL105'),
(1, 'CL109'),
(2, 'CL101'),
(3, 'CL101'),
(3, 'CL109'),
(4, 'CL101'),
(4, 'CL105'),
(5, 'CL105'),
(6, 'CL105'),
(6, 'CL109');

insert into teach values
('CHOI', 'CL101'),
('CHOI', 'CL101'),
('CHOI', 'CL101'),
('POMEL', 'CL105'),
('MAYER', 'CL101'),
('MAYER', 'CL109');