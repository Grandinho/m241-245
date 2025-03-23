package sensorreading

import (
	"air-controller-webservice/services/device"
	"air-controller-webservice/types"
	"air-controller-webservice/utils"
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

type Handler struct {
	store types.SensorReadingStore
	db    *sql.DB
}

func NewHandler(store types.SensorReadingStore, db *sql.DB) *Handler {
	return &Handler{store: store, db: db}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/sensorreading", h.handleGet).Methods("GET")
	router.HandleFunc("/sensorreading/device/{deviceId}", h.handleGetByDeviceId).Methods("GET")
	router.HandleFunc("/sensorreading", h.handlePost).Methods("POST")
}

func (h *Handler) handleGet(w http.ResponseWriter, r *http.Request) {
	sensorReadings, err := h.store.GetSensorReadings()

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, sensorReadings)
}

func (h *Handler) handleGetByDeviceId(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	deviceId := vars["deviceId"]

	sensorReadings, err := h.store.GetSensorReadingsByDevice(deviceId)

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, sensorReadings)
}

func (h *Handler) handlePost(w http.ResponseWriter, r *http.Request) {
	var payload types.SensorReadingPayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	deviceStore := device.NewStore(h.db)
	device, err := deviceStore.GetDeviceByMac(payload.DeviceMacAddress)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	if device.ID == 0 {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("device with following mac address was not found %s", device.MACAddress))
		return
	}

	err = h.store.CreateSensorReading(payload, device.ID)

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusCreated, nil)
}
