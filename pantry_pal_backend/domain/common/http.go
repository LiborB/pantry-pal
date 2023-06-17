package common

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetJson(c *gin.Context, data interface{}) {
	if err := c.BindJSON(data); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}
}
