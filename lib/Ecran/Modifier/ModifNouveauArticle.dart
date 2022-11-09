// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unrelated_type_equality_checks, non_constant_identifier_names, unnecessary_this, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/Ecran/Pages/ListesNouveauArticle.dart';
import 'package:app/Ecran/Pages/index.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/dataArticle.dart';
import 'package:app/Ecran/modele/dataMagasin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

import '../modele/database_Helper.dart';
import '../modele/magasin.dart';

class ModifNouveauArticle extends StatefulWidget {
  Article article = Article();

  ModifNouveauArticle.modification(this.article);

  @override
  State<ModifNouveauArticle> createState() => _PagesNouveauArticleState();
}

class _PagesNouveauArticleState extends State<ModifNouveauArticle> {
  String gencode = "";
  int id_enseigne = 0;
  int id = 0;
  double prix = 0;
  String libele = "";
  String description = "";
  String imageString = "rien";
  File? fichierImage;

  TextEditingController codebarCcontroller = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController libeleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<DropdownMenuItem<String?>> listesvrai = [];
  List<Container> listesvraii = [];

  List<Item> listeItem = [];
  int a = 0;
  void recuperer() async {
    await dataItem().SelectAll().then((value) {
      listeItem = value;
      setState(() {
        a = value.length;
      });
      //setState(() => listeItem);
      listeItem.forEach((element) {
        listesvrai.add(DropdownMenuItem(
          value: element.id_enseigne.toString(),
          child: Text(element.design_enseigne),
        ));
      });
      setState(() => listesvrai);
    });
  }

  var formValide = GlobalKey<FormState>();

  void Modifier() {
    if (formValide.currentState!.validate()) {
      if (pad != 0) {
        setState(() {
          bas = 0;
          pad = 0.7;
        });
      } else {
        Article article = Article.modif(this.id, this.libele, this.prix, this.gencode, this.description, this.imageString, this.id_enseigne);
        DataArticle().UpdateArticle(article);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Index(2),
            ));
      }
    } else {}
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

  void pickImage(ImageSource Sourc) async {
    var images = await ImagePicker().pickImage(source: Sourc, maxHeight: 800, maxWidth: 800);
    String? pathImage;

    if (images != null) {
      setState(() {
        pathImage = images.path;
        fichierImage = File(pathImage!);

        // final imgString = imgbytes.base //print
        imageString = base64Encode(fichierImage!.readAsBytesSync());
      });
      // //print("lien :$pathImage");
      //print(imageString);
    } else {
      //print("image null");
    }
  }

  Future BarcodeScanner() async {
    String barcodeLocal;
    try {
      barcodeLocal = await FlutterBarcodeScanner.scanBarcode("#DF1C5D", "Annuler", true, ScanMode.BARCODE);
      if (barcodeLocal != "-1") {
        setState(() {
          gencode = barcodeLocal;
          codebarCcontroller.text = gencode.toString();
        });
      } else {}
    } catch (e) {}
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
                              this.imageString = "";
                            });
                            Navigator.pop(context);
                          }),
                    ),
                  ],
                ))
          ]),
    );
  }

  bool tap = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
    id_enseigne = widget.article.id_enseigne;

    prix = widget.article.prix;
    gencode = widget.article.gencode;
    libele = widget.article.libele;
    description = widget.article.description;

    imageString = widget.article.image;
    id = widget.article.id;
    libeleController.text = widget.article.libele;
    descriptionController.text = widget.article.description;
    prixController.text = widget.article.prix.toString();
    codebarCcontroller.text = widget.article.gencode.toString();

    if (descriptionController.text.isEmpty) {
      setState(() {
        tap = false;
      });
    } else {
      setState(() {
        tap = true;
      });
    }
  }

  double pad = 0;
  double bas = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Article"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formValide,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(color: Color.fromARGB(255, 216, 211, 211), borderRadius: BorderRadius.circular(100)),
                      child: ClipOval(
                          child: (fichierImage == null)
                              ? showImage(widget.article.image)
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

                    autocorrect: false,
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
                      libele = value;
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
                      try {
                        prix = double.parse(value);
                      } catch (e) {
                        //print("null prix");
                      }
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
                    value: id_enseigne.toString(),
                    //itemHeight:  <String>['Chien', 'Chat', 'Tigre', 'Lion'].map((e) => ),

                    items: listesvrai,
                    hint: Text("Choix Magasin"),
                    onChanged: (value) {
                      id_enseigne = int.parse(value.toString());
                      setState(() => id_enseigne);
                    },

                    validator: (value) => a == 0 ? "Veuillez choisir un Magasin" : null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      filled: true,
                      //hintText: "Magasin",
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
                      onTap: () {
                        if (descriptionController.text.isEmpty) {
                          setState(() {
                            tap = false;
                          });
                        } else {
                          setState(() {
                            tap = true;
                          });
                        }
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            tap = false;
                          });
                        } else {
                          setState(() {
                            tap = true;
                          });
                        }
                        setState(() {
                          description = value;
                        });
                      },
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                      ),
                    ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Index(2),
                                ));
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
                          onPressed: () => ModifAlert("Enregistrer le modification ?", 1),
                          // ignore: sort_child_properties_last
                          child: Text(
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
      ),
    );
  }

  Container errorScan() {
    if (pad != 0) {
      return Container(
        margin: EdgeInsets.only(top: 9, bottom: bas),
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Veuillez scanner le code bar",
          style: TextStyle(color: Color.fromARGB(255, 235, 40, 26), fontSize: 12),
        ),
      );
    }
    return Container();
  }

  Future ModifAlert(String text, int i) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: Text(text),
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
                            return (i == 1)
                                ? Modifier()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Index(2),
                                    ));
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
}
