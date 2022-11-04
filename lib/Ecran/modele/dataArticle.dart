// ignore_for_file: non_constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'package:app/Ecran/Nouvelle%20Article/AjoutArticle.dart';
import 'package:app/Ecran/modele/database_Helper.dart';
import 'package:app/Ecran/modele/article.dart';
import 'package:sqflite/sqflite.dart';

class DataArticle {
  Future<Article> AjoutArticle(Article article) async {
    Database db = await DatabaseHelper().database;
    article.id = await db.insert("art_nouv", article.toMap());
    //int id = await db.rawInsert("INSERT INTO art_nouv(libele,prix,gencode,image,magasin) VALUES('coca',2225,656565665,'jhuik','oilkhgt')");
    //"INSERT INTO art_nouv(id,libele,prix,gencode,image,magasin) VALUES('${article.getLibele}','${article.getPrix}','${article.getGencode}','${article.getImage}','${article.getMagasin}')");
    print(article.id);

    return article;
  }

  Future DeleteArticle(int id) async {
    Database db = await DatabaseHelper().database;
    await db.delete("art_nouv", where: "id = ?", whereArgs: [id]);
    //await db.rawDelete("DELETE FROM Article WHERE id = $id ");
  }

  Future UpdateArticle(Article article) async {
    Database db = await DatabaseHelper().database;
    print(article.id);
    await db.update("art_nouv", article.toMap(), where: "id = ?", whereArgs: [article.id]);
  }

  Future<List<Article>> SelectAll() async {
    List<Article> listes = [];
    Database db = await DatabaseHelper().database;

    List<Map<String, dynamic>> result = await db.rawQuery("SELECT * FROM art_nouv");
    //List<Map<String, dynamic>> resulti = await db.query("Article", where: "", orderBy: "is ASC");
    result.forEach((MapElement) {
      Article article = Article();
      article.fromMap(MapElement);
      listes.add(article);
    });
    print(listes[0].libele);
    return listes;
  }
}
