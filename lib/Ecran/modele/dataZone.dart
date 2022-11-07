import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/magasin.dart';
import 'package:app/Ecran/modele/zone.dart';
import 'package:sqflite/sqflite.dart';

class DataZone {
  // Future<Zone> AjoutZone(Zone Zone) async {
  //   Database db = await DatabaseHelper().database;
  //   Zone.id_enseigne = await db.insert("enseigne", Zone.toMap());
  //   //await db.rawInsert("INSERT INTO Zone(nom) values('$nom')");
  //   print(Zone.id_enseigne);

  //   return Zone;
  // }

  // Future DeleteZone(int id) async {
  //   Database db = await DatabaseHelper().database;
  //   await db.rawDelete("DELETE FROM enseigne WHERE id_enseigne = $id ");
  // }

  // Future UpdateZone(Zone Zone) async {
  //   Database db = await DatabaseHelper().database;

  //   await db.update("enseigne", Zone.toMap(), where: "id_enseigne = ?", whereArgs: [Zone.id_enseigne]);
  // }

  Future<List<Zone>> SelectAll() async {
    List<Zone> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM zone");
    //List<Map<String, dynamic>> resulti = await db.query("Zone", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Zone zone = Zone();
      zone.fromMap(MapElement);
      listes.add(zone);
    });

    return listes;
  }
}
