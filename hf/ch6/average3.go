package main

import "fmt"

func average(numbers ...float64) float64 {
	var sum float64 = 0

	for _, number := range numbers {
		sum += number
	}
	return sum / float64(len(numbers))
}
func main() {
	fmt.Println(average(1.0, 100.0, -12.3, 45.0, 11.2, 145.6))
	fmt.Println(average(15.0, 150.0, -12.3, 45.0, 11.2, 145.6))
}
