package main // group of files

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"
)

//  {"page":"words","input":"word1","words":["word1"]}
type Words struct {
	Page  string   `json:"page"` // we look for the page attribute
	Input string   `json:"input"` // we look for the input attribute
	Words []string `json:"words"` // we look for the words attribute
}

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
	if resp.StatusCode != 200 {
		fmt.Printf("Error: HTTP request failed with status code %v\n", resp.StatusCode)
		os.Exit(1)
	}

	var words Words
	err = json.Unmarshal(body, &words) // Unmarshal JSON response into Words struct
	if err != nil {
		log.Fatalf("Error unmarshalling JSON response: %v", err)
	}
	fmt.Printf("Json parsed:\nPage: %s\nInput: %s\nWords: %v\n", words.Page, words.Input, strings.Join(words.Words, ", "))
	fmt.Printf("HTTP Response status: %s\n", resp.Status)
}

