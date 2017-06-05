package main

import "net/http"
import "encoding/json"
import "fmt"
import "os"

type Human struct {
	Nama string
}

type mhs struct {
	Mhs []Human
}

func utama(res http.ResponseWriter, req *http.Request) {

	data := []Human{{Nama: "Reno"}, {Nama: "eko"}, {Nama: "deni"}, {Nama: "sony"}}
	data_2 := mhs{data}

	json.NewEncoder(res).Encode(data_2)

}

func create(res http.ResponseWriter, req *http.Request) {
	nim := req.FormValue("nim")
	nama := req.FormValue("nama")

	create, _ := os.Create(nama + ".txt")
	defer create.Close()

	create.WriteString("nim : " + nim + ", nama : " + nama)

}

func main() {
	http.HandleFunc("/", utama)
	http.HandleFunc("/daftar", create)
	fmt.Println("running now...")
	http.ListenAndServe(":8080", nil)

}
