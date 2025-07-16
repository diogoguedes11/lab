package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/tidwall/gjson"
)


func main() {
	args := os.Args
	url := fmt.Sprintf("https://api.github.com/users/%v/events",args[1])
	response, err := http.Get(url)

	if err != nil {
		log.Fatalf("Error fetching data %v", err)
	}
	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		log.Fatalf("Error: received status code: %v", response.StatusCode)
	}
	body,err := io.ReadAll(response.Body)

	if err != nil {
		log.Fatalf("Some error occurred when reading the json content %v",err)
	}

	json := string(body)

	operationType := gjson.Get(json,"#.type")
	author := gjson.Get(json,"#.actor.display_login")
	repo := gjson.Get(json,"#.repo.url")
	fmt.Println(author)
	fmt.Println(repo)
	fmt.Println(operationType)
	

}