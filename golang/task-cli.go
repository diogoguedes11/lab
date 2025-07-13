package main

// Marshall serializes json which means transforms my struct data to Json mode
// Unmarshall is the reverse (deserialization)
import (
	"encoding/json"
	"fmt"
	"os"
	"time"
)

type Task struct {
    Id        string `json:"id"`
    Body      string `json:"body"`
    Status    string `json:"status"`
    CreatedAt string `json:"createdAt"`
    UpdatedAt string `json:"updatedAt"`
}

func main() {
    filename := "tasks.json"
    args := os.Args
    // Step 1: Read existing data if file exists
    var tasks []Task
    data, err := os.ReadFile(filename)
    if err == nil && len(data) > 0 {
        // Step 2: Unmarshal JSON array to slice
        if err := json.Unmarshal(data, &tasks); err != nil {
            fmt.Println("Error decoding JSON:", err)
            return
        }
    } else if err != nil && !os.IsNotExist(err) {
        // Real error (not file not exist)
        fmt.Println("Error reading file:", err)
        return
    }

    switch args[1] {
	case "add":
		{
		newTask := Task{
			Id:        fmt.Sprintf("%d", len(tasks)+1), // Auto ID based on length
			Body: 	 string(args[2]),
			Status:    "todo",
			CreatedAt: time.Now().String(),
			UpdatedAt: time.Now().String(),
		}
		tasks = append(tasks, newTask) // Append new task
		// Step 4: Marshal updated slice back to JSON
		updatedData, err := json.MarshalIndent(tasks, "", "  ")
		if err != nil {
			fmt.Println("Error encoding JSON:", err)
			return
		}

		// Step 5: Write JSON back to file (overwrite)
		if err := os.WriteFile(filename, updatedData, 0644); err != nil {
			fmt.Println("Error writing to file:", err)
			return
		}

		fmt.Println("Task added successfully!")
	}

	case "delete":
		idToRemove := args[2]	
		for i, t := range tasks{
			if t.Id == idToRemove{
				tasks = append(tasks[:i],tasks[i+1:]...)
				break
			}
		}	
		updatedFile , err := json.MarshalIndent(tasks,""," ")
		if err == nil {
			os.WriteFile(filename,updatedFile, 0644)	
		}
	}

}