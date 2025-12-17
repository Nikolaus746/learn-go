package datafile

import (
	"bufio"
	"log"
	"os"
	"strconv"
)

func GetFloats(fileName string) ([3]float64, error) {
	var numbers [3]float64
	file, err := os.Open("data.txt")
	if err != nil {
		log.Fatal(err)
	}
	i := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		numbers[i], err = strconv.ParseFloat(scanner.Text(), 64)
		if err != nil {
			return numbers, err
		}
		i++
	}
	err = file.Close()
	if err != nil {
		log.Fatal(numbers, err)
	}
	if scanner.Err() != nil {
		log.Fatal(numbers, scanner.Err())
	}
	return numbers, nil
}
