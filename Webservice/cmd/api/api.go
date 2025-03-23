package api

import (
	"air-controller-webservice/services/device"
	sensorreading "air-controller-webservice/services/sensor-reading"
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

	deviceStore := device.NewStore(s.db)
	deviceHandler := device.NewHandler(deviceStore)
	deviceHandler.RegisterRoutes(router)

	sensorReadingStore := sensorreading.NewStore(s.db)
	sensorReadingHandler := sensorreading.NewHandler(sensorReadingStore, s.db)
	sensorReadingHandler.RegisterRoutes(router)

	log.Println("listening on", s.addr)
	return http.ListenAndServe(s.addr, router)
}
