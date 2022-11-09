// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unrelated_type_equality_checks, unused_local_variable

import 'dart:convert';

import 'package:app/Ecran/Pages/AucuneDonnes.dart';
import 'package:app/Ecran/Pages/ListesTop1000.dart';
import 'package:app/Ecran/Pages/index.dart';
import 'package:app/Ecran/Pages/two_letter_icon.dart';
import 'package:app/Ecran/modele/dataPreparation.dart';
import 'package:app/Ecran/modele/dataTop1000.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/magasin.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:app/Ecran/modele/zone.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ListesPreparation extends StatefulWidget {
  @override
  State<ListesPreparation> createState() => _ListesPreparationState();
}

class _ListesPreparationState extends State<ListesPreparation> {
  List<Preparation> listes = [];
  String news = "";
  String news1 = "";
  int id = 0;
  bool top = false;
  bool etat = false;
  String ip = "197.7.2.2";

  void Transerer(int id_prep) async {
    print(await DataTop1000().SelectNombreTop1000Mysql(id_prep, ip));

    print(await DataTop1000().SelectNombreTop1000(id_prep));

    await DataPreparation().SelectAllOne(id_prep, ip);
  }

  Future recuperer() async {
    await DataPreparation().SelectAll().then((value) {
      // //print()
      setState(() {
        listes = value;
      });
    });

    return listes;
  } // //print

  Icon icone(int etat, int etat_attente) {
    var iconValide = Icon(
      Icons.check_circle,
      color: Colors.green,
    );

    var iconNon = Icon(
      Icons.check_circle,
      color: Colors.grey,
    );

    var iconAttente = Icon(
      Icons.check_circle,
      color: Colors.orange,
    );

    if (etat == 1) {
      return iconValide;
    } else if (etat_attente == 1) {
      return iconAttente;
    }
    return iconNon;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: Center(
        child: preparation(),
      ),
    );
  }

  ActionPane? startAction(int etat, int id_prep) {
    var startAttente = ActionPane(motion: ScrollMotion(), extentRatio: 0.4, children: [
      SlidableAction(
        onPressed: (context) {
          alerteTraner(id_prep);
        },
        label: "Transferer",
        backgroundColor: Colors.green,
        icon: Icons.arrow_circle_right_rounded,
      ),
    ]);

    if (etat == 0) {
      return null;
    } else {
      return startAttente;
    }
  }

  Scaffold preparation() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preparation"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await DataPreparation().Charger(ip);
                recuperer();
              },
              icon: Icon(Icons.get_app_sharp))
        ],
      ),
      body: GestureDetector(
          onTap: () {
            // //print("clicked");
            //Slidable.of(context)!.close(duration: Duration(seconds: 0));
          },
          child: SlidableAutoCloseBehavior(
            closeWhenOpened: true,
            closeWhenTapped: true,
            child: Center(
              child: (listes.isEmpty)
                  ? AucuneDonnes()
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: listes.length,
                      itemBuilder: (context, index) {
                        Preparation prep = listes[index];
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(top: 10),
                          child: Slidable(
                            startActionPane: startAction(prep.etat, prep.id_prep),
                            endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.5, children: [
                              SlidableAction(
                                onPressed: (context) {
                                  //alerte1();
                                  alerteDelete(prep);
                                },
                                label: "Delete",
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              SlidableAction(
                                onPressed: (context) {
                                  alerte(prep);
                                },
                                label: "Plus",
                                backgroundColor: Colors.blue,
                                icon: Icons.description,
                              ),
                            ]),
                            child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Index.top(prep: prep),
                                      ));
                                },
                                title: Text(prep.libelle_prep),
                                subtitle: Center(child: Text("${prep.design_magasin} ( ${prep.libelle_zone} )")),
                                leading: TwoLetterIcon(prep.libelle_prep),
                                trailing: icone(prep.etat, prep.etat_attente)),
                          ),
                        );
                      }),
            ),
          )),
    );
  }

  Future alerte(Preparation prep) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(
              "Description",
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: (prep.description.toString().length > 100) ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height / 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row("Date creation  :  ", prep.date_prep),
                  SizedBox(
                    height: 5,
                  ),
                  row("Libelle  :  ", prep.libelle_prep),
                  SizedBox(
                    height: 5,
                  ),
                  (prep.date_maj_prep != "") ? row("Date mise a jour  :  ", prep.date_maj_prep) : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  (prep.description == "")
                      ? SizedBox()
                      : Column(
                          children: [
                            row("Description  :  ", ""),
                            SizedBox(
                              height: 5,
                            ),
                            Text(prep.description)
                          ],
                        ),
                  SizedBox(
                    height: 5,
                  ),
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

  Row row(String nom, String text) {
    return Row(
      children: [
        Text(
          nom,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: TextStyle(wordSpacing: 2),
        ),
      ],
    );
  }

  Future alerteDelete(Preparation prep) async {
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
                            DataPreparation().DeletePreparation(prep.id_prep);
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

  Future alerteTraner(int id_prep) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            content: Text(
              "Tranfer de données",
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
                            Transerer(id_prep);
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
