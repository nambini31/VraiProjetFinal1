// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields

class Item {
  int _id_enseigne = 0;
  String _design_enseigne = "";
  String _design_plus_enseigne = "";

  get design_plus_enseigne => this._design_plus_enseigne;

  set design_plus_enseigne(value) => this._design_plus_enseigne = value;

  int get id_enseigne => this._id_enseigne;

  set id_enseigne(int value) => this._id_enseigne = value;

  get design_enseigne => this._design_enseigne;

  set design_enseigne(value) => this._design_enseigne = value;

  Item();
  Item.id(this._id_enseigne, this._design_enseigne, this._design_plus_enseigne);

  fromMap(Map<String, dynamic> map) {
    if (map["id_enseigne"] != null) {
      id_enseigne = map["id_enseigne"];
    }
    design_enseigne = map["design_enseigne"];
    design_plus_enseigne = map["design_plus_enseigne"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"id_enseigne": id_enseigne, "design_enseigne": design_enseigne, "design_plus_enseigne": design_plus_enseigne};

    return map;
  }
}
