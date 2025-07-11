package main

import "fmt"

func plus(a int,b int) int{
	return a + b
}
func multiplevalues()(int,int){
	return 3,7
}


func main(){
	res := plus(1,2)
	fmt.Println("1+2=",res)
	a,b := multiplevalues()
	fmt.Println(a)
	fmt.Println(b)
}

