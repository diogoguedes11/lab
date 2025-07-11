package main

import "fmt"

func main() {
	// Maps
	m:= make(map[string]int)
	m["k1"] = 1
	m["k2"] = 13
	fmt.Println("map:", m)
	v1 := m["k1"]
	v3 := m["k3"] // 0 because there is no key map for k3
	println(v1,v3)

	delete(m,"k2")
	fmt.Println("map:",m)
	clear(m)
	println(m)
}