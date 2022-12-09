package product

import (
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io"
	"log"
	"net/http"
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

	c.JSON(http.StatusOK, body)
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
