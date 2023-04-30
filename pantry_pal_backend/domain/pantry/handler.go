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
	group.PATCH("", updateItem)
}

type updateItemPayload struct {
	Id              int    `json:"id"`
	Name            string `json:"name"`
	ExpiryDate      int    `json:"expiryDate"`
	Barcode         string `json:"barcode"`
	UpdateLocalItem bool   `json:"updateLocalItem"`
}

func addItem(c *gin.Context) {
	var body updateItemPayload

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
		Barcode:    body.Barcode,
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

func updateItem(c *gin.Context) {
	var body updateItemPayload

	if err := c.BindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}

	var pantryItem database.PantryItem

	tx := database.DB.Find(&pantryItem, body.Id)

	if tx.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Item not found",
		})
		return
	}

	pantryItem.Name = body.Name
	pantryItem.ExpiryDate = body.ExpiryDate
	pantryItem.Barcode = body.Barcode

	database.DB.Save(&pantryItem)

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
	Id         int    `json:"id"`
	Name       string `json:"name"`
	ExpiryDate int    `json:"expiryDate"`
	Barcode    string `json:"barcode"`
	CreatedAt  int    `json:"createdAt"`
}

func getItems(c *gin.Context) {
	userId := c.GetString("userId")

	var items []database.PantryItem
	database.DB.Where(&database.PantryItem{
		UserId: userId,
	}).Find(&items)

	output := []pantryItem{}
	for _, item := range items {
		output = append(output, pantryItem{
			Name:       item.Name,
			Id:         int(item.ID),
			ExpiryDate: item.ExpiryDate,
			Barcode:    item.Barcode,
			CreatedAt:  int(item.CreatedAt.Unix()),
		})
	}

	c.JSON(http.StatusOK, output)
}
