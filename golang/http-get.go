package main // group of files

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
)

func main() {
	args := os.Args
	if len(args) < 2 {
		fmt.Println("Usage: go run http-get.go <url>")
		fmt.Println("No arguments provided")
		os.Exit(1)
	}
	if _, err := url.ParseRequestURI(args[1]); err != nil {
		fmt.Printf("Invalid URL format: %s\n", err)
		fmt.Println("Usage: go run http-get.go <url>")
		os.Exit(1)
	}
	fmt.Println("Valid URL:", args[1])
	resp, err := http.Get(args[1])
	if err != nil {
		log.Fatalf("Error fetching URL: %v", err)
	}
	defer resp.Body.Close() // Ensure the response body is closed after reading

	body, err := io.ReadAll(resp.Body) 
	if err != nil {
		log.Fatalf("Error reading response body: %v", err)
	}

	fmt.Printf("Response body: %s\n", body)
	fmt.Printf("HTTP Response status: %s\n", resp.Status)
}

