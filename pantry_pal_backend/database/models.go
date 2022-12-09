package database

import "gorm.io/gorm"

type PantryItem struct {
	gorm.Model
	Name    string
	UserId  string
	Barcode *string
}
