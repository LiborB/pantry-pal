package common

import (
	"context"
	firebase "firebase.google.com/go"
	"log"
)

var FirebaseApp *firebase.App

func SetupFirebase() {
	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		log.Fatalf("error initializing infra: %v\n", err)

	}

	FirebaseApp = app
}
