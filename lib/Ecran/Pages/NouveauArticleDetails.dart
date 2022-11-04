// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:app/Ecran/Pages/ListesNouveauArticle.dart';
import 'package:app/Ecran/Pages/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:app/Ecran/modele/article.dart';

class NouveauArticleDetails extends StatefulWidget {
  Article article = Article();
  NouveauArticleDetails(this.article);

  @override
  State<NouveauArticleDetails> createState() => _NouveauArticleDetailsState();
}

class _NouveauArticleDetailsState extends State<NouveauArticleDetails> {
  showImage(String img) {
    return Image.memory(
      base64Decode(img),
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details Article"),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Index(2),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: widget.article.image == "" ? null : showImage(widget.article.image),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text("Libélé : ${widget.article.libele}"),
            Padding(padding: EdgeInsets.all(5)),
            Text("Prix : ${widget.article.prix}"),
          ],
        ),
      ),
    );
  }
}
