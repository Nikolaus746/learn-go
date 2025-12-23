package main

import (
	"fmt"
	"math"
)

func maximum(numbers ...float64) float64 {
	max := math.Inf(-1)
	for _, number := range numbers {

		if number > max {
			max = number
		}
	}
	return max
}

func main() {

	fmt.Println(maximum(71.8, 88.2, 99.1))
	fmt.Println(maximum(5.8, 86.2, 39.1))
}
