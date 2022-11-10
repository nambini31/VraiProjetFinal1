// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names, camel_case_types

class Collecte {
  int _ref_art = 0;
  String _libelle_art = "";
  String _gencode_art = "";
  String _date_art = "";
  String _date_update_art = "";

  int _ref_art_conc = 0;
  String _libelle_art_conc = "";
  String _gencode_art_conc = "";
  String _date_art_conc = "";
  double _prix_art_conc = 0;

  Collecte();
  Collecte.id();

  int get ref_art => this._ref_art;

  set ref_art(int value) => this._ref_art = value;

  get libelle_art => this._libelle_art;

  set libelle_art(value) => this._libelle_art = value;

  get gencode_art => this._gencode_art;

  set gencode_art(value) => this._gencode_art = value;

  get date_art => this._date_art;

  set date_art(value) => this._date_art = value;

  get date_update_art => this._date_update_art;

  set date_update_art(value) => this._date_update_art = value;

  get ref_art_conc => this._ref_art_conc;

  set ref_art_conc(value) => this._ref_art_conc = value;

  get libelle_art_conc => this._libelle_art_conc;

  set libelle_art_conc(value) => this._libelle_art_conc = value;

  get gencode_art_conc => this._gencode_art_conc;

  set gencode_art_conc(value) => this._gencode_art_conc = value;

  get date_art_conc => this._date_art_conc;

  set date_art_conc(value) => this._date_art_conc = value;

  get prix_art_conc => this._prix_art_conc;

  set prix_art_conc(value) => this._prix_art_conc = value;

  void fromMap(Map<String, dynamic> map) {
    ref_art = map["ref_art"];
    libelle_art = map["libelle_art"];
    gencode_art = map["gencode_art"];
    date_art = map["date_art"];
    date_update_art = map["date_update_art"];

    ref_art_conc = map["ref_art_conc"];
    libelle_art_conc = map["libelle_art_conc"];
    gencode_art_conc = map["gencode_art_conc"];
    prix_art_conc = map["prix_art_conc"];
    date_art_conc = map["date_val_releve"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map["ref_art"] = ref_art;
    map["libelle_art"] = libelle_art;
    map["gencode_art"] = gencode_art;
    map["date_art"] = date_art;
    map["date_update_art"] = date_update_art;

    map["ref_art_conc"] = ref_art_conc;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["prix_art_conc"] = prix_art_conc;
    map["date_val_releve"] = date_art_conc;

    return map;
  }
}
