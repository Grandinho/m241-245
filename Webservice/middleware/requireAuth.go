package middleware

import (
	"air-controller-webservice/config"
	"air-controller-webservice/utils"
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/golang-jwt/jwt/v4"
)

func RequireAuth() func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				utils.WriteError(w, http.StatusUnauthorized, errors.New("authorization header is required"))
				return
			}

			tokenParts := strings.Split(authHeader, " ")
			fmt.Println(tokenParts)
			fmt.Println(len(tokenParts))
			fmt.Println(tokenParts[0])
			if len(tokenParts) != 2 || tokenParts[0] != "Bearer" {
				utils.WriteError(w, http.StatusUnauthorized, errors.New("invalid authorization format"))
				return
			}

			tokenString := tokenParts[1]

			token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
				return []byte(config.Envs.Secret), nil
			}, jwt.WithValidMethods([]string{jwt.SigningMethodHS256.Alg()}))

			if err != nil {
				utils.WriteError(w, http.StatusUnauthorized, errors.New("invalid token"))
				return
			}

			if _, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
				next.ServeHTTP(w, r)
				return
			}

			utils.WriteError(w, http.StatusUnauthorized, errors.New("invalid token claims"))
		})
	}
}
