CREATE DATABASE air_controller_db;
USE air_controller_db;

CREATE TABLE devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    localization VARCHAR(255)
);

CREATE TABLE sensor_readings(
    id INT AUTO_INCREMENT PRIMARY KEY,
    deviceId INT NOT NULL,
    readedAt datetime  NOT NULL,
    temperature decimal(4,2),
    humidity TINYINT,
    pressure DECIMAL(6,2),
    -- gas_readings not clear yet
    -- air_quality_index not clear yet
    FOREIGN KEY (deviceId) References Devices(id)
);

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    createdAt timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY (username)
);