-- MySQL Script generated by MySQL Workbench
-- Sat Oct  3 10:03:37 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema universo_camping
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema universo_camping
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `universo_camping` DEFAULT CHARACTER SET utf8 ;
USE `universo_camping` ;

-- -----------------------------------------------------
-- Table `universo_camping`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`categories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `image` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `fecha` DATE NULL DEFAULT NULL,
  `avatar` VARCHAR(45) NULL DEFAULT NULL,
  `direccion` VARCHAR(45) NULL DEFAULT NULL,
  `ciudad` VARCHAR(45) NULL DEFAULT NULL,
  `provincia` VARCHAR(45) NULL DEFAULT NULL,
  `rol` VARCHAR(45) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`products` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `price` INT(11) NOT NULL,
  `discount` INT(11) NOT NULL DEFAULT 0,
  `description` VARCHAR(300) NOT NULL,
  `image` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `id_user` INT(11) NULL DEFAULT NULL,
  `id_category` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_categoria_idx` (`id_category` ASC),
  INDEX `id_user_idx` (`id_user` ASC),
  CONSTRAINT `id_category`
    FOREIGN KEY (`id_category`)
    REFERENCES `universo_camping`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_user`
    FOREIGN KEY (`id_user`)
    REFERENCES `universo_camping`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`cart` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_user` INT(11) NOT NULL,
  `id_product` INT(11) NOT NULL,
  `quantity` INT(11) NOT NULL DEFAULT 1,
  `remito` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_producto_idx` (`id_product` ASC),
  INDEX `id_usuario_idx` (`id_user` ASC),
  CONSTRAINT `id_producto`
    FOREIGN KEY (`id_product`)
    REFERENCES `universo_camping`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_usuario`
    FOREIGN KEY (`id_user`)
    REFERENCES `universo_camping`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
