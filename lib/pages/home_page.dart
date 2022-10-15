import 'package:flutter/material.dart';

import '../models/bandModel.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: "1", nombre: "Metalica", votes: 5),
    Band(id: "2", nombre: "Heroes del silencio", votes: 3),
    Band(id: "3", nombre: "Bonjovi", votes: 2),
    Band(id: "4", nombre: "Queen", votes: 5)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "BandNames",
          //textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, i) => _bandtile(bands[i])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => addNewBand()),
    );
  }

  Widget _bandtile(Band band) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print("direction:$direction");
        print("id:$band.id");
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Text(
          "Borrar banda",
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.nombre!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.nombre!),
        trailing: Text(
          "${band.votes}",
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.nombre);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("New band name:"),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
                child: Text("Add"),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandList(textController.text))
          ],
        );
      },
    );
  }

  void addBandList(String nombre) {
    print(nombre);
    if (nombre.length > 1) {
      this.bands.add(
          new Band(id: DateTime.now().toString(), nombre: nombre, votes: 0));
      setState(() {});
      //podemos agregarlo
    }
    Navigator.pop(context);
  }
}
