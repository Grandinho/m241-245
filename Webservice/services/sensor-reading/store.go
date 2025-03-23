package sensorreading

import (
	"air-controller-webservice/types"
	"database/sql"
	"fmt"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) CreateSensorReading(sensorReading types.SensorReadingPayload, deviceId int) error {
	_, err := s.db.Exec("INSERT INTO sensor_readings(deviceId, temperature, humidity, carbondioxide, airQualityIndex) VALUES (?,?,?,?,?)",
		deviceId,
		sensorReading.Temperature,
		sensorReading.Humidity,
		sensorReading.Carbondioxide,
		sensorReading.AirQualityIndex)
	if err != nil {
		return err
	}

	fmt.Println("inserted")

	return nil
}

func (s *Store) GetSensorReadings() ([]*types.SensorReading, error) {
	rows, err := s.db.Query("SELECT * FROM sensor_readings")
	if err != nil {
		return nil, err
	}

	var sensorReadings []*types.SensorReading
	for rows.Next() {
		sensorReading, err := scanRowIntoSensorReading(rows)
		if err != nil {
			return nil, err
		}
		sensorReadings = append(sensorReadings, sensorReading)
	}

	return sensorReadings, nil
}

func (s *Store) GetSensorReadingsByDevice(deviceId string) ([]*types.SensorReading, error) {
	rows, err := s.db.Query("SELECT * FROM sensor_readings where deviceId = ?", deviceId)
	if err != nil {
		return nil, err
	}

	var sensorReadings []*types.SensorReading
	for rows.Next() {
		sensorReading, err := scanRowIntoSensorReading(rows)
		if err != nil {
			return nil, err
		}
		sensorReadings = append(sensorReadings, sensorReading)
	}

	return sensorReadings, nil
}

func scanRowIntoSensorReading(rows *sql.Rows) (*types.SensorReading, error) {
	sensorReading := new(types.SensorReading)

	err := rows.Scan(
		&sensorReading.ID,
		&sensorReading.DeviceId,
		&sensorReading.Temperature,
		&sensorReading.AirQualityIndex,
		&sensorReading.Humidity,
		&sensorReading.Carbondioxide,
		&sensorReading.CreatedAt,
	)

	if err != nil {
		return nil, err
	}

	return sensorReading, nil
}
