package device

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

func (s *Store) CreateDevice(device types.DevicePayload) error {
	var count int
	if err := s.db.QueryRow("SELECT Count(*) FROM requested_devices where macAddress = ? AND active = true", device.MACAddress).Scan(&count); err != nil {
		return err
	}
	if count != 1 {
		return fmt.Errorf("device was never requested. request the device first")
	}
	if err := s.DeactivateDevice(device.MACAddress); err != nil {
		return err
	}

	if _, err := s.db.Exec("INSERT INTO devices(macAddress, name, localization) VALUES (?,?,?)", device.MACAddress, device.Name, device.Localization); err != nil {
		return err
	}

	return nil
}
func (s *Store) RequestDevice(requestDevice types.RequestDevicePayload) error {
	if _, err := s.db.Exec("INSERT INTO requested_devices(macAddress,active) VALUES(?,?)", requestDevice.MACAddress, true); err != nil {
		return err
	}

	return nil
}
func (s *Store) GetDevices() ([]*types.Device, error) {
	rows, err := s.db.Query("SELECT * FROM devices")

	if err != nil {
		return nil, err
	}

	var devices []*types.Device
	for rows.Next() {
		device, err := ScanRowsIntoDevice(rows)
		if err != nil {
			return nil, err
		}
		devices = append(devices, device)
	}

	return devices, nil
}

func (s *Store) GetDeviceById(deviceId int) (*types.Device, error) {
	rows, err := s.db.Query("SELECT * FROM devices where id = ?", deviceId)

	if err != nil {
		return nil, err
	}

	device := new(types.Device)
	for rows.Next() {
		device, err = ScanRowsIntoDevice(rows)
		if err != nil {
			return nil, err
		}
	}

	return device, nil
}

func (s *Store) GetDeviceByMac(macAddress string) (*types.Device, error) {
	rows, err := s.db.Query("SELECT * FROM devices where macAddress = ?", macAddress)

	if err != nil {
		return nil, err
	}

	device := new(types.Device)
	for rows.Next() {
		device, err = ScanRowsIntoDevice(rows)
		if err != nil {
			return nil, err
		}
	}

	return device, nil
}

func (s *Store) GetRequestedDevices() ([]*types.RequestDevice, error) {
	rows, err := s.db.Query("SELECT * FROM requested_devices where active = true")

	if err != nil {
		return nil, err
	}

	var requestedDevices []*types.RequestDevice
	for rows.Next() {
		requestedDevice, err := ScanRowsIntoRequestedDevice(rows)
		if err != nil {
			return nil, err
		}
		requestedDevices = append(requestedDevices, requestedDevice)
	}

	return requestedDevices, nil
}

func (s *Store) DeactivateDevice(macAddress string) error {
	if _, err := s.db.Exec("UPDATE requested_devices SET active = false where macAddress = ?", macAddress); err != nil {
		return err
	}

	return nil
}

func ScanRowsIntoRequestedDevice(rows *sql.Rows) (*types.RequestDevice, error) {
	requestedDevice := new(types.RequestDevice)

	if err := rows.Scan(
		&requestedDevice.ID,
		&requestedDevice.MACAddress,
		&requestedDevice.CreatedAt,
		&requestedDevice.Active,
	); err != nil {
		return nil, err
	}

	return requestedDevice, nil
}

func ScanRowsIntoDevice(rows *sql.Rows) (*types.Device, error) {
	device := new(types.Device)

	if err := rows.Scan(
		&device.ID,
		&device.MACAddress,
		&device.Name,
		&device.Localization,
		&device.CreatedAt,
	); err != nil {
		return nil, err
	}

	return device, nil
}
