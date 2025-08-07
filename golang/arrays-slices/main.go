package main

import "fmt"

func main() {
	var arr1 []int = []int{1, 2, 3, 4, 5}
	var arr2 []int = arr1[1:3]
	fmt.Println(arr1)
	fmt.Println(arr2)
	fmt.Printf("Length: %d, Capacity: %d\n", len(arr1), cap(arr1))
	fmt.Printf("Length: %d, Capacity: %d\n", len(arr2), cap(arr2))

	var arr3 []int = []int{1,2,3}
	fmt.Println(arr3)
	fmt.Printf("Length: %d, Capacity: %d\n", len(arr3), cap(arr3))
	arr3 = append(arr3, 4,5,6)
	fmt.Println(arr3)
	fmt.Printf("Length: %d, Capacity: %d\n", len(arr3), cap(arr3))
}
