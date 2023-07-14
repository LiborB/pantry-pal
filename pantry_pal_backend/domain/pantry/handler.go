package pantry

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm/clause"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
	"time"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/pantry/:householdId", common.HouseholdValidator)

	group.POST("", addItem)
	group.GET("", getItems)
	group.POST("/update", updateItem)
}

type updateItemPayload struct {
	Id              int      `json:"id"`
	ProductName     string   `json:"productName"`
	ExpiryDate      int      `json:"expiryDate"`
	Barcode         string   `json:"barcode"`
	UpdateLocalItem bool     `json:"updateLocalItem"`
	Brand           *string  `json:"brand"`
	Quantity        *float64 `json:"quantity"`
	QuantityUnit    *string  `json:"quantityUnit"`
	EnergyPer100g   *float64 `json:"energyPer100g"`
}

func addItem(c *gin.Context) {
	var body updateItemPayload
	householdId := c.GetInt("householdId")
	userId := c.GetString("userId")

	log.Println(body)

	if err := c.BindJSON(&body); err != nil {
		log.Println(err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid body",
		})
		return
	}

	pantryItem := database.PantryItem{
		ProductName:   body.ProductName,
		ExpiryDate:    time.Unix(int64(body.ExpiryDate), 0).UTC(),
		Barcode:       body.Barcode,
		HouseholdID:   householdId,
		Quantity:      body.Quantity,
		QuantityUnit:  body.QuantityUnit,
		EnergyPer100g: body.EnergyPer100g,
		CreatedByID:   userId,
	}

	var product database.Product
	tx := database.DB.Where(&database.Product{
		Barcode: body.Barcode,
	}).First(&product)

	if tx.Error == nil {
		pantryItem.ProductID = &product.ID
	}

	database.DB.Create(&pantryItem)

	if body.UpdateLocalItem && body.Barcode != "" {
		var pantryItemDetail database.Product

		tx := database.DB.Where(&database.Product{
			Barcode: body.Barcode,
		}).Find(&pantryItemDetail)

		if tx.Error == nil {
			database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
				ID:            body.Id,
				ProductName:   body.ProductName,
				Brand:         body.Brand,
				HouseholdID:   householdId,
				ProductID:     pantryItemDetail.ID,
				Quantity:      body.Quantity,
				QuantityUnit:  body.QuantityUnit,
				EnergyPer100g: body.EnergyPer100g,
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

	pantryItem.ProductName = body.ProductName
	pantryItem.Brand = body.Brand
	pantryItem.ExpiryDate = time.Unix(int64(body.ExpiryDate), 0).UTC()
	pantryItem.Barcode = body.Barcode

	database.DB.Save(&pantryItem)

	if body.UpdateLocalItem && body.Barcode != "" {
		var itemDetail database.Product

		err := database.DB.Where(&database.Product{
			Barcode: body.Barcode,
		}).First(&itemDetail)

		if err.Error == nil {
			database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Create(&database.PantryItemCustomised{
				ProductID:   itemDetail.ID,
				HouseholdID: c.GetInt("householdId"),
				ProductName: body.ProductName,
				Brand:       body.Brand,
			})
		}
	}

	c.Status(http.StatusNoContent)
}

type pantryItem struct {
	Id            int      `json:"id"`
	ProductName   string   `json:"productName"`
	Brand         *string  `json:"brand"`
	ExpiryDate    int64    `json:"expiryDate"`
	Barcode       string   `json:"barcode"`
	CreatedAt     int64    `json:"createdAt"`
	DeletedAt     *int64   `json:"deletedAt"`
	Quantity      *float64 `json:"quantity"`
	QuanityUnit   *string  `json:"quantityUnit"`
	EnergyPer100g *float64 `json:"energyPer100g"`
}

func getItems(c *gin.Context) {
	householdId := c.GetInt("householdId")

	var items []database.PantryItem
	database.DB.Where(&database.PantryItem{
		HouseholdID: householdId,
	}).Find(&items)

	output := []pantryItem{}
	for _, item := range items {
		var deletedAt *int64 = nil
		if item.DeletedAt != nil {
			d := item.DeletedAt.UnixMilli()
			deletedAt = &d
		}

		output = append(output, pantryItem{
			ProductName:   item.ProductName,
			Brand:         item.Brand,
			Id:            item.ID,
			ExpiryDate:    item.ExpiryDate.Unix(),
			Barcode:       item.Barcode,
			CreatedAt:     item.CreatedAt.UnixMilli(),
			DeletedAt:     deletedAt,
			Quantity:      item.Quantity,
			QuanityUnit:   item.QuantityUnit,
			EnergyPer100g: item.EnergyPer100g,
		})
	}

	c.JSON(http.StatusOK, output)
}
