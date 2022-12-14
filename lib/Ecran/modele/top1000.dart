// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names

class Top1000 {
  int _id_releve = 0;
  String _ref_art = "";
  String _libelle_art = "";
  String _gencode_art = "";
  double _prix_art = 0;

  double get prix_art => this._prix_art;

  set prix_art(double value) => this._prix_art = value;

  String _ref_art_conc = "";
  String _libelle_art_conc = "";
  String _gencode_art_conc = "";
  double _prix_art_conc = 0;

  get prix_art_conc => this._prix_art_conc;

  set prix_art_conc(value) => this._prix_art_conc = value;

  int _etat_art = 0;
  String _date_val_releve = "";
  String _date_maj_releve = "";
  int _id_prep = 0;

  int _id_changer_nouveau = 0;

  get id_changer_nouveau => this._id_changer_nouveau;

  set id_changer_nouveau(value) => this._id_changer_nouveau = value;

  Top1000();
  Top1000.id(
      this._id_releve,
      this._ref_art,
      this._libelle_art,
      this._gencode_art,
      this._prix_art,
      this._ref_art_conc,
      this._libelle_art_conc,
      this._gencode_art_conc,
      this._prix_art_conc,
      this._date_maj_releve,
      this._date_val_releve,
      this._id_prep,
      this._etat_art,
      this._id_changer_nouveau);

  get date_maj_releve => this._date_maj_releve;

  set date_maj_releve(value) => this._date_maj_releve = value;

  int get id_releve => _id_releve;

  set id_releve(int value) => _id_releve = value;

  get ref_art => _ref_art;

  set ref_art(value) => _ref_art = value;

  get libelle_art => _libelle_art;

  set libelle_art(value) => _libelle_art = value;

  get gencode_art => _gencode_art;

  set gencode_art(value) => _gencode_art = value;

  get ref_art_conc => _ref_art_conc;

  set ref_art_conc(value) => _ref_art_conc = value;

  get libelle_art_conc => _libelle_art_conc;

  set libelle_art_conc(value) => _libelle_art_conc = value;

  get gencode_art_conc => _gencode_art_conc;

  set gencode_art_conc(value) => _gencode_art_conc = value;

  get etat_art => _etat_art;

  set etat_art(value) => _etat_art = value;

  get date_val_releve => _date_val_releve;

  set date_val_releve(value) => _date_val_releve = value;

  get id_prep => _id_prep;

  set id_prep(value) => _id_prep = value;

  void fromMap(Map<String, dynamic> map) {
    id_releve = map["id_releve"];
    ref_art = map["ref_art"];
    libelle_art = map["libelle_art"];
    gencode_art = map["gencode_art"];
    prix_art = map["prix_art"];

    ref_art_conc = map["ref_art_conc"];
    libelle_art_conc = map["libelle_art_conc"];
    gencode_art_conc = map["gencode_art_conc"];
    prix_art_conc = map["prix_art_conc"];
    id_changer_nouveau = map["id_changer_nouveau"];
    etat_art = map["etat_art"];
    date_val_releve = map["date_val_releve"];
    date_maj_releve = map["date_maj_releve"];
    id_prep = map["id_prep"];
  }

  // void fromMapWithoutJoin(Map<String, dynamic> map) {
  //   id_releve = map["id_releve"];
  //   ref_art_conc = map["ref_art_conc"];
  //   prix_art_conc = map["prix_art_conc"];
  //   etat_art = map["etat_art"];
  //   date_val_releve = map["date_val_releve"];
  //   date_maj_releve = map["date_maj_releve"];
  //   id_prep = map["id_prep"];
  // }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id_releve"] = id_releve;
    map["ref_art"] = ref_art;
    map["libelle_art"] = libelle_art;
    map["gencode_art"] = gencode_art;
    map["prix_art"] = prix_art;

    map["ref_art_conc"] = ref_art_conc;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["prix_art_conc"] = prix_art_conc;

    map["etat_art"] = etat_art;
    map["date_val_releve"] = date_val_releve;
    map["date_maj_releve"] = date_maj_releve;
    map["id_prep"] = id_prep;
    map["id_changer_nouveau"] = id_changer_nouveau;

    return map;
  }

  Map<String, dynamic> toMapNouveauSiExiste() {
    Map<String, dynamic> map = {};
    map["ref_art"] = ref_art;
    map["libelle_art"] = libelle_art;
    map["gencode_art"] = gencode_art;
    map["prix_art"] = prix_art;

    map["ref_art_conc"] = ref_art_conc;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["prix_art_conc"] = prix_art_conc;

    map["etat_art"] = etat_art;
    map["date_val_releve"] = date_val_releve;
    map["date_maj_releve"] = date_maj_releve;
    map["id_prep"] = id_prep;
    map["id_changer_nouveau"] = id_changer_nouveau;
    return map;
  }
}
