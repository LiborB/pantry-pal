package product

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
	"io"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/product", common.HouseholdValidator)

	group.POST("/:householdId/detail", productDetail)
}

type productResponse struct {
	Product struct {
		ProductName string `json:"product_name"`
		ImageUrl    string `json:"image_url"`
	} `json:"product"`
	Barcode string `json:"code"`
	Status  int    `json:"status"`
}

type productInfo struct {
	Name string `json:"name"`
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

	resp, err := http.Get(fmt.Sprintf("https://world.openfoodfacts.org/api/v0/product/%s.json", barcode))

	if err != nil {
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	body, err := getJson[productResponse](resp.Body)

	if err != nil {
		log.Printf("Failed to parse response body %#v", body)
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	if body.Status == 0 {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	database.DB.Clauses(clause.OnConflict{UpdateAll: true}).Save(&database.Product{
		Barcode: barcode,
		Name:    body.Product.ProductName,
	})

	var customizedItem database.PantryItemCustomised

	tx := database.DB.Where(&database.PantryItemCustomised{
		HouseholdID: householdId,
		PantryItemDetail: database.Product{
			Barcode: barcode,
		},
	}).First(&customizedItem)

	if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
		c.JSON(200, productInfo{Name: body.Product.ProductName})
	} else {
		c.JSON(200, productInfo{Name: customizedItem.Name})
	}
}

func getJson[T any](body io.ReadCloser) (*T, error) {
	defer body.Close()

	var target T
	err := json.NewDecoder(body).Decode(&target)

	if err != nil {
		return nil, err
	}

	return &target, nil
}
