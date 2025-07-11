package main

import "fmt"


func main() {
	var a [5]int
	fmt.Println("emp:", a)
	a[4] = 100
	fmt.Println("set", a)

	fmt.Println("Length of the array:",len(a))

	b := [5]int{2, 2, 5, 4, 5}
    	fmt.Println("arr:", b)

	for i := range b {
		fmt.Print(b[i])
	}

	
}