package datafile

import (
	"bufio"
	"log"
	"os"
)

func GetStrings(fileName string) ([]string, error) {
	var lines []string
	file, err := os.Open(fileName)
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
	}
	err = file.Close()
	if err != nil {
		log.Fatal(nil, err)
	}
	if scanner.Err() != nil {
		log.Fatal(nil, scanner.Err())
	}
	return lines, nil
}
