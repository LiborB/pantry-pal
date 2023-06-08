package database

import (
	"gorm.io/gorm"
	"time"
)

type PantryItem struct {
	gorm.Model
	Name       string
	UserId     string
	Barcode    string
	ExpiryDate int
}

type PantryItemCustomised struct {
	Barcode   string `gorm:"primaryKey;autoIncrement:false"`
	Name      string
	UserId    string    `gorm:"primaryKey;autoIncrement:false"`
	CreatedAt time.Time `gorm:"default:current_timestamp"`
	UpdatedAt time.Time `gorm:"default:current_timestamp"`
}

type Household struct {
	OwnerUserId string `gorm:"primaryKey;autoIncrement:false"`
	Name        string
	CreatedAt   time.Time         `gorm:"default:current_timestamp"`
	UpdatedAt   time.Time         `gorm:"default:current_timestamp"`
	Members     []HouseholdMember `gorm:"foreignKey:MemberUserId"`
}

type HouseholdMember struct {
	OwnerUserId  string `gorm:"primaryKey;autoIncrement:false"`
	OwnerEmail   string
	MemberUserId string `gorm:"primaryKey;autoIncrement:false"`
	MemberEmail  string
	Status       string
}
