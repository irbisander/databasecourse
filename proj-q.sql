--1,2
INSERT INTO `mus`.`Groups` (`Name`, `Founded`) VALUES ('Sabanda', '10.12.16');

INSERT INTO `mus`.`Traks` (`Name`, `During`, `href`, `Groups_idGroup`, `Date`) VALUES ('Love', '30', 'vk.com', '1', '10.12.2012');

INSERT INTO `mus`.`Compositions` (`Groups_idGroup`) VALUES ('1');

INSERT INTO `mus`.`Musicians` (`Name`, `MiddleName`) VALUES ('Alex', 'Petrov');

INSERT INTO `mus`.`Compositions_Musitians` (`Compositions_idComposition`, `Musicians_idMusician`, `role`) VALUES ('1', '1', 'guitar');

INSERT INTO `mus`.`Albums` (`Date`, `Compositions_idComposition`, `Name`, `Description`) VALUES ('12.12.18', '1', 'Bang', 'Thats a good music');

INSERT INTO `mus`.`Albums_Traks` (`Albums_idAlbum`, `idTrak`) VALUES ('1', '1');

INSERT INTO `mus`.`Labels` (`idLabels`, `Name`) VALUES (NULL, 'Hey');

--3
SELECT * FROM mus.Groups
where (idGroup=1)
;

SELECT * FROM mus.Traks
where (idTrak=1)
;

SELECT * FROM mus.Compositions
where (idComposition=1)
;

SELECT * FROM mus.Compositions_Musitians
where (idCompositions_Musitians=1)
;

SELECT * FROM mus.Albums
where (idAlbum=1)
;

SELECT * FROM mus.Albums_Traks
where (idAlbums_Traks=1)
;

SELECT * FROM mus.Labels
where (idLabels=1)
;

--4

UPDATE `mus`.`Albums` SET `Date` = '2012-12-16', `Name` = 'Ban', `Description` = 'Thats a bad music' WHERE (`idAlbum` = '1');

UPDATE `mus`.`Albums_Traks` SET `Albums_idAlbum` = '2', `idTrak` = '2' WHERE (`idAlbums_Traks` = '1');

UPDATE `mus`.`Compositions` SET `Groups_idGroup` = '2', `Labels_idLabels` = '1' WHERE (`idComposition` = '1');

UPDATE `mus`.`Compositions_Musitians` SET `Compositions_idComposition` = '2', `Musicians_idMusician` = '2', `role` = 'drum' WHERE (`idCompositions_Musitians` = '1');

UPDATE `mus`.`Groups` SET `Name` = 'Aeros', `Founded` = '2014-10-19' WHERE (`idGroup` = '1');

UPDATE `mus`.`Labels` SET `Name` = 'Nope' WHERE (`idLabels` = '1');

UPDATE `mus`.`Musicians` SET `Name` = 'Alla', `MiddleName` = 'Petrova' WHERE (`idMusician` = '1');

UPDATE `mus`.`Traks` SET `Name` = 'Lover', `During` = '35', `href` = 'facebook.com', `Groups_idGroup` = '2', `Date` = '2012-10-11' WHERE (`idTrak` = '1');

--5

DELETE FROM `mus`.`Albums` WHERE (`idAlbum` = '1');
DELETE FROM `mus`.`Albums_Traks` WHERE (`idAlbums_Traks` = '1');
DELETE FROM `mus`.`Compositions` WHERE (`idComposition` = '1');
DELETE FROM `mus`.`Compositions_Musitians` WHERE (`idCompositions_Musitians` = '1');
DELETE FROM `mus`.`Groups` WHERE (`idGroup` = '1');
DELETE FROM `mus`.`Labels` WHERE (`idLabels` = '1');
DELETE FROM `mus`.`Musicians` WHERE (`idMusician` = '1');
DELETE FROM `mus`.`Traks` WHERE (`idTrak` = '1');

--6
SELECT Groups.Name,count(*) as count
FROM mus.Groups
inner Join mus.Compositions 
On  Groups.idGroup = Compositions.`Groups_idGroup`
Group by Groups.idGroup
Order by count DESC
limit 1
;

--7
SELECT 
    Groups.Name, t1.Name
FROM
    Groups
        INNER JOIN
    (SELECT 
        *
    FROM
        Compositions
    INNER JOIN Albums ON Compositions.idComposition = Album.Compositions_idComposition) AS t1 ON Groups.idGroup = t1.Groups_idGroup
WHERE
    t1.Genre = (SELECT 
            Genre AS g
        FROM
            Album AS a
        GROUP BY g
        ORDER BY COUNT(*)
        LIMIT 1)

;
--8
SELECT Musicians.idMusician as id,Musicians.Name,count(*) as c from mus.Musicians 
inner join mus.Compositions_Musitians
on mus.Musicians.idMusician=mus.Compositions_Musitians.Musicians_idMusician
left join mus.Compositions
on mus.Compositions_Musitians.Compositions_idComposition=mus.Compositions.idComposition
left join mus.Groups
on mus.Compositions.Groups_idGroup=mus.Groups.idGroup
Group by id
having c>1
;

--9
Select distinct t1.Genre,name1.Name,name2.Name,name3.Name
From mus.Traks as t1
left join (SELECT t2.Name,t2.Genre
    FROM   mus.Traks as t2
    Where t1.Genre=t2.Genre
    order by During ASC
    limit 1
    ) AS name1
on name1.Genre=t1.Genre
left join (SELECT t3.Name,t3.Genre
    FROM   mus.Traks as t3
    Where t1.Genre=t3.Genre
    order by During ASC
    limit 1,1
    ) AS name2
on name1.Genre=name2.Genre
left join   (
   SELECT t4.Name,t4.Genre
    FROM   mus.Traks as t4
    Where t1.Genre=t4.Genre
    order by During ASC
    limit 2,1
    ) AS name3
on name2.Genre=name3.Genre

;
--10
Select g.Name,count(*) as Count
from mus.Groups as g
left join mus.Compositions as c
on g.idGroup = c.Groups_idGroup 
left join mus.Albums as a
on c.idComposition = a.Compositions_idComposition
Where(year('1987-01-01')=year(a.Date))
Group by g.idGroup
;
--11.1
                              Вывести все треки выбранной группы, их продолжительность и альбомы, в которые они были внесены
Select t.Name,t.During,g.Name,a.Name
from mus.Groups as g
right join mus.Traks as t
on g.idGroup=t.Groups_idGroup
left join mus.Compositions as c
on c.Groups_idGroup=g.idGroup
left join mus.Albums as a
on a.Compositions_idComposition=c.idComposition
left join mus.Albums_Traks as a_t
on a_t.Albums_idAlbum=a.idAlbum
where g.Name like "%Saban%"

--11.2
                              /*вывести всех гитаристов исполняющих жанр*/
Select m.idMusician,m.Name
from mus.Musicians as m
right join mus.Compositions_Musitians as c_m
on m.idMusician=c_m.Musicians_idMusician
left join mus.Compositions as c
on c.idComposition=c_m.Compositions_idComposition
left join mus.Albums as a
on a.Compositions_idComposition=c.idComposition
where (c_m.role like "%guitar%") and (a.Genre like "Jazz")
