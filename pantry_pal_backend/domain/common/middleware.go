package common

import (
	"github.com/gin-gonic/gin"
	"pantry_pal_backend/domain/database"
	"strconv"
)

func HouseholdValidator(c *gin.Context) {
	userId := c.GetString("userId")

	householdId, err := strconv.Atoi(c.Param("householdId"))
	if err != nil {
		c.AbortWithStatusJSON(400, "Invalid household id")
		return
	}

	var member *database.HouseholdMember

	database.DB.Where(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      userId,
	}).First(&member)

	if member == nil {
		c.AbortWithStatus(403)
		return
	}

	c.Set("householdId", householdId)
}
