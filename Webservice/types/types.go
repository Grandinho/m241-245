package types

import "time"

type UserStore interface {
	GetUserByUsername(username string) (*User, error)
	GetUserByID(id int) (*User, error)
	CreateUser(User) error
}

type User struct {
	ID        int       `json:"id"`
	Username  string    `json:"username"`
	Password  string    `json:"password"`
	CreatedAt time.Time `json:"createdAt"`
}

type RegisterUserPayload struct {
	Username string `json:"username"`
	Password string `json:"password"`
}
