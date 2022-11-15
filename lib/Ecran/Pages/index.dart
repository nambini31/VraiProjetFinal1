// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously, body_might_complete_normally_nullable

import 'dart:convert';
import 'dart:io';

import 'package:app/Ecran/Pages/Acceuil.dart';
import 'package:app/Ecran/Pages/AucuneDonnes.dart';
import 'package:app/Ecran/Pages/two_letter_icon.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/dataArticle.dart';
import 'package:app/Ecran/modele/dataMagasin.dart';
import 'package:app/Ecran/modele/dataPreparation.dart';
import 'package:app/Ecran/modele/dataTop1000.dart';
import 'package:app/Ecran/modele/magasin.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Index extends StatefulWidget {
  Preparation prep1 = Preparation();

  Index({super.key});

  int id_prep = 0;
  String NomPagePrep = "";
  Index.top(this.id_prep, this.NomPagePrep);
  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int iPage = 0;
  int i1 = 0;
  int i2 = 0;
  int i = 0;

  Top1000 top1000_ajout_modif = Top1000();

  String ip = "197.7.2.241";

  int idPage = 0;
  String NomPagePrep = "";

  List listesAttenteTop = [];
  List listesValiderTop = [];

  List<Preparation> listesAttente = [];
  List<Preparation> listesValider = [];
  List<Preparation> listesTransferer = [];

  bool add_releve = false;
  bool modif_releve = false;
  List<DropdownMenuItem<String?>> listesvraiArticle = [];
  List<DropdownMenuItem<String?>> listesvrai = [];
  var formValideNotExistante = GlobalKey<FormState>();
  var formValideExistante = GlobalKey<FormState>();
  // String selectgencode = "";
  // String selectlibelle = "";
  int id_relever = 0;
  double panga = 0;
  int id_choix = 0;
  String scanError = "";
  double pad = 0;
  double bas = 0;
  Article article_modif = Article();
  bool ajout_article = false;
  bool modif_article = false;
  int id_art_modif = 0;
  List<Item> listeItem = [];

  TextEditingController DesignationControlleurExistant = TextEditingController();
  TextEditingController DesignationControlleurRemplacer_Nouveau = TextEditingController();
  TextEditingController prixControllerTout = TextEditingController();
  TextEditingController codebarControllerRemplacer_Nouveau = TextEditingController();
  TextEditingController codebarControllerExistant = TextEditingController();
  String dateTime() {
    var date = DateTime.now();
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
  }

  List<Article> listesNewArt = [];

  bool end = false;
  int a = 0;
  bool tap = false;
  String gencode = "";
  String description = "";
  int id_enseigne = 0;
  double prix = 0;
  String libele = "";
  String imageString = "";
  File? fichierImage;

  TextEditingController codebarCcontroller = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController libeleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var formValideArticle = GlobalKey<FormState>();

  void ajouter_modif_Article() {
    String txt = "";
    if (ajout_article == true && modif_article == false) {
      txt = "Ajout Article";
    } else if (ajout_article == false && modif_article == true) {
      txt = "Modifier Article";
    }
    if (formValideArticle.currentState!.validate()) {
      //ss
      if (pad != 0) {
        setState(() {
          bas = 0;
          pad = 0.7;
        });
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: ((BuildContext context) {
              return AlertDialog(
                title: Text(txt),
                actionsAlignment: MainAxisAlignment.end,
                actions: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Non")),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          child: TextButton(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                              onPressed: () {
                                if (ajout_article == true && modif_article == false) {
                                  Navigator.pop(context);
                                  Article article = Article.ajt(libele, prix, gencode, description, imageString, id_enseigne);
                                  DataArticle().AjoutArticle(article);
                                  setState(() {
                                    ajout_article = false;
                                  });
                                } else if (ajout_article == false && modif_article == true) {
                                  Navigator.pop(context);
                                  print("$libele, $prix, $gencode, $description, $id_enseigne");
                                  Article article = Article.modif(id_art_modif, libele, prix, gencode, description, imageString, id_enseigne);
                                  DataArticle().UpdateArticle(article);
                                  setState(() {
                                    modif_article = false;
                                  });
                                }
                                recuperer(idPage);
                                ViderChamps();
                              },
                              child: Text("Oui")),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }));
      }
    } else {}
  }

  void pickImage(ImageSource Sourc) async {
    var images = await ImagePicker().pickImage(source: Sourc, maxHeight: 800, maxWidth: 800);
    String? pathImage;

    if (images != null) {
      setState(() {
        pathImage = images.path;
        fichierImage = File(pathImage!);

        // final imgString = imgbytes.base
        imageString = base64Encode(fichierImage!.readAsBytesSync());
      });
      // ////print("lien :$pathImage");

    } else {
      ////print("image null");
    }
  }

  void ViderChamps() {
    DesignationControlleurRemplacer_Nouveau.clear();
    prixControllerTout.clear();
    codebarControllerRemplacer_Nouveau.clear();
    pad = 0;

    codebarCcontroller.clear();
    prixController.clear();
    libeleController.clear();
    descriptionController.clear();
    fichierImage = null;
  }

  Future alertCamera() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SimpleDialog(
          title: Text(
            "Choix",
            textAlign: TextAlign.center,
          ),
          children: [
            Container(
                width: 80,
                //height: 120,
                //padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Icon(Icons.browse_gallery_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Gallerie")
                            ],
                          ),
                          onTap: () {
                            pickImage(ImageSource.gallery);
                            Navigator.pop(context);
                          }),
                    ),
                    //Padding(padding: EdgeInsets.all(5)),
                    Container(
                      height: 50,
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Camera")
                            ],
                          ),
                          onTap: () {
                            pickImage(ImageSource.camera);
                            Navigator.pop(context);
                          }),
                    ),
                    Container(
                      height: 50,
                      child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Effacer")
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              fichierImage = null;
                              imageString = "";
                            });
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ))
          ]),
    );
  }

  void ChargerDrowpMagasin() async {
    listeItem.forEach((element) {
      ////print(element.design_enseigne);
      listesvraiArticle.add(DropdownMenuItem(
        value: element.id_enseigne.toString(),
        child: Text(element.design_enseigne),
      ));
    });
  }

  Future BarcodeScanner() async {
    String barcodeLocal = "";
    try {
      barcodeLocal = await FlutterBarcodeScanner.scanBarcode("#DF1C5D", "Annuler", true, ScanMode.BARCODE);
      if (barcodeLocal != "-1") {
        setState(() {
          end = false;
          codebarControllerRemplacer_Nouveau.text = barcodeLocal;
          codebarCcontroller.text = barcodeLocal;
          gencode = barcodeLocal;
        });
      } else {}
    } catch (e) {}
  }

  void ajouter_modif() {
    if (add_releve == true && modif_releve == false) {
      if (top1000_ajout_modif.ref_art_conc.toString().isEmpty || top1000_ajout_modif.ref_art_conc == '0') {
        if (formValideNotExistante.currentState!.validate()) {
          if (pad == 0) {
            //print("Collecte");
            valideFormAjout(1, "Ajout nouveau concurent");
            recuperer(idPage);
          }
        }
      } else {
        if (listesvrai.length == 1) {
          if (formValideNotExistante.currentState!.validate()) {
            if (pad == 0) {
              //print("nouveau");
              valideFormAjout(2, "Ajout nouveau concurent");
            }
          }
        } else {
          if (id_choix == 1) {
            if (formValideExistante.currentState!.validate()) {
              //print("update");
              valideFormAjout(0, "Ajout relever");
            }
          } else {
            if (formValideNotExistante.currentState!.validate()) {
              if (id_choix == 2 && pad == 0) {
                //print("remplacer");
                valideFormAjout(3, "Changer l'article concurent");
              }
            }
          }
        }
      }
    } else {
      if (top1000_ajout_modif.id_changer_nouveau == 0) {
        valideFormModif(0, "Modification");
      } else if (top1000_ajout_modif.id_changer_nouveau == 1) {
        valideFormModif(1, "Modification");
      } else if (top1000_ajout_modif.id_changer_nouveau == 2) {
        valideFormModif(2, "Modification");
      } else {
        valideFormModif(3, "Modification");
      }
    }
  }

  Future valideFormModif(int id, String txt) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(txt),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Non")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            if (id == 0) {
                              Releve releveExiste = Releve.updateExistant(id_relever, double.parse(prixControllerTout.text), dateTime());
                              DataTop1000().UpdateReleveExistante(releveExiste, idPage);
                            } else {
                              Releve releveNotExiste = Releve.updateRelever(id_relever, DesignationControlleurRemplacer_Nouveau.text,
                                  codebarControllerRemplacer_Nouveau.text, double.parse(prixControllerTout.text), dateTime(), 3);
                              DataTop1000().UpdateReleveNouveauNot_OU_Existante(releveNotExiste, idPage);
                            }

                            setState(() {
                              modif_releve = false;
                              recuperer(idPage);
                            });
                            ViderChamps();
                          },
                          child: Text("Oui")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
  }

  Future valideFormAjout(int id, String txt) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(txt),
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text("Non")),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                            if (id == 0) {
                              Releve releveExiste = Releve.updateExistant(id_relever, double.parse(prixControllerTout.text), dateTime());
                              DataTop1000().UpdateReleveExistante(releveExiste, idPage);
                            } else if (id == 1) {
                              Releve releveNotExiste = Releve.updateRelever(id_relever, DesignationControlleurRemplacer_Nouveau.text,
                                  codebarControllerRemplacer_Nouveau.text, double.parse(prixControllerTout.text), dateTime(), 3);
                              DataTop1000().UpdateReleveNouveauNot_OU_Existante(releveNotExiste, idPage);
                            } else if (id == 2) {
                              Top1000 top1000 = Top1000.id(
                                id_relever,
                                top1000_ajout_modif.ref_art,
                                top1000_ajout_modif.libelle_art,
                                top1000_ajout_modif.gencode_art,
                                top1000_ajout_modif.prix_art,
                                top1000_ajout_modif.ref_art,
                                DesignationControlleurRemplacer_Nouveau.text,
                                codebarControllerRemplacer_Nouveau.text,
                                double.parse(prixControllerTout.text),
                                dateTime(),
                                "",
                                idPage,
                                0,
                                2,
                              );
                              DataTop1000().AjoutNouveauReleveExistante(top1000, idPage);
                            } else {
                              Releve releveExiste = Releve.updateRelever(id_relever, DesignationControlleurRemplacer_Nouveau.text,
                                  codebarControllerRemplacer_Nouveau.text, double.parse(prixControllerTout.text), dateTime(), 1);
                              Releve releveAncien = Releve.insert(id_relever, top1000_ajout_modif.libelle_art_conc,
                                  top1000_ajout_modif.gencode_art_conc, top1000_ajout_modif.ref_art_conc, top1000_ajout_modif.id_prep);
                              DataTop1000().UpdateReleveRemplace(releveExiste, idPage, releveAncien);
                            }

                            setState(() {
                              add_releve = false;
                              recuperer(idPage);
                            });
                            ViderChamps();
                          },
                          child: Text("Oui")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      add_releve = false;
      id_choix = 1;
    });

    recuperer(idPage);
  }

  void onItemTap(int Index) {
    setState(() {
      iPage = Index;
      idPage = 0;
      add_releve = false;
      modif_releve = false;
      pad = 0;
      ajout_article = false;
      modif_article = false;
      listesAttente.clear();
      listesValider.clear();
      listesTransferer.clear();
      listesAttenteTop.clear();
      listesValiderTop.clear();
      listesvraiArticle.clear();
    });
    recuperer(idPage);
    setState(() {
      ChargerDrowpMagasin();
    });
    ViderChamps();
  }

  Future recuperer(int idPage) async {
    await dataItem().SelectAll().then((value) {
      setState(() {
        a = value.length;
        listeItem = value;
      });
    });

    await DataArticle().SelectAll().then((value) {
      //////print(object)
      setState(() {
        listesNewArt = value;
      });
    });

    if (idPage == 0) {
      await DataPreparation().SelectAttente().then((value) {
        // ////print()
        setState(() {
          listesAttente = value;
        });
      });
      await DataPreparation().SelectValider().then((value) {
        // ////print()
        setState(() {
          listesValider = value;
        });
      });
      await DataPreparation().SelectTransferer().then((value) {
        // ////print()
        setState(() {
          listesTransferer = value;
        });
      });
    } else {
      //print("id = $idPage");
      await DataTop1000().SelectAttente(idPage).then((value) {
        //////print()
        setState(() {
          listesAttenteTop = value;
        });
      });
      await DataTop1000().SelectValider(idPage).then((value) {
        //////print()
        setState(() {
          listesValiderTop = value;
        });
      });
    }
  } // ////print

  Future search(String txt) async {
    if (idPage == 0) {
      if (i == 0) {
        await DataPreparation().SearchAttente(txt).then((value) {
          // ////print()
          setState(() {
            listesAttente = value;
          });
        });
      } else if (i == 1) {
        await DataPreparation().SearchValider(txt).then((value) {
          // ////print()
          setState(() {
            listesValider = value;
          });
        });
      } else {
        await DataPreparation().SearchTransferer(txt).then((value) {
          // ////print()
          setState(() {
            listesTransferer = value;
          });
        });
      }
    } else {
      if (i == 0) {
        await DataTop1000().SearchAttente(idPage, txt).then((value) {
          //////print()
          setState(() {
            listesAttenteTop = value;
          });
        });
      } else {
        await DataTop1000().SearchValider(idPage, txt).then((value) {
          //////print()
          setState(() {
            listesValiderTop = value;
          });
        });
      }
    }
  }

  void Transerer(int id_prep) async {
    await DataPreparation().SelectAllOne(id_prep, ip);
    recuperer(idPage);
    //}
  }

////print
//focus
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool appExit = false;
        if (iPage == 1) {
          if (idPage != 0) {
            if (add_releve == true || modif_releve == true) {
              setState(() {
                add_releve = false;
                modif_releve = false;
              });
            } else {
              setState(() {
                listesAttenteTop.clear();
                listesValiderTop.clear();
                listesvraiArticle.clear();
                add_releve = false;
                modif_releve = false;
                iPage = 1;
                idPage = 0;
                recuperer(idPage);
              });
            }
          } else if (idPage == 0) {
            appExit = await exitApp();
          }
        } else if (iPage == 2) {
          if (ajout_article == true || modif_article == true) {
            setState(() {
              ajout_article = false;
              modif_article = false;
            });
          } else {
            appExit = await exitApp();
          }
        } else {
          appExit = await exitApp();
        }
        return Future.value(appExit);
      },
      child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: DefaultTabController(
            length: (idPage == 0) ? 3 : 2,
            initialIndex: 0,
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Titre(iPage),
                  actions: ListActionAppBar(iPage),
                  leading: LeadingPages(),
                  automaticallyImplyLeading: true,
                ),
                body: CorpsPages(iPage),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Acceuil"),
                    BottomNavigationBarItem(icon: Icon(Icons.compare), label: "Relever"),
                    BottomNavigationBarItem(icon: Icon(Icons.article), label: "Article"),
                    //BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "Collect"),
                  ],
                  currentIndex: iPage,
                  onTap: onItemTap,
                )),
          )),
    );
  }

  IconButton? LeadingPages() {
    if (iPage == 1) {
      if (idPage != 0) {
        if (add_releve == true || modif_releve == true) {
          return IconButton(
              onPressed: () {
                setState(() {
                  add_releve = false;
                  modif_releve = false;
                  //recuperer(idPage);
                });
              },
              icon: Icon(Icons.arrow_back));
        }
        return IconButton(
            onPressed: () {
              setState(() {
                listesAttenteTop.clear();
                listesValiderTop.clear();
                listesvraiArticle.clear();
                add_releve = false;
                modif_releve = false;
                iPage = 1;
                idPage = 0;
                recuperer(idPage);
              });
            },
            icon: Icon(Icons.arrow_back));
      } else if (idPage == 0) {
        return null;
      }
    } else if (iPage == 2) {
      if (ajout_article == true || modif_article == true) {
        return IconButton(
            onPressed: () {
              setState(() {
                ajout_article = false;
                modif_article = false;
              });
            },
            icon: Icon(Icons.arrow_back));
      }
    }
  }

  Text Titre(int iPage) {
    if (iPage == 0) {
      return Text("ACCEUIL");
    } else if (iPage == 2) {
      return Text("Nouveau Article");
    } else {
      if (idPage == 0) {
        return Text("Preparation");
      } else {
        return Text(NomPagePrep);
      }
    }
  }

  List<Widget>? ListActionAppBar(int iPage) {
    if (iPage == 0) {
      return null;
    } else if (iPage == 1 && idPage != 0) {
      return null;
    } else if (iPage == 2 && ajout_article == false && modif_article == false) {
      return [
        IconButton(
          onPressed: () {
            setState(() {
              id_enseigne = listeItem[0].id_enseigne;
              ajout_article = true;
            });
          },
          icon: Icon(Icons.add),
        )
      ];
    } else if (iPage == 1 && idPage == 0) {
      return [
        IconButton(
            onPressed: () async {
              await DataPreparation().Charger(ip);
              setState(() {
                recuperer(idPage);
              });
            },
            icon: Icon(Icons.get_app_sharp))
      ];
    }
  }

  Widget CorpsPages(int iPage) {
    //print(" $add_releve  $idPage $modif_releve");

    if (iPage == 0) {
      setState(() {
        id_choix = 1;
      });
      return Acceuil();
    } else if (iPage == 2) {
      setState(() {
        id_choix = 1;
      });
      if (ajout_article == false && modif_article == false) {
        return ListesNouveauArticles();
      } else if (ajout_article == true && modif_article == false) {
        return AjoutNouveauArticle();
      } else {
        return AjoutNouveauArticle();
      }
    } else {
      if (add_releve == true && idPage != 0 && modif_releve == false) {
        return Formulaire(top1000_ajout_modif, context);
      } else if (add_releve == false && idPage != 0 && modif_releve == true) {
        setState(() {
          id_choix = 1;
        });
        return Formulaire(top1000_ajout_modif, context);
      }
      setState(() {
        id_choix = 1;
      });
      return Scaffold(
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
            bottom: TabOnTap(idPage),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: TabBarAffichage(idPage),
        ),
      );
    }
  }

  TabBar TabOnTap(int idPage) {
    if (idPage == 0) {
      return TabBar(
          onTap: (value) {
            setState(() {
              i = value;
            });
          },
          // ignore: prefer_const_literals_to_create_immutables
          tabs: [
            Tab(
              text: "Attente",
            ),
            Tab(
              text: "Enregistrer",
            ),
            Tab(
              text: "Transferer",
            )
          ]);
    } else {
      return TabBar(
          onTap: (value) {
            setState(() {
              i = value;
            });
          },
          tabs: [
            Tab(
              text: "Attente",
            ),
            Tab(
              text: "Enregistrer",
            )
          ]);
    }
  }

  TabBarView TabBarAffichage(int idPage) {
    if (idPage == 0) {
      return TabBarView(physics: BouncingScrollPhysics(), children: [
        preparationAttente(),
        preparationValider(),
        preparationTransferer(),
      ]);
    } else {
      return TabBarView(physics: BouncingScrollPhysics(), children: [
        Attente(),
        Valide(),
      ]);
    }
  }

  Icon icone({int? etat, int? etat_attente, double? prix}) {
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
    if (idPage == 0) {
      if (etat == 1) {
        return iconValide;
      } else if (etat == 2) {
        return iconTransferer;
      } else if (etat_attente == 1) {
        return iconAttente;
      }
      return iconNon;
    } else {
      if (etat == 1) {
        return iconValide;
      } else if (etat == 0 && prix != 0) {
        return iconAttente;
      } else {
        return iconNon;
      }
    }
  }

  ActionPane? startAction({etat, Top1000? top1000}) {
    var startAttente = ActionPane(motion: ScrollMotion(), extentRatio: 0.4, children: [
      SlidableAction(
        onPressed: (context) {
          alerteTraner(idPage);
        },
        label: "Transferer",
        backgroundColor: Colors.green,
        icon: Icons.arrow_circle_right_rounded,
      ),
    ]);

    var startAttenteArticle = ActionPane(motion: ScrollMotion(), extentRatio: 0.4, children: [
      SlidableAction(
        onPressed: (context) {
          alerte(top1000: top1000);
          FocusScope.of(context).requestFocus(FocusNode());
        },
        label: "Plus",
        backgroundColor: Colors.blue,
        icon: Icons.description,
      ),
      Padding(padding: EdgeInsets.all(2)),
      SlidableAction(
        onPressed: (context) {
          alerteValider(top1000!.id_releve);
        },
        label: "Valider",
        backgroundColor: Colors.green,
        icon: Icons.add_home,
      ),
    ]);
    var startAttenteNouveau = ActionPane(motion: ScrollMotion(), extentRatio: 0.3, children: [
      SlidableAction(
        onPressed: (context) {
          alerte(top1000: top1000);
          FocusScope.of(context).requestFocus(FocusNode());
        },
        label: "Plus",
        backgroundColor: Colors.blue,
        icon: Icons.description,
      ),
    ]);
    if (idPage == 0) {
      if (etat == 0 || etat == 2) {
        return null;
      } else {
        return startAttente;
      }
    } else {
      if (top1000!.etat_art == 1) {
        return startAttenteNouveau;
      } else if (top1000.etat_art == 0 && top1000.prix_art_conc != 0) {
        return startAttenteArticle;
      } else {
        return startAttenteNouveau;
      }
    }
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
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("NON")),
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
                            validerRelever(id_releve);
                          },
                          child: Text("OUI")),
                    )
                  ],
                ),
              )
            ],
          );
        }));
  }

  Future<void> validerRelever(int id_releve) async {
    await DataTop1000().UpdateEtatReleve(id_releve, idPage, dateTime());
    setState(() {
      recuperer(idPage);
    });

    // setState(() {
    //   i = 1;
    // });
  }

  ActionPane? endAction({Top1000? top1000, Preparation? preparation}) {
    var endPrep = ActionPane(motion: ScrollMotion(), extentRatio: 0.5, children: [
      SlidableAction(
        onPressed: (context) {
          //alerte1();
          AlerteDelete(preparation!, idPage);
        },
        label: "Delete",
        backgroundColor: Colors.red,
        icon: Icons.delete,
      ),
      Padding(padding: EdgeInsets.all(2)),
      SlidableAction(
        onPressed: (context) {
          alerte(prep: preparation);
        },
        label: "Plus",
        backgroundColor: Colors.blue,
        icon: Icons.description,
      ),
    ]);
    var endtopplus = ActionPane(motion: ScrollMotion(), extentRatio: 0.3, children: [
      SlidableAction(
        onPressed: (context) {
          listesvrai.clear();

          setState(() {
            add_releve = true;
            modif_releve = false;
            top1000_ajout_modif = top1000!;
          });
          NonExistantAdd();
          setState(() {
            id_choix = 1;
          });
        },
        label: "Nouveau",
        backgroundColor: Colors.blue,
        icon: Icons.add,
      ),
    ]);
    var endTop = ActionPane(motion: ScrollMotion(), extentRatio: 0.7, children: [
      SlidableAction(
        onPressed: (context) {
          alerteAnnuler(top1000!.id_releve, top1000.id_changer_nouveau);
        },
        label: "Annuler",
        backgroundColor: Colors.red,
        icon: Icons.cancel,
      ),
      Padding(padding: EdgeInsets.all(2)),
      SlidableAction(
        onPressed: (context) {
          listesvrai.clear();

          setState(() {
            add_releve = false;
            modif_releve = true;
            top1000_ajout_modif = top1000!;
          });
          TypeChoixModif();
        },
        label: "Modifier",
        backgroundColor: Colors.blue,
        icon: Icons.add_home,
      ),
      Padding(padding: EdgeInsets.all(2)),
      SlidableAction(
        onPressed: (context) {
          listesvrai.clear();

          setState(() {
            add_releve = true;
            modif_releve = false;
            top1000_ajout_modif = top1000!;
          });
          NonExistantAdd();
          setState(() {
            id_choix = 1;
          });
        },
        label: "Nouveau",
        backgroundColor: Colors.blue,
        icon: Icons.add,
      ),
    ]);

    if (idPage == 0) {
      return endPrep;
    } else {
      if (top1000!.etat_art == 1) {
        //print("gen valide");
        return null;
      } else if (top1000.etat_art == 0 && top1000.prix_art_conc != 0) {
        //print("gen attente ");
        return endTop;
      } else {
        if (top1000.ref_art_conc.toString().isEmpty || top1000.ref_art_conc.toString() == "0") {
          //print("gen collecte");
          return null;
        } else {
          //print("gen non nul");
          return endtopplus;
        }
      }
    }
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

  Future alerteAnnuler(int id_releve, int id_nouv_change) async {
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
                    SizedBox(
                      width: 100,
                      child: TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("NON")),
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
                            annuler(id_releve, id_nouv_change);
                          },
                          child: Text("OUI")),
                    ),
                  ],
                ),
              )
            ],
          );
        }));
  }

  Future<void> annuler(int id_releve, int id_nouv) async {
    await DataTop1000().AnnulerReleve(id_releve, id_nouv, idPage);
    setState(() {
      recuperer(idPage);
    });
  }

  Future AlerteDelete(Preparation prep, int idPage) async {
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
                  children: Delete_Prep_Top(prep, idPage),
                ),
              )
            ],
          );
        }));
  }

  List<Widget> Delete_Prep_Top(Preparation prep, int idPage) {
    if (idPage == 0) {
      return [
        SizedBox(
          width: 100,
          child: TextButton(
              style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
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
              style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: () {
                Navigator.pop(context);
                DataPreparation().DeletePreparation(prep.id_prep);
                recuperer(idPage);
              },
              child: Text("OK")),
        ),
      ];
    } else {
      return [
        SizedBox(
          width: 100,
          child: TextButton(
              style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NON")),
        ),
        SizedBox(
          width: 30,
        ),
        Container(
          width: 100,
          child: TextButton(
              style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.white), backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: () {
                // Navigator.pop(context);
                // annuler(id_releve);
              },
              child: Text("OUI")),
        ),
      ];
    }
  }

  Future alerte({Preparation? prep, Top1000? top1000}) async {
    if (idPage == 0) {
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
                height: (prep!.description.toString().length > 100) ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height / 5,
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
    } else {
      if (top1000!.date_maj_releve == "" && top1000.date_val_releve == "") {
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
  }

  String TextPrix(double prix) {
    if (prix != 0) {
      return "$prix Ar";
    } else {
      return "0 Ar";
    }
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
                      startActionPane: startAction(etat: prep.etat),
                      endActionPane: endAction(preparation: prep),
                      child: ListTile(
                          onTap: () async {
                            setState(() {
                              idPage = prep.id_prep;
                              NomPagePrep = prep.libelle_prep;
                              recuperer(idPage);
                            });
                          },
                          title: Text(prep.libelle_prep),
                          subtitle: Center(child: Text("${prep.design_magasin} ( ${prep.libelle_zone} )")),
                          leading: TwoLetterIcon(prep.libelle_prep),
                          trailing: icone(etat: prep.etat, etat_attente: prep.etat_attente)),
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
                      startActionPane: startAction(etat: prep.etat),
                      endActionPane: endAction(preparation: prep),
                      child: ListTile(
                          onTap: () async {
                            setState(() {
                              idPage = prep.id_prep;
                              NomPagePrep = prep.libelle_prep;
                              recuperer(idPage);
                            });
                          },
                          title: Text(prep.libelle_prep),
                          subtitle: Center(child: Text("${prep.design_magasin} ( ${prep.libelle_zone} )")),
                          leading: TwoLetterIcon(prep.libelle_prep),
                          trailing: icone(etat: prep.etat, etat_attente: prep.etat_attente)),
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
                      startActionPane: startAction(etat: prep.etat),
                      endActionPane: endAction(preparation: prep),
                      child: ListTile(
                          onTap: () async {
                            setState(() {
                              idPage = prep.id_prep;
                              NomPagePrep = prep.libelle_prep;
                              recuperer(idPage);
                            });
                          },
                          title: Text(prep.libelle_prep),
                          subtitle: Center(child: Text("${prep.design_magasin} ( ${prep.libelle_zone} )")),
                          leading: TwoLetterIcon(prep.libelle_prep),
                          trailing: icone(etat: prep.etat, etat_attente: prep.etat_attente)),
                    ),
                  );
                }),
      ),
    );
  }

  Widget Attente() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Center(
        child: (listesAttenteTop.isEmpty)
            ? AucuneDonnes()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: listesAttenteTop.length,
                itemBuilder: (context, index) {
                  Top1000 top1000 = listesAttenteTop[index];

                  return SingleChildScrollView(
                      child: Slidable(
                    startActionPane: startAction(top1000: top1000),
                    endActionPane: endAction(top1000: top1000),
                    child: ListTile(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        if (top1000.prix_art_conc > 0) {
                        } else {
                          setState(() {
                            top1000_ajout_modif = top1000;
                          });
                          listesvrai.clear();

                          TypeChoix(top1000.ref_art_conc);
                          setState(() {
                            //print(id_choix);
                            add_releve = true;
                          });
                        }
                      },
                      title: TextS2M(top1000.libelle_art, top1000.gencode_art, 13),
                      subtitle: (top1000.ref_art_conc.toString().isEmpty || top1000.ref_art_conc == '0')
                          ? null
                          : TextConcur(top1000.libelle_art_conc, top1000.gencode_art_conc),
                      leading: Icon(
                        Icons.production_quantity_limits,
                        size: 40,
                        color: Colors.green,
                      ),
                      trailing: icone(etat: top1000.etat_art, prix: top1000.prix_art_conc),
                    ),
                  ));
                }),
      ),
    );
  }

  Text TextS2M(String libelle, String gencode, double taille) {
    return Text(
      "$libelle : $gencode",
      style: TextStyle(fontSize: taille),
    );
  }

  Text TextConcur(String libelle, String gencode) {
    return Text(
      "$libelle : $gencode",
      style: TextStyle(fontSize: 17.5, height: 2.2, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Container Valide() {
    return Container(
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: Center(
          child: (listesValiderTop.isEmpty)
              ? AucuneDonnes()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listesValiderTop.length,
                  itemBuilder: (context, index) {
                    Top1000 top1000 = listesValiderTop[index];

                    return SingleChildScrollView(
                        child: Slidable(
                      startActionPane: startAction(top1000: top1000),
                      endActionPane: endAction(top1000: top1000),
                      child: ListTile(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          if (top1000.prix_art_conc > 0) {
                          } else {
                            setState(() {
                              top1000_ajout_modif = top1000;
                            });
                            listesvrai.clear();

                            TypeChoix(top1000.ref_art_conc);
                            setState(() {
                              //print(id_choix);
                              add_releve = true;
                            });
                          }
                        },
                        title: TextS2M(top1000.libelle_art, top1000.gencode_art, 13),
                        subtitle: (top1000.ref_art_conc.toString().isEmpty || top1000.ref_art_conc == '0')
                            ? null
                            : TextConcur(top1000.libelle_art_conc, top1000.gencode_art_conc),
                        leading: Icon(
                          Icons.production_quantity_limits,
                          size: 40,
                          color: Colors.green,
                        ),
                        trailing: icone(etat: top1000.etat_art, prix: top1000.prix_art_conc),
                      ),
                    ));
                  }),
        ),
      ),
    );
  }

  Future Existant() async {
    ["Existant", "Remplacer"].forEach((element) {
      listesvrai.add(DropdownMenuItem(
        value: id_choix.toString(),
        child: Text(element),
      ));
      setState(() {
        id_choix = id_choix + 1;
      });
    });

    setState(() {
      id_relever = top1000_ajout_modif.id_releve;
    });
    setState(() => listesvrai);
  }

  Future NonExistantAdd() async {
    listesvrai.add(DropdownMenuItem(
      value: id_choix.toString(),
      child: Text("Nouveau"),
    ));
    setState(() {
      id_choix = id_choix + 1;
    });
    setState(() => listesvrai);
    setState(() => id_relever = top1000_ajout_modif.id_releve);
  }

  Future NonExistant() async {
    listesvrai.add(DropdownMenuItem(
      value: id_choix.toString(),
      child: Text("Collecte"),
    ));
    setState(() {
      id_choix = id_choix + 1;
    });
    setState(() => listesvrai);
    setState(() => id_relever = top1000_ajout_modif.id_releve);
  }

  Future Remplacant() async {
    listesvrai.add(DropdownMenuItem(
      value: id_choix.toString(),
      child: Text("Remplacer"),
    ));
    setState(() {
      id_choix = id_choix + 1;
    });
    setState(() => listesvrai);
    setState(() => id_relever = top1000_ajout_modif.id_releve);
  }

  Future ExisteSeul() async {
    listesvrai.add(DropdownMenuItem(
      value: id_choix.toString(),
      child: Text("Existante"),
    ));
    setState(() {
      id_choix = id_choix + 1;
    });
    setState(() => listesvrai);
    setState(() => id_relever = top1000_ajout_modif.id_releve);
  }

  Future TypeChoix(String id_Concur) async {
    if (id_Concur.isEmpty || id_Concur == '0') {
      NonExistant();
    } else {
      Existant();
      DesignationControlleurExistant.text = top1000_ajout_modif.libelle_art_conc;
      codebarControllerExistant.text = top1000_ajout_modif.gencode_art_conc;
    }
    setState(() {
      id_choix = 1;
    });
  }

  Future TypeChoixModif() async {
    if (top1000_ajout_modif.id_changer_nouveau == 0) {
      ExisteSeul();
      DesignationControlleurExistant.text = top1000_ajout_modif.libelle_art_conc;
      codebarControllerExistant.text = top1000_ajout_modif.gencode_art_conc;
      prixControllerTout.text = top1000_ajout_modif.prix_art_conc.toString();
    } else if (top1000_ajout_modif.id_changer_nouveau == 1) {
      Remplacant();
      DesignationControlleurRemplacer_Nouveau.text = top1000_ajout_modif.libelle_art_conc;
      codebarControllerRemplacer_Nouveau.text = top1000_ajout_modif.gencode_art_conc;
      prixControllerTout.text = top1000_ajout_modif.prix_art_conc.toString();
    } else if (top1000_ajout_modif.id_changer_nouveau == 2) {
      NonExistantAdd();
      DesignationControlleurRemplacer_Nouveau.text = top1000_ajout_modif.libelle_art_conc;
      codebarControllerRemplacer_Nouveau.text = top1000_ajout_modif.gencode_art_conc;
      prixControllerTout.text = top1000_ajout_modif.prix_art_conc.toString();
    } else {
      NonExistant();
      DesignationControlleurRemplacer_Nouveau.text = top1000_ajout_modif.libelle_art_conc;
      codebarControllerRemplacer_Nouveau.text = top1000_ajout_modif.gencode_art_conc;
      prixControllerTout.text = top1000_ajout_modif.prix_art_conc.toString();
      id_choix = 1;
    }

    // id_choix = 1;
  }

  SingleChildScrollView Formulaire(Top1000 top1000, BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          (end == false)
              ? SizedBox()
              : Container(
                  color: Colors.red,
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    scanError,
                    textAlign: TextAlign.center,
                    style: TextStyle(wordSpacing: 2, height: 1.6, fontSize: 19, color: Colors.white),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [chooixEntete(), form(), validation(top1000)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    if (add_releve == true && modif_releve == false) {
      if (listesvrai.length == 1) {
        return FormNotExiste(context);
      } else {
        if (top1000_ajout_modif.ref_art_conc.toString().isEmpty || top1000_ajout_modif.ref_art_conc == '0') {
          //print("not existe");
          return FormNotExiste(context);
        } else {
          if (id_choix == 1) {
            //print("choisit 1 ");
            return FormExiste(context);
          } else {
            //print('choisit autre');
            return FormNotExiste(context);
          }
        }
      }
    } else if (add_releve == false && modif_releve == true) {
      if (top1000_ajout_modif.id_changer_nouveau == 0) {
        return FormExiste(context);
      } else if (top1000_ajout_modif.id_changer_nouveau == 1) {
        return FormNotExiste(context);
      } else if (top1000_ajout_modif.id_changer_nouveau == 2) {
        return FormNotExiste(context);
      } else {
        return FormNotExiste(context);
      }
    }
    return Container();
  }

  Column chooixEntete() {
    return Column(
      children: [
        Text("ID RELEVER : $id_relever"),
        Padding(padding: EdgeInsets.all(12)),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: DropdownButtonFormField2(
            value: id_choix.toString(),
            items: listesvrai,
            hint: Text("Choix Concurent"),
            onChanged: (value) {
              FocusScope.of(context);
              //print(top1000_ajout_modif.ref_art_conc);
              if (id_choix == int.parse(value.toString())) {
              } else {
                ViderChamps();
              }
              setState(() {
                id_choix = int.parse(value.toString());
              });
              //print(id_choix);
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
      ],
    );
  }

// if (
  Form FormExiste(BuildContext context) {
    return Form(
        key: formValideExistante,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 0),
            child: TextFormField(
              controller: DesignationControlleurExistant,
              enabled: false,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: 50,
                  child: Icon(
                    Icons.article_rounded,
                    color: Colors.blue,
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 10),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                //labelText: "Nom",
                hintText: "Designation",
              ),
              onChanged: (value) {},

              onTap: () {
                //print("none");
              },

              onSaved: (newValue) {
                //nom = newValue!;
              },
              //onSubmitted: submit,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              controller: codebarControllerExistant,

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
                //print("none");
              },

              onSaved: (newValue) {
                //nom = newValue!;
              },
              //onSubmitted: submit,
            ),
          ),
          //errorDesign(),

          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: TextFormField(
              controller: prixControllerTout,

              autocorrect: false,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                ////print(valeur);
              },
              validator: (value) => value!.isEmpty ? "Veuillez entrer le prix" : null,
              onSaved: (newValue) {
                //nom = newValue!;
              },
              //onSubmitted: submit,
            ),
          ),
        ]));
  }

  Container validation(Top1000 top1000) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  ViderChamps();
                  add_releve = false;
                  modif_releve = false;
                  setState(() {
                    top1000_ajout_modif = top1000;
                  });
                  listesvrai.clear();

                  TypeChoix(top1000.ref_art_conc);
                });
              },
              // ignore: sort_child_properties_last
              child: Text(
                "ANNULER",
                style: TextStyle(letterSpacing: 1),
              ),
              style: TextButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
            ),
          ),
          Container(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                ajouter_modif();
              },
              // ignore: sort_child_properties_last
              child: (add_releve == true)
                  ? Text(
                      "AJOUTER",
                      style: TextStyle(letterSpacing: 1),
                    )
                  : Text(
                      "MODIFIER",
                      style: TextStyle(letterSpacing: 1),
                    ),
              style: TextButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
        ],
      ),
    );
  }

  Form FormNotExiste(BuildContext context) {
    return Form(
        key: formValideNotExistante,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: TextFormField(
                  controller: DesignationControlleurRemplacer_Nouveau,

                  autocorrect: false,

                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                    //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                    //labelText: "Nom",
                    hintText: "Designation",
                    prefixIcon: Container(
                      width: 50,
                      child: Icon(
                        Icons.article_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    //libele = value;
                  },
                  onTap: () {
                    ////print(valeur);
                  },
                  validator: (value) => value!.isEmpty ? "Veuillez entrer la designation" : null,
                  onSaved: (newValue) {
                    //nom = newValue!;
                  },
                  //onSubmitted: submit,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(pad),
                color: pad == 0 ? null : Colors.redAccent,
                child: Row(
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
                      width: MediaQuery.of(context).size.width - (pad == 0 ? 124 : 125.7),
                      child: TextFormField(
                        controller: codebarControllerRemplacer_Nouveau,
                        validator: (value) {
                          if (codebarControllerRemplacer_Nouveau.text.isEmpty) {
                            setState(() {
                              bas = 0;
                              pad = 0.7;
                            });
                          } else {
                            setState(() {
                              pad = 0;
                            });
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
                          hintText: "Code barre",
                        ),
                        onChanged: (value) {},

                        onTap: () {
                          //print("none");
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
              errorScan()
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: TextFormField(
              controller: prixControllerTout,

              autocorrect: false,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                ////print(valeur);
              },
              validator: (value) => value!.isEmpty ? "Veuillez entrer le prix" : null,
              onSaved: (newValue) {
                //nom = newValue!;
              },
              //onSubmitted: submit,
            ),
          ),
        ]));
  }

  SingleChildScrollView AjoutNouveauArticle() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: formValideArticle,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(color: Color.fromARGB(255, 216, 211, 211), borderRadius: BorderRadius.circular(100)),
                    child: ClipOval(
                        child: (fichierImage == null)
                            ? showImage(imageString)
                            : Image.file(
                                fichierImage!,
                                fit: BoxFit.cover,
                                //width: 50,
                              )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    width: 70,
                    child: RawMaterialButton(
                        padding: EdgeInsets.all(12),
                        shape: CircleBorder(),
                        fillColor: Colors.lightBlue,
                        onPressed: () {
                          alertCamera();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: libeleController,
                  style: TextStyle(fontSize: 19),

                  //autocorrect: false,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 3),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                    //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                    //labelText: "Nom",
                    hintText: "Entrer la designation",
                    prefixIcon: Icon(
                      Icons.article_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      libele = value;
                      print(value);
                    });
                  },
                  onTap: () {
                    //////print(valeur);
                  },
                  validator: (value) => value!.isEmpty ? "Veuillez entrer la designation" : null,
                  onSaved: (newValue) {
                    //nom = newValue!;
                  },
                  //onSubmitted: submit,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: prixController,
                  style: TextStyle(fontSize: 19),

                  autocorrect: false,

                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 3),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                    //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                    //labelText: "Designation",
                    hintText: "Entrer le prix",
                    prefixIcon: Icon(
                      Icons.price_change_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      try {
                        prix = double.parse(value);
                      } catch (e) {
                        ////print("null prix");
                      }
                    });
                  },
                  validator: (value) => value!.isEmpty ? "Veuillez entrer un prix" : null,
                  onSaved: (newValue) {
                    //nom = newValue!;
                  },
                  //onSubmitted: submit,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: DropdownButtonFormField2(
                  //itemHeight:  <String>['Chien', 'Chat', 'Tigre', 'Lion'].map((e) => ),

                  items: listesvraiArticle,
                  hint: Text("Choix Magasin"),
                  onChanged: (value) {
                    id_enseigne = int.parse(value.toString());

                    setState(
                      () => id_enseigne,
                    );
                  },
                  itemPadding: EdgeInsets.only(right: 20, left: 30),
                  value: id_enseigne.toString(),
                  validator: (value) => a == 0 ? "Veuillez choisir un Magasin" : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    filled: true,

                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                    //contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                    prefixIcon: Icon(
                      Icons.price_change_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                padding: EdgeInsets.all(pad),
                color: pad == 0 ? null : Colors.redAccent,
                child: Row(
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
                      width: MediaQuery.of(context).size.width - (pad == 0 ? 124 : 125.7),
                      child: TextFormField(
                        controller: codebarCcontroller,
                        validator: (value) {
                          if (codebarCcontroller.text.isEmpty) {
                            setState(() {
                              bas = 0;
                              pad = 0.7;
                            });
                          } else {
                            setState(() {
                              pad = 0;
                            });
                          }
                        },
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
                          hintText: "Code barre",
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
              errorScan(),
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                      controller: descriptionController,
                      style: TextStyle(fontSize: 19),
                      autocorrect: false,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            tap = false;
                          });
                        } else {
                          tap = true;
                        }
                        setState(() {
                          description = value;
                        });
                      },
                      // onTap: () {
                      //   setState(() {
                      //     tap = true;
                      //   });
                      // },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                      )),
                ),
                (tap == true)
                    ? SizedBox()
                    : Positioned(
                        top: 45,
                        left: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Description",
                          style: TextStyle(fontSize: 19, color: Color.fromARGB(140, 0, 0, 0)),
                        ),
                      )
              ]),
              Container(
                margin: EdgeInsets.only(top: 20, left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            ajout_article = false;
                            modif_article = false;
                            listesvraiArticle.clear();
                          });
                          ViderChamps();
                          recuperer(idPage);
                          ChargerDrowpMagasin();
                        },
                        style: TextButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
                        child: Text(
                          "ANNULER",
                          style: TextStyle(letterSpacing: 1),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          ajouter_modif_Article();
                        },
                        // ignore: sort_child_properties_last
                        child: (ajout_article == true && modif_article == false)
                            ? Text(
                                "AJOUTER",
                                style: TextStyle(letterSpacing: 1),
                              )
                            : Text(
                                "MODIFIER",
                                style: TextStyle(letterSpacing: 1),
                              ),
                        style: TextButton.styleFrom(
                            elevation: 0,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(1)))),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SlidableAutoCloseBehavior ListesNouveauArticles() {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      closeWhenTapped: true,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: (listesNewArt.isEmpty)
              ? AucuneDonnes()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listesNewArt.length,
                  itemBuilder: (context, index) {
                    Article article = listesNewArt[index];
                    return Slidable(
                      closeOnScroll: true,
                      endActionPane: ActionPane(motion: ScrollMotion(), extentRatio: 0.5, children: [
                        SlidableAction(
                          onPressed: (context) {
                            alerteDeleteArticleNouveau(article.id);
                          },
                          label: "Supprimer",
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              modif_article = true;
                              libeleController.text = article.libele;
                              codebarCcontroller.text = article.gencode;
                              descriptionController.text = article.description;
                              imageString = article.image;
                              libele = article.libele;
                              gencode = article.gencode;
                              description = article.description;
                              prix = article.prix;
                              id_art_modif = article.id;
                              id_enseigne = article.id_enseigne;
                              prixController.text = article.prix.toString();
                            });
                          },
                          label: "Modifier",
                          backgroundColor: Colors.blue,
                          icon: Icons.update,
                        )
                      ]),
                      child: ListTile(
                          onTap: () {
                            alerteArticleNouveau(article.image, article.description);
                          },
                          title: TextConcurArticle(article.libele, article.gencode),
                          subtitle: TextprixArticle(article.design_enseigne, article.prix.toString(), 14),
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
    );
  }

  Center TextprixArticle(String enseigne, String prix, double taille) {
    return Center(
      child: Text(
        " $enseigne  :  $prix Ar",
        style: TextStyle(fontSize: taille, height: 3, color: Color.fromARGB(255, 41, 38, 38)),
      ),
    );
  }

  Text TextConcurArticle(String libelle, String gencode) {
    return Text(
      "$libelle : $gencode",
      style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  showImage(String img) {
    return (imageString == "")
        ? Icon(
            Icons.broken_image,
            size: 100,
          )
        : Image.memory(
            base64Decode(img),
            fit: BoxFit.cover,
          );
  }

  Future alerteDeleteArticleNouveau(int id) async {
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
                            recuperer(idPage);
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

  Future alerteArticleNouveau(String image, String description) async {
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

//pad
  Container errorScan() {
    if (pad != 0) {
      return Container(
        margin: EdgeInsets.only(top: 9, bottom: bas),
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Veuillez scanner un code bar",
          style: TextStyle(color: Color.fromARGB(255, 235, 40, 26), fontSize: 12),
        ),
      );
    }
    return Container();
  }

  Future<bool> exitApp() async {
    bool AppExit = await showDialog(
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
    return AppExit;
  }
}
