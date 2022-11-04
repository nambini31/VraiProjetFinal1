class Article {
  int _id = 1;

  String _image = "";

  String _libele = "";

  int _prix = 0;

  int _gencode = 0;

  int _id_enseigne = 0;

  get id_enseigne => this._id_enseigne;

  set id_enseigne(value) => this._id_enseigne = value;

  Article();

  Article.id(this._id, this._libele, this._prix, this._gencode, this._image, this._id_enseigne);

  Article.ajt(this._libele, this._prix, this._gencode, this._image, this._id_enseigne);
  Article.modif(this._id, this._libele, this._prix, this._gencode, this._image, this._id_enseigne);

  int get id => this._id;

  set id(int value) => this._id = value;

  get image => this._image;

  set image(value) => this._image = value;

  get libele => this._libele;

  set libele(value) => this._libele = value;

  get prix => this._prix;

  set prix(value) => this._prix = value;

  get gencode => this._gencode;

  set gencode(value) => this._gencode = value;

  void fromMap(Map<String, dynamic> map) {
    id = map["id"];
    libele = map["libele"];
    prix = map["prix"];
    id_enseigne = map["id_enseigne"];
    image = map["image"];
    gencode = map["gencode"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["libele"] = libele;
    map["prix"] = prix;
    map["gencode"] = gencode;
    map["id_enseigne"] = _id_enseigne;
    map["image"] = image;
    return map;
  }
}
