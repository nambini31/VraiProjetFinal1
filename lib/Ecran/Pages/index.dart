// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:app/Ecran/Pages/Acceuil.dart';
import 'package:app/Ecran/Pages/ListesNouveauArticle.dart';
import 'package:app/Ecran/Pages/ListesPreparation.dart';
import 'package:app/Ecran/Pages/ListesTop1000.dart';
import 'package:app/Ecran/Pages/Relever.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  int i = 0;
  int i1 = 0;
  int i2 = 0;

  Index(this.i);
  Index.rel(this.i1);
  Index.top(this.i2);

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
    i1 = widget.i1;
    i2 = widget.i2;
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
    if (i1 != 0) {
      setState(() {
        i = 1;
      });
      return Relever(i1);
    } else if (i2 != 0) {
      setState(() {
        i = 1;
      });
      return ListesTop1000(id: i2);
    } else {
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
