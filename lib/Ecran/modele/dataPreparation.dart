// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'dart:convert';

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  String ip = "197.7.2.2";

  Future SelectAllOne(int id_prep) async {
    Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT preparation.* FROM preparation WHERE preparation.id_prep = $id_prep ");
    List<Map<String, dynamic>> top = await db.rawQuery("SELECT * FROM releve WHERE id_prep = $id_prep ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) async {
      int id_zone = MapElement["id_zone"];
      int id_enseigne = MapElement["id_enseigne"];

      try {
        //   final response = await http.post(Uri.parse('http://$ip/app/lib/php/Transferer.php'), headers: {"Accept": "appication/json"}, body: {});
        top.forEach((element) async {
          final response1 = await http.post(Uri.parse('http://$ip/app/lib/php/Transferer.php'), headers: {
            "Accept": "appication/json"
          }, body: {
            "id_prep": MapElement["id_prep"].toString(),
            "date_maj_prep": MapElement["date_maj_prep"].toString(),
            "etat": MapElement["etat"].toString(),
            "id_releve": element["id_releve"].toString(),
            "etat_art": element["etat_art"].toString(),
            "ref_art_conc": element["ref_art_conc"].toString(),
            "date_maj_releve": element["date_maj_releve"].toString(),
            "date_val_releve": element["date_val_releve"].toString(),
            "prix_art_conc": element["prix_art_conc"].toString(),
            "id_zone": MapElement["id_zone"].toString(),
            "id_enseigne": MapElement["id_enseigne"].toString()
          });
        });
      } catch (e) {}
    });
  }
}
