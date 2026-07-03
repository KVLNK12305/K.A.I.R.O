package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kairo-app/kairo-backend/internal/ai"
	"github.com/kairo-app/kairo-backend/internal/models"
)

type ChatHandler struct {
	provider ai.AIProvider
	model    string
}

func NewChatHandler(provider ai.AIProvider, defaultModel string) *ChatHandler {
	return &ChatHandler{
		provider: provider,
		model:    defaultModel,
	}
}

func (h *ChatHandler) HandleChat(c *gin.Context) {
	var req models.ChatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format: " + err.Error()})
		return
	}

	respContent, err := h.provider.Chat(c.Request.Context(), req.Messages)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "AI Provider error: " + err.Error()})
		return
	}

	modelUsed := req.Model
	if modelUsed == "" {
		modelUsed = h.model
	}

	c.JSON(http.StatusOK, models.ChatResponse{
		Response: respContent,
		Model:    modelUsed,
	})
}
