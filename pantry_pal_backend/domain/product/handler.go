package product

import (
	"errors"
	"github.com/gin-gonic/gin"
	"github.com/openfoodfacts/openfoodfacts-go"
	"gorm.io/gorm/clause"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/product", common.HouseholdValidator)

	group.POST("/:householdId/detail", productDetail)
}

type productInfo struct {
	ProductName   string  `json:"productName"`
	Brand         string  `json:"brand"`
	Quantity      float64 `json:"quantity"`
	QuantityUnit  string  `json:"quantityUnit"`
	EnergyPer100g float64 `json:"energyPer100g"`
}

func productDetail(c *gin.Context) {
	barcode, exists := c.GetQuery("barcode")
	householdId := c.GetInt("householdId")

	if !exists {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Missing barcode query parameter",
		})
		return
	}

	api := openfoodfacts.NewClient("world", "", "")

	product, err := api.Product(barcode)

	if errors.Is(err, openfoodfacts.ErrNoProduct) {
		c.JSON(http.StatusNotFound, gin.H{
			"error": "Product not found",
		})
		return
	}

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Internal server error",
		})
		return
	}

	qtyAmount, qtyUnit := GetUnitAmountParts(product.Quantity)

	database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Save(&database.Product{
		Barcode:       barcode,
		ProductName:   product.ProductName,
		Brand:         product.Brands,
		EnergyPer100g: product.Nutriments.Energy100G,
		Quantity:      qtyAmount,
		QuantityUnit:  qtyUnit,
	})

	var customizedItem database.PantryItemCustomised

	tx := database.DB.Where(&database.PantryItemCustomised{
		HouseholdID: householdId,
		Product: database.Product{
			Barcode: barcode,
		},
	}).First(&customizedItem)

	response := productInfo{
		Quantity:      qtyAmount,
		QuantityUnit:  qtyUnit,
		EnergyPer100g: product.Nutriments.Energy100G,
		Brand:         product.Brands,
		ProductName:   product.ProductName,
	}

	if tx.Error == nil {
		response.ProductName = customizedItem.ProductName
	}

	c.JSON(200, response)
}
