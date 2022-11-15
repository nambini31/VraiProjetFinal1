// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields

class Releve {
  int _id_releve = 0;
  String _libelle_art_conc = "";
  String _ref_art_conc = "";

  get ref_art_conc => this._ref_art_conc;

  set ref_art_conc(value) => this._ref_art_conc = value;

  String _gencode_art_conc = "";
  String _date_maj_releve = "";
  double _prix_art_conc = 0;
  int _id_changer_nouveau = 0;
  int _id_prep = 0;

  get id_changer_nouveau => this._id_changer_nouveau;

  set id_changer_nouveau(value) => this._id_changer_nouveau = value;

  get id_prep => this._id_prep;

  set id_prep(value) => this._id_prep = value;

  get prix_art_conc => this._prix_art_conc;

  set prix_art_conc(value) => this._prix_art_conc = value;

  get date_maj_releve => this._date_maj_releve;

  set date_maj_releve(value) => this._date_maj_releve = value;

  Releve(this._id_releve, this._libelle_art_conc, this._gencode_art_conc);
  Releve.insert(this._id_releve, this._libelle_art_conc, this._gencode_art_conc, this._ref_art_conc, this._id_prep);
  Releve.updateExistant(this._id_releve, this._prix_art_conc, this._date_maj_releve);
  Releve.updateRelever(
      this._id_releve, this._libelle_art_conc, this._gencode_art_conc, this._prix_art_conc, this._date_maj_releve, this._id_changer_nouveau);

  int get id_releve => _id_releve;

  set id_releve(int value) => _id_releve = value;

  get libelle_art_conc => _libelle_art_conc;

  set libelle_art_conc(value) => _libelle_art_conc = value;

  get gencode_art_conc => _gencode_art_conc;

  set gencode_art_conc(value) => _gencode_art_conc = value;

  Map<String, dynamic> toMapExistante() {
    Map<String, dynamic> map = {};
    map["prix_art_conc"] = prix_art_conc;
    map["date_maj_releve"] = date_maj_releve;
    return map;
  }

  Map<String, dynamic> toMapUpdate() {
    Map<String, dynamic> map = {};
    map["prix_art_conc"] = prix_art_conc;
    map["ref_art_conc"] = 1;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["date_maj_releve"] = date_maj_releve;
    map["id_changer_nouveau"] = id_changer_nouveau;
    return map;
  }

  Map<String, dynamic> toMapRemplace() {
    Map<String, dynamic> map = {};
    map["prix_art_conc"] = prix_art_conc;
    map["libelle_art_conc"] = libelle_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["date_maj_releve"] = date_maj_releve;
    map["id_changer_nouveau"] = id_changer_nouveau;
    return map;
  }

  Map<String, dynamic> toMapRemplaceInsert() {
    Map<String, dynamic> map = {};
    map["id_releve"] = id_releve;
    map["libelle_art_conc"] = libelle_art_conc;
    map["ref_art_conc"] = ref_art_conc;
    map["gencode_art_conc"] = gencode_art_conc;
    map["id_prep"] = id_prep;
    return map;
  }
}
