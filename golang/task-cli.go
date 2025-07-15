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


func deleteRecord(id string,tasks []Task,filename string ) []Task {
	idToRemove := id	
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
	return tasks
}

func updateRecord(id string, body string, tasks []Task, filename string) []Task {
	for _ , t := range tasks {
			if id == t.Id {
				
				updatedTask := Task{
					Id:        t.Id, // Auto ID based on length
					Body: 	 body,
					Status:    t.Status,
					CreatedAt: t.CreatedAt,
					UpdatedAt: t.UpdatedAt,
				}
				tasks = deleteRecord(t.Id,tasks,filename)
				tasks = append(tasks,updatedTask)
			}
		}
		
		// Step 4: Marshal updated slice back to JSON
		updatedData, err := json.MarshalIndent(tasks, "", "  ")
		if err != nil {
			fmt.Println("Error encoding JSON:", err)
		}

		// Step 5: Write JSON back to file (overwrite)
		if err := os.WriteFile(filename, updatedData, 0644); err != nil {
			fmt.Println("Error writing to file:", err)
		}
		return tasks
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
		deleteRecord(args[2],tasks,filename)
	
	case "list":
		if len(args) < 3 {
			for _ , t  := range tasks {
				fmt.Println("======================================================")
				fmt.Println("Id:",t.Id)
				fmt.Println("Body:",t.Body)
				fmt.Println("CreatedAt:",t.CreatedAt)
				fmt.Println("UpdatedAt:",t.UpdatedAt)
				fmt.Println("Status:",t.Status)
			}	
		}
		if len(args) == 3 {
			for _ , t  := range tasks {
				if args[2] == t.Status {
					fmt.Println("======================================================")
					fmt.Println("Id:",t.Id)
					fmt.Println("Body:",t.Body)
					fmt.Println("CreatedAt:",t.CreatedAt)
					fmt.Println("UpdatedAt:",t.UpdatedAt)
					fmt.Println("Status:",t.Status)
				}
			}
		}

	case "update":
		updateRecord(args[2],args[3],tasks,filename)
	}
}