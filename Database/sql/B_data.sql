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
(1, 21.5, 45.2, 85, 650.25, NOW());

-- Current readings for device 2 (Küche)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.8, 52.4, 75, 750.50, NOW());

-- Current readings for device 3 (Schlafzimmer)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(3, 19.2, 48.7, 95, 500.75, NOW());

-- Current readings for device 4 (Büro)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(4, 23.1, 40.3, 65, 850.25, NOW());

-- Current readings for device 5 (Badezimmer)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(5, 24.5, 65.8, 80, 600.50, NOW());

-- Historical data for device 1 - last 24 hours (sample every 4 hours)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 20.8, 43.5, 83, 680.25, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(1, 21.0, 44.0, 84, 670.50, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(1, 21.2, 44.8, 86, 660.75, DATE_SUB(NOW(), INTERVAL 12 HOUR)),
(1, 21.3, 45.5, 87, 655.25, DATE_SUB(NOW(), INTERVAL 16 HOUR)),
(1, 21.0, 46.2, 85, 665.50, DATE_SUB(NOW(), INTERVAL 20 HOUR)),
(1, 20.5, 46.5, 82, 675.75, DATE_SUB(NOW(), INTERVAL 24 HOUR));

-- Historical data for device 2 - last 24 hours (sample every 4 hours)
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.0, 51.0, 73, 770.25, DATE_SUB(NOW(), INTERVAL 4 HOUR)),
(2, 22.2, 51.5, 74, 765.50, DATE_SUB(NOW(), INTERVAL 8 HOUR)),
(2, 22.5, 52.0, 76, 755.75, DATE_SUB(NOW(), INTERVAL 12 HOUR)),
(2, 22.9, 52.8, 77, 745.25, DATE_SUB(NOW(), INTERVAL 16 HOUR)),
(2, 23.0, 53.0, 78, 735.50, DATE_SUB(NOW(), INTERVAL 20 HOUR)),
(2, 22.5, 52.5, 76, 740.75, DATE_SUB(NOW(), INTERVAL 24 HOUR));

-- Add some extreme values for testing
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(3, 16.0, 70.0, 50, 1200.00, DATE_SUB(NOW(), INTERVAL 2 HOUR)),
(4, 28.5, 30.0, 40, 1500.00, DATE_SUB(NOW(), INTERVAL 3 HOUR)),
(5, 26.0, 80.0, 60, 900.00, DATE_SUB(NOW(), INTERVAL 1 HOUR));

-- Weekly comparison data - device 1
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(1, 21.2, 44.5, 86, 645.25, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(1, 21.3, 45.0, 87, 635.50, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, 21.0, 45.5, 85, 650.75, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 20.8, 46.0, 84, 660.25, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 21.5, 44.8, 88, 640.50, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 21.7, 43.5, 90, 625.75, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 21.2, 44.0, 86, 645.00, DATE_SUB(NOW(), INTERVAL 7 DAY));

-- Weekly comparison data - device 2
INSERT INTO sensor_readings (deviceId, temperature, humidity, carbondioxide, airQualityIndex, createdAt) VALUES
(2, 22.5, 52.0, 76, 745.25, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 22.7, 52.5, 78, 735.50, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 22.4, 53.0, 75, 750.75, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 22.0, 53.5, 74, 760.25, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 22.8, 52.8, 79, 730.50, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(2, 23.0, 51.5, 80, 720.75, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(2, 22.5, 52.0, 76, 745.00, DATE_SUB(NOW(), INTERVAL 7 DAY));