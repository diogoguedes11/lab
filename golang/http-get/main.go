package main // group of files

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
)



func (w Words) getResponse() string {
	return fmt.Sprintf("Page: %s, Input: %s, Words: %v", w.Page, w.Input, w.Words)
}



func (o Occurrence) getResponse() string { //overloading, we use the same function name but different types
	fmt.Printf("Contents:\nPage name: %s\n",o.Page)
	fmt.Printf("Words:\n")
	for word,occurrence := range(o.Words) {
		fmt.Printf("- %s: %d\n", word,occurrence)
	}
	return fmt.Sprintf("Page: %s, Words: %v", o.Page, o.Words)
}


func doRequest(client http.Client, requestUrl string) (Response, error) {
	if _, err := url.ParseRequestURI(requestUrl); err != nil {
		return nil, RequestError{
			HTTPCode: 400,
			Body:     fmt.Sprintf("invalid URL: %v", err),
			Err:      "Bad Request",
		}
	}
	fmt.Println("Valid URL:", requestUrl)
	resp, err := client.Get(requestUrl)
	if err != nil {
		return nil, RequestError{
			HTTPCode: 500,
			Body:     fmt.Sprintf("error making HTTP GET request: %v", err),
			Err:      "Internal Server Error",
		}
	}
	defer resp.Body.Close() // Ensure the response body is closed after reading

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, RequestError{
			HTTPCode: 500,
			Body:     fmt.Sprintf("error reading response body: %v", err),
			Err:      "Internal Server Error",
		}
	}
		if resp.StatusCode != 200 {
			return nil, RequestError{
				HTTPCode: resp.StatusCode,
				Body:     string(body),
				Err:      fmt.Sprintf("unexpected HTTP status code: %d", resp.StatusCode),
			}
		}

		var page Page
		
		err = json.Unmarshal(body, &page) 
		
		
		switch(page.Name) {
			case "words":
				var words Words
				err := json.Unmarshal(body,&words)
				if err != nil {
					return nil, RequestError{
						HTTPCode: resp.StatusCode,
						Body:     string(body),
						Err:      fmt.Sprintf("words: error unmarshalling json response: %v", err),
					}
				}
				return words, nil
			case "occurrence":
				var occurrence Occurrence
				err := json.Unmarshal(body,&occurrence)
				if err != nil {
					return nil, RequestError{
						HTTPCode: resp.StatusCode,
						Body:     string(body),
						Err:      fmt.Sprintf("occurrence: error unmarshalling json response: %v", err),
					}
				}
				
				return occurrence, nil
		}

		if err != nil {
			return nil, RequestError{
				HTTPCode: resp.StatusCode,
				Body:     string(body),
				Err:      fmt.Sprintf("error unmarshalling json response: %v", err),
			}
		}
	return nil,nil
}

func main() {
	var (
		requestUrl string
		password string
		parsedUrl *url.URL
		err error
	)
	flag.StringVar(&requestUrl, "url", "", "URL to make the HTTP GET request to")
	flag.StringVar(&password, "password", "", "Password for authentication")
	flag.Parse()

	parsedUrl, err = url.ParseRequestURI(requestUrl) // Checks if the URL is valid
	client := http.Client{}
	if err != nil {
		log.Fatalf("Invalid URL: %v\n Usage: go run http-get.go -h ", err)
	}
	if password != "" {
		token, err := loginRequest(client,parsedUrl.Scheme+"://"+parsedUrl.Host+"/login", password)
		if err != nil {
			if reqErr, ok := err.(RequestError); ok {
				fmt.Printf("RequestError: %s", reqErr.Error())
			}
			return
		}
		client.Transport = MyJWTTransport{
			Token: token,
		}
		fmt.Println("Token:", token)
		res,err := doRequest(client, parsedUrl.String()) // Call the doRequest function with the provided URL argument
		if err != nil {
			if reqErr, ok := err.(RequestError); ok {
				fmt.Printf("RequestError: %s", reqErr.Error())
			}
			return
		}
		if res != nil {
			fmt.Println(res.getResponse()) 
		}
	}
	if password == "" {
		res, err := doRequest(client,parsedUrl.String()) // Call the doRequest function with the provided URL argument
		if err != nil {
			if reqErr, ok := err.(RequestError); ok {
				fmt.Printf("RequestError: %s", reqErr.Error())
			}
		}
		if res != nil {
			fmt.Println(res.getResponse()) 
		}
	}	
}

