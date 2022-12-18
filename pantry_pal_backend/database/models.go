package database

import (
	"gorm.io/gorm"
	"time"
)

type PantryItem struct {
	gorm.Model
	Name       string
	UserId     string
	Barcode    *string
	ExpiryDate time.Time
}
