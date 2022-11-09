// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields

class Releve {
  int _id_releve = 0;
  String _libelle_art_conc = "";
  String _gencode_art_conc = "";
  String _date_maj_releve = "";
  int _id_choix = 0;
  double _prix_art_conc = 0;

  get prix_art_conc => this._prix_art_conc;

  set prix_art_conc(value) => this._prix_art_conc = value;

  int get id_choix => this._id_choix;

  set id_choix(int value) => this._id_choix = value;

  get date_maj_releve => this._date_maj_releve;

  set date_maj_releve(value) => this._date_maj_releve = value;

  Releve(this._id_releve, this._libelle_art_conc, this._gencode_art_conc, this._id_choix);
  Releve.no();
  Releve.update(this._id_releve, this._prix_art_conc, this._date_maj_releve, this._id_choix);

  int get id_releve => _id_releve;

  set id_releve(int value) => _id_releve = value;

  get libelle_art_conc => _libelle_art_conc;

  set libelle_art_conc(value) => _libelle_art_conc = value;

  get gencode_art_conc => _gencode_art_conc;

  set gencode_art_conc(value) => _gencode_art_conc = value;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["prix_art_conc"] = prix_art_conc;
    map["date_maj_releve"] = date_maj_releve;
    map["id_choix"] = id_choix;
    return map;
  }
}
