package main

import (
	"fmt"
	"hf-ch4/keyboard"
	"log"
)

func main() {
	fmt.Println("Enter a grade")
	grade, err := keyboard.GetFloat()
	if err != nil {
		log.Fatal(err)
	}
	var status string
	if grade >= 60 {
		status = "passing"
	} else {
		status = "not passing"
	}
	fmt.Println(status)
}
