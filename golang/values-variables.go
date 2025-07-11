package main

import (
	"fmt"
	"math"
)


func main() {
	fmt.Println("go"+"lang")
	fmt.Println("1+1=",1+1)
	fmt.Println(true && false)
	fmt.Println(!true)


	var a = "initial"
	fmt.Println(a)

	var b,c int = 1,2
	fmt.Println(b,c)
	var e int
	fmt.Println(e)
	// this shorthand only exists inside the function
	f := "apple" // a way to create a variable
	fmt.Println(f)

	// Constants (declares a constant value)
	const n = 500000

	fmt.Println(math.Sin(n))
}