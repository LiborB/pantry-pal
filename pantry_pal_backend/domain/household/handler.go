package household

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	r.POST("/household", createHousehold)
	r.GET("/household", getHouseholds)

	group := r.Group("/household/:householdId/members", common.HouseholdValidator)

	group.GET("", getMembers)
	group.POST("", addMember)
}

type householdMember struct {
	UserId  string `json:"userId"`
	Email   string `json:"email"`
	Status  string `json:"status"`
	IsOwner bool   `json:"isOwner"`
}

func getMembers(c *gin.Context) {
	householdId := c.GetInt("householdId")

	var dbMembers []database.HouseholdMember

	database.DB.Where(database.HouseholdMember{HouseholdID: householdId}).Joins("User").Find(&dbMembers)

	output := []householdMember{}
	for _, member := range dbMembers {
		output = append(output, householdMember{
			UserId:  member.UserID,
			Email:   member.User.Email,
			Status:  member.Status,
			IsOwner: member.IsOwner,
		})
	}

	c.JSON(http.StatusOK, output)
}

type addMemberPayload struct {
	Email string `json:"email"`
}

func addMember(c *gin.Context) {
	householdId := c.GetInt("householdId")

	var body addMemberPayload
	common.GetJson(c, &body)

	var user database.User
	tx := database.DB.Where(&database.User{Email: body.Email}).First(&user)

	if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
		c.Status(http.StatusNotFound)
		return
	}

	var member database.HouseholdMember
	tx = database.DB.Where(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      user.ID,
	}).First(&member)

	if tx.Error == nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code": "member_exists",
		})
		return
	}

	database.DB.Create(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      user.ID,
		Status:      "pending",
		IsOwner:     false,
	})

	c.Status(http.StatusNoContent)
}

type createHouseholdPayload struct {
	Name string `json:"name"`
}

func createHousehold(c *gin.Context) {
	userId := c.GetString("userId")

	var body createHouseholdPayload
	common.GetJson(c, &body)

	household := database.Household{
		UserID: userId,
		Name:   body.Name,
	}
	database.DB.Create(&household)

	database.DB.Create(&database.HouseholdMember{
		HouseholdID: household.ID,
		UserID:      userId,
		Status:      "accepted",
		IsOwner:     true,
	})

	c.Status(http.StatusNoContent)
}

type household struct {
	Id   int    `json:"id"`
	Name string `json:"name"`
}

func getHouseholds(c *gin.Context) {
	userId := c.GetString("userId")

	var households []database.Household

	database.DB.Where(&database.Household{UserID: userId}).Find(&households)

	output := []household{}

	for _, h := range households {
		output = append(output, household{
			Id:   h.ID,
			Name: h.Name,
		})
	}

	c.JSON(http.StatusOK, output)
}
