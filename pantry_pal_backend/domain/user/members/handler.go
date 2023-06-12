package members

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/user/members")

	group.GET("/user/members", getMembers)
}

type householdMember struct {
	UserId string `json:"userId"`
	Email  string `json:"email"`
	Status string `json:"status"`
}

func getMembers(c *gin.Context) {
	userId := c.GetString("userId")

	var household database.Household
	database.DB.First(&database.Household{
		OwnerUserId: userId,
	}).Find(&household)

	var members []householdMember
	for _, member := range household.Members {
		members = append(members, householdMember{
			UserId: member.MemberUser.UserId,
			Email:  member.MemberUser.Email,
			Status: member.Status,
		})
	}

	c.JSON(http.StatusOK, members)
}
