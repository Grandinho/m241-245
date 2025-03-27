CREATE DATABASE air_controller_db;
USE air_controller_db;

CREATE TABLE devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    macAddress VARCHAR(255),
    name VARCHAR(255),
    localization VARCHAR(255),
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY (macAddress)
);

CREATE TABLE requested_devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    macAddress VARCHAR(255),
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN,
    UNIQUE KEY (macAddress)
);

CREATE TABLE sensor_readings(
    id INT AUTO_INCREMENT PRIMARY KEY,
    deviceId INT NOT NULL,
    temperature decimal(5,2),
    humidity decimal(5,2),
    carbondioxide decimal(7,2),
    airQualityIndex SMALLINT,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (deviceId) References devices(id)
);

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY (username)
);