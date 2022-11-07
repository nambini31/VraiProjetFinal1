// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'dart:convert';

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DataPreparation {
  Future DeletePreparation(int id) async {
    Database db = await DatabaseHelper().database;
    await db.delete("preparation", where: "id_prep = ?", whereArgs: [id]);
    await db.delete("releve", where: "id_prep = ?", whereArgs: [id]);
    //await db.rawDelete("DELETE FROM Article");
  }

  Future<List<Preparation>> SelectAll() async {
    List<Preparation> listes = [];
    Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT preparation.*,enseigne.design_enseigne,zone.libelle_zone FROM enseigne INNER JOIN preparation  ON preparation.id_enseigne = enseigne.id_enseigne INNER JOIN zone ON preparation.id_zone = zone.id_zone ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Preparation article = Preparation();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }
}
