package pantry

import (
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
	"pantry_pal_backend/domain/database"
	"time"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/pantry")

	group.POST("", addItem)
	group.GET("", getItems)
}

type addItemPayload struct {
	Name       string    `json:"name"`
	ExpiryDate time.Time `json:"expiryDate"`
}

func addItem(c *gin.Context) {
	var body addItemPayload

	if err := c.BindJSON(&body); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}

	database.DB.Create(database.PantryItem{
		Name:       body.Name,
		UserId:     c.GetString("userId"),
		ExpiryDate: body.ExpiryDate,
	})

	c.Status(http.StatusNoContent)
}

type pantryItem struct {
	ID         int       `json:"id"`
	Name       string    `json:"name"`
	CreatedAt  time.Time `json:"createdAt"`
	ExpiryDate time.Time `json:"expiryDate"`
}

func getItems(c *gin.Context) {
	userId := c.GetString("userId")

	var items []database.PantryItem
	database.DB.Where(&database.PantryItem{
		UserId: userId,
	}).Find(&items)

	res := []pantryItem{}

	for _, item := range items {
		res = append(res, pantryItem{
			ID:        int(item.ID),
			Name:      item.Name,
			CreatedAt: item.CreatedAt,
		})
	}

	c.JSON(http.StatusOK, res)
}
