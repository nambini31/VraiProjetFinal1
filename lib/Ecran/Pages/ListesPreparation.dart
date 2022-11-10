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
  List<Preparation> listesToutes = [];
  List<Preparation> listesAttente = [];
  List<Preparation> listesValider = [];
  List<Preparation> listesTransferer = [];

  String news = "";
  String news1 = "";
  int id = 0;
  bool top = false;
  bool etat = false;
  String ip = "197.7.2.241";
  int i = 0;

  void Transerer(int id_prep) async {
    // int? nbrPrep = await DataTop1000().SelectNombrePreparation(id_prep, ip);

    // int? nbrTopMysql = await DataTop1000().SelectNombreTop1000Mysql(id_prep, ip);

    // int? nbrTop = await DataTop1000().SelectNombreTop1000Fini(id_prep);

    // if (nbrPrep == 1 && (nbrTop == nbrTopMysql)) {
    //   EasyLoading.instance
    //     ..maskType = EasyLoadingMaskType.none
    //     ..loadingStyle = EasyLoadingStyle.custom
    //     ..radius = 29.0
    //     ..contentPadding = EdgeInsets.all(13)
    //     ..backgroundColor = Color.fromRGBO(0, 0, 0, 0)
    //     ..textColor = Color.fromARGB(255, 255, 255, 255)
    //     ..userInteractions = false
    //     ..dismissOnTap = false
    //     ..animationStyle = EasyLoadingAnimationStyle.opacity
    //     ..toastPosition = EasyLoadingToastPosition.bottom;

    //   await EasyLoading.showToast('Relever deja tranferer', duration: Duration(seconds: 2));
    // } else {
    await DataPreparation().SelectAllOne(id_prep, ip);
    //}
  }

  Future recuperer() async {
    await DataPreparation().SelectAll().then((value) {
      // //print()
      setState(() {
        listesToutes = value;
      });
    });
    await DataPreparation().SelectAttente().then((value) {
      // //print()
      setState(() {
        listesAttente = value;
      });
    });
    await DataPreparation().SelectValider().then((value) {
      // //print()
      setState(() {
        listesValider = value;
      });
    });
    await DataPreparation().SelectTransferer().then((value) {
      // //print()
      setState(() {
        listesTransferer = value;
      });
    });
  } // //print

  Icon icone(int etat, int etat_attente) {
    var iconValide = Icon(
      Icons.radio_button_checked_rounded,
      color: Colors.green,
    );

    var iconNon = Icon(
      Icons.radio_button_checked_rounded,
      color: Colors.grey,
    );

    var iconAttente = Icon(
      Icons.radio_button_checked_rounded,
      color: Colors.orange,
    );
    var iconTransferer = Icon(
      Icons.check_circle,
      color: Colors.blue,
      size: 30,
    );

    if (etat == 1) {
      return iconValide;
    } else if (etat == 2) {
      return iconTransferer;
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

  Future search(String txt) async {
    if (i == 0) {
      await DataPreparation().SearchAll(txt).then((value) {
        // //print()
        setState(() {
          listesToutes = value;
        });
      });
    } else if (i == 1) {
      await DataPreparation().SearchAttente(txt).then((value) {
        // //print()
        setState(() {
          listesAttente = value;
        });
      });
    } else if (i == 2) {
      await DataPreparation().SearchValider(txt).then((value) {
        // //print()
        setState(() {
          listesValider = value;
        });
      });
    } else {
      await DataPreparation().SearchTransferer(txt).then((value) {
        // //print()
        setState(() {
          listesTransferer = value;
        });
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () => ,
  //     child: Center(
  //       child: preparation(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitApp(),
      child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Relever de prix"),
              actions: [
                IconButton(
                    onPressed: () async {
                      await DataPreparation().Charger(ip);

                      recuperer();
                    },
                    icon: Icon(Icons.get_app_sharp))
              ],
              automaticallyImplyLeading: false,
            ),
            body: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(110),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    titleSpacing: 15,
                    title: Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search(value);
                          });
                        },
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2),
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.grey,
                          hintText: "Rechercher",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                        ),
                      ),
                    ),
                    bottom: TabBar(
                        onTap: (value) {
                          setState(() {
                            i = value;
                          });
                        },
                        // ignore: prefer_const_literals_to_create_immutables
                        tabs: [
                          Tab(
                            text: "Tous",
                          ),
                          Tab(
                            text: "Attente",
                          ),
                          Tab(
                            text: "Valider",
                          ),
                          Tab(
                            text: "Transferer",
                          )
                        ]),
                  ),
                ),
                body: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TabBarView(physics: BouncingScrollPhysics(), children: [
                    preparationToutes(),
                    preparationAttente(),
                    preparationValider(),
                    preparationTransferer(),
                  ]),
                ),
              ),
            ),
          )),
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

    if (etat == 0 || etat == 2) {
      return null;
    } else {
      return startAttente;
    }
  }

  SlidableAutoCloseBehavior preparationToutes() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Center(
        child: (listesToutes.isEmpty)
            ? AucuneDonnes()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listesToutes.length,
                itemBuilder: (context, index) {
                  Preparation prep = listesToutes[index];
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
    );
  }

  SlidableAutoCloseBehavior preparationAttente() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Center(
        child: (listesAttente.isEmpty)
            ? AucuneDonnes()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listesAttente.length,
                itemBuilder: (context, index) {
                  Preparation prep = listesAttente[index];
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
    );
  }

  SlidableAutoCloseBehavior preparationValider() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Center(
        child: (listesValider.isEmpty)
            ? AucuneDonnes()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listesValider.length,
                itemBuilder: (context, index) {
                  Preparation prep = listesValider[index];
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
    );
  }

  SlidableAutoCloseBehavior preparationTransferer() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Center(
        child: (listesTransferer.isEmpty)
            ? AucuneDonnes()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listesTransferer.length,
                itemBuilder: (context, index) {
                  Preparation prep = listesTransferer[index];
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
