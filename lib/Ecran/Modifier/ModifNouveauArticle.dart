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
  int gencode = 0;
  int id_enseigne = 0;
  int id_enseigne_value_drowp = 0;
  int id = 0;
  int prix = 0;
  String libele = "";
  String imageString = "rien";
  File? fichierImage;

  TextEditingController codebarCcontroller = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController libeleController = TextEditingController();

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
      Article article = Article.modif(this.id, this.libele, this.prix, this.gencode, this.imageString, this.id_enseigne_value_drowp);
      DataArticle().UpdateArticle(article);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Index(2),
          ));
    } else {}
  }

  showImage(String img) {
    return (imageString == "")
        ? null
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
          gencode = int.parse(barcodeLocal);
          codebarCcontroller.text = gencode.toString();
        });
      } else {
        setState(() {
          gencode = 0;
          codebarCcontroller.text = "";
        });
      }
    } catch (e) {
      setState(() {
        gencode = 0;
        codebarCcontroller.text = "";
      });
    }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
    id_enseigne = widget.article.id_enseigne;
    prix = widget.article.prix;
    gencode = widget.article.gencode;
    libele = widget.article.libele;

    imageString = widget.article.image;
    id = widget.article.id;
    libeleController.text = widget.article.libele;
    prixController.text = widget.article.prix.toString();
    codebarCcontroller.text = widget.article.gencode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier Article"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 10,
        padding: EdgeInsets.all(16),
        child: Form(
          key: formValide,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(color: Color.fromRGBO(158, 158, 158, 1), borderRadius: BorderRadius.circular(100)),
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
                    keyboardType: TextInputType.number,
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
                        prix = int.parse(value);
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
                      id_enseigne_value_drowp = int.parse(value.toString());
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //TextButton(onPressed: onPressed, child: child,),
                    TextButton.icon(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                        onPressed: () {
                          BarcodeScanner();
                        },
                        icon: Icon(Icons.camera_alt),
                        label: Text("Scan Barcode")),
                    Text("==========="),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      width: 200,
                      child: TextFormField(
                        controller: codebarCcontroller,
                        style: TextStyle(
                          fontSize: 19,
                        ),
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 3),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),

                          //labelText: "Designation",
                          hintText: "Barcode Generer",
                        ),
                        onChanged: (value) {
                          try {
                            gencode = int.parse(value);
                          } catch (e) {
                            //print("null gencode");
                          }
                        },
                        validator: (value) => value!.isEmpty ? "Veuiller scanner le barcode" : null,
                        onSaved: (newValue) {
                          //nom = newValue!;
                        },
                        //onSubmitted: submit,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.blue), foregroundColor: MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            Modifier();
                            //recuperer();
                          },
                          icon: Icon(Icons.update),
                          label: Text("Modifier")),
                      Padding(padding: EdgeInsets.all(5)),
                      TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.red), foregroundColor: MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Index(2),
                                ));
                            //recuperer();
                          },
                          icon: Icon(Icons.cancel),
                          label: Text("Annuler")),
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
