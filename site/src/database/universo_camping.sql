-- MySQL Script generated by MySQL Workbench
-- Tue Oct 27 11:12:37 2020
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
-- Table `universo_camping`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
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
AUTO_INCREMENT = 27
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`cart` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cantidad` INT(11) NOT NULL DEFAULT 1,
  `remito` INT(11) NOT NULL,
  `id_users` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_cart_users1_idx` (`id_users` ASC),
  CONSTRAINT `id_users`
    FOREIGN KEY (`id_users`)
    REFERENCES `universo_camping`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`categories` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `imagen` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`products` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `precio` INT(11) NOT NULL,
  `descuento` INT(11) NOT NULL DEFAULT 0,
  `descripcion` VARCHAR(300) NOT NULL,
  `imagenes` VARCHAR(100) NOT NULL,
  `stock` INT(11) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `id_category` INT(11) UNSIGNED NULL DEFAULT NULL,
  `id_cart` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_categoria_idx` (`id_category` ASC),
  INDEX `fk_products_cart1_idx` (`id_cart` ASC),
  CONSTRAINT `id_cart`
    FOREIGN KEY (`id_cart`)
    REFERENCES `universo_camping`.`cart` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_category`
    FOREIGN KEY (`id_category`)
    REFERENCES `universo_camping`.`categories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 30
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `universo_camping`.`ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `universo_camping`.`ventas` (
  `id` INT(11) UNSIGNED NOT NULL,
  `id_users` INT(11) UNSIGNED NOT NULL,
  `id_products` INT(11) UNSIGNED NOT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_has_products_products1_idx` (`id_products` ASC),
  INDEX `fk_users_has_products_users1_idx` (`id_users` ASC),
  CONSTRAINT `fk_users_has_products_products1`
    FOREIGN KEY (`id_products`)
    REFERENCES `universo_camping`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_products_users1`
    FOREIGN KEY (`id_users`)
    REFERENCES `universo_camping`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
