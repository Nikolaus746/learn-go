package magazine

type Subscriber struct {
	Name   string
	Rate   float64
	Active bool
	Adress
}

type Employee struct {
	Name   string
	Salary float64
	Adress
}

type Adress struct {
	Street   string
	State    string
	City     string
	PostCode string
}
