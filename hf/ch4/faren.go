package main

import (
	"fmt"
	"hf-ch4/keyboard"
	"log"
)

func main() {
	fmt.Println("Enter a temperature in Fahrenheit: ")
	faren, err := keyboard.GetFloat()

	if err != nil {
		log.Fatal(err)
	}
	cels := (faren - 32) * 5 / 9
	fmt.Printf("%0.2f degrees Celsius\n", cels)

}
