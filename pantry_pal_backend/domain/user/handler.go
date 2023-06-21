package user

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/user")

	group.POST("", addUser)
	group.PATCH("", updateUser)
	group.GET("", getUser)
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

type updateUserPayload struct {
	FirstName        string `json:"firstName"`
	LastName         string `json:"lastName"`
	OnboardedVersion int    `json:"onboardedVersion"`
}

func updateUser(c *gin.Context) {
	userId := c.GetString("userId")

	var body updateUserPayload
	common.GetJson(c, &body)

	database.DB.Updates(&database.User{
		ID:               userId,
		FirstName:        body.FirstName,
		LastName:         body.LastName,
		OnboardedVersion: body.OnboardedVersion,
	})

	c.Status(http.StatusNoContent)
}

type user struct {
	ID               string `json:"id"`
	FirstName        string `json:"firstName"`
	LastName         string `json:"lastName"`
	OnboardedVersion int    `json:"onboardedVersion"`
	Email            string `json:"email"`
}

func getUser(c *gin.Context) {
	userId := c.GetString("userId")

	dbUser := database.User{
		ID: userId,
	}
	tx := database.DB.First(&dbUser)

	if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
		c.Status(http.StatusNotFound)
		return
	}

	c.JSON(http.StatusOK, user{
		ID:               dbUser.ID,
		FirstName:        dbUser.FirstName,
		LastName:         dbUser.LastName,
		OnboardedVersion: dbUser.OnboardedVersion,
		Email:            dbUser.Email,
	})
}
