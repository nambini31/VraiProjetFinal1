// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:app/Ecran/Pages/Acceuil.dart';
import 'package:app/Ecran/Pages/ListesNouveauArticle.dart';
import 'package:app/Ecran/Pages/ListesPreparation.dart';
import 'package:app/Ecran/Pages/ListesTop1000.dart';
import 'package:app/Ecran/Pages/Relever.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  int i = 0;
  Preparation prep1 = Preparation();
  Preparation prep = Preparation();

  Index(this.i);
  Index.rel(this.prep1);
  Index.top({required this.prep});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int i = 0;
  int i1 = 0;
  int i2 = 0;
  @override
  void initState() {
    super.initState();
    i = widget.i;
    i1 = widget.prep1.id_prep;
    i2 = widget.prep.id_prep;
  }

  List<Widget> pages = [Acceuil(), ListesPreparation(), ListesNouveauArticle()];

  void onItemTap(int Index) {
    setState(() {
      i = Index;
      i1 = 0;
      i2 = 0;
    });
  }

  Widget retour() {
    if (i1 != 0 && i == 0 && i2 == 0) {
      setState(() {
        i = 1;
      });
      return Relever(widget.prep1);
    } else if (i2 != 0 && i == 0 && i1 == 0) {
      setState(() {
        i = 1;
      });
      return ListesTop1000(
        preptop: widget.prep,
      );
    } else {
      i1 = 0;
      i2 = 0;
      return pages[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: retour(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Acceuil"),
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: "Relever"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Article"),
        ],
        currentIndex: i,
        onTap: onItemTap,
      ),
    );
  }
}
