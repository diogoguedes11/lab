package main // group of files

import (
	"fmt"
	"os"
)

func main() {
	args := os.Args
	if len(args) < 2 {
		fmt.Println("Usage: go run course.go <arguments>")
		fmt.Println("No arguments provided")
		os.Exit(1)
	}
	fmt.Printf("Hello, World!\nArguments: %s\n", args[1:])
	a := "123"
	b := &a
	fmt.Println("b:", *b)

}
