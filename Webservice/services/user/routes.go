package user

import (
	"air-controller-webservice/config"
	"air-controller-webservice/types"
	"air-controller-webservice/utils"
	"fmt"
	"net/http"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/gorilla/mux"
	"golang.org/x/crypto/bcrypt"
)

type Handler struct {
	store types.UserStore
}

func NewHandler(store types.UserStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/login", h.handleLogin).Methods("POST")
	router.HandleFunc("/login", h.handleOptions).Methods("OPTIONS")
	router.HandleFunc("/register", h.handleRegister).Methods("POST")
	router.HandleFunc("/register", h.handleOptions).Methods("OPTIONS")

}

func (h *Handler) handleLogin(w http.ResponseWriter, r *http.Request) {
	var payload types.LoginUserPayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	user, err := h.store.GetUserByUsername(payload.Username)

	if err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	if user.ID == 0 {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("user or password incorrect"))
		return
	}

	if err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(payload.Password)); err != nil {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("user or password incorrect"))
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": user.ID,
		"exp": time.Now().Add(time.Hour * 24).Unix(),
	})

	tokenString, err := token.SignedString([]byte(config.Envs.Secret))

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, nil)
		return
	}

	loginToken := types.LoginToken{Token: tokenString}
	utils.WriteJSON(w, http.StatusOK, loginToken)
}

func (h *Handler) handleRegister(w http.ResponseWriter, r *http.Request) {
	var payload types.RegisterUserPayload
	if err := utils.ParseJSON(r, &payload); err != nil {
		utils.WriteError(w, 400, err)
		return
	}

	_, err := h.store.GetUserByUsername(payload.Username)
	if err == nil {
		utils.WriteError(w, http.StatusConflict, fmt.Errorf("username %s already exists", payload.Username))
		return
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(payload.Password), 10)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, nil)
	}

	err = h.store.CreateUser(types.User{
		Username: payload.Username,
		Password: string(hashedPassword),
	})

	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusCreated, nil)
}

func (h *Handler) handleOptions(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
	w.WriteHeader(http.StatusOK)
}
