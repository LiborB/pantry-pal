package pantry

import (
	"context"
	"firebase.google.com/go/messaging"
	"fmt"
	"log"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
	"strconv"
)

func HandleExpiryNotifications() {
	var items []database.PantryItem

	database.DB.Where("expiry_date > current_date - 3 AND expiry_notified = false").Find(&items)

	for _, item := range items {
		go processItem(item)
	}
}

func processItem(item database.PantryItem) {
	ctx := context.Background()
	client, err := common.FirebaseApp.Messaging(ctx)

	if err != nil {
		println(err)
		return
	}

	message := &messaging.Message{
		Topic: fmt.Sprintf("notification.expiry.%d", item.HouseholdID),
		Data: map[string]string{
			"item_id":      strconv.Itoa(item.ID),
			"household_id": strconv.Itoa(item.HouseholdID),
		},
		Notification: &messaging.Notification{
			Title: "Expiry Notification",
			Body:  "Your " + item.ProductName + " is expiring soon!",
		},
	}

	_, err = client.Send(ctx, message)

	if err != nil {
		println(err)
		return
	}

	item.ExpiryNotified = true
	database.DB.Save(&item)

	log.Printf("Sent notification for item %d and household id %d", item.ID, item.HouseholdID)
}
