package main

import (
	"air-controller-webservice/cmd/api"
	"air-controller-webservice/config"
	"air-controller-webservice/db"
	"database/sql"
	"log"

	"github.com/go-sql-driver/mysql"
)

func main() {
	db, err := db.NewMariaDBStorage(mysql.Config{
		User:                 config.Envs.DBUser,
		Passwd:               config.Envs.DBPassword,
		Addr:                 config.Envs.DBAddress,
		DBName:               config.Envs.DBName,
		Net:                  "tcp",
		AllowNativePasswords: true,
		ParseTime:            true,
	})
	initStorage(db)
	if err != nil {
		log.Fatal(err)
	}
	server := api.NewAPIServer(":8080", db)
	if err := server.Run(); err != nil {
		log.Fatal(err)
	}
}

func initStorage(db *sql.DB) {
	if err := db.Ping(); err != nil {
		log.Fatal(nil)
	}

	log.Println("DB: Sucessfully connected")
}
