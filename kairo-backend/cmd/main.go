package main

import (
	"log"

	"github.com/kairo-app/kairo-backend/internal/ai/providers"
	"github.com/kairo-app/kairo-backend/internal/api"
	"github.com/kairo-app/kairo-backend/internal/config"
)

func main() {
	log.Println("Initializing K.A.I.R.O AI Gateway...")

	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	log.Printf("Loaded configuration. Model: %s, Port: %s\n", cfg.Model, cfg.Port)

	// Initialize AI Provider
	groqProvider := providers.NewGroqProvider(cfg.GroqAPIKey, cfg.Model)

	// Initialize API Handlers & Router
	chatHandler := api.NewChatHandler(groqProvider, cfg.Model)
	router := api.SetupRouter(chatHandler)

	log.Printf("Starting K.A.I.R.O AI Gateway on port %s...\n", cfg.Port)
	if err := router.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Server terminated with error: %v", err)
	}
}
