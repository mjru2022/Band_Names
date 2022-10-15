import 'package:flutter/foundation.dart';

class Band {
  String? id;
  String? nombre;
  int? votes;

  Band({this.id, this.nombre, this.votes});
  factory Band.fromMap(Map<String, dynamic> obj) =>
      Band(id: obj["id"], nombre: obj["nombre"], votes: obj["votes"]);
}
