// go build task-cli.go to create the binary
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
)

type Message struct {
	Id string `json:"id"`
	Body string `json:"body"`
}

func main() {
	
	message := Message{
		Id: "1",
		Body: "test",
	}
	file, err := os.Create("tasks.json")

	// nil means zero errors, nothing.
	if err != nil {
		fmt.Println("Errro creating the file %v",err)
	}
	defer file.Close() // delays the execution of the function until the function returns.
	args := os.Args
	encoder := json.NewEncoder(file)


	if args[1] == "add" {
		
	
		err = encoder.Encode(message)

		if err != nil {
			log.Fatalf("Error writing file %v",err)
		}
		fmt.Println("Added the text to the file")
	}
	if args[1] == "update" {
		fmt.Print("update command")
	}
}