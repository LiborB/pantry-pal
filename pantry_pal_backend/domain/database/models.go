package database

import (
	"gorm.io/gorm"
	"time"
)

type PantryItem struct {
	gorm.Model
	Name       string `json:"name"`
	UserId     string `json:"user_id"`
	Barcode    string `json:"barcode"`
	ExpiryDate int    `json:"expiry_date"`
}

type PantryItemCustomised struct {
	Barcode   string `gorm:"primaryKey"`
	Name      string
	UserId    string    `gorm:"primaryKey"`
	CreatedAt time.Time `gorm:"default:current_timestamp"`
	UpdatedAt time.Time `gorm:"default:current_timestamp"`
}
