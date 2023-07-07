package database

import "time"

type Product struct {
	ID            int `gorm:"primaryKey"`
	CreatedAt     time.Time
	UpdatedAt     time.Time
	ProductName   string
	Barcode       string `gorm:"uniqueIndex:idx_product"`
	Brand         string
	Quantity      float64
	QuantityUnit  string
	EnergyPer100g float64
}

type PantryItem struct {
	ID             int `gorm:"primaryKey"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
	ProductName    string
	Brand          *string
	Quantity       *float64
	QuantityUnit   *string
	EnergyPer100g  *float64
	Barcode        string
	ExpiryDate     time.Time
	Household      Household
	HouseholdID    int
	ConsumedAt     *time.Time
	DeletedAt      *time.Time
	Product        *Product
	ProductID      *int
	CreatedBy      User `gorm:"foreignKey:CreatedByID"`
	CreatedByID    string
	ExpiryNotified bool
}

type PantryItemCustomised struct {
	ID            int `gorm:"primaryKey"`
	CreatedAt     time.Time
	UpdatedAt     time.Time
	ProductName   string
	Brand         *string
	Quantity      *float64
	QuantityUnit  *string
	EnergyPer100g *float64
	Household     Household
	HouseholdID   int `gorm:"uniqueIndex:idx_pantry_item_customised"`
	Product       Product
	ProductID     int `gorm:"uniqueIndex:idx_pantry_item_customised"`
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
	ID               string `gorm:"primaryKey"`
	CreatedAt        time.Time
	UpdatedAt        time.Time
	Email            string
	FirstName        string
	LastName         string
	OnboardedVersion int
}
