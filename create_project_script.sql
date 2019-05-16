-- MySQL Workbench Synchronization
-- Generated: 2019-05-16 15:31
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: POA.17

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `mus` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `mus`.`Musicians` (
  `idMusician` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `MiddleName` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idMusician`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Albums` (
  `idAlbum` INT(11) NOT NULL AUTO_INCREMENT,
  `Date` DATE NULL DEFAULT NULL,
  `Compositions_idComposition` INT(11) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Description` LONGTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idAlbum`),
  INDEX `fk_Albums_Compositions1_idx` (`Compositions_idComposition` ASC) VISIBLE,
  CONSTRAINT `fk_Albums_Compositions1`
    FOREIGN KEY (`Compositions_idComposition`)
    REFERENCES `mus`.`Compositions` (`idComposition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Traks` (
  `idTrak` INT(11) NOT NULL,
  `Name` INT(11) NOT NULL,
  `During` INT(11) NOT NULL,
  `href` LONGTEXT NOT NULL,
  `Groups_idGroup` INT(11) NOT NULL,
  `Date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idTrak`),
  INDEX `fk_Traks_Groups1_idx` (`Groups_idGroup` ASC) VISIBLE,
  CONSTRAINT `fk_Traks_Groups1`
    FOREIGN KEY (`Groups_idGroup`)
    REFERENCES `mus`.`Groups` (`idGroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Groups` (
  `idGroup` INT(11) NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Founded` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idGroup`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Compositions` (
  `idComposition` INT(11) NOT NULL AUTO_INCREMENT,
  `Ncomp` INT(11) NOT NULL,
  `Groups_idGroup` INT(11) NOT NULL,
  `Labels_idLabels` INT(11) NOT NULL,
  PRIMARY KEY (`idComposition`),
  INDEX `fk_Compositions_Groups1_idx` (`Groups_idGroup` ASC) VISIBLE,
  INDEX `fk_Compositions_Labels1_idx` (`Labels_idLabels` ASC) VISIBLE,
  CONSTRAINT `fk_Compositions_Groups1`
    FOREIGN KEY (`Groups_idGroup`)
    REFERENCES `mus`.`Groups` (`idGroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Compositions_Labels1`
    FOREIGN KEY (`Labels_idLabels`)
    REFERENCES `mus`.`Labels` (`idLabels`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Albums_Traks` (
  `idAlbums_Traks` INT(11) NOT NULL,
  `Albums_idAlbum` INT(11) NOT NULL,
  PRIMARY KEY (`idAlbums_Traks`),
  INDEX `fk_Albums_Traks_Albums1_idx` (`Albums_idAlbum` ASC) VISIBLE,
  CONSTRAINT `fk_Albums_Traks_Albums1`
    FOREIGN KEY (`Albums_idAlbum`)
    REFERENCES `mus`.`Albums` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Compositions_Musitians` (
  `idCompositions_Musitians` INT(11) NOT NULL,
  `Compositions_idComposition` INT(11) NOT NULL,
  `Musicians_idMusician` INT(11) NOT NULL,
  `role` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idCompositions_Musitians`),
  INDEX `fk_Compositions_Musitians_Compositions1_idx` (`Compositions_idComposition` ASC) VISIBLE,
  INDEX `fk_Compositions_Musitians_Musicians1_idx` (`Musicians_idMusician` ASC) VISIBLE,
  CONSTRAINT `fk_Compositions_Musitians_Compositions1`
    FOREIGN KEY (`Compositions_idComposition`)
    REFERENCES `mus`.`Compositions` (`idComposition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Compositions_Musitians_Musicians1`
    FOREIGN KEY (`Musicians_idMusician`)
    REFERENCES `mus`.`Musicians` (`idMusician`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `mus`.`Labels` (
  `idLabels` INT(11) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idLabels`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


DELIMITER $$

USE `mus`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Album_AFTER_INSERT` AFTER INSERT ON `Album` FOR EACH ROW
BEGIN
IF(`Date`>=now()) then
 Set `Date` =now();
end if;	
END$$

USE `mus`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Traks_AFTER_INSERT` AFTER INSERT ON `Traks` FOR EACH ROW
BEGIN
IF(During>=60) then
 Set During = 60;
end if;	
IF(`Date`>=now()) then
 Set `Date` =now();
end if;	
END$$


DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
