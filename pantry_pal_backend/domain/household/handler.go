package household

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	r.POST("/household", createHousehold)

	group := r.Group("/household/:householdId", common.HouseholdValidator)

	group.GET("/members", getMembers)
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

	database.DB.Where(database.HouseholdMember{HouseholdID: householdId})

	var output []householdMember
	for _, member := range dbMembers {
		output = append(output, householdMember{
			UserId: member.UserID,
			Email:  member.User.Email,
			Status: member.Status,
		})
	}

	c.JSON(http.StatusOK, output)
}

type createHouseholdPayload struct {
	Name string `json:"name"`
}

func createHousehold(c *gin.Context) {
	userId := c.GetString("userId")

	var body createHouseholdPayload
	common.GetJson(c, &body)

	database.DB.Create(&database.Household{
		UserID: userId,
		Name:   body.Name,
	})

	c.Status(http.StatusNoContent)
}
