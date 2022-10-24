// ignore: file_names
// ignore: file_names
class Band {
  String? id;
  String? nombre;
  int? votes;

  Band({this.id, this.nombre, this.votes});

  factory Band.fromMap(Map<String, dynamic> obj) => Band(
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      nombre: obj.containsKey("nombre") ? obj["nombre"] : "no-nombre",
      votes: obj.containsKey("votes") ? obj["votes"] : "no-votes");
}
