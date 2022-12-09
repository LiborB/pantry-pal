package pantry

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/pantry")

	group.POST("/", addItem)
	group.GET("/", getItems)
}

func addItem(c *gin.Context) {
	log.Printf(c.GetString("test"))

	c.JSON(http.StatusOK, gin.H{
		"name": "libor",
	})
}

func getItems(c *gin.Context) {
	val := c.GetString("userId")

	c.JSON(http.StatusOK, gin.H{
		"test": val,
	})
}
