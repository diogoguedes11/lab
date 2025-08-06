package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
)

type LoginRequest struct {
	Password string `json:"password"`
}
type LoginResponse struct {
	Token string `json:"token"`
}

func loginRequest(client http.Client, loginUrl string, password string) (string, error) {

	loginRequest := LoginRequest{
		Password: password,
	}

	respBody, err := json.Marshal(loginRequest) // Convert the login request to JSON

	if err != nil {
		return "", RequestError{
			HTTPCode: 500,
			Body:     fmt.Sprintf("error marshalling login request: %v", err),
			Err:      "Internal Server Error",
		}
	}
	if _, err := url.ParseRequestURI(loginUrl); err != nil {
		return "", RequestError{
			HTTPCode: 400,
			Body:     fmt.Sprintf("invalid URL: %v", err),
			Err:      "Bad Request",
		}
	}
	fmt.Println("Valid URL:", loginUrl)
	token, err := client.Post(loginUrl, "application/json", bytes.NewBuffer(respBody)) // Make a POST request with the JSON body

	if err != nil {
		return "", RequestError{
			HTTPCode: 500,
			Body:     fmt.Sprintf("error making HTTP POST request: %v", err),
			Err:      "Internal Server Error",
		}
	}
	
	defer token.Body.Close()

	var loginResponse LoginResponse

	respBody, err = io.ReadAll(token.Body)

	if err != nil {
		log.Printf("Error reading response body: %v", err)
		return "", err
	}
	if err := json.Unmarshal(respBody, &loginResponse); err != nil {
		log.Printf("Error unmarshalling response body: %v", err)
		return "", err
	}
	
	if loginResponse.Token == "" {
		return "", RequestError{
			HTTPCode: token.StatusCode,
			Body:     string(respBody),
			Err:      "Login Failed",
		}
	}
	return loginResponse.Token, nil
}
