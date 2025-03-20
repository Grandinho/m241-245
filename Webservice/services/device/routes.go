package device

import (
	"net/http"

	"github.com/gorilla/mux"
)

type Handler struct {
}

func NewHandler() *Handler {
	return &Handler{}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("device/", h.handleGet).Methods("GET")
}

func (h *Handler) handleGet(w http.ResponseWriter, r *http.Request) {

}
