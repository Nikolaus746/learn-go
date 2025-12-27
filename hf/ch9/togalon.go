package main

import "fmt"

type Liters float64
type Mililiters float64
type Galons float64

func (l Liters) ToGalons() Galons {
	return Galons(l * 0.264)
}

func (m Mililiters) ToGalons() Galons {
	return Galons(m * 0.000264)
}
func main() {
	soda := Liters(2)
	fmt.Printf("%0.3f liters equals %0.3f gallons\n", soda, soda.ToGalons())
	water := Mililiters(500)
	fmt.Printf("%0.3f milliliters equals %0.3f gallons\n", water, water.ToGalons())
}
