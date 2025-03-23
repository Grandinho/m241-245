package types

import "time"

type UserStore interface {
	GetUserByUsername(username string) (*User, error)
	GetUserByID(id int) (*User, error)
	CreateUser(User) error
}

type User struct {
	ID        int       `json:"id"`
	Username  string    `json:"username"`
	Password  string    `json:"password"`
	CreatedAt time.Time `json:"createdAt"`
}

type RegisterUserPayload struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type SensorReadingStore interface {
	CreateSensorReading(sensorReading SensorReadingPayload, deviceId int) error
	GetSensorReadingsByDevice(deviceId string) ([]*SensorReading, error)
	GetSensorReadings() ([]*SensorReading, error)
}

type SensorReading struct {
	ID              int       `json:"id"`
	DeviceId        int       `json:"deviceId"`
	Temperature     float32   `json:"temperature"`
	AirQualityIndex float32   `json:"airQualityIndex"`
	Humidity        float32   `json:"humidity"`
	Carbondioxide   float32   `json:"carbondioxide"`
	CreatedAt       time.Time `json:"createdAt"`
}

type SensorReadingPayload struct {
	DeviceMacAddress string  `json:"deviceMacAddress"`
	Temperature      float32 `json:"temperature"`
	AirQualityIndex  float32 `json:"airQualityIndex"`
	Humidity         float32 `json:"humidity"`
	Carbondioxide    float32 `json:"carbondioxide"`
}

type DeviceStore interface {
	CreateDevice(device DevicePayload) error
	RequestDevice(requestDevice RequestDevicePayload) error
	GetDevices() ([]*Device, error)
	GetDeviceById(deviceId int) (*Device, error)
	GetDeviceByMac(macAddress string) (*Device, error)
	GetRequestedDevices() ([]*RequestDevice, error)
	DeactivateDevice(macAddress string) error
}

type Device struct {
	ID           int       `json:"id"`
	MACAddress   string    `json:"macAddress"`
	Name         string    `json:"name"`
	Localization string    `json:"localization"`
	CreatedAt    time.Time `json:"createdAt"`
}

type DevicePayload struct {
	MACAddress   string `json:"macAddress"`
	Name         string `json:"name"`
	Localization string `json:"localization"`
}

type RequestDevice struct {
	ID         int       `json:"id"`
	MACAddress string    `json:"macAddress"`
	CreatedAt  time.Time `json:"createdAt"`
	Active     bool      `json:"active"`
}

type RequestDevicePayload struct {
	MACAddress string `json:"macAddress"`
}
