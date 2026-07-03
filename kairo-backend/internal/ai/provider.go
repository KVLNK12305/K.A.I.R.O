package ai

import (
	"context"

	"github.com/kairo-app/kairo-backend/internal/models"
)

type AIProvider interface {
	Chat(ctx context.Context, messages []models.Message, modelOverride string) (string, error)
}
