// ignore_for_file: unused_import, use_key_in_widget_constructors, no_logic_in_create_state, prefer_const_constructors, non_constant_identifier_names, unused_local_variable,, avoid_print

import 'dart:convert';
import 'dart:ffi';
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';

class Secondpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return Homesecond();
  }
}

class Homesecond extends State<Secondpage> {
  String change = "";
  String submit = "";
  List produitlist = [];

  TextEditingController nom = TextEditingController();

  Future<void> getproduct() async {
    final response = await http.get(Uri.parse("http://192.168.74.1/app/lib/php/select.php"));

    TextEditingController champ = TextEditingController();

    if (response.statusCode == 200) {
      print("avy a");
      setState(() {
        produitlist = json.decode(response.body);
      });
      print(produitlist.length);
    } else {}
  }

  Future<void> deletecient(String id) async {
    final response = await http.post(Uri.parse("http://192.168.74.1/app/lib/php/delete.php"), body: {"id": id});
    if (response.statusCode == 200) {
      getproduct();
      print(produitlist.length);
    } else {}
  }

  @override
  void initState() {
    getproduct();
    super.initState();
    print(produitlist.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("seconde page"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: produitlist.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.home),
              title: Text(produitlist[index]["numclient"]),
              subtitle: Text(produitlist[index]["nomclient"]),
              trailing: IconButton(
                  onPressed: () {
                    deletecient(produitlist[index]["idclient"]);
                  },
                  icon: Icon(Icons.delete)),
              tileColor: Colors.blue,
              iconColor: Colors.amber,
              onTap: (() {}),
              onLongPress: () {
                print("ay ay ay ");
              },
            );
          },
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [

        //     ElevatedButton(onPressed: alerte, child: Text("alert dialog")),
        //     ElevatedButton(onPressed: alerte1, child: Text("simple dialog")),
        //     TextField(
        //       keyboardType: TextInputType.number,
        //       onChanged: (String value) {
        //         setState(() {
        //           change = value;
        //         });
        //       },
        //       onSubmitted: (String value) {
        //         setState(() {
        //           submit = value;
        //         });
        //       },
        //       decoration: InputDecoration(labelText: "Votre nom"),
        //     ),
        //     Text(change),
        //     Text(submit),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alerte();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.width / 1.8,
                width: MediaQuery.of(context).size.width,
                color: Colors.pink,
                padding: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Container(
                      width: 110,
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(50)),
                      child: Image.asset(
                        "lib\\image\\varika1.png",
                        fit: BoxFit.cover,
                        width: 80,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Tahindraza Nico",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "nicotahindraza310501@gmail.com",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                )),
          ],
        )),
      ),
    );
  }

  void create_snack() {
    SnackBar snack = SnackBar(content: Text("voici le snackbar"));
    //Scaffold.of(context).showBottomSheet(
    //(context) => snack,
    //);
  }

  Future alerte1() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return SimpleDialog(
            title: Text("simple dialog"),
            contentPadding: EdgeInsets.all(10),
            children: [
              Text("errerrrrrrrrrrrrrrrrrrrrrrrrdssssssssssssssssssssssssssssdsddddddddddddd"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OUI")),
            ],
          );
        }));
  }

  Future alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text("etez vous Sur que ca marche"),
            content: Container(
              height: 50,
              child: Column(
                children: [
                  TextFormField(
                    controller: nom,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    //Navigator.pop(context);
                  },
                  child: Text("OUI")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("NON"))
            ],
          );
        }));
  }
}
