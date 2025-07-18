package main

import (
	"fmt"
	"os"
)


func main() {
	args := os.Args

	port := args[1]
	origin := args[2]

	fmt.Println(port,origin)
}