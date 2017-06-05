import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

var nama_user = "blank";

const jsoncodec = const JsonCodec();
var httpClient = createHttpClient();

final TextEditingController _username = new TextEditingController();
final TextEditingController _password = new TextEditingController();
final TextEditingController _konfirmasi = new TextEditingController();

final TextEditingController _username_daftar = new TextEditingController();
final TextEditingController _password_daftar = new TextEditingController();

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => new _LandingPageState();
}
class _LandingPageState extends State<LandingPage> {
  var _router = <String, WidgetBuilder> {
    "/menu_login" : (BuildContext context) => new MenuLogin(),
    "/menu_utama" : (BuildContext context) => new MenuUtama(),
    "/menu_daftar" : (BuildContext context) => new MenuDaftar(),
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
    isi_menu_login.add(new Text("\n"));
    isi_menu_login.add(new RaisedButton(onPressed: _menu_daftar,child: new Text("mendaftar"),));


    return new Scaffold(
      appBar: new AppBar(title: new Text("Menu Login"),),
      body: new Center(child: new Container (
        child: new ListView(children: isi_menu_login,), width: 260.0,),),);
  }

  _menu_daftar(){
    Navigator.of(context).pushNamed("/menu_daftar");
  }


  _login() async {
    String url = "http://192.168.137.172:9090/mau_login";
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
class MenuDaftar extends StatefulWidget {
  @override
  _MenuDaftarState createState() => new _MenuDaftarState();
}

class _MenuDaftarState extends State<MenuDaftar> {
  @override
  Widget build(BuildContext context) {
    var isi_menu_daftar = [];

    isi_menu_daftar.add(new Center(child: new Container(child: new Text("masukkan username anda"),)));
    isi_menu_daftar.add(new TextField(controller: _username_daftar, decoration: new InputDecoration(hintText: "masukkan username anda"),));
    isi_menu_daftar.add(new Center(child: new Container(child: new Text("masukkan password anda"),)));
    isi_menu_daftar.add(new TextField(controller: _password_daftar, decoration: new InputDecoration(hintText: "masukkan password anda"),));
    isi_menu_daftar.add(new Text("\n"));
    isi_menu_daftar.add(new RaisedButton(onPressed: _daftar,child: new Text("mendaftar"),));

    return new Scaffold(appBar: new AppBar(title: new Text("Menu daftar"),),body: new Center(child: new Container(child: new ListView(children: isi_menu_daftar ,),width: 260.0,),),);
  }
  _daftar() async {
    String url = "http://192.168.137.172:9090/mau_mendaftar";
    var data = {"username":_username_daftar.text, "password": _password_daftar.text};
    var response = await httpClient.post(url, body: data);
    var hasil = jsoncodec.decode(response.body);

    bool ijin = hasil["Akses"];

    if (ijin) {
      _username_daftar.clear();
      _password_daftar.clear();
      Navigator.pop(context);
    } else {

    }
  }
}

void main() {
  runApp(new LandingPage());
}
