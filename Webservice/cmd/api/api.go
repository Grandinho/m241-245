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
	router.Use(enableCORS)

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
	log.Println("Adjusted ports")
	return http.ListenAndServe(s.addr, router)
}

func enableCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type, Accept")
		w.Header().Set("Access-Control-Allow-Credentials", "true")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}
