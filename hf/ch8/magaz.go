package main

import (
	"fmt"
	"hf-ch8/magazine"
)

func main() {
	var employee magazine.Employee
	employee.Name = "Joy Card"
	employee.Salary = 60000
	employee.Street = "Lenin str"
	employee.State = "USA"
	employee.PostCode = "009UH"
	fmt.Println(employee.Name)
	fmt.Println(employee.Salary)
	fmt.Println(employee.PostCode)
	fmt.Println(employee.State)
	fmt.Println(employee.Street)
}
