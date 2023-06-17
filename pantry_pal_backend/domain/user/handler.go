package user

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/user")

	group.POST("", addUser)
}

func addUser(c *gin.Context) {
	userId := c.GetString("userId")

	client, err := common.FirebaseApp.Auth(c)
	if err != nil {
		log.Fatalf("error getting Auth client: %v\n", err)
	}

	user, err := client.GetUser(c, userId)
	if err != nil {
		c.Status(http.StatusForbidden)
		return
	}

	database.DB.Create(&database.User{
		ID:    userId,
		Email: user.Email,
	})

	c.Status(http.StatusOK)
}
