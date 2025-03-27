package config

import (
	"fmt"
	"os"
)

type Config struct {
	PublicHost string
	Port       string
	DBUser     string
	DBPassword string
	DBAddress  string
	DBName     string
}

var Envs = initConfig()

func initConfig() Config {
	return Config{
		PublicHost: getEnv("PUBLIC_HOST", "http://localhost"),
		Port:       getEnv("WEBSERVICE_PORT", "8080"),
		DBUser:     getEnv("DB_USER", "root"),
		DBPassword: getEnv("DB_PASSWORD", "secret"),
		DBAddress:  fmt.Sprintf("%s:%s", getEnv("DB_HOST", "mariadb"), getEnv("DB_PORT", "3306")),
		DBName:     getEnv("DB_NAME", "air_controller_db"),
	}
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		fmt.Print("Key " + value)
		return value
	}
	return fallback
}
