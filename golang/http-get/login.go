package main

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
)


func loginRequest(requestUrl string, password string) (*http.Response, error) {
	if _, err := url.ParseRequestURI(requestUrl); err != nil {
		return nil, RequestError{
			HTTPCode: 400,
			Body:     fmt.Sprintf("invalid URL: %v", err),
			Err:      "Bad Request",
		}
	}
	fmt.Println("Valid URL:", requestUrl)
	requestBody := strings.NewReader(fmt.Sprintf(`{"password": %q}`, password))
	resp, err := http.Post(requestUrl, "application/json", requestBody)
	return resp, err

}
