// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'dart:convert';

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:app/Ecran/modele/magasin.dart';
import 'package:app/Ecran/modele/preparation.dart';
import 'package:app/Ecran/modele/top1000.dart';
import 'package:app/Ecran/modele/zone.dart';
import 'package:flutter/material.dart';
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

  Future chargeArticle(String ip) async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectArticle.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Top1000 top1000 = Top1000.id(
              int.parse(element["id_rel_rel"]),
              element["ref_rel"],
              element["libelle_art_rel"],
              element["gencod_rel"],
              double.parse(element["prix_ref_rel"]),
              element["id_art_conc_rel"],
              element["lib_art_concur_rel"],
              element["gc_concur_rel"],
              0,
              (element["etat_rel"] == null) ? 0 : int.parse(element["etat_rel"]),
              "",
              "",
              int.parse(
                element["num_rel_rel"],
              ),
              0);

          try {
            await db.insert("releve", top1000.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future chargeMagasin(String ip) async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectEnseigne.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Item top = Item.id(
            int.parse(element["enseigne_ens"]),
            element["libelle_ens"],
            element["lib_plus_ens"],
          );

          try {
            await db.insert("enseigne", top.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future chargeZone(String ip) async {
    Database db = await DatabaseHelper().database;
    //await db.rawDelete("DELETE FROM releve");
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/selectZone.php")).timeout(Duration(seconds: 4));

      if (response.statusCode == 200) {
        produitlist = json.decode(response.body);

        produitlist.forEach((element) async {
          Zone top = Zone.id(
            int.parse(element["zone_zn"]),
            element["libelle_zn"],
            element["lib_plus_zn"],
          );

          try {
            await db.insert("zone", top.toMap());
          } catch (e) {}
        });
      } else {
        //print("dat non recu");
      }
    } catch (e) {
      //print('connecx timeout');
    }
  }

  Future Charger(String ip) async {
    Database db = await DatabaseHelper().database;
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
      ..userInteractions = true
      ..dismissOnTap = false;
    await EasyLoading.show(status: 'loading...');
    List produitlist = [];

    try {
      var response = await http.get(Uri.parse("http://$ip/app/lib/php/select.php")).timeout(Duration(milliseconds: 2000));

      if (response.statusCode == 200) {
        chargeMagasin(ip);
        chargeZone(ip);
        produitlist = json.decode(response.body);

        chargeArticle(ip);
        produitlist.forEach((element) async {
          Preparation prepa = Preparation.id(
              int.parse(element["id_releve"]),
              element["libelle_releve"],
              (element["date_releve"] == null) ? "" : element["date_releve"],
              (element["lib_plus_releve"] == null) ? "" : element["lib_plus_releve"],
              element["dt_maj_releve"],
              int.parse(element["enseigne_releve"]),
              0,
              0,
              int.parse(element["zone_releve"]));

          try {
            await db.insert("preparation", prepa.toMap());
            print(prepa.description);
          } catch (e) {}
          EasyLoading.showSuccess('Success!', dismissOnTap: true);
          await EasyLoading.dismiss();
        });
      } else {
        //print("dat non recu");

      }
    } catch (e) {
      EasyLoading.showError('Connection error', duration: Duration(seconds: 2));
      //print('connecx timeout');
    }
  }

  Future SelectAllOne(int id_prep, String ip) async {
    Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT preparation.* FROM preparation WHERE preparation.id_prep = $id_prep ");
    List<Map<String, dynamic>> top = await db.rawQuery("SELECT * FROM releve WHERE id_prep = $id_prep ");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) async {
      try {
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
          ..userInteractions = true
          ..dismissOnTap = false;
        await EasyLoading.show(status: 'En cours de Transfer...');
        final response = await http.post(Uri.parse('http://$ip/app/lib/php/TransfererPreparation.php'), headers: {
          "Accept": "appication/json"
        }, body: {
          "id_prep": MapElement["id_prep"].toString(),
          "date_maj_prep": MapElement["date_maj_prep"].toString(),
          "etat": MapElement["etat"].toString(),
        });

        //   final response = await http.post(Uri.parse('http://$ip/app/lib/php/Transferer.php'), headers: {"Accept": "appication/json"}, body: {});
        top.forEach((element) async {
          final response1 = await http.post(Uri.parse('http://$ip/app/lib/php/TransfererTop1000.php'), headers: {
            "Accept": "appication/json"
          }, body: {
            "id_prep": MapElement["id_prep"].toString(),
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

        EasyLoading.showSuccess('Success!');
        await EasyLoading.dismiss();
      } catch (e) {
        EasyLoading.showError('Connection error',
            duration: Duration(
              seconds: 2,
            ),
            dismissOnTap: true);
      }
    });
  }
}
