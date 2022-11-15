// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/releve.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

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

  // Future SelectNombreAttente(int id) async {
  //   Database db = await DatabaseHelper().database;

  //   await db.rawUpdate(
  //       "UPDATE preparation SET etat_Attente = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  // }

  Future etatPreparation(int id) async {
    Database db = await DatabaseHelper().database;
    int? countattente;
    int? countetat;
    int? count;

    try {
      countattente =
          Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 AND prix_art_conc != 0"));
    } catch (e) {
      countattente = 0;
    }

    try {
      count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id "));
    } catch (e) {
      count = 0;
    }

    try {
      countetat = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 1 "));
    } catch (e) {
      countetat = 0;
    }

    print("countAttente = $countattente et countEtat = $countetat");

    if (countetat == 0 && countattente == 0) {
      await db.rawUpdate("UPDATE preparation SET etat = 0 , etat_Attente = 0   WHERE id_prep = $id ");
    } else if (countetat! == 0 && countattente! <= count!) {
      await db.rawUpdate(
          "UPDATE preparation SET etat_Attente = 1  , etat = 0 ,  date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    } else if (countetat > 0 && countattente! > 0) {
    } else if (countetat < count! && countattente! == 0) {
      await db.rawUpdate(
          "UPDATE preparation SET etat_Attente = 1 , etat = 0 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    } else if (countetat > 0 && countattente! > 0) {
      await db.rawUpdate(
          "UPDATE preparation SET etat_Attente = 1 , etat = 0 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    } else {
      await db.rawUpdate(
          "UPDATE preparation SET etat = 1 , etat_attente = 0, date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
    }
  }

  Future etatPreparationCharger(int id) async {
    Database db = await DatabaseHelper().database;
    int? countattente;
    int? countetat;
    int? count;

    try {
      countattente =
          Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 AND prix_art_conc != 0"));
    } catch (e) {
      countattente = 0;
    }

    try {
      count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id "));
    } catch (e) {
      count = 0;
    }

    try {
      countetat = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 1 "));
    } catch (e) {
      countetat = 0;
    }

    print("countAttente = $countattente et countEtat = $countetat");

    if (countetat == 0 && countattente == 0) {
      await db.rawUpdate("UPDATE preparation SET etat = 0 , etat_Attente = 0   WHERE id_prep = $id ");
    } else if (countetat! == 0 && countattente! <= count!) {
      await db.rawUpdate("UPDATE preparation SET etat_Attente = 1 , etat = 0  WHERE id_prep = $id ");
    } else if (countetat < count! && countattente! == 0) {
      await db.rawUpdate("UPDATE preparation SET etat_Attente = 1 , etat = 0  WHERE id_prep = $id ");
    } else if (countetat > 0 && countattente! > 0) {
      await db.rawUpdate("UPDATE preparation SET etat_Attente = 1 , etat = 0  WHERE id_prep = $id ");
    } else {
      await db.rawUpdate("UPDATE preparation SET etat = 1 , etat_attente = 0  WHERE id_prep = $id ");
    }
  }

  // Future SelectNombreValider(int id) async {
  // Future etatPreparationCharger(int id) async {
  //   Database db = await DatabaseHelper().database;
  //   int? countattente;
  //   int? countetat;
  //   try {
  //     countattente =
  //         Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 AND prix_art_conc != 0"));
  //   } catch (e) {
  //     countattente = 0;
  //   }

  //   try {
  //     countetat = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 1 "));
  //   } catch (e) {
  //     countetat = 0;
  //   }

  //   print("countAttente = $countattente et countEtat = $countetat");

  //   if (countetat == 0 && countattente == 0) {
  //     await db.rawUpdate("UPDATE preparation SET etat = 0 , etat_Attente = 0   WHERE id_prep = $id ");
  //   } else if (countetat! == 0 && countattente! > 0) {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat_Attente = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   } else {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   }
  // }
  // Future SelectNombreValider(int id) async {
  //   Database db = await DatabaseHelper().database;

  //   int? count;
  //   try {
  //     count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 "));
  //   } catch (e) {
  //     count = 0;
  //   }

  //   if (count == 0) {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   } else {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat_Attente = 1 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   }
  // }

  // Future SelectNombreAnnuler(int id) async {
  //   Database db = await DatabaseHelper().database;
  //   int? count;
  //   int? count2;
  //   try {
  //     count = Sqflite.firstIntValue(
  //         await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND prix_art_conc != 0 AND etat_art = 0 "));
  //   } catch (e) {
  //     count = 0;
  //   }

  //   try {
  //     count2 = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id  AND etat_art = 1 "));
  //   } catch (e) {
  //     count2 = 0;
  //   }

  //   if (count == 0 && count2 == 0) {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat_attente = 0 , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   } else {
  //     await db.rawUpdate(
  //         "UPDATE preparation SET etat_Attente = 1  , date_maj_prep = '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}' WHERE id_prep = $id ");
  //   }
  // } tomysql

  Future<int?> SelectNombreTop1000Fini(int id) async {
    Database db = await DatabaseHelper().database;
    int? count;
    try {
      count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 1 "));
    } catch (e) {
      count = 0;
    }
    return count;
  }

  // Future<int?> SelectNombreTopNonfini(int id) async {
  //   Database db = await DatabaseHelper().database;
  //   int? count;
  //   try {
  //     count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(id_releve) FROM releve WHERE id_prep = $id AND etat_art = 0 "));
  //   } catch (e) {
  //     count = 0;
  //   }
  //   return count;
  // }

//SelectNumberPreparation.php
  Future<int?> SelectNombreTop1000Mysql(int id_prep, String ip) async {
    Database db = await DatabaseHelper().database;
    int? count;
    try {
      var response = await http
          .post(Uri.parse("http://$ip/app/lib/php/selectNumberTop1000.php"), body: {"id_prep": id_prep.toString()}).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        var rep = json.decode(response.body);
        count = int.parse(rep[0]);
      } else {}
    } catch (e) {
      EasyLoading.instance
        ..maskType = EasyLoadingMaskType.custom
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.circle
        ..loadingStyle = EasyLoadingStyle.dark
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = Colors.yellow
        ..backgroundColor = Colors.green
        ..indicatorColor = Colors.yellow
        ..textColor = Colors.yellow
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false;
      EasyLoading.showError('Connection error', duration: Duration(seconds: 2), dismissOnTap: true);
    }
    return count;
  }

  // Future<int?> SelectNombreTop1000mysql(int id_prep, String ip) async {
  //   Database db = await DatabaseHelper().database;
  //   int? count;
  //   try {
  //     var response = await http
  //         .post(Uri.parse("http://$ip/app/lib/php/SelectNumbertoponmysql.php"), body: {"id_prep": id_prep.toString()}).timeout(Duration(seconds: 5));

  //     if (response.statusCode == 200) {
  //       var rep = json.decode(response.body);
  //       count = int.parse(rep[0]);
  //     } else {}
  //   } catch (e) {
  //     EasyLoading.instance
  //       ..maskType = EasyLoadingMaskType.custom
  //       ..displayDuration = const Duration(milliseconds: 2000)
  //       ..indicatorType = EasyLoadingIndicatorType.circle
  //       ..loadingStyle = EasyLoadingStyle.dark
  //       ..indicatorSize = 45.0
  //       ..radius = 10.0
  //       ..progressColor = Colors.yellow
  //       ..backgroundColor = Colors.green
  //       ..indicatorColor = Colors.yellow
  //       ..textColor = Colors.yellow
  //       ..maskColor = Colors.black.withOpacity(0.5)
  //       ..userInteractions = false;
  //     EasyLoading.showError('Connection error', duration: Duration(seconds: 2), dismissOnTap: true);
  //   }
  //   return count;
  // }

  Future<int?> SelectNombrePreparation(int id_prep, String ip) async {
    Database db = await DatabaseHelper().database;
    int? count;
    try {
      var response = await http
          .post(Uri.parse("http://$ip/app/lib/php/selectNumberPreparation.php"), body: {"id_prep": id_prep.toString()}).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        var rep = json.decode(response.body);
        count = rep[0];
      } else {}
    } catch (e) {
      EasyLoading.instance
        ..maskType = EasyLoadingMaskType.custom
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.circle
        ..loadingStyle = EasyLoadingStyle.dark
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = Colors.yellow
        ..backgroundColor = Colors.green
        ..indicatorColor = Colors.yellow
        ..textColor = Colors.yellow
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false;
      EasyLoading.showError('Connection error', duration: Duration(seconds: 2), dismissOnTap: true);
    }
    return count;
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

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 0 ");
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

  Future UpdateReleveExistante(Releve releve, int id_prep) async {
    Database db = await DatabaseHelper().database;
    await db.update("releve", releve.toMapExistante(), where: " id_releve = ? AND id_prep = ?", whereArgs: [releve.id_releve, id_prep]);
    etatPreparation(id_prep);
  }

  Future AjoutNouveauReleveExistante(Top1000 top, int id_prep) async {
    Database db = await DatabaseHelper().database;
    await db.insert("releve", top.toMapNouveauSiExiste());
    etatPreparation(id_prep);
  }

  Future UpdateReleveNouveauNot_OU_Existante(Releve releve, int id_prep) async {
    Database db = await DatabaseHelper().database;
    await db.update("releve", releve.toMapUpdate(), where: " id_releve = ? AND id_prep = ?", whereArgs: [releve.id_releve, id_prep]);

    etatPreparation(id_prep);
  }

  Future UpdateReleveRemplace(Releve releve, int id_prep, Releve releveAncien) async {
    Database db = await DatabaseHelper().database;
    await db.update("releve", releve.toMapRemplace(), where: " id_releve = ? AND id_prep = ?", whereArgs: [releve.id_releve, id_prep]);

    await db.insert("change", releveAncien.toMapRemplaceInsert());

    etatPreparation(id_prep);
  }

  Future UpdateEtatReleve(int id_releve, int id_prep, String datetime) async {
    Database db = await DatabaseHelper().database;

    await db.rawUpdate("UPDATE releve SET etat_art = 1 , date_val_releve = '$datetime' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    etatPreparation(id_prep);
  }

// prix
  Future AnnulerReleve(int id_releve, int id_nouv, int id_prep) async {
    Database db = await DatabaseHelper().database;
    if (id_nouv == 0) {
      await db.rawUpdate("UPDATE releve SET  prix_art_conc = 0 , date_maj_releve = '' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    } else if (id_nouv == 1) {
      Database db = await DatabaseHelper().database;
      List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM change WHERE id_releve = $id_releve AND id_prep = $id_prep   ");
      //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
      result.forEach((MapElement) async {
        await db.rawUpdate(
            "UPDATE releve SET prix_art_conc= 0 , ref_art_conc = '${MapElement['ref_art_conc']}' , libelle_art_conc = '${MapElement['libelle_art_conc']}' , gencode_art_conc = '${MapElement['gencode_art_conc']}' , date_maj_releve = '' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
      });
      await db.rawUpdate("DELETE FROM change WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    } else if (id_nouv == 2) {
      await db.rawUpdate("DELETE FROM releve WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    } else {
      await db.rawUpdate(
          "UPDATE releve SET ref_art_conc = 0 , libelle_art_conc = '' , gencode_art_conc = '' , prix_art_conc = 0 , date_maj_releve = '' WHERE id_releve = $id_releve AND id_prep = $id_prep ");
    }

    etatPreparation(id_prep);
  }

  Future<List<Top1000>> SearchAttente(int id, String txt) async {
    List<Top1000> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 0 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR  gencode_art_conc LIKE '%$txt%' OR libelle_art_conc LIKE '%$txt%' OR  date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' )  ");
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
        "SELECT * FROM releve WHERE id_prep = ${id} AND etat_art = 1 AND (ref_art LIKE '%$txt%' OR libelle_art LIKE '%$txt%' OR gencode_art LIKE '%$txt%' OR prix_art LIKE '%$txt%' OR   libelle_art_conc LIKE '%$txt%' OR date_val_releve LIKE '%$txt%' OR  date_maj_releve LIKE '%$txt%' ) ");
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
