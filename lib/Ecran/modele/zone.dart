// ignore_for_file: non_constant_identifier_names, unused_field, prefer_final_fields

class Zone {
  int _id_zone = 0;
  String _libelle_zone = "";
  String _libelle_plus_zone = "";

  get libelle_plus_zone => this._libelle_plus_zone;

  set libelle_plus_zone(value) => this._libelle_plus_zone = value;

  int get id_zone => this._id_zone;

  set id_zone(int value) => this._id_zone = value;

  get libelle_zone => this._libelle_zone;

  set libelle_zone(value) => this._libelle_zone = value;

  Zone();
  Zone.id(this._id_zone, this._libelle_zone, this._libelle_plus_zone);

  fromMap(Map<String, dynamic> map) {
    if (map["id_zone"] != null) {
      id_zone = map["id_zone"];
    }
    libelle_zone = map["libelle_zone"];
    libelle_plus_zone = map["libelle_plus_zone"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"id_zone": id_zone, "libelle_zone": libelle_zone, "libelle_plus_zone": libelle_plus_zone};

    return map;
  }
}
