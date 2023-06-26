package common

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
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

	var member database.HouseholdMember

	tx := database.DB.Where(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      userId,
		Status:      "accepted",
	}).First(&member)

	if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
		c.AbortWithStatus(403)
		return
	}

	c.Set("householdId", householdId)
}
