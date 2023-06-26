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
	group := r.Group("/pantry/:householdId", common.HouseholdValidator)

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
	householdId := c.GetInt("householdId")

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
		HouseholdID: householdId,
		Quantity:    1,
	})

	if body.UpdateLocalItem && body.Barcode != "" {
		var pantryItemDetail database.Product

		tx := database.DB.Where(&database.Product{
			Barcode: body.Barcode,
		}).Find(&pantryItemDetail)

		if tx.Error == nil {
			database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
				ID:                 body.Id,
				Name:               body.Name,
				HouseholdID:        householdId,
				PantryItemDetailID: pantryItemDetail.ID,
			})
		} else {
			database.DB.Create(&database.Product{
				Barcode: body.Barcode,
			})
		}
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
		var itemDetail database.Product

		err := database.DB.Where(&database.Product{
			Barcode: body.Barcode,
		}).First(&itemDetail)

		if err.Error == nil {
			database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
				PantryItemDetailID: itemDetail.ID,
				HouseholdID:        c.GetInt("householdId"),
				Name:               body.Name,
			})
		}
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
			CreatedAt:  int(item.CreatedAt.UnixMilli()),
		})
	}

	c.JSON(http.StatusOK, output)
}
