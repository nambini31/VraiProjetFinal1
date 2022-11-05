// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, prefer_is_empty, unnecessary_null_comparison

import 'package:app/Ecran/Pages/index.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:intl/intl.dart';
import 'package:app/Ecran/modele/dataTop1000.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Relever extends StatefulWidget {
  Preparation prepatop = Preparation();
  Relever(this.prepatop);

  @override
  State<Relever> createState() => _ReleverState();
}

class _ReleverState extends State<Relever> {
  List<DropdownMenuItem<String?>> listesvrai = [];
  var formValide = GlobalKey<FormState>();
  String selectgencode = "";
  String selectlibelle = "";
  int id_choix = 1;
  int id_relever = 0;

  TextEditingController searchController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController scanController = TextEditingController();
  TextEditingController codebarController = TextEditingController();
  String dateTime() {
    var date = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  void ajouter() {
    if (formValide.currentState!.validate()) {
      Releve releve = Releve.update(id_relever, prixController.text, dateTime());
      DataTop1000().UpdateReleve(releve, widget.prepatop.id_prep);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Index.top(prep: widget.prepatop),
          ));
    } else {}
  }

  Future recuperer() async {
    ["Rechercher article", "Scanner le code barre"].forEach((element) {
      listesvrai.add(DropdownMenuItem(
        value: id_choix.toString(),
        child: Text(element),
      ));
      setState(() {
        id_choix = id_choix + 1;
      });
    });
    setState(() => listesvrai);
  }

  bool suggeest = true;

  Future<List<Releve>> onTapSearch(String query) async {
    List<Top1000> listesToutes = [];
    await DataTop1000().SelectAllSuggest(widget.prepatop.id_prep).then((value) {
      listesToutes = value;
    });
    List<Releve> search = [];
    listesToutes.forEach((element) {
      Releve releve = Releve(element.id_releve, element.libelle_art_conc, element.gencode_art_conc);

      search.add(releve);
    });
    search.retainWhere((element) => element.libelle_art_conc.toString().toLowerCase().contains(query.toLowerCase()));

    return search;
  }

  Future BarcodeScanner() async {
    String barcodeLocal = "";
    try {
      barcodeLocal = await FlutterBarcodeScanner.scanBarcode("#DF1C5D", "Annuler", true, ScanMode.BARCODE);
      if (barcodeLocal != "-1") {
        Map<String, dynamic> selectlibell = await DataTop1000().SelectLibelle(barcodeLocal);

        setState(() {
          codebarController.text = barcodeLocal;
          selectgencode = barcodeLocal;
          selectlibelle = selectlibell["libelle_art_conc"];
          id_relever = selectlibell["id_releve"];
        });
        scanController.text = selectlibell["libelle_art_conc"];
      } else {
        setState(() {
          selectgencode = "";
          selectlibelle = "";
        });
      }
    } catch (e) {
      scanController.text = "";
      codebarController.text = "";
      setState(() {
        id_relever = 0;
      });
      setState(() {
        selectgencode = "";
        selectlibelle = "";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
    scanController.text = "";
    id_choix = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Relever de prix")),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Index.top(prep: widget.prepatop),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formValide,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ID RELEVER : $id_relever"),
                Padding(padding: EdgeInsets.all(12)),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: DropdownButtonFormField2(
                    value: id_choix.toString(),
                    items: listesvrai,
                    hint: Text("Choix Relever"),
                    onChanged: (value) {
                      id_choix = int.parse(value.toString());
                      setState(() => id_choix);
                      searchController.text = "";
                      prixController.text = "";
                      codebarController.text = "";
                      setState(() {
                        id_relever = 0;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      filled: true,
                      //hintText: "Magasin",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                      //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                      prefixIcon: Icon(
                        Icons.select_all,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: (id_choix == 1)
                      ? TypeAheadFormField(
                          validator: (value) => (value!.isEmpty || searchController.text != selectlibelle) ? "Aucun article correspondant" : null,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchController,

                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                              //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                              //labelText: "Nom",
                              hintText: "Rechercher article",
                              prefixIcon: Container(
                                width: 50,
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                            ),

                            onTap: () {},

                            // validator: (value) => value!.isEmpty ? "Veuillez entrer la designation" : null,
                            // onSaved: (newValue) {
                            //   //nom = newValue!;
                            // },
                          ),
                          noItemsFoundBuilder: (context) => SizedBox(
                            height: 40,
                            child: Center(
                              child: Text("Article introuvable"),
                            ),
                          ),
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              constraints: BoxConstraints(maxHeight: suggeest ? 200 : 0),
                              elevation: 4.0,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
                          itemBuilder: (context, itemData) {
                            Releve? rel = Releve.no();
                            rel = itemData as Releve?;
                            return Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.refresh),
                                SizedBox(width: 10),
                                Container(padding: EdgeInsets.only(top: 14), height: 40, child: Text((rel!.libelle_art_conc)))
                              ],
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            Releve? rel = Releve.no();
                            rel = suggestion as Releve?;
                            searchController.text = rel!.libelle_art_conc;
                            codebarController.text = rel.gencode_art_conc;

                            setState(() {
                              selectgencode = rel!.gencode_art_conc;
                              id_relever = rel.id_releve;
                              selectlibelle = rel.libelle_art_conc;
                            });
                          },
                          suggestionsCallback: (pattern) {
                            if (pattern.isNotEmpty) {
                              return onTapSearch(pattern);
                            } else {
                              return [];
                            }
                          },
                        )
                      : Row(
                          children: [
                            Container(
                              height: 48.4,
                              child: ElevatedButton(
                                onPressed: () => BarcodeScanner(),
                                child: Icon(Icons.camera_alt),
                                style: TextButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 104,
                              child: TextFormField(
                                controller: scanController,
                                validator: (value) {
                                  if (value!.isEmpty && id_choix == 1) {
                                    return null;
                                  } else {
                                    return null;
                                  }
                                }, //index.top
                                // textAlign: TextAlign.center,
                                enabled: false,
                                autocorrect: false,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                                  //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                                  //labelText: "Nom",
                                  hintText: "Libelle Code barre",
                                ),
                                onChanged: (value) {
                                  //libele = value;
                                },

                                onTap: () {
                                  print("none");
                                },

                                onSaved: (newValue) {
                                  //nom = newValue!;
                                },
                                //onSubmitted: submit,
                              ),
                            )
                          ],
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TextFormField(
                    controller: codebarController,

                    // textAlign: TextAlign.center,
                    enabled: false,
                    autocorrect: false,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                      //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.format_list_numbered,
                          color: Colors.blue,
                        ),
                      ),
                      //labelText: "Nom",
                      hintText: "Code barre  ",
                    ),

                    onChanged: (value) {
                      //libele = value;
                    },

                    onTap: () {
                      print("none");
                    },

                    onSaved: (newValue) {
                      //nom = newValue!;
                    },
                    //onSubmitted: submit,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TextFormField(
                    controller: prixController,

                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                      //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                      //labelText: "Nom",
                      hintText: "Entrer le Prix",
                      prefixIcon: Container(
                        width: 50,
                        child: Icon(
                          Icons.price_change_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      //libele = value;
                    },
                    onTap: () {
                      //print(valeur);
                    },
                    validator: (value) => value!.isEmpty ? "Veuillez entrer le prix" : null,
                    onSaved: (newValue) {
                      //nom = newValue!;
                    },
                    //onSubmitted: submit,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        label: Text("Ajouter"),
                        onPressed: ajouter,
                        icon: Icon(Icons.add_circle_outlined),
                        style: TextButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
                      ),
                      ElevatedButton.icon(
                        label: Text("Annuler"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Index.top(prep: widget.prepatop),
                              ));
                        },
                        icon: Icon(Icons.cancel_rounded),
                        style: TextButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
