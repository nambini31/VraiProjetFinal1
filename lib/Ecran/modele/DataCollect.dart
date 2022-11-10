// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/Collecte.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/Collecte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DataCollect {
  Future<List<Collecte>> SelectAll() async {
    List<Collecte> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM collect ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Collecte article = Collecte();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }
}
