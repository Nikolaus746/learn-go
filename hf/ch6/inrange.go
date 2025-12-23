package main

import "fmt"

func inRange(min float64, max float64, numbers ...float64) []float64 {
	var result []float64
	for _, number := range numbers {
		if number >= min && number <= max {
			result = append(result, number)
		}
	}
	return result
}

func main() {
	fmt.Println(inRange(1.0, 100.0, -12.3, 45.0, 11.2, 145.6))
	fmt.Println(inRange(15.0, 150.0, -12.3, 45.0, 11.2, 145.6))
}
