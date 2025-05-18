use etekhno_rentacar;

CREATE TABLE IF NOT EXISTS `user` (
  `id` VARCHAR(36) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL UNIQUE,
  `gender` TINYINT(1) NOT NULL,
  `deleted` TINYINT NULL,
  `profile_picture` MEDIUMBLOB NULL,
  `login_attempt` TINYINT(1) NOT NULL DEFAULT 0,
  `locked` TINYINT(1) NOT NULL DEFAULT false,
  `locked_time` DateTime NULL,
  `account_verified` BOOLEAN NULL,
  `timezone` VARCHAR(36) NULL,
  `locale` VARCHAR(36) NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(30) NOT NULL,
  `created_date` DATETIME NOT NULL,
  `created_by` VARCHAR(36) NOT NULL,
  `last_modified_date` DATETIME NOT NULL,
  `last_modified_by` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `secure_token`(
  `id` VARCHAR(36) NOT NULL,
  `token` VARCHAR(36) NOT NULL,
  `timestamp` DATE NOT NULL,
  `expire_at` DATETIME NOT NULL,
  `user_id` VARCHAR(45) NOT NULL,
  `is_expired` TINYINT NOT NULL,
  `email_type` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS `customer` (
  `cnic` VARCHAR(36) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL UNIQUE,
  `gender` TINYINT(1) NOT NULL,
  `deleted` TINYINT NULL,
  `profile_picture` MEDIUMBLOB NULL,
  `locked` TINYINT(1) NOT NULL DEFAULT false,
  `locked_time` DateTime NULL,
  `account_verified` BOOLEAN NULL,
  `phone_number` VARCHAR(30) NOT NULL,
  `created_date` DATETIME NOT NULL,
  `created_by` VARCHAR(36) NOT NULL,
  `last_modified_date` DATETIME NOT NULL,
  `last_modified_by` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`cnic`));

CREATE TABLE IF NOT EXISTS `address`(
    `id` VARCHAR(36) NOT NULL,
    `street`VARCHAR(36) NOT NULL,
    `city` VARCHAR(36) NOT NULL,
    `state` VARCHAR(36) NOT NULL,
    `country` VARCHAR(50) NOT NULL,
    `postal_code` INT(10) NOT NULL,
    `latitude` DOUBLE NULL,
    `longitude` DOUBLE NULL,
    `validate` TINYINT(1) NULL,
     PRIMARY KEY (`id`),
     UNIQUE KEY(`street`, `city`, `state`, `country`, `postal_code`)
);

CREATE TABLE IF NOT EXISTS `user_address_relation`(
    `user_id` VARCHAR(36) NOT NULL,
    `address_id` VARCHAR(36) NOT NULL,
    `created_date` DATETIME NOT NULL,
    `created_by` VARCHAR(36) NOT NULL,
    `last_modified_date` DATETIME NOT NULL,
    `last_modified_by` VARCHAR(36) NOT NULL,
    UNIQUE(`user_id`,`address_id`),
    FOREIGN KEY(`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`address_id`) REFERENCES `address`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
);