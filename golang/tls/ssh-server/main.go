package main

import (
	"fmt"
	"net"
)

func startServer() error {
	ln, err := net.Listen("tcp", ":2222")
	fmt.Println("Listening on port 2222")
	if err != nil {
		// handle error
	}
	for {
		_, err := ln.Accept()
		if err != nil {
			return fmt.Errorf("Error accepting connection: %v", err)
		}
	}
}


func main(){
	startServer()	

}