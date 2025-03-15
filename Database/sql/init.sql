CREATE DATABASE air_controller_db;
USE air_controller_db;

CREATE TABLE device (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    localization VARCHAR(255)
);