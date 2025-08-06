package api

import (
	"net/http"
)
type MyJWTTransport struct {
	transport http.RoundTripper
	token     string
	password  string
	loginURL  string
}

func (t MyJWTTransport) RoundTrip(req *http.Request) (*http.Response, error) {

	if t.token == "" {
		if t.password != "" {
			token, err := loginRequest(http.Client{}, t.loginURL, t.password)
			if err != nil {
				return nil, err
			}
			t.token = token
		}
	}
	if t.token != "" {
		req.Header.Set("Authorization", "Bearer "+t.token) // Set the Authorization header with the JWT token

	}

	return t.transport.RoundTrip(req)
}