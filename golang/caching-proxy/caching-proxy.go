package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"time"
)


func handleRequest(w http.ResponseWriter, r *http.Request) {
	
}

func main() {
	port := flag.String("port", "8080", "port to listen on")
	origin := flag.String("origin", "http://localhost", "origin server URL")

	flag.Parse()

	fmt.Println("Port:", *port)
	fmt.Println("Origin:", *origin)

	
	s := &http.Server{
		Addr:           ":8080",
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
		Handler: http.HandlerFunc(handleRequest),
	}
	log.Println("Starting proxy server on :8080")
	err := s.ListenAndServe()
	if err != nil {
		log.Fatal("Error starting proxy server: ", err)
	}
}