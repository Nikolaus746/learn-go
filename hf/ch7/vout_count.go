package main

import (
	"fmt"
	"hf-ch7/datafile"
	"log"
)

func main() {
	lines, err := datafile.GetStrings("votes.txt")
	if err != nil {
		log.Fatal(err)

	}
	fmt.Println(lines)
}
