// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'package:app/Ecran/Pages/AucuneDonnes.dart';
import 'package:app/Ecran/Pages/index.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/dataTop1000.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ListesTop1000 extends StatefulWidget {
  Preparation preptop = Preparation();
  ListesTop1000({required this.preptop});

  @override
  State<ListesTop1000> createState() => _ListesTop1000State();
}

class _ListesTop1000State extends State<ListesTop1000> {
  late TabController tabcontrol;

  List<Top1000> listesToutes = [];
  List<Top1000> listesAttente = [];
  List<Top1000> listesValider = [];

  int i = 0;

  bool rel = false;
  String dateTime() {
    var date = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  Future<void> validerRelever(int id_releve, int id_prep) async {
    await DataTop1000().UpdateEtatReleve(id_releve, id_prep, dateTime());
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Index.top(prep: widget.preptop),
        ));

    recuperer();

    setState(() {
      i = 1;
    });
  }

  Future<void> annuler(int id_releve, int id_prep) async {
    await DataTop1000().AnnulerReleve(id_releve, id_prep);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Index.top(
            prep: widget.preptop,
          ),
        ));
    recuperer();
    setState(() {
      i = 1;
    });
  }

  Future recuperer() async {
    await DataTop1000().SelectAll(widget.preptop.id_prep).then((value) {
      ////print()
      setState(() {
        listesToutes = value;
      });
    });
    await DataTop1000().SelectAttente(widget.preptop.id_prep).then((value) {
      ////print()
      setState(() {
        listesAttente = value;
      });
    });
    await DataTop1000().SelectValider(widget.preptop.id_prep).then((value) {
      ////print()
      setState(() {
        listesValider = value;
      });
    });
    //return listesToutes;
  }

  Future search(String txt) async {
    if (i == 0) {
      await DataTop1000().SearchAll(widget.preptop.id_prep, txt).then((value) {
        ////print()
        setState(() {
          listesToutes = value;
        });
      });
    } else if (i == 1) {
      await DataTop1000().SearchAttente(widget.preptop.id_prep, txt).then((value) {
        ////print()
        setState(() {
          listesAttente = value;
        });
      });
    } else {
      await DataTop1000().SearchValider(widget.preptop.id_prep, txt).then((value) {
        ////print()
        setState(() {
          listesValider = value;
        });
      });
    }

    //return listesToutes;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Index.rel(widget.preptop),
                        ));
                  },
                  icon: Icon(Icons.takeout_dining))
            ],
            title: Text(widget.preptop.libelle_prep),
            leading: rel
                ? Icon(
                    Icons.arrow_back,
                    color: Colors.transparent,
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Index(1),
                          ));
                    },
                    icon: Icon(Icons.arrow_back)),
          ),
          body: DefaultTabController(
            length: 3,
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
                      tabs: [
                        Tab(
                          text: "Tous",
                        ),
                        Tab(
                          text: "En attente",
                        ),
                        Tab(
                          text: "Valider",
                        )
                      ]),
                ),
              ),
              body: Container(
                margin: EdgeInsets.only(top: 10),
                child: TabBarView(physics: BouncingScrollPhysics(), children: [
                  Toutes(),
                  Attente(),
                  Valide(),
                ]),
              ),
            ),
          ),
        ));
  }

  Container Toutes() {
    return Container(
      //color: Colors.white,
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: Center(
          child: (listesToutes.isEmpty)
              ? AucuneDonnes()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listesToutes.length,
                  itemBuilder: (context, index) {
                    Top1000 top1000 = listesToutes[index];

                    return SingleChildScrollView(
                        child: Slidable(
                      startActionPane: startAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      endActionPane: endAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      child: ListTile(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          alerte(top1000);
                        },
                        title: Text(top1000.libelle_art),
                        subtitle: Center(child: Text("Prix : ${top1000.prix_art} Ar")),
                        leading: Icon(
                          Icons.production_quantity_limits,
                          size: 40,
                          color: Colors.green,
                        ),
                        trailing: icone(top1000.etat_art, top1000.prix_art_conc),
                      ),
                    ));
                  }),
        ),
      ),
    );
  }

  Icon icone(int etat, int prix) {
    var iconValide = Icon(
      Icons.check_circle,
      color: Colors.green,
    );
    var iconAttente = Icon(
      Icons.check_circle,
      color: Colors.orange,
    );
    var iconNon = Icon(
      Icons.check_circle,
      color: Colors.grey,
    );

    if (etat == 1) {
      return iconValide;
    } else if (etat == 0 && prix != 0) {
      return iconAttente;
    } else {
      return iconNon;
    }
  }

  ActionPane? endAction(int etat, int prix, int id_releve) {
    var endAttente = ActionPane(motion: ScrollMotion(), extentRatio: 0.6, children: [
      SlidableAction(
        onPressed: (context) {
          alerteDelete(id_releve);
        },
        label: "Annuler",
        backgroundColor: Colors.red,
        icon: Icons.cancel,
      ),
      Padding(padding: EdgeInsets.all(2)),
      SlidableAction(
        onPressed: (context) {},
        label: "Modifier",
        backgroundColor: Colors.blue,
        icon: Icons.add_home,
      ),
      Padding(padding: EdgeInsets.all(2)),
    ]);

    if (etat == 1) {
      return null;
    } else if (etat == 0 && prix != 0) {
      return endAttente;
    } else {
      return null;
    }
  }

// //print
  ActionPane? startAction(int etat, int prix, int id_rel) {
    var startAttente = ActionPane(motion: ScrollMotion(), extentRatio: 0.4, children: [
      SlidableAction(
        onPressed: (context) {
          alerteValider(id_rel);
        },
        label: "Valider",
        backgroundColor: Colors.green,
        icon: Icons.add_home,
      ),
    ]);

    if (etat == 1) {
      return null;
    } else if (etat == 0 && prix != 0) {
      return startAttente;
    } else {
      return null;
    }
  }

  Container Attente() {
    return Container(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: Center(
          child: (listesAttente.isEmpty)
              ? AucuneDonnes()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listesAttente.length,
                  itemBuilder: (context, index) {
                    Top1000 top1000 = listesAttente[index];

                    return SingleChildScrollView(
                        child: Slidable(
                      startActionPane: startAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      endActionPane: endAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      child: ListTile(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          alerte(top1000);
                        },
                        title: Center(child: Text(top1000.libelle_art)),
                        subtitle: Center(child: Text("Prix : ${top1000.prix_art} Ar")),
                        leading: Icon(
                          Icons.production_quantity_limits,
                          size: 40,
                          color: Colors.green,
                        ),
                        trailing: icone(top1000.etat_art, top1000.prix_art_conc),
                      ),
                    ));
                  }),
        ),
      ),
    );
  }

  Container Valide() {
    return Container(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: Center(
          child: (listesValider.isEmpty)
              ? AucuneDonnes()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listesValider.length,
                  itemBuilder: (context, index) {
                    Top1000 top1000 = listesValider[index];

                    return SingleChildScrollView(
                        child: Slidable(
                      startActionPane: startAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      endActionPane: endAction(top1000.etat_art, top1000.prix_art_conc, top1000.id_releve),
                      child: ListTile(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          alerte(top1000);
                        },
                        title: Center(
                          child: Text(top1000.libelle_art),
                        ),
                        subtitle: Center(child: Text("Prix : ${top1000.prix_art} Ar")),
                        leading: Icon(
                          Icons.production_quantity_limits,
                          size: 40,
                          color: Colors.green,
                        ),
                        trailing: icone(top1000.etat_art, top1000.prix_art_conc),
                      ),
                    ));
                  }),
        ),
      ),
    );
  }

  Future alerteDelete(int id_releve) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(
              "Annulation Relevé",
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            annuler(id_releve, widget.preptop.id_prep);
                          },
                          child: Text("OUI")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("NON")),
                    )
                  ],
                ),
              )
            ],
          );
        }));
  }

  Future alerteValider(int id_releve) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(
              "Validation Relevé",
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            validerRelever(id_releve, widget.preptop.id_prep);
                          },
                          child: Text("OUI")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("NON")),
                    )
                  ],
                ),
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

  double panga = 0;
  Future alerte(Top1000 top1000) async {
    if (top1000.date_maj_releve == "" && top1000.date_val_releve == "") {
      setState(() {
        panga = 8;
      });
    } else if (top1000.date_maj_releve != "" && top1000.date_val_releve == "") {
      setState(() {
        panga = 7;
      });
    } else {
      setState(() {
        panga = 5;
      });
    }

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(
              "Article Concurent | Date",
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / panga,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  row("Libelle  :  ", top1000.libelle_art_conc),
                  SizedBox(
                    height: 5,
                  ),
                  row("Gencode  :  ", top1000.gencode_art_conc),
                  SizedBox(
                    height: 5,
                  ),
                  row("Pix  :  ", TextPrix(top1000.prix_art_conc)),
                  (top1000.date_maj_releve == "")
                      ? SizedBox(
                          height: 5,
                        )
                      : SizedBox(),
                  (top1000.date_maj_releve != "") ? row("Date relever  :  ", top1000.date_maj_releve) : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  (top1000.date_val_releve != "") ? row("Date validaion  :  ", top1000.date_val_releve) : Container(),
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

  String TextPrix(int prix) {
    if (prix != 0) {
      return "$prix Ar";
    } else {
      return "0 Ar";
    }
  }
}
