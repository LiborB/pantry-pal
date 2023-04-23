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
	ExpiryDate int
}

type PantryItemCustomised struct {
	Barcode   string `gorm:"primaryKey"`
	Name      string
	UserId    string    `gorm:"primaryKey"`
	CreatedAt time.Time `gorm:"default:current_timestamp"`
	UpdatedAt time.Time `gorm:"default:current_timestamp"`
}
