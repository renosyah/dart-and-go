import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


var nama_user = "blank";

const jsoncodec = const JsonCodec();
var httpClient = createHttpClient();

final TextEditingController _username = new TextEditingController();
final TextEditingController _password = new TextEditingController();
final TextEditingController _konfirmasi = new TextEditingController();



class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _router = <String, WidgetBuilder> {
    "/menu_utama" : (BuildContext context) => new MenuUtama(),

  };


  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new MenuLogin(),
      routes: _router,
    );
  }


}



 



class MenuLogin extends StatefulWidget {
  @override
  _MenuLoginState createState() => new _MenuLoginState();
}

class _MenuLoginState extends State<MenuLogin> {
  @override
  Widget build(BuildContext context) {
    var isi_menu_login = [];

    isi_menu_login.add(new Center(child: new Text("Login")));

    isi_menu_login.add(new Text("\n\n"));
    isi_menu_login.add(new TextField(controller: _username,
      decoration: new InputDecoration(hintText: "masukkan username anda"),));
    isi_menu_login.add(new TextField(controller: _password,
      decoration: new InputDecoration(hintText: "masukkan password anda"),));
    isi_menu_login.add(new Text("\n"));
    isi_menu_login.add(new RaisedButton(
      onPressed: _login, child: new Text("Login"),));


    return new Scaffold(
      appBar: new AppBar(title: new Text("Menu Login"),),
      body: new Center(child: new Container (
        child: new ListView(children: isi_menu_login,), width: 260.0,),),);
  }


  _login() async {
    String url = "http://192.168.23.1:8080/mau_login";
    var data = {"username": _username.text, "password": _password.text};
    var response = await httpClient.post(url, body: data);
    var hasil = jsoncodec.decode(response.body);

    bool ijin = hasil["Akses"];
    String username = hasil["Username"];

    _username.clear();
    _password.clear();

    if (ijin) {
      Navigator.of(this.context).pushNamed("/menu_utama");
      nama_user = "selamat datang : " + username;
    } else {

    }
  }
}

class MenuUtama extends StatefulWidget {
  @override
  _MenuUtamaState createState() => new _MenuUtamaState();
}

class _MenuUtamaState extends State<MenuUtama> {
  @override
  Widget build(BuildContext context) {
    var item_menu_utama =[];

      item_menu_utama.add(new Text(nama_user));




    return new Scaffold(body:new Center(child: new Container(child: new ListView(children: item_menu_utama,),),),appBar: new AppBar(title : new Text("Menu Utama")),);
  }
}


void main() {
  runApp(new LandingPage());
}





