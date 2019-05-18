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