package common

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

func GetJson(c *gin.Context, data interface{}) {
	if err := c.BindJSON(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}
}

func ForbiddenError(c *gin.Context, code string) {
	c.JSON(http.StatusForbidden, gin.H{
		"errorCode": code,
	})
}

func IntParam(c *gin.Context, name string) int {
	value := c.Param(name)

	intValue, err := strconv.Atoi(value)

	if err != nil {
		ForbiddenError(c, "INVALID_PARAM")
	}

	return intValue
}
