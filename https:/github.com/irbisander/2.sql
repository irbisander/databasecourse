/*1*/
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
where N_Group = 2253;

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
Order by s.n_group asc;

/*7*/
Select s.*
From students s
Order by s.n_group desc, s.surname asc;

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
SELECT s.N_GROUP, COUNT(s.N_GROUP)
FROM students s
GROUP BY s.N_GROUP
ORDER BY s.N_GROUP desc;

/*2. Выведите на экран для каждой группы максимальный средний балл*/
SELECT s.N_GROUP, max(s.score)
FROM students s
GROUP BY s.N_GROUP;

/*3. Подсчитать количество студентов с каждой фамилией*/
SELECT s.surname, Count(s.surname)
FROM students s
GROUP BY s.surname;

/*5. Для студентов каждого курса подсчитать средний балл*/
SELECT substr(s.n_group, 1, 1), avg(s.score) 
FROM students s
GROUP BY substr(s.n_group, 1, 1);

/*6. Для студентов заданного курса вывести один номер групп с максимальным средним баллом*/
SELECT s.N_GROUP, avg(s.score)
FROM students s
where substr(s.n_group, 1, 1) like '2'
GROUP BY s.n_group
Having max(s.score) -- тут точно ниче не забыл?
order by s.score desc
limit 1;

/*7. Для каждой группы подсчитать средний балл, 
вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5.
Отсортировать по от меньшего среднего балла к большему.*/
SELECT s.N_GROUP, avg(s.score)
FROM students s
GROUP BY s.N_GROUP
HAVING avg(s.score) <= 3.5
Order by avg(s.score) asc;

/*8. Вывести 3 хобби с максимальным риском*/
SELECT h.*
FROM hobbies h
ORDER BY h.risk desc
Limit 3;

/*9. Для каждой группы в одном запросе вывести количество студентов, 
максимальный балл в группе, средний балл в группе, минимальный балл в группе*/
SELECT s.N_GROUP, count(s.N_GROUP), max(s.score), avg(s.score), min(s.score)
FROM students s
GROUP BY s.N_GROUP;

/*10. Вывести студента/ов, который/ые имеют наибольший балл в заданной группе*/
SELECT s.surname, max(s.score), s.N_GROUP
FROM students s
Where s.n_group = 2253
GROUP BY s.N_GROUP
/*если текущая оценка не является максимальной в группе, кикаем этого студента.
таким образом, останутся только те, чей балл в группе максимальный.
например Петров с 5.0 и Сидоров с 5.0*/
Having max(s.score);

/*11. Аналогично 10 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом.*/
select s.*
from
(SELECT 
	s1.N_GROUP, max(s1.score) ms
FROM students s1
GROUP BY s1.N_GROUP) t, students s
Where s.N_GROUP = t.N_GROUP AND ms = s.SCORE;

/*Многотабличные запросы*/
/*1. Вывести все имена и фамилии студентов, и название хобби, которым занимается этот студент.*/
select *
from students, students_hobbies
where students.N_Z = students_hobbies.N_Z;

select s.*, sh.n_z as test
from students
inner join students_hobbies on students.N_Z = students_hobbies.N_Z;

/*Выведет и тех студентов, у которых нет никаких хобби. 
Правое вхождение будет эквивалентно обычному внутреннему, так как присутствует внешний ключ*/
select *
from students
left join students_hobbies on students.N_Z = students_hobbies.N_Z;

/*аналог full outer из oracle*/
SELECT * FROM students
LEFT JOIN students_hobbies ON students.N_Z = students_hobbies.N_Z
UNION
SELECT * FROM students
RIGHT JOIN students_hobbies ON students.N_Z = students_hobbies.N_Z;

/*2. Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
SELECT s.*,
       sh.n_z AS test
FROM students s
INNER JOIN
  ( SELECT sh.N_Z,
           max(CASE
                   WHEN sh.DATE_FINISH IS NULL THEN curdate() - sh.DATE_FINISH
                   ELSE sh.DATE_FINISH - sh.DATE_START
               END) AS MaxDays
   FROM students_hobbies sh) t ON students.N_Z = t.N_Z;

SELECT s.NAME,
       s.surname,
       (CASE
            WHEN sh.date_finish IS NULL THEN Datediff(Now(), sh.date_start)
            ELSE Datediff(sh.date_finish, sh.date_start)
        END) AS md
FROM students s
INNER JOIN students_hobbies sh ON s.n_z = sh.n_z
WHERE md =
    (SELECT Max(CASE
                    WHEN sh.date_finish IS NULL THEN Datediff(Now(), sh.date_start)
                    ELSE Datediff(sh.date_finish, sh.date_start)
                END)
     FROM students_hobbies sh);

Select S.*,
case
	when sh.DATE_FINISH IS NULL then Datediff(Now(), sh.date_start)
	else Datediff(sh.date_finish, sh.date_start)
end as Date_Finish
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
ORDER BY Date_Finish desc
Limit 1;

/*3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, 
средний балл которых выше среднего, 
а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.*/
Select s.`Name`,s.Surname,s.`N_Z`,s.`Birth Date` from s
WHERE (s.Score>=(select avg(score) from s)) and (select sum(risk) from h,s_h where (s.`N_Z`=s_h.`N_Z` and s_h.id_hobby=h.id) and (current_date()<=s_h.`date_finish` or s_h.`date_finish`=null))>0.9 
;
/*4. Вывести фамилию, имя, зачетку, дату рождения, 
название хобби и длительность в месяцах, для всех завершенных хобби.*/
Select s.`Name`,s.Surname,s.`N_Z`,s.`Birth Date`, h.`name`,TIMESTAMPDIFF(month, s_h.`date_start`, s_h.`date_finish`) as month_count
from (s,h,s_h) 
Where s_h.`date_finish`<=current_date() and s.`N_Z`=s_h.`N_Z` and s_h.id_hobby=h.id

/*5. Вывести фамилию, имя, зачетку, дату рождения студентов, 
которым исполнилось N полных лет на текущую дату, и которые имеют более 1 действующего хобби.*/ 
Select s.`Name`,s.Surname,s.`N_Z`,s.`Birth Date`
from s
Where  
(
(
	select count(*) as cnt 
	from s_h
	where  (s_h.`date_finish`>=curdate() or s_h.`date_finish` is null) and s.`N_Z`=s_h.`N_Z`
	group by s_h.`N_Z`
	HAVING cnt>1
    )
    and
    (
    TIMESTAMPDIFF(year, s.`Birth Date`, Now()) LIKE '18'
    )
)

/*6. Найти средний балл в каждой группе, учитывая только баллы студентов, 
которые имеют хотя бы одно действующее хобби.*/ 
Select AVG(SCORE)
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
where SH.DATE_FINISH is NULL
GROUP by N_GROUP;

/*7. Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих,
указав номер зачетки студента и номер его группы.*/ 


/*8. Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where S.SCORE = (Select MAX(SCORE) From STUDENTS)
ORDER by S.SCORE desc;

/*9. Найти все действующие хобби, которыми увлекаются троечники 2-го курса.*/ 
Select S.NAME, S.SURNAME, H.NAME as Hobbie, S.SCORE, S.N_GROUP
From STUDENTS S
INNER JOIN STUDENTS_HOBBIES SH on S.N_Z = SH.N_Z
INNER JOIN HOBBIES H on H.ID = SH.HOBBY_ID
where S.SCORE LIKE '3%' and substr(S.N_GROUP,1,1) LIKE '2' and SH.DATE_FINISH is null;

/*10. Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.*/ 

/*11. Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.*/
Select *
From (Select N_GROUP, COUNT(SCORE) as avg_count From STUDENTS Group by N_GROUP) t1
INNER JOIN (Select N_GROUP, COUNT(SCORE) as inner_count From STUDENTS Where SCORE >= 4 
Group by N_GROUP) t2 on t2.N_GROUP = t1.N_GROUP
where inner_count/avg_count >= 0.6;
