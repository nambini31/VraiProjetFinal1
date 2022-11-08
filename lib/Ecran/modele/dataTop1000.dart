// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DataTop1000 {
  // Future DeletePreparation(int id) async {
  //   Database db = await DatabaseHelper().database;
  //   await db.delete("preparation", where: "id_prep = ?", whereArgs: [id]);
  //   //await db.rawDelete("DELETE FROM Article WHERE id = $id ");
  // }

  Future<List<Top1000>> SelectAll(int id) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future SelectNombreAttente(int id) async {
    Database db = await DatabaseHelper().database;

    await db.rawUpdate(
        "UPDATE preparation SET etat_Attente = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  }

  Future SelectNombreValider(int id) async {
    Database db = await DatabaseHelper().database;
    int? count;
    try {
      count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 "));
    } catch (e) {
      count = 0;
    }

    if (count == 0) {
      await db.rawUpdate(
          "UPDATE preparation SET etat = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    } else {
      await db.rawUpdate(
          "UPDATE preparation SET etat_Attente = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    }
  }

  Future SelectNombreAnnuler(int id) async {
    Database db = await DatabaseHelper().database;
    int? count;
    int? count2;
    try {
      count = Sqflite.firstIntValue(
          await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND prix_art_conc != 0 AND etat_art = 0 "));
    } catch (e) {
      count = 0;
    }

    try {
      count2 = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id  AND etat_art = 1 "));
    } catch (e) {
      count2 = 0;
    }

    if (count == 0 && count2 == 0) {
      await db.rawUpdate(
          "UPDATE preparation SET etat_attente = 0 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    } else {
      await db.rawUpdate(
          "UPDATE preparation SET etat_Attente = 1  , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    }
  }

  Future<List<Top1000>> SelectAllSuggest(int id) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} AND prix_art_conc = 0 ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future<List<Top1000>> SelectAllSuggestModif(int id, int id_relever) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} AND prix_art_conc = 0 OR (id_releve = $id_relever AND prix_art_conc != 0 ) ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future<List<Top1000>> SelectAttente(int id) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 0 AND prix_art_conc != 0 ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future<Map<String, dynamic>> SelectLibelle(String gencode) async {
    Database db = await DatabaseHelper().database;
    List<Map<String, Object?>> result =
        await db.rawQuery("SELECT id_releve, libelle_art_conc ,prix_art_conc FROM releve WHERE gencode_art_conc = '$gencode'  ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");

    return result[0];
  }

  Future<List<Top1000>> SelectValider(int id) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 1 ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future UpdateReleve(Releve releve, int id_prep) async {
    Database db = await DatabaseHelper().database;

    await db.update("releve", releve.toMap(), where: " id_releve = ? AND id_prep = ?", whereArgs: [releve.id_releve, id_prep]);

    SelectNombreAttente(id_prep);
  }

  Future UpdateEtatReleve(int id_releve, int id_prep, String datetime) async {
    Database db = await DatabaseHelper().database;

    await db.rawUpdate("UPDATE releve SET etat_art = 1 , date_val_releve = '$datetime' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    SelectNombreValider(id_prep);
  }

// prix
  Future AnnulerReleve(int id_releve, int id_prep) async {
    Database db = await DatabaseHelper().database;
    await db.rawUpdate("UPDATE releve SET prix_art_conc= 0  , date_maj_releve = '' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    SelectNombreAnnuler(id_prep);
  }

  Future<List<Top1000>> SearchAll(int id, String txt) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM releve WHERE id_prep = ${id} AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR  date_val_releve LIKE '%$txt%' OR date_maj_releve LIKE '%$txt%' ) ");
    //"SELECT * FROM releve WHERE id_prep = ${id} AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR ref_art_conc LIKE '%$txt%' OR libelle_art_conc LIKE '%$txt%' OR gencode_art_conc LIKE '%$txt%' OR prix_art_conc LIKE '%$txt%' OR date_val_releve LIKE '%$txt%' ) ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future<List<Top1000>> SearchAttente(int id, String txt) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 0 AND prix_art_conc != 0 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR  gencode_art_conc LIKE '%$txt%' OR  date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' )  ");
    //"SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 0 AND prix_art_conc != 0 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR ref_art_conc LIKE '%$txt%' OR libelle_art_conc LIKE '%$txt%' OR gencode_art_conc LIKE '%$txt%' OR prix_art_conc LIKE '%$txt%' OR date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' )  ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }

  Future<List<Top1000>> SearchValider(int id, String txt) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 1 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR  date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' ) ");
    // "SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 1 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR ref_art_conc LIKE '%$txt%' OR libelle_art_conc LIKE '%$txt%' OR gencode_art_conc LIKE '%$txt%' OR prix_art_conc LIKE '%$txt%' OR date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' ) ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Top1000 article = Top1000();
      article.fromMap(MapElement);
      listes.add(article);
    });

    return listes;
  }
}
