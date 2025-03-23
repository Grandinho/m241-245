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
	router.HandleFunc("/device", h.handlePost).Methods("POST")
	router.HandleFunc("/device/request", h.handleGetRequestedDevices).Methods("GET")
	router.HandleFunc("/device/request", h.handleRequest).Methods("POST")
	router.HandleFunc("/device/request/decline", h.handleDeclinedRequest).Methods("POST")
}

func (h *Handler) handleGet(w http.ResponseWriter, r *http.Request) {
	devices, err := h.store.GetDevices()
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
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

	utils.WriteJSON(w, http.StatusCreated, nil)

}

func (h *Handler) handleRequest(w http.ResponseWriter, r *http.Request) {
	var payload types.RequestDevicePayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
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

func (h *Handler) handleDeclinedRequest(w http.ResponseWriter, r *http.Request) {
	var payload types.RequestDevicePayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}
	if payload.MACAddress == "" {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("define mac-address"))
	}

	if err := h.store.DeactivateDevice(payload.MACAddress); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, nil)
}
