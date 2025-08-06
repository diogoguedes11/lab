package main

import "net/http"
type MyJWTTransport struct {
	Token  string
}

func (t MyJWTTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	if t.Token != ""{
		req.Header.Set("Authorization", "Bearer "+t.Token) // Set the Authorization header with the JWT token
	}
	return http.DefaultTransport.RoundTrip(req)
}