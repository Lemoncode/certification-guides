package main

import (
  "fmt"
  "net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "Hello world")
}

func main() {
  http.HandleFunc("/hello", helloHandler)
  fmt.Println("Server is running on port 8080")
  http.ListenAndServe(":8080", nil)
}
