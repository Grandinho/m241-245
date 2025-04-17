package device

import (
	"air-controller-webservice/types"
	"air-controller-webservice/utils"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

type Handler struct {
	store types.DeviceStore
}

func NewHandler(store types.DeviceStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/device", h.handleGet).Methods("GET")
	router.HandleFunc("/device/{macId}", h.handleGetByMac).Methods("GET")
	router.HandleFunc("/device", h.handlePost).Methods("POST")
	router.HandleFunc("/device", h.handleOptions).Methods("OPTIONS")
	router.HandleFunc("/device/request", h.handleGetRequestedDevices).Methods("GET")
	router.HandleFunc("/device/request/{macId}", h.handleGetRequestedDevicesByMac).Methods("GET")
	router.HandleFunc("/device/request", h.handleRequest).Methods("POST")
	router.HandleFunc("/device/request/decline", h.handleDeclinedRequest).Methods("POST")
	router.HandleFunc("/device/request/decline", h.handleOptions).Methods("OPTIONS")
}

func (h *Handler) handleGet(w http.ResponseWriter, r *http.Request) {
	devices, err := h.store.GetDevices()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, devices)

}

func (h *Handler) handleGetByMac(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	macAddress := vars["macId"]
	devices, err := h.store.GetDeviceByMac(macAddress)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	if devices.ID == 0 {
		utils.WriteJSON(w, http.StatusNotFound, nil)
		return
	}

	utils.WriteJSON(w, http.StatusOK, devices)

}

func (h *Handler) handlePost(w http.ResponseWriter, r *http.Request) {
	var payload types.DevicePayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	if err := h.store.CreateDevice(payload); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	if err := h.store.DeleteRequestDevice(payload.MACAddress); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusCreated, nil)

}

func (h *Handler) handleRequest(w http.ResponseWriter, r *http.Request) {
	var payload types.RequestDevicePayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	device, _ := h.store.GetDeviceByMac(payload.MACAddress)
	if device.ID != 0 {
		response := types.Response{Message: "device already registered"}
		utils.WriteJSON(w, http.StatusConflict, response)
		return
	}

	requestedDevices, _ := h.store.GetRequestedDevicesByMac(payload.MACAddress)
	if requestedDevices.ID != 0 {
		if requestedDevices.Active {
			response := types.Response{Message: "device already requested"}
			utils.WriteJSON(w, http.StatusConflict, response)
			return
		} else {
			response := types.Response{Message: "device was declined"}
			utils.WriteJSON(w, http.StatusConflict, response)
			return
		}
	}

	if err := h.store.RequestDevice(payload); err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusCreated, nil)
}

func (h *Handler) handleGetRequestedDevices(w http.ResponseWriter, r *http.Request) {
	requestedDevices, err := h.store.GetRequestedDevices()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, requestedDevices)
}

func (h *Handler) handleGetRequestedDevicesByMac(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	macAddress := vars["macId"]
	requestedDevices, err := h.store.GetRequestedDevicesByMac(macAddress)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, requestedDevices)
}

func (h *Handler) handleDeclinedRequest(w http.ResponseWriter, r *http.Request) {
	var payload types.RequestDevicePayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}
	if payload.MACAddress == "" {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("define mac-address"))
		return
	}

	if err := h.store.DeactivateDevice(payload.MACAddress); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, nil)
}

func (h *Handler) handleOptions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	w.WriteHeader(http.StatusOK)
}
