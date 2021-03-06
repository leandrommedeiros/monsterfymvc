-- MySQL Script generated by MySQL Workbench
-- Sun Feb  7 19:11:41 2016
-- Model: Relationships    Version: 2.1
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema cortex
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `cortex` ;

-- -----------------------------------------------------
-- Schema cortex
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cortex` DEFAULT CHARACTER SET utf8 ;
USE `cortex` ;

-- -----------------------------------------------------
-- Table `cortex`.`groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`groups` ;

CREATE TABLE IF NOT EXISTS `cortex`.`groups` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cortex`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`user` ;

CREATE TABLE IF NOT EXISTS `cortex`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `corporation_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `email` VARCHAR(100) NOT NULL,
  `password` CHAR(32) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_group`
    FOREIGN KEY (`group_id`)
    REFERENCES `cortex`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `cortex`.`user` (`email` ASC);

CREATE INDEX `fk_user_group_idx` ON `cortex`.`user` (`group_id` ASC);


-- -----------------------------------------------------
-- Table `cortex`.`module`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`module` ;

CREATE TABLE IF NOT EXISTS `cortex`.`module` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `title` VARCHAR(100) NOT NULL,
  `name` VARCHAR(45) NOT NULL DEFAULT 'module',
  `menu_order` INT UNSIGNED NOT NULL,
  `icon` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_UNIQUE` ON `cortex`.`module` (`name` ASC);


-- -----------------------------------------------------
-- Table `cortex`.`group_module`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`group_module` ;

CREATE TABLE IF NOT EXISTS `cortex`.`group_module` (
  `module_id` INT UNSIGNED NOT NULL,
  `group_id` INT NOT NULL,
  `favorite` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`module_id`, `group_id`),
  CONSTRAINT `fk_group_module_module`
    FOREIGN KEY (`module_id`)
    REFERENCES `cortex`.`module` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_module_group`
    FOREIGN KEY (`group_id`)
    REFERENCES `cortex`.`groups` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_group_module_module_idx` ON `cortex`.`group_module` (`module_id` ASC);

CREATE INDEX `fk_group_module_group_idx` ON `cortex`.`group_module` (`group_id` ASC);


-- -----------------------------------------------------
-- Table `cortex`.`action`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`action` ;

CREATE TABLE IF NOT EXISTS `cortex`.`action` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `module_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `action` VARCHAR(45) NOT NULL,
  `menu_order` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_action_module`
    FOREIGN KEY (`module_id`)
    REFERENCES `cortex`.`module` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_action_module_idx` ON `cortex`.`action` (`module_id` ASC);


-- -----------------------------------------------------
-- Table `cortex`.`user_action`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cortex`.`user_action` ;

CREATE TABLE IF NOT EXISTS `cortex`.`user_action` (
  `user_id` INT UNSIGNED NOT NULL,
  `action_id` INT UNSIGNED NOT NULL,
  CONSTRAINT `fk_user_action_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `cortex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_action_action`
    FOREIGN KEY (`action_id`)
    REFERENCES `cortex`.`action` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_user_action_user_idx` ON `cortex`.`user_action` (`user_id` ASC);

CREATE INDEX `fk_user_action_action_idx` ON `cortex`.`user_action` (`action_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `cortex`.`groups`
-- -----------------------------------------------------
START TRANSACTION;
USE `cortex`;
INSERT INTO `cortex`.`groups` (`id`, `name`, `description`) VALUES (1, 'Cortex - Administradores', 'Grupo de usuários de manutenção');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cortex`.`user`
-- -----------------------------------------------------
START TRANSACTION;
USE `cortex`;
INSERT INTO `cortex`.`user` (`id`, `corporation_id`, `group_id`, `active`, `email`, `password`, `name`) VALUES (1, 1, 1, 1, 'admin@cortex.com.br', 'a946ae1df51a10613a6e5624d1daa82c', 'Administrador');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cortex`.`module`
-- -----------------------------------------------------
START TRANSACTION;
USE `cortex`;
INSERT INTO `cortex`.`module` (`id`, `active`, `title`, `name`, `menu_order`, `icon`) VALUES (1, 0, 'Cortex Setup', 'system', 0, ' ');
INSERT INTO `cortex`.`module` (`id`, `active`, `title`, `name`, `menu_order`, `icon`) VALUES (2, 0, 'Dashboard', 'dashboard', 1, ' ');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cortex`.`group_module`
-- -----------------------------------------------------
START TRANSACTION;
USE `cortex`;
INSERT INTO `cortex`.`group_module` (`module_id`, `group_id`, `favorite`) VALUES (1, 1, 0);
INSERT INTO `cortex`.`group_module` (`module_id`, `group_id`, `favorite`) VALUES (2, 1, 0);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cortex`.`user_action`
-- -----------------------------------------------------
START TRANSACTION;
USE `cortex`;
INSERT INTO `cortex`.`user_action` (`user_id`, `action_id`) VALUES (1, 3);
INSERT INTO `cortex`.`user_action` (`user_id`, `action_id`) VALUES (1, 4);
INSERT INTO `cortex`.`user_action` (`user_id`, `action_id`) VALUES (1, 5);

COMMIT;

