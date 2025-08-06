package main

type Response interface { // you create an interface as a general way to handle different types of responses
	getResponse() string
}