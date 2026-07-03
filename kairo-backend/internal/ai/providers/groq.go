package providers

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/kairo-app/kairo-backend/internal/models"
)

const groqEndpoint = "https://api.groq.com/openai/v1/chat/completions"

type GroqProvider struct {
	apiKey     string
	model      string
	httpClient *http.Client
}

func NewGroqProvider(apiKey string, defaultModel string) *GroqProvider {
	return &GroqProvider{
		apiKey: apiKey,
		model:  defaultModel,
		httpClient: &http.Client{
			Timeout: 120 * time.Second,
		},
	}
}

type groqRequest struct {
	Model       string           `json:"model"`
	Messages    []models.Message `json:"messages"`
	Temperature float32          `json:"temperature,omitempty"`
	Stream      bool             `json:"stream"`
}

type groqResponse struct {
	ID      string `json:"id"`
	Choices []struct {
		Message struct {
			Role    string `json:"role"`
			Content string `json:"content"`
		} `json:"message"`
	} `json:"choices"`
	Error *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
		Code    string `json:"code"`
	} `json:"error,omitempty"`
}

func (g *GroqProvider) Chat(ctx context.Context, messages []models.Message, modelOverride string) (string, error) {
	modelToUse := g.model
	if modelOverride != "" {
		modelToUse = modelOverride
	}
	reqBody := groqRequest{
		Model:    modelToUse,
		Messages: messages,
		Stream:   false,
	}

	jsonData, err := json.Marshal(reqBody)
	if err != nil {
		return "", fmt.Errorf("failed to marshal request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, groqEndpoint, bytes.NewBuffer(jsonData))
	if err != nil {
		return "", fmt.Errorf("failed to create http request: %w", err)
	}

	req.Header.Set("Authorization", "Bearer "+g.apiKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := g.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to send request to groq: %w", err)
	}
	defer resp.Body.Close()

	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read groq response body: %w", err)
	}

	var gResp groqResponse
	if err := json.Unmarshal(bodyBytes, &gResp); err != nil {
		return "", fmt.Errorf("failed to unmarshal groq response (status %d): %s", resp.StatusCode, string(bodyBytes))
	}

	if gResp.Error != nil {
		return "", fmt.Errorf("groq API error: %s (code: %s)", gResp.Error.Message, gResp.Error.Code)
	}

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("groq returned non-200 status: %d - %s", resp.StatusCode, string(bodyBytes))
	}

	if len(gResp.Choices) == 0 {
		return "", fmt.Errorf("groq returned no choices in completion response")
	}

	return gResp.Choices[0].Message.Content, nil
}
