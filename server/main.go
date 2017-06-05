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

type respon struct {
	Username string
	Akses    bool
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

func mau_login(res http.ResponseWriter, req *http.Request) {
	username := req.FormValue("username")
	password := req.FormValue("password")

	var password_ku = "12345"

	if password == password_ku {

		data := respon{username, true}
		json.NewEncoder(res).Encode(data)

	} else {
		data := respon{"", false}
		json.NewEncoder(res).Encode(data)
	}
}

func main() {
	http.HandleFunc("/", utama)
	http.HandleFunc("/daftar", create)
	http.HandleFunc("/mau_login", mau_login)
	fmt.Println("running now...")
	http.ListenAndServe(":8080", nil)

}
