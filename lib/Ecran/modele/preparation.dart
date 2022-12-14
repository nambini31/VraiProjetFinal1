// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields

class Preparation {
  int _id_prep = 0;
  int _id_enseigne = 0;
  String _libelle_prep = "";
  String _description = "";
  String _date_prep = "";
  String _design_magasin = "";
  String _libelle_zone = "";

  get libelle_zone => this._libelle_zone;

  set libelle_zone(value) => this._libelle_zone = value;

  int _etat = 0;

  int _etat_attente = 0;

  int _id_zone = 0;

  get id_zone => this._id_zone;

  set id_zone(value) => this._id_zone = value;

  String _date_maj_prep = "";

  get date_maj_prep => this._date_maj_prep;

  set date_maj_prep(value) => this._date_maj_prep = value;

  get etat_attente => this._etat_attente;

  set etat_attente(value) => this._etat_attente = value;

  get etat => _etat;

  set etat(value) => _etat = value;

  get design_magasin => _design_magasin;

  set design_magasin(value) => _design_magasin = value;

  Preparation();

  Preparation.id(this._id_prep, this._libelle_prep, this._date_prep, this._description, this._date_maj_prep, this._id_enseigne, this._etat,
      this._etat_attente, this._id_zone);

  get id_prep => _id_prep;

  set id_prep(value) => _id_prep = value;

  get id_enseigne => _id_enseigne;

  set id_enseigne(value) => _id_enseigne = value;

  get libelle_prep => _libelle_prep;

  set libelle_prep(value) => _libelle_prep = value;

  get description => _description;

  set description(value) => _description = value;

  get date_prep => _date_prep;

  set date_prep(value) => _date_prep = value;

  void fromMap(Map<String, dynamic> map) {
    id_prep = map["id_prep"];
    libelle_prep = map["libelle_prep"];
    description = map["description"];
    id_enseigne = map["id_enseigne"];
    date_prep = map["date_prep"];
    date_maj_prep = map["date_maj_prep"];
    design_magasin = map["design_enseigne"];
    libelle_zone = map["libelle_zone"];
    etat = map["etat"];
    etat_attente = map["etat_attente"];
    id_zone = map["id_zone"];
  }

  void fromMapWithoutJoin(Map<String, dynamic> map) {
    id_prep = map["id_prep"];
    date_maj_prep = map["date_maj_prep"];
    etat = map["etat"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map["id_prep"] = id_prep;
    map["libelle_prep"] = libelle_prep;
    map["description"] = description;
    map["id_enseigne"] = id_enseigne;
    map["date_prep"] = date_prep;
    map["date_maj_prep"] = date_maj_prep;
    map["etat"] = etat;
    map["etat_attente"] = etat_attente;
    map["id_zone"] = id_zone;

    return map;
  }
}
