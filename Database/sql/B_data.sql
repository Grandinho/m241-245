USE air_controller_db;

-- Insert test devices
INSERT INTO devices (macAddress, name, localization) VALUES
('AA:BB:CC:DD:EE:01', 'Wohnzimmer-Sensor', 'Wohnzimmer'),
('AA:BB:CC:DD:EE:02', 'Küchen-Sensor', 'Küche'),
('AA:BB:CC:DD:EE:03', 'Schlafzimmer-Sensor', 'Schlafzimmer'),
('AA:BB:CC:DD:EE:04', 'Büro-Sensor', 'Arbeitszimmer'),
('AA:BB:CC:DD:EE:05', 'Badezimmer-Sensor', 'Badezimmer');

-- Insert requested devices
INSERT INTO requested_devices (macAddress, active) VALUES
('AA:BB:CC:DD:EE:06', true),
('AA:BB:CC:DD:EE:07', true),
('AA:BB:CC:DD:EE:08', false),
('AA:BB:CC:DD:EE:09', false),
('AA:BB:CC:DD:EE:10', true);

-- Insert test users
INSERT INTO users (username, password) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'), -- password: test123
('user1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
('user2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');

-- Current readings for device 1 (Wohnzimmer)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 21.5, 45.2, 850, 125, NOW());

-- Current readings for device 2 (Küche)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.8, 52.4, 1050, 185, NOW());

-- Current readings for device 3 (Schlafzimmer)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(3, 19.2, 48.7, 750, 95, NOW());

-- Current readings for device 4 (Büro)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(4, 23.1, 40.3, 1650, 275, NOW());

-- Current readings for device 5 (Badezimmer)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(5, 24.5, 65.8, 1250, 210, NOW());

-- Historical data for device 1 - last 24 hours (hourly intervals)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 20.8, 43.5, 830, 120, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(1, 21.0, 44.0, 840, 125, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(1, 21.2, 44.8, 860, 130, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(1, 21.3, 45.5, 870, 135, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(1, 21.4, 45.8, 880, 140, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(1, 21.5, 46.0, 900, 145, DATE_SUB(NOW(), INTERVAL 6 HOUR)),
(1, 21.4, 46.2, 890, 140, DATE_SUB(NOW(), INTERVAL 7 HOUR)),
(1, 21.3, 46.0, 870, 135, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(1, 21.0, 45.8, 850, 130, DATE_SUB(NOW(), INTERVAL 9 HOUR)),
(1, 20.8, 45.5, 840, 125, DATE_SUB(NOW(), INTERVAL 10 HOUR)),
(1, 20.6, 45.3, 830, 120, DATE_SUB(NOW(), INTERVAL 11 HOUR)),
(1, 20.5, 45.0, 820, 115, DATE_SUB(NOW(), INTERVAL 12 HOUR)),
(1, 20.3, 44.8, 800, 110, DATE_SUB(NOW(), INTERVAL 13 HOUR)),
(1, 20.2, 44.5, 790, 105, DATE_SUB(NOW(), INTERVAL 14 HOUR)),
(1, 20.0, 44.3, 780, 100, DATE_SUB(NOW(), INTERVAL 15 HOUR)),
(1, 20.3, 44.5, 790, 105, DATE_SUB(NOW(), INTERVAL 16 HOUR)),
(1, 20.5, 44.8, 810, 110, DATE_SUB(NOW(), INTERVAL 17 HOUR)),
(1, 20.8, 45.0, 820, 115, DATE_SUB(NOW(), INTERVAL 18 HOUR)),
(1, 21.0, 45.3, 830, 120, DATE_SUB(NOW(), INTERVAL 19 HOUR)),
(1, 21.2, 45.5, 840, 125, DATE_SUB(NOW(), INTERVAL 20 HOUR)),
(1, 21.3, 45.8, 845, 130, DATE_SUB(NOW(), INTERVAL 21 HOUR)),
(1, 21.4, 46.0, 848, 128, DATE_SUB(NOW(), INTERVAL 22 HOUR)),
(1, 21.5, 46.2, 852, 126, DATE_SUB(NOW(), INTERVAL 23 HOUR)),
(1, 21.4, 46.0, 848, 125, DATE_SUB(NOW(), INTERVAL 24 HOUR));

-- Historical data for device 2 - last 24 hours (hourly intervals)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.0, 51.0, 980, 170, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(2, 22.2, 51.5, 990, 175, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(2, 22.5, 52.0, 1000, 180, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(2, 22.8, 52.3, 1020, 190, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(2, 23.0, 52.5, 1040, 200, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(2, 23.2, 52.8, 1060, 210, DATE_SUB(NOW(), INTERVAL 6 HOUR)),
(2, 23.3, 53.0, 1080, 215, DATE_SUB(NOW(), INTERVAL 7 HOUR)),
(2, 23.2, 52.8, 1070, 210, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(2, 23.0, 52.5, 1050, 200, DATE_SUB(NOW(), INTERVAL 9 HOUR)),
(2, 22.8, 52.3, 1030, 190, DATE_SUB(NOW(), INTERVAL 10 HOUR)),
(2, 22.5, 52.0, 1010, 180, DATE_SUB(NOW(), INTERVAL 11 HOUR)),
(2, 22.3, 51.8, 1000, 175, DATE_SUB(NOW(), INTERVAL 12 HOUR)),
(2, 22.0, 51.5, 990, 170, DATE_SUB(NOW(), INTERVAL 13 HOUR)),
(2, 21.8, 51.0, 970, 165, DATE_SUB(NOW(), INTERVAL 14 HOUR)),
(2, 21.5, 50.5, 950, 160, DATE_SUB(NOW(), INTERVAL 15 HOUR)),
(2, 21.8, 50.8, 970, 165, DATE_SUB(NOW(), INTERVAL 16 HOUR)),
(2, 22.0, 51.0, 990, 170, DATE_SUB(NOW(), INTERVAL 17 HOUR)),
(2, 22.3, 51.3, 1010, 175, DATE_SUB(NOW(), INTERVAL 18 HOUR)),
(2, 22.5, 51.5, 1030, 180, DATE_SUB(NOW(), INTERVAL 19 HOUR)),
(2, 22.8, 51.8, 1040, 185, DATE_SUB(NOW(), INTERVAL 20 HOUR)),
(2, 23.0, 52.0, 1045, 188, DATE_SUB(NOW(), INTERVAL 21 HOUR)),
(2, 23.0, 52.2, 1048, 186, DATE_SUB(NOW(), INTERVAL 22 HOUR)),
(2, 22.9, 52.3, 1046, 185, DATE_SUB(NOW(), INTERVAL 23 HOUR)),
(2, 22.8, 52.2, 1042, 184, DATE_SUB(NOW(), INTERVAL 24 HOUR));

-- Add some fluctuation data for device 3
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(3, 19.0, 47.5, 720, 90, DATE_SUB(NOW(), INTERVAL 1 HOUR)),
(3, 18.5, 47.0, 700, 85, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(3, 18.0, 46.5, 680, 80, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(3, 18.2, 46.8, 690, 82, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(3, 18.5, 47.0, 710, 86, DATE_SUB(NOW(), INTERVAL 5 HOUR)),
(3, 18.8, 47.3, 730, 90, DATE_SUB(NOW(), INTERVAL 6 HOUR)),
(3, 19.0, 47.5, 740, 92, DATE_SUB(NOW(), INTERVAL 7 HOUR)),
(3, 19.2, 47.8, 750, 95, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(3, 19.5, 48.0, 760, 98, DATE_SUB(NOW(), INTERVAL 9 HOUR)),
(3, 19.8, 48.3, 770, 100, DATE_SUB(NOW(), INTERVAL 10 HOUR)),
(3, 20.0, 48.5, 780, 102, DATE_SUB(NOW(), INTERVAL 11 HOUR)),
(3, 20.2, 48.8, 790, 105, DATE_SUB(NOW(), INTERVAL 12 HOUR));

-- Add some extreme values for testing (within 500 AQI max)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(3, 16.0, 70.0, 3000, 350, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(4, 28.5, 30.0, 4000, 450, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(5, 26.0, 80.0, 2500, 320, DATE_SUB(NOW(), INTERVAL 1 HOUR));

-- Add temperature extremes
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, -5.0, 35.0, 600, 80, DATE_SUB(NOW(), INTERVAL 30 DAY)),
(2, 32.0, 60.0, 1200, 220, DATE_SUB(NOW(), INTERVAL 28 DAY));

-- Weekly comparison data - device 1
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 21.2, 44.5, 860, 130, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(1, 21.3, 45.0, 870, 135, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 21.0, 45.5, 850, 125, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 20.8, 46.0, 840, 120, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 21.5, 44.8, 880, 140, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 21.7, 43.5, 900, 145, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 21.2, 44.0, 860, 130, DATE_SUB(NOW(), INTERVAL 7 DAY));

-- Weekly comparison data - device 2
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.5, 52.0, 1020, 180, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 22.7, 52.5, 1040, 190, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 22.4, 53.0, 1010, 175, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 22.0, 53.5, 990, 170, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 22.8, 52.8, 1050, 195, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 23.0, 51.5, 1070, 200, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(2, 22.5, 52.0, 1020, 180, DATE_SUB(NOW(), INTERVAL 7 DAY));

-- Monthly data for device 1
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 20.5, 44.0, 830, 120, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(1, 20.3, 44.2, 820, 115, DATE_SUB(NOW(), INTERVAL 9 DAY)),
(1, 20.0, 44.5, 810, 110, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(1, 19.8, 45.0, 800, 105, DATE_SUB(NOW(), INTERVAL 11 DAY)),
(1, 19.5, 45.5, 780, 100, DATE_SUB(NOW(), INTERVAL 12 DAY)),
(1, 19.3, 46.0, 770, 95, DATE_SUB(NOW(), INTERVAL 13 DAY)),
(1, 19.0, 46.5, 760, 90, DATE_SUB(NOW(), INTERVAL 14 DAY)),
(1, 19.5, 46.0, 780, 95, DATE_SUB(NOW(), INTERVAL 18 DAY)),
(1, 20.0, 45.5, 800, 100, DATE_SUB(NOW(), INTERVAL 22 DAY)),
(1, 20.5, 45.0, 820, 110, DATE_SUB(NOW(), INTERVAL 25 DAY)),
(1, 21.0, 44.5, 840, 120, DATE_SUB(NOW(), INTERVAL 28 DAY)),
(1, 21.5, 44.0, 860, 130, DATE_SUB(NOW(), INTERVAL 30 DAY));

-- Monthly data for device 4 (Büro) - showing working hours pattern
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(4, 23.0, 40.0, 1600, 260, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(4, 23.2, 40.5, 1650, 270, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(4, 23.3, 41.0, 1700, 280, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 23.0, 40.8, 1680, 275, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(4, 23.1, 40.5, 1660, 270, DATE_SUB(NOW(), INTERVAL 5 DAY)),
-- Weekend drop
(4, 22.0, 39.0, 800, 130, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(4, 21.5, 38.5, 780, 120, DATE_SUB(NOW(), INTERVAL 7 DAY)),
-- Back to work
(4, 23.2, 40.0, 1650, 270, DATE_SUB(NOW(), INTERVAL 8 DAY)),
(4, 23.3, 40.5, 1670, 280, DATE_SUB(NOW(), INTERVAL 9 DAY)),
(4, 23.5, 41.0, 1700, 290, DATE_SUB(NOW(), INTERVAL 10 DAY)),
(4, 23.2, 40.8, 1680, 285, DATE_SUB(NOW(), INTERVAL 11 DAY)),
(4, 23.0, 40.5, 1650, 275, DATE_SUB(NOW(), INTERVAL 12 DAY)),
-- Weekend drop
(4, 22.0, 39.0, 820, 140, DATE_SUB(NOW(), INTERVAL 13 DAY)),
(4, 21.8, 38.5, 800, 130, DATE_SUB(NOW(), INTERVAL 14 DAY));

-- Add high AQI events (approaching max of 500)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 24.0, 55.0, 2500, 380, DATE_SUB(NOW(), INTERVAL 15 DAY)),
(2, 25.0, 60.0, 3000, 420, DATE_SUB(NOW(), INTERVAL 16 DAY)),
(3, 23.0, 58.0, 3500, 460, DATE_SUB(NOW(), INTERVAL 17 DAY)),
(4, 26.0, 52.0, 4000, 490, DATE_SUB(NOW(), INTERVAL 18 DAY)),
(5, 25.5, 65.0, 3800, 470, DATE_SUB(NOW(), INTERVAL 19 DAY));

-- Add season transition data
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 18.0, 50.0, 900, 150, DATE_SUB(NOW(), INTERVAL 20 DAY)),
(1, 17.5, 52.0, 920, 155, DATE_SUB(NOW(), INTERVAL 21 DAY)),
(1, 17.0, 54.0, 930, 160, DATE_SUB(NOW(), INTERVAL 22 DAY)),
(1, 16.5, 56.0, 940, 165, DATE_SUB(NOW(), INTERVAL 23 DAY)),
(1, 16.0, 58.0, 950, 170, DATE_SUB(NOW(), INTERVAL 24 DAY)),
(1, 15.5, 60.0, 960, 175, DATE_SUB(NOW(), INTERVAL 25 DAY)),
(1, 15.0, 62.0, 970, 180, DATE_SUB(NOW(), INTERVAL 26 DAY)),
(1, 14.5, 64.0, 980, 185, DATE_SUB(NOW(), INTERVAL 27 DAY)),
(1, 14.0, 66.0, 990, 190, DATE_SUB(NOW(), INTERVAL 28 DAY)),
(1, 13.5, 68.0, 1000, 195, DATE_SUB(NOW(), INTERVAL 29 DAY)),
(1, 13.0, 70.0, 1020, 200, DATE_SUB(NOW(), INTERVAL 30 DAY));

-- Add hourly data variations for a complete day for device 5 (Badezimmer) - showing morning/evening humidity spikes
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(5, 22.0, 55.0, 900, 150, DATE_SUB(CONCAT(CURDATE(), ' 00:00:00'), INTERVAL 0 HOUR)),
(5, 21.8, 54.0, 880, 145, DATE_SUB(CONCAT(CURDATE(), ' 01:00:00'), INTERVAL 0 HOUR)),
(5, 21.5, 53.0, 860, 140, DATE_SUB(CONCAT(CURDATE(), ' 02:00:00'), INTERVAL 0 HOUR)),
(5, 21.2, 52.0, 850, 135, DATE_SUB(CONCAT(CURDATE(), ' 03:00:00'), INTERVAL 0 HOUR)),
(5, 21.0, 51.0, 840, 130, DATE_SUB(CONCAT(CURDATE(), ' 04:00:00'), INTERVAL 0 HOUR)),
(5, 21.5, 60.0, 900, 160, DATE_SUB(CONCAT(CURDATE(), ' 05:00:00'), INTERVAL 0 HOUR)),
(5, 22.0, 75.0, 1000, 190, DATE_SUB(CONCAT(CURDATE(), ' 06:00:00'), INTERVAL 0 HOUR)), -- Morning shower
(5, 22.5, 80.0, 1100, 210, DATE_SUB(CONCAT(CURDATE(), ' 07:00:00'), INTERVAL 0 HOUR)), -- Morning shower
(5, 23.0, 70.0, 1050, 200, DATE_SUB(CONCAT(CURDATE(), ' 08:00:00'), INTERVAL 0 HOUR)),
(5, 23.5, 60.0, 950, 170, DATE_SUB(CONCAT(CURDATE(), ' 09:00:00'), INTERVAL 0 HOUR)),
(5, 24.0, 55.0, 900, 150, DATE_SUB(CONCAT(CURDATE(), ' 10:00:00'), INTERVAL 0 HOUR)),
(5, 24.2, 54.0, 880, 145, DATE_SUB(CONCAT(CURDATE(), ' 11:00:00'), INTERVAL 0 HOUR)),
(5, 24.5, 53.0, 860, 140, DATE_SUB(CONCAT(CURDATE(), ' 12:00:00'), INTERVAL 0 HOUR)),
(5, 24.8, 52.0, 850, 138, DATE_SUB(CONCAT(CURDATE(), ' 13:00:00'), INTERVAL 0 HOUR)),
(5, 25.0, 51.0, 840, 135, DATE_SUB(CONCAT(CURDATE(), ' 14:00:00'), INTERVAL 0 HOUR)),
(5, 25.2, 50.0, 830, 132, DATE_SUB(CONCAT(CURDATE(), ' 15:00:00'), INTERVAL 0 HOUR)),
(5, 25.0, 51.0, 850, 140, DATE_SUB(CONCAT(CURDATE(), ' 16:00:00'), INTERVAL 0 HOUR)),
(5, 24.8, 52.0, 900, 150, DATE_SUB(CONCAT(CURDATE(), ' 17:00:00'), INTERVAL 0 HOUR)),
(5, 24.5, 60.0, 950, 170, DATE_SUB(CONCAT(CURDATE(), ' 18:00:00'), INTERVAL 0 HOUR)),
(5, 24.0, 75.0, 1100, 200, DATE_SUB(CONCAT(CURDATE(), ' 19:00:00'), INTERVAL 0 HOUR)), -- Evening shower
(5, 23.5, 80.0, 1200, 220, DATE_SUB(CONCAT(CURDATE(), ' 20:00:00'), INTERVAL 0 HOUR)), -- Evening shower
(5, 23.0, 70.0, 1100, 200, DATE_SUB(CONCAT(CURDATE(), ' 21:00:00'), INTERVAL 0 HOUR)),
(5, 22.5, 65.0, 1000, 180, DATE_SUB(CONCAT(CURDATE(), ' 22:00:00'), INTERVAL 0 HOUR)),
(5, 22.0, 60.0, 950, 160, DATE_SUB(CONCAT(CURDATE(), ' 23:00:00'), INTERVAL 0 HOUR));