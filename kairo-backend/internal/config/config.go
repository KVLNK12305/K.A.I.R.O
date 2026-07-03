package config

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	GroqAPIKey string
	Port       string
	Model      string
}

func LoadConfig() (*Config, error) {
	// Attempt to load .env file if it exists
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found or error reading it, relying on environment variables")
	}

	apiKey := os.Getenv("GROQ_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("GROQ_API_KEY environment variable is required")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	model := os.Getenv("MODEL")
	if model == "" {
		model = "openai/gpt-oss-120b"
	}

	return &Config{
		GroqAPIKey: apiKey,
		Port:       port,
		Model:      model,
	}, nil
}
