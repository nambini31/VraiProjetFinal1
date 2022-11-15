// ignore_for_file: non_constant_identifier_names

class Article {
  int _id = 1;
  Article();

  String _image = "";

  String _libele = "";

  double _prix = 0;

  String _gencode = "";
  String _design_enseigne = "";

  String get design_enseigne => this._design_enseigne;

  set design_enseigne(String value) => this._design_enseigne = value;

  String get gencode => this._gencode;

  set gencode(String value) => this._gencode = value;

  int _id_enseigne = 0;

  String _description = "";

  String get description => this._description;

  set description(String value) => this._description = value;

  get id_enseigne => this._id_enseigne;

  set id_enseigne(value) => this._id_enseigne = value;

  Article.id(this._id, this._libele, this._prix, this._gencode, this._description, this._image, this._id_enseigne);

  Article.ajt(this._libele, this._prix, this._gencode, this._description, this._image, this._id_enseigne);
  Article.modif(this._id, this._libele, this._prix, this._gencode, this._description, this._image, this._id_enseigne);

  int get id => this._id;

  set id(int value) => this._id = value;

  get image => this._image;

  set image(value) => this._image = value;

  get libele => this._libele;

  set libele(value) => this._libele = value;

  get prix => this._prix;

  set prix(value) => this._prix = value;

  void fromMap(Map<String, dynamic> map) {
    id = map["id"];
    libele = map["libele"];
    prix = map["prix"];
    id_enseigne = map["id_enseigne"];
    image = map["image"];
    gencode = map["gencode"];
    description = map["description"];
    design_enseigne = map["design_enseigne"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["libele"] = libele;
    map["prix"] = prix;
    map["gencode"] = gencode;
    map["id_enseigne"] = _id_enseigne;
    map["image"] = image;
    map["description"] = description;
    return map;
  }
}
