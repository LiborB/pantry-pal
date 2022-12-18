package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"pantry_pal_backend/database"
	"pantry_pal_backend/pantry"
	"pantry_pal_backend/product"
	"strings"

	firebase "firebase.google.com/go"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	database.InitDatabase()

	r := gin.Default()

	setupAuth(r)

	err = r.SetTrustedProxies(nil)

	if err != nil {
		log.Fatal(err)
	}

	pantry.AddRoutes(r)
	product.AddRoutes(r)

	err = r.Run(os.Getenv("URL"))

	if err != nil {
		log.Fatal(err)
	}
}

func setupAuth(engine *gin.Engine) {
	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	engine.Use(func(c *gin.Context) {
		client, err := app.Auth(c)
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
