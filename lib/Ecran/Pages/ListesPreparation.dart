// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unrelated_type_equality_checks

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

  // loading() {
  //   EasyLoading.instance.displayDuration = const Duration(milliseconds: 2000);
  //   EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;
  //   EasyLoading.instance.loadingStyle = EasyLoadingStyle.dark;
  //   EasyLoading.instance.indicatorSize = 45.0;
  //   EasyLoading.instance.radius = 10.0;
  //   EasyLoading.instance.progressColor = Colors.yellow;
  //   EasyLoading.instance.backgroundColor = Colors.green;
  //   EasyLoading.instance.indicatorColor = Colors.yellow;
  //   EasyLoading.instance.textColor = Colors.yellow;
  //   EasyLoading.instance.maskColor = Colors.blue.withOpacity(0.5);
  //   EasyLoading.instance.userInteractions = true;
  //   EasyLoading.instance.dismissOnTap = false;
  // }

  String ip = "197.7.2.3";

  Future chargeArticle() async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectArticle.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Top1000 top1000 = Top1000.id(
              int.parse(element["id_rel_rel"]),
              element["ref_rel"],
              element["libelle_art_rel"],
              element["gencod_rel"],
              int.parse(element["prix_ref_rel"]),
              element["id_art_conc_rel"],
              element["lib_art_concur_rel"],
              element["gc_concur_rel"],
              0,
              int.parse(element["etat_rel"]),
              "",
              "",
              int.parse(
                element["num_rel_rel"],
              ),
              0);

          try {
            await db.insert("releve", top1000.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future chargeMagasin() async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectEnseigne.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Item top = Item.id(
            int.parse(element["enseigne_ens"]),
            element["libelle_ens"],
            element["lib_plus_ens"],
          );

          try {
            await db.insert("enseigne", top.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future chargeZone() async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectZone.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Item top = Item.id(
            int.parse(element["zone_zn"]),
            element["libelle_zn"],
            element["lib_plus_zn"],
          );

          try {
            await db.insert("zone", top.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future Charger() async {
    Database db = await DatabaseHelper().database;

    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/select.php")).timeout(Duration(milliseconds: 2000));

      if (response.statusCode == 200) {
        chargeMagasin();
        chargeZone();
        produitlist = json.decode(response.body);
        await EasyLoading.show(status: 'loading...');

        chargeArticle();
        produitlist.forEach((element) async {
          Preparation prepa = Preparation.id(
              int.parse(element["id_releve"]),
              element["libelle_releve"],
              (element["date_releve"] == null) ? "" : element["date_releve"],
              (element["lib_plus_releve"] == null) ? "" : element["lib_plus_releve"],
              element["dt_maj_releve"],
              int.parse(element["enseigne_releve"]),
              0,
              0,
              element["zone_releve"]);

          try {
            await db.insert("preparation", prepa.toMap());
            print(prepa.description);
          } catch (e) {
            await EasyLoading.dismiss();
          }
          await EasyLoading.dismiss();
        });
        recuperer();
      } else {
        //print("dat non recu");

      }
    } catch (e) {
      EasyLoading.showError('Connection error', duration: Duration(seconds: 1));
      //print('connecx timeout');
    }
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

  ActionPane? startAction(int etat) {
    var startAttente = ActionPane(motion: ScrollMotion(), extentRatio: 0.4, children: [
      SlidableAction(
        onPressed: (context) {
          alerteTraner();
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
                Charger();
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
                            startActionPane: startAction(prep.etat),
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

  Future alerteTraner() async {
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
                            // DataPreparation().DeletePreparation(prep.id_prep);
                            // recuperer();
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
