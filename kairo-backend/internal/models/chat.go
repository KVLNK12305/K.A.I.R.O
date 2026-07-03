package models

type Message struct {
	Role    string `json:"role" binding:"required"`
	Content string `json:"content" binding:"required"`
}

type ChatRequest struct {
	Messages    []Message `json:"messages" binding:"required,min=1"`
	Model       string    `json:"model,omitempty"`
	Temperature float32   `json:"temperature,omitempty"`
}

type ChatResponse struct {
	Response string `json:"response"`
	Model    string `json:"model"`
}
