// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names

class Concurent {
  int _id_releve = 0;
  String _ref_art_conc = "";
  String _libelle_art_conc = "";
  String _gencode_art_conc = "";
  double _prix_art_conc = 0;

  int _etat_art = 0;
  String _date_val_releve = "";
  String _date_maj_releve = "";
  int _id_prep = 0;
  int _id_changer = 0;
  int _id_nouveau = 0;

  get id_changer => this._id_changer;

  set id_changer(value) => this._id_changer = value;

  get id_nouveau => this._id_nouveau;

  set id_nouveau(value) => this._id_nouveau = value;

  Concurent();
  Concurent.id(this._id_releve, this._ref_art_conc, this._libelle_art_conc, this._gencode_art_conc, this._prix_art_conc, this._etat_art,
      this._date_maj_releve, this._date_val_releve, this._id_changer, this._id_nouveau, this._id_prep);

  int get id_releve => this._id_releve;

  set id_releve(int value) => this._id_releve = value;

  get ref_art_conc => this._ref_art_conc;

  set ref_art_conc(value) => this._ref_art_conc = value;

  get libelle_art_conc => this._libelle_art_conc;

  set libelle_art_conc(value) => this._libelle_art_conc = value;

  get gencode_art_conc => this._gencode_art_conc;

  set gencode_art_conc(value) => this._gencode_art_conc = value;

  get prix_art_conc => this._prix_art_conc;

  set prix_art_conc(value) => this._prix_art_conc = value;

  get etat_art => this._etat_art;

  set etat_art(value) => this._etat_art = value;

  get date_val_releve => this._date_val_releve;

  set date_val_releve(value) => this._date_val_releve = value;

  get date_maj_releve => this._date_maj_releve;

  set date_maj_releve(value) => this._date_maj_releve = value;

  get id_prep => this._id_prep;

  set id_prep(value) => this._id_prep = value;

  void fromMap(Map<String, dynamic> map) {
    id_releve = map["id_releve"];
    ref_art_conc = map["ref_art_conc"];
    libelle_art_conc = map["libelle_art_conc"];
    gencode_art_conc = map["gencode_art_conc"];
    prix_art_conc = map["prix_art_conc"];

    etat_art = map["etat_art"];
    date_val_releve = map["date_val_releve"];
    date_maj_releve = map["date_maj_releve"];
    id_prep = map["id_prep"];
    id_changer = map["id_changer"];
    id_nouveau = map["id_nouveau"];
  }

  // void fromMapWithoutJoin(Map<String, dynamic> map) {
  //   id_releve = map["id_releve"];
  //   ref_art_conc = map["ref_art_conc"];
  //   prix_art_conc = map["prix_art_conc"];
  //   etat_art = map["etat_art"];
  //   date_val_releve = map["date_val_releve"];
  //   date_maj_releve = map["date_maj_releve"];
  //   id_prep = map["id_prep"];
  //   id_changer = map["id_changer"];
  //   id_nouveau = map["id_nouveau"];
  // }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id_releve"] = id_releve;
    // map["ref_art"] = ref_art;
    // map["libelle_art"] = libelle_art;
    // map["gencode_art"] = gencode_art;
    // map["prix_art"] = prix_art;

    map["ref_art_conc"] = ref_art_conc;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["prix_art_conc"] = prix_art_conc;

    map["etat_art"] = etat_art;
    map["date_val_releve"] = date_val_releve;
    map["date_maj_releve"] = date_maj_releve;
    map["id_prep"] = id_prep;
    map["id_changer"] = id_changer;
    map["id_nouveau"] = id_nouveau;
    // map["id_choix"] = id_choix;

    return map;
  }
}
