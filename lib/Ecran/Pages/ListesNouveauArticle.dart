// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:app/Ecran/Modifier/ModifNouveauArticle.dart';
import 'package:app/Ecran/Pages/AucuneDonnes.dart';
import 'package:app/Ecran/Ajout/AjoutNouveauArticle.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/dataArticle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListesNouveauArticle extends StatefulWidget {
  const ListesNouveauArticle({super.key});

  @override
  State<ListesNouveauArticle> createState() => _PagesListeState();
}

enum Actions { Update, Delete }

class _PagesListeState extends State<ListesNouveauArticle> {
  TextEditingController nom = TextEditingController();
  TextEditingController nom1 = TextEditingController();
  List<Article> listes = [];
  File? fichierImage;
  String news = "";
  String news1 = "";

  Future recuperer() async {
    try {
      await DataArticle().SelectAll().then((value) {
        //////print(object)
        setState(() {
          listes = value;
        });
      });
    } catch (e) {
      setState(() {
        listes = [];
      });
    }
  }

  //SlidableController final  =  SlidableController ();

  @override
  void initState() {
    // TODO: implement initStatess
    super.initState();
    recuperer();
  }

// ////print
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Listes des Articles"),
          automaticallyImplyLeading: false,
          // ignore: prefer_const_literals_to_create_immutables
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AjoutNouveauArticle(),
                    ));
              },
              icon: Icon(Icons.add),
            ),
            // IconButton(
            //     onPressed: () {
            //       // Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(
            //       //       builder: (context) => PagesNouveauArticle(),
            //       //     ));
            //     },
            //     icon: Icon(Icons.more_vert))
          ],
        ),
        body: GestureDetector(
          onTap: () {
            //////print("clicked");
            //Slidable.of(context)!.close(duration: Duration(seconds: 0));
          },
          child: SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            closeWhenTapped: true,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: (listes.isEmpty)
                    ? AucuneDonnes()
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: listes.length,
                        itemBuilder: (context, index) {
                          Article article = listes[index];
                          return Slidable(
                            closeOnScroll: true,
                            endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.5, children: [
                              SlidableAction(
                                onPressed: (context) {
                                  alerteDelete(article.id);
                                },
                                label: "Delete",
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              SlidableAction(
                                onPressed: (context) {
                                  //nom1.text = Article.nom;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ModifNouveauArticle.modification(article),
                                      ));
                                },
                                label: "Update",
                                backgroundColor: Colors.blue,
                                icon: Icons.update,
                              )
                            ]),
                            child: ListTile(
                                onTap: () {
                                  alerte(article.image, article.description);
                                },
                                title: Center(child: Text(article.libele)),
                                subtitle: Center(child: Text("Prix : ${article.prix.toString()} Ar          Gencode : " + article.gencode)),
                                leading: Icon(
                                  Icons.production_quantity_limits,
                                  size: 40,
                                  color: Colors.green,
                                ),
                                trailing: (article.image != "")
                                    ? Icon(
                                        Icons.image,
                                        color: Colors.blue,
                                      )
                                    : Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.redAccent,
                                      )),
                          );
                        }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showImage(String img) {
    return Image.memory(
      base64Decode(img),
      fit: BoxFit.cover,
    );
  }

  Future alert() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Container(
          //width: 100,
          height: 140,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      news = value;
                    });
                  },
                  controller: nom,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    // Article Article = Article();
                    // Article.nom = news;
                    // dataArticle().AjoutArticle(Article);
                    // //////print("ajout");
                    // recuperer();
                    // Navigator.pop(context);
                  },
                  child: Text("Ajouter"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future alerteDelete(int id) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(
              "Suppression",
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Annuler")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            DataArticle().DeleteArticle(id);
                            recuperer();
                          },
                          child: Text("OK")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
  }

  Future alerte(String image, String description) async {
    double div = (description.length > 100) ? 2.2 : 2.4;
    if (description == "") {
      div = 2.91;
    }
    print(div);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return (image == "")
              ? AlertDialog(
                  title: Text(
                    "Description",
                    style: TextStyle(decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    child: Text((description == "") ? "Aucune Descrption" : description, textAlign: TextAlign.center),
                  ),
                  actionsAlignment: MainAxisAlignment.end,
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK")),
                    )
                  ],
                )
              : AlertDialog(
                  title: Text(
                    "Image",
                    style: TextStyle(decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: MediaQuery.of(context).size.height / div,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 3,
                                child: ClipOval(child: showImage(image))),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        (description == "")
                            ? SizedBox()
                            : Column(
                                children: [
                                  Text("DESCRIPTION", style: TextStyle(decoration: TextDecoration.underline)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(description, textAlign: TextAlign.center),
                                ],
                              )
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.end,
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK")),
                    )
                  ],
                );
        }));
  }

  Future<bool> exitApp() async {
    bool appExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text("Voulez vous vraiment quitter ?"),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Annuler")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            // DataPreparation().DeletePreparation(prep.id_prep);
                            // recuperer();
                            Navigator.of(context).pop(true);
                          },
                          child: Text("Oui")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
    return appExit;
  }
}
