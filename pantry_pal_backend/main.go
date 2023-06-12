package main

import (
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
	"pantry_pal_backend/domain/pantry"
	"pantry_pal_backend/domain/product"
	"pantry_pal_backend/domain/user"
	"pantry_pal_backend/domain/user/members"
	"strings"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	database.InitDatabase()

	r := gin.Default()
	r.Use(errorHandler)

	setupAuth(r)

	err = r.SetTrustedProxies(nil)

	if err != nil {
		log.Fatal(err)
	}

	pantry.AddRoutes(r)
	product.AddRoutes(r)
	members.AddRoutes(r)
	user.AddRoutes(r)

	err = r.Run(os.Getenv("URL"))

	if err != nil {
		log.Fatal(err)
	}
}

func setupAuth(engine *gin.Engine) {
	common.SetupFirebase()

	engine.Use(func(c *gin.Context) {
		client, err := common.FirebaseApp.Auth(c)
		if err != nil {
			log.Fatalf("error getting Auth client: %v\n", err)
		}

		jwt := strings.Split(c.GetHeader("Authorization"), " ")

		if len(jwt) != 2 {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		token, err := client.VerifyIDToken(c, jwt[1])
		if err != nil {
			log.Printf("error verifying ID token: %v\n", err)
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}

		c.Set("userId", token.Subject)

		c.Next()
	})
}

func errorHandler(c *gin.Context) {
	c.Next()

	for _, err := range c.Errors {
		log.Println(err.Error())
	}
}
