package product

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io"
	"log"
	"net/http"
	"pantry_pal_backend/domain/database"
)

func AddRoutes(r *gin.Engine) {
	group := r.Group("/product")

	group.GET("/detail", productDetail)
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

	customItem := database.PantryItemCustomised{
		UserId:  c.GetString("userId"),
		Barcode: barcode,
	}

	result := database.DB.First(&customItem)
	var info productInfo

	if result.Error == nil {
		info = productInfo{Name: customItem.Name}
	} else {
		info = productInfo{Name: body.Product.ProductName}
	}

	c.JSON(http.StatusOK, info)
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
