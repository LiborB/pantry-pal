package database

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"
	"os"
)

var db *gorm.DB

func InitDatabase() {
	connString := fmt.Sprintf("user=%s password=%s host=%s port=%s dbname=%s",
		os.Getenv("DB_USERNAME"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_NAME"))

	dbContext, err := gorm.Open(postgres.New(postgres.Config{
		DSN: connString,
	}))

	if err != nil {
		log.Fatal("Failed to initialise database connection")
	}

	db = dbContext
}
