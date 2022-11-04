// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_key_in_widget_constructors, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/Ecran/Ajout/second_page_avant.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String nom = "";
  String mot_de_passe = "";
  String text = "";
  bool obscurtext = true;
  // void submit(String e) {
  //   setState(() {
  //     text = "Message envoyé a $e";
  //   });
  // }

  var formValide = GlobalKey<FormState>();

  void login(String nom, String mot_de_passe) async {
    //final response = await http.post(Uri.parse('http://197.7.2.146/php/login.php'), body: {"username": nom, "password": mot_de_passe});
    final response = await http.post(Uri.parse('http://192.168.74.1/app/lib/php/login.php'), body: {"username": nom, "password": mot_de_passe});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data[0] == 0) {
        print("tsy mitovy");
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return Secondpage();
        }));
      }
    } else {
      print("rien");
    }
  }

  void change(String e) {
    setState(() {
      text = e;
    });
  }

  void validationform() {
    if (formValide.currentState!.validate()) {
      login(nom, mot_de_passe);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: formValide,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            //padding: EdgeInsets.fromLTRB(30, MediaQuery.of(context).size.width / 15, 30, MediaQuery.of(context).size.width / 15),
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              height: MediaQuery.of(context).size.height,
              //color: Colors.black,

              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(
                          "lib\\image\\varika1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Text(
                        "Utilisateur",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(221, 44, 42, 42)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 19),
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only (top: 19),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(29)),
                          //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                          //labelText: "Nom",
                          hintText: "Entrer votre matricule",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            nom = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre nom" : null,
                        onSaved: (newValue) {
                          nom = newValue!;
                        },
                        //onSubmitted: submit,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(fontSize: 19),
                        onChanged: (value) {
                          setState(() {
                            mot_de_passe = value;
                          });
                        },
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre mot de passe" : null,
                        onSaved: (newValue) {
                          mot_de_passe = newValue!;
                        },
                        obscureText: obscurtext,
                        decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(top: 20),

                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(29)),

                            //labelText: "mot de passe",
                            hintText: "Entrer votre mot de passe",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscurtext = !obscurtext;
                                });
                              },
                              child: obscurtext
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Colors.grey,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    ),
                            )),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: ElevatedButton(
                            onPressed: validationform,
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 243, 63, 146))),
                            child: Text("Connecter", style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 40)),
                      Container(
                        width: 140,
                        decoration: BoxDecoration(color: Color.fromARGB(255, 3, 31, 52), borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          "lib\\image\\logoinfo.png",
                          fit: BoxFit.none,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
