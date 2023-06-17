package pantry

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm/clause"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/pantry", common.HouseholdValidator)

	group.POST("/:householdId", addItem)
	group.GET("/:householdId", getItems)
	group.PATCH("/:householdId", updateItem)
}

type updateItemPayload struct {
	Id              int    `json:"id"`
	Name            string `json:"name"`
	ExpiryDate      int    `json:"expiryDate"`
	Barcode         string `json:"barcode"`
	UpdateLocalItem bool   `json:"updateLocalItem"`
	HouseholdId     int    `json:"householdId"`
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
		Name:        body.Name,
		ExpiryDate:  body.ExpiryDate,
		Barcode:     body.Barcode,
		HouseholdID: body.HouseholdId,
		Quantity:    1,
	})

	if body.UpdateLocalItem && body.Barcode != "" {
		database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
			ID:          body.Id,
			Name:        body.Name,
			HouseholdID: body.HouseholdId,
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
			PantryItemID: body.Id,
			HouseholdID:  body.HouseholdId,
			Name:         body.Name,
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
	householdId := c.GetInt("householdId")

	var items []database.PantryItem
	database.DB.Where(&database.PantryItem{
		HouseholdID: householdId,
	}).Find(&items)

	output := []pantryItem{}
	for _, item := range items {
		output = append(output, pantryItem{
			Name:       item.Name,
			Id:         item.ID,
			ExpiryDate: item.ExpiryDate,
			Barcode:    item.Barcode,
			CreatedAt:  item.CreatedAt,
		})
	}

	c.JSON(http.StatusOK, output)
}
