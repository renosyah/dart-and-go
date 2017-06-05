package main

import "net/http"
import "encoding/json"
import "fmt"
import "os"
import "database/sql"
import _ "github.com/lib/pq"

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

func connect() *sql.DB {
	var db, err = sql.Open("postgres", "postgresql://root@localhost:26257/login?sslmode=disable") //default cockroach setting
	err = db.Ping()
	if err != nil {
		fmt.Println("database tidak bisa dihubungi")
		os.Exit(0)
	}
	return db
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

func daftar(res http.ResponseWriter, req *http.Request) {
	db := connect()
	defer db.Close()

	username := req.FormValue("username")
	password := req.FormValue("password")

	db.Exec("insert into login.asd values ($1,$2)", username, password)

	data := respon{"", true}
	json.NewEncoder(res).Encode(data)
}

func mau_login(res http.ResponseWriter, req *http.Request) {
	username := req.FormValue("username")
	password := req.FormValue("password")
	var pass_db string
	db := connect()
	defer db.Close()
	rows := db.QueryRow("select password from login.asd where username = $1", username)
	rows.Scan(&pass_db)
	if password != pass_db {
		data := respon{"", false}
		json.NewEncoder(res).Encode(data)
		fmt.Println(password, username, pass_db)
		return
	}
	data := respon{username, true}
	json.NewEncoder(res).Encode(data)

	fmt.Println(password, username, pass_db)
}
func main() {
	http.HandleFunc("/", utama)
	http.HandleFunc("/daftar", create)
	http.HandleFunc("/mau_mendaftar", daftar)
	http.HandleFunc("/mau_login", mau_login)
	fmt.Println("running now...")
	http.ListenAndServe(":9090", nil)

}
