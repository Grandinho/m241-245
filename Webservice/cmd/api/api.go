package api

import (
	"air-controller-webservice/services/device"
	"air-controller-webservice/services/user"
	"database/sql"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type APIServer struct {
	addr string
	db   *sql.DB
}

func NewAPIServer(addr string, db *sql.DB) *APIServer {
	return &APIServer{
		addr: addr,
		db:   db,
	}
}

func (s *APIServer) Run() error {
	router := mux.NewRouter()

	userStore := user.NewStore(s.db)
	userHandler := user.NewHandler(userStore)
	userHandler.RegisterRoutes(router)

	deviceHandler := device.NewHandler()
	deviceHandler.RegisterRoutes(router)

	log.Println("listening on", s.addr)
	return http.ListenAndServe(s.addr, router)
}
