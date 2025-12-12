package main

import (
	"fmt"
	"strings"
)

func main() {
	booken := "G# Ro#ck!"
	replcer := strings.NewReplacer("#", "o")
	fied := replcer.Replace(booken)
	fmt.Println(fied)
}
