--1
Select s.name as Name, s.surname as Surname, s.gradesAvg as Grades
From students s
where s.gradesAvg >= 3 and s.gradesAvg <= 4;

Select s.name as Name, s.surname as Surname, s.gradesAvg as Grades
From students s
where not s.gradesAvg <= 2 and not s.gradesAvg >= 5;

Select s.name as Name, s.surname as Surname, s.gradesAvg as Grades
From students s
where s.gradesAvg between 3 and 4;

Select s.name as Name, s.surname as Surname, s.gradesAvg as Grades
From students s
where s.gradesAvg in (3, 4);

/*2*/
Select s.*
From students s
where group = 2253;

/*3*/
Select s.name as Name, s.surname as Surname, s.DATE_BIRTH as BirthDate
from students s
where s.date_birth >= '2000.01.01';

/*4*/
Select s.name as Name, s.surname as Surname, s.DATE_BIRTH as BirthDate
from students s
where month(s.date_birth) = 4;

/*5*/
Select s.name as Name, s.surname as Surname, s.DATE_BIRTH as BirthDate
from students s
where month(s.date_birth) = month(curdate());

/*6*/
Select s.*
From students s
Order by s.group asc;

/*7*/
Select s.*
From students s
Order by s.group desc, s.surname asc;

/*8*/
Select s.*
From students s
Where s.score >= 4
Order by s.score;

/*9*/
SELECT s.*
FROM students s
ORDER BY s.score desc
Limit 5;


/*10*/
SELECT s.surname, s.score,
 CASE
 WHEN s.score >= 4 THEN 'очень высокий'
 WHEN s.score >= 3 and s.score < 4 THEN 'высокий'
 WHEN s.score >= 2 and s.score < 3 THEN 'средний'
 WHEN s.score >= 1 and s.score < 2 THEN 'низкий'
 WHEN s.score < 0 THEN 'очень низкий'
 ELSE 'default'
END
FROM students s;

/*Групповые функции*/
/*1*/
SELECT s.group, COUNT(s.group)
FROM students s
GROUP BY s.group
ORDER BY s.group desc;

/*2*/
SELECT s.group, max(s.score)
FROM students s
GROUP BY s.group;

/*3*/
SELECT s.surname, Count(s.surname)
FROM students s
GROUP BY s.surname;

/*5*/
SELECT substr(s.group, 1, 1), avg(s.score) 
FROM students s
GROUP BY substr(s.group, 1, 1);

/*6.*/
SELECT s.group, avg(s.score)
FROM students s
where s.group = 2253
GROUP BY s.group
order by avg(s.score) desc
limit 1;

/*7.*/
SELECT s.group, avg(s.score)
FROM students s
GROUP BY s.group
HAVING avg(s.score) <= 3.5
Order by avg(s.score) asc;

/*8.*/
SELECT h.*
FROM hobbies h
ORDER BY h.risk desc
Limit 3;

/*9*/
SELECT s.group, count(s.group), max(s.score), avg(s.score), min(s.score)
FROM students s
GROUP BY s.group;

/*10*/
SELECT s.surname, max(s.score), s.group
FROM students s
Where s.group = 2253
GROUP BY s.group
Having max(s.score);

/*11*/
select s.*
from
(SELECT 
	s1.group, max(s1.score) ms
FROM students s1
GROUP BY s1.group) t, students s
Where s.group = t.group AND ms = s.SCORE;

/*Многотабличные запросы*/
/*1.*/

select s.*, s_h.n_z as test
from s
inner join s_h on s.N_Z = s_h.N_Z;

--2
Select S.*,
case
	when s_h.DATE_FINISH IS NULL then Datediff(Now(), s_h.date_start)
	else Datediff(s_h.DATE_FINISH, s_h.date_start)
end as DATE_FINISH
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
ORDER BY DATE_FINISH desc
Limit 1;

--3
SELECT S.NAME,
       S.SURNAME,
       S.N_Z,
       S.DATE_BIRTH,
       t1.risks
FROM STUDENTS S,
	(SELECT s_h.n_z, sum(h.risk) AS risks
   FROM students_hobbies s_h
   INNER JOIN hobbies h ON s_h.hobby_id = h.id
   GROUP BY s_h.n_z) AS t1
WHERE s.n_z = t1.n_z AND t1.risksum > 9 AND s.score>(select avg(score) from s);

--4
Select S.NAME, S.SURNAME, S.N_Z, H.NAME, TIMESTAMPDIFF(month, s_h.date_start, s_h.DATE_FINISH)
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
where s_h.DATE_FINISH IS NOT NULL;

/*5.*/
Select S.NAME, S.SURNAME, S.N_Z, S.DATE_BIRTH
From STUDENTS S 
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
where TIMESTAMPDIFF(year, s.DATE_BIRTH, Now()) LIKE '18' and s_h.DATE_FINISH is null
group by S.NAME, S.SURNAME, S.N_Z, S.DATE_BIRTH
having count(*) > 1;

/*6. */ 
Select group, AVG(SCORE)
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
where s_h.DATE_FINISH is NULL
GROUP by group;

/*7.*/
Select S.N_Z, S.group, H.NAME, H.RISK, Datediff(s_h.DATE_FINISH, s_h.date_start)
end as Amount
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
where s_h.DATE_FINISH IS not NULL
ORDER BY Amount desc

/*8.*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
where S.SCORE = (Select MAX(SCORE) From STUDENTS)
ORDER by S.SCORE desc;

/*9*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE, S.group
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
where S.SCORE LIKE '3%' and substr(S.group,1,1) LIKE '2' and s_h.DATE_FINISH is null;

/*10*/ 
select s_hActual.n_c 
from 
(select count(distinct s_h.n_z) as s_hobbiesCount , substr(S.group,1,1) as n_c 
from students_hobbies s_h, students s
where s_h.DATE_FINISH is null and s_h.date_start is not null and s.n_z=s_h.n_z 
group by substr(S.group,1,1)) s_hActual, 
(select count(*) as studentsCount, substr(S.group,1,1) as n_c 
from students s
group by substr(s.group,1,1)) s_hGeneral
where s_hActual.n_c=s_hGeneral.n_c and (s_hActual.s_hobbiesCount/s_hGeneral.studentsCount)>0.5;

/*11.*/
Select *
From (Select group, COUNT(SCORE) as avg_count From STUDENTS Group by group) t1
INNER JOIN (Select group, COUNT(SCORE) as inner_count From STUDENTS Where SCORE >= 4 
Group by group) t2 on t2.group = t1.group
where inner_count/avg_count >= 0.6;

/*12.*/
select Count(distinct s_h.hobby_id) as Count, substr(S.group,1,1) as Course
from students s
INNER JOIN STUDENTS_HOBBIES s_h ON S.N_Z = s_h.N_Z
group by substr(S.group,1,1);

/*13.*/
Select S.N_Z, S.SURNAME, S.NAME, S.DATE_BIRTH, substr(S.group,1,1)
From STUDENTS S
LEFT JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
where S.SCORE >= 4.5 and  s_h.date_start is null
order by substr(S.group,1,1) asc, s.score desc;

/*14.*/
CREATE VIEW v1 AS
SELECT S.*
FROM STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h ON S.N_Z = s_h.N_Z
WHERE s_h.DATE_FINISH IS NOT NULL AND TIMESTAMPDIFF(YEAR, s_h.date_start, s_h.DATE_FINISH) >= 5;

/*15.*/
Select Count(*), h.name
From hobbies h
inner join students_hobbies s_h on s_h.hobby_id = h.id
group by h.id;

/*16.*/
Select h.id
From hobbies h
inner join students_hobbies s_h on s_h.hobby_id = h.id
group by h.id
order by Count(*) desc
limit 1;

/*17.*/
select s.*
from students s,
(Select h.id as maxId
From hobbies h
inner join students_hobbies s_h on s_h.hobby_id = h.id
group by h.id
order by Count(*) desc
limit 1);

/*18*/
Select ID_H, H.RISK
From HOBBIES H 
where H.RISK = (Select MAX(H.RISK) From HOBBIES H)
ORDER by RISK desc 
Limit 3;

/*19.*/
Select distinct s.n_z
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on h.id = s_h.hobby_id
where DATE_FINISH IS NULL
ORDER by Datediff(s_h.DATE_FINISH, s_h.date_start) desc 
Limit 10;

/*20*/
Select distinct group
From (Select S.*
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID_H = s_h.ID_H
where DATE_FINISH IS NULL
ORDER by (sysdate - DATE_START) desc 
Limit 3);

/*21.*/
Create or replace VIEW V
as Select N_Z, NAME, SURNAME
From STUDENTS S
ORDER by SCORE desc;

/*22.*/--еще не сделал
Create or replace VIEW V
as Select tkl.COURS, hobbie
From (Select substr(S.group,1,1) as COURS From STUDENTS S where )tk1
LEFT JOIN (
	select substr(S1.group,1,1) as COURS_O, count(*) as hbs
	From STUDENTS S1
	INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
	INNER JOIN HOBBIES H on H.ID_H = s_h.ID_H

	)
	
/*23.*/

/*24. */
Create or replace VIEW V 
as Select tkl.COURS, tkl.NAME, N
From (Select substr(group,1,1) as COURS, COUNT(S.NAME) as NAME From STUDENTS S GROUP by substr(S.group,1,1))tkl
LEFT JOIN (Select substr(S1.group,1,1) as COURS_O, COUNT(S1.NAME) as N
From STUDENTS S1
where S1.SCORE >= 4
GROUP by substr(S1.group,1,1))
t1 on tkl.COURS = t1.COURS_O;

/*25.*/ 
CREATE OR REPLACE VIEW V AS 
Select s_h.ID_H
From  STUDENTS_HOBBIES s_h
Group by s_h.ID_H
having COUNT(N_Z) = (Select MAX(COUNT(N_Z)) From STUDENTS_HOBBIES s_h
Group by s_h.ID_H);

/*26*/
CREATE VIEW V AS 
Select *
From  STUDENTS S;

/*27.*/
Select substr(s.name,1,1) as literal, max(s.score), avg(s.score), min(s.score)
From students s 
Where s.score > 3.6
group by substr(s.name,1,1);

/*28.*/
Select substr(s.group,1,1), s.surname, max(s.score), min(s.score)
From students s
Group by substr(s.group,1,1), s.surname;

/*29.*/
Select date_format(s.date_birth, '%Y'), Count(*)
From STUDENTS S 
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
group by date_format(s.date_birth, '%Y');

/*30.*/
Select substr(s.name,1,1) as literal, max(h.risk), min(h.risk)
From students s 
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on H.ID = s_h.HOBBY_ID
group by substr(s.name,1,1);

/*31.*/
Select substr(s.date_birth,6,2) as month, s.score
From students s 
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z
INNER JOIN HOBBIES H on (H.ID = s_h.HOBBY_ID and H.NAME = 'Football')
group by substr(s.date_birth,6,2);

/*32.*/ 
Select 'Имя: '||NAME||' Фамилия: '||SURNAME||' Группа: '||group as INFORMATION
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES s_h on S.N_Z = s_h.N_Z;


/*33.*/
Select s.surname, case 
When s.surname like '%ов' then position('ов' in s.surname)
Else 'Not found.'
End 
From students s;

--не понял
/*34. */
select concat(s.surname,repeat('#',10-length(s.surname)))
from students s;
--аналогично
/*35.*/
select replace(t1.cstring,'#',''),
(select concat(s.surname,repeat('#',10-length(s.surname)) as cstring)
from students s) t1;

/*36.*/
select day(last_day('2018.04.01'));

/*37.*/
select date_add(now(), interval 7-dayofweek(now()) day);

/*38.*/
select cast(
substr(
date_format(now(),'%Y'),
1,2) 
as signed)+1, 
week(now()), 
dayofyear(now());

/*39. */
select s.*, s_h.n_z, 
case
When s_h.DATE_FINISH is null then 'Занимется'
else then 'Закончил'
end
from students s, students_hobbies s_h
where s.N_Z = s_h.N_Z;

/*40. */ 
--не знаю как сделать для n групп (без case)
/*
select s.score,s.group

group by  
*/
/*1.*/
delete
from students
where s.date_birth is null;

/*2.*/
update students
set date_birth = '1999-01-01'
where date_birth is null;

/*3.*/
delete
from students
where n_z = 21;

select h.name, Count(*)
from students_hobbies s_h, hobbies h
where s_h.hobby_id = h.id
group by s_h.hobby_id;


/*4.*/
update hobbies
set risk = risk - 1
where id = (
			select max(t1.hobby_counter), t1.id from (
			select Count(*) as hobby_counter, s_h.hobby_id as id
			from students_hobbies s_h
			group by s_h.hobby_id) as t1
			);

/*5.*/
update students2
set score = score + 0.01
where n_z = (select s_h.n_z from students2_hobbies where s_h.DATE_FINISH is null and s_h.date_start is not null);

/*6. */
DELETE
FROM hobbies
where ID = (select s_h.HOBBY_ID from students2_hobbies s_h where s_h.DATE_FINISH is not null);

/*7.*/
update students2_hobbies
set date_start = '2009-11-15', DATE_FINISH = null
where students2_hobbies.n_z = 4 and students2_hobbies.hobby_id = 5;

/*8*/
--самую раннюю или все самые ранние?

/*9.*/
update students2_hobbies
set hobby_id = 7
where hobby_id = 1;

update students2_hobbies
set hobby_id = 5
where hobby_id = 3;

/*10"*/
INSERT INTO hobbies (id,risk, name) VALUES (/*Как добавить, если стоит автоматическое увеличение?*/,0.1,'Studying');
