import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:with_backend/url.dart';

void main() {
  runApp(new landingPage());
}

url_data url = new url_data();

class landingPage extends StatefulWidget {
  @override
  _landingPageState createState() => new _landingPageState();
}

class _landingPageState extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    var _router = <String ,WidgetBuilder> {
      "/menu_tampil" : (BuildContext context) => new MenuTampil(),
    };


    return new MaterialApp(
      home: new MenuInput(),
      routes: _router,
    );
  }


}


class MenuInput extends StatefulWidget {
  @override
  _MenuInputState createState() => new _MenuInputState();
}

class _MenuInputState extends State<MenuInput> {
  @override
  Widget build(BuildContext context) {




    final TextEditingController _controller_nim = new TextEditingController();
    final TextEditingController _controller_nama = new TextEditingController();
    var isi = [];

    Future _postdata() async{
      if (_controller_nama.text == null && _controller_nim == null) return;


      var data = {"nim":_controller_nim.text,"nama": _controller_nama.text};
      await httpClient.post(url.daftar(),body: data);

      _controller_nim.clear();
      _controller_nama.clear();


    }

    isi.add(new Text("\n\n"));
    isi.add(new Text("Menu Input"));
    isi.add(new Text("\n\n"));
    isi.add(new TextField(controller: _controller_nim,decoration: new InputDecoration(hintText: "input nim")));
    isi.add(new TextField(controller: _controller_nama,decoration: new InputDecoration(hintText: "input nama")));
    isi.add(new RaisedButton(onPressed: _postdata,child: new Text("inputkan data")));
    isi.add(new Text("\n\n"));
    isi.add(new RaisedButton(onPressed: _loaddata,child: new Text("tampil data"),));
    isi.add(new Text("\n"));
    isi.add(new RaisedButton(onPressed: _clear_buku,child: new Text("hapus"),));
    isi.add(new Text("\n\n"));
    isi.add(new RaisedButton(onPressed: _halaman_tampil,child: new Text("lihat data")));

    return new Scaffold(
      appBar: new AppBar(title: new Text("Menu Input")),
      body: new Center(child: new Container(child: new Column(children: isi),width: 260.0,),)
    );
  }

  void _halaman_tampil(){

    Navigator.of(this.context).pushNamed("/menu_tampil");

  }
}

_clear_buku(){

if (!(bukuku.length < 0) ) {
  bukuku.clear();
}
}

var httpClient = createHttpClient();
var bukuku = [];





Future _loaddata() async {


  var response =  await httpClient.post(url.buka());
  var hasil = jsonCodec.decode(response.body);

  var list = hasil["Mhs"];


  for (int i = 0; i < list.length ; i++) {
    Map array = hasil["Mhs"][i];

    String nama = array["Nama"];
    int a =i+1;
    bukuku.add("No $a. $nama");
  }


}


const jsonCodec = const JsonCodec();

class MenuTampil extends StatefulWidget {
  @override
  _MenuTampilState createState() => new _MenuTampilState();
}

class _MenuTampilState extends State<MenuTampil> {

  @override
  build(BuildContext context)  {
    var data = [];



    for (int i=0;i<bukuku.length;i++) {
      data.add(new Text(bukuku[i]));
      data.add(new Text("\n"));

    }




    return new Scaffold(
        appBar: new AppBar(title: new Text("Menu Tampil")),
         body: new ListView(children: data));
  }

}


