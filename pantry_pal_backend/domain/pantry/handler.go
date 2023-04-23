package pantry

import (
	"gorm.io/gorm/clause"
	"log"
	"net/http"
	"pantry_pal_backend/domain/database"

	"github.com/gin-gonic/gin"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/pantry")

	group.POST("", addItem)
	group.GET("", getItems)
}

type addItemPayload struct {
	Name            string `json:"name"`
	ExpiryDate      int    `json:"expiryDate"`
	UpdateLocalItem bool   `json:"updateLocalItem"`
	Barcode         string `json:"barcode"`
}

func addItem(c *gin.Context) {
	var body addItemPayload

	log.Println(body)

	if err := c.BindJSON(&body); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}

	database.DB.Create(&database.PantryItem{
		Name:       body.Name,
		UserId:     c.GetString("userId"),
		ExpiryDate: body.ExpiryDate,
	})

	if body.UpdateLocalItem && body.Barcode != "" {
		database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
			Barcode: body.Barcode,
			UserId:  c.GetString("userId"),
			Name:    body.Name,
		})
	}

	c.Status(http.StatusNoContent)
}

type pantryItem struct {
	ID         int    `json:"id"`
	Name       string `json:"name"`
	CreatedAt  int    `json:"createdAt"`
	ExpiryDate int    `json:"expiryDate"`
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
			ID:         int(item.ID),
			Name:       item.Name,
			CreatedAt:  int(item.CreatedAt.UnixMilli()),
			ExpiryDate: item.ExpiryDate,
		})
	}

	c.JSON(http.StatusOK, res)
}
