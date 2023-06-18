package database

import "time"

type PantryItem struct {
	ID          int `gorm:"primaryKey"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Name        string
	Barcode     string
	ExpiryDate  int
	Household   Household
	HouseholdID int
	Quantity    int
}

type PantryItemCustomised struct {
	ID           int `gorm:"primaryKey"`
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Name         string
	Household    Household
	HouseholdID  int `gorm:"uniqueIndex:idx_pantry_item_customised"`
	PantryItem   PantryItem
	PantryItemID int `gorm:"uniqueIndex:idx_pantry_item_customised"`
}

type Household struct {
	ID        int `gorm:"primaryKey"`
	CreatedAt time.Time
	UpdatedAt time.Time
	Name      string
	UserID    string
	User      User
	Members   []HouseholdMember
}

type HouseholdMember struct {
	ID          int `gorm:"primaryKey"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	User        User
	UserID      string `gorm:"uniqueIndex:idx_household_member"`
	HouseholdID int    `gorm:"uniqueIndex:idx_household_member"`
	Household   Household
	// Status can be "pending", "accepted"
	Status  string
	IsOwner bool
}

type User struct {
	// This is the user's ID from firebase
	ID        string `gorm:"primaryKey"`
	CreatedAt time.Time
	UpdatedAt time.Time
	Email     string
}
