//import 'dart:io';
//import 'package:flutter/cupertino.dart';
import 'package:bands_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
//import 'dart:async';
//import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    //Band(id: "1", nombre: "Metalica"),
    //Band(id: "2", nombre: "quee"),
    // Band(id: "3", nombre: "heroes del silencio"),
    //Band(id: "4", nombre: "bandsi"),
  ];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on("active-bands", _handleActive);

    super.initState();
  }

  _handleActive(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "BandNames",
          //textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.check_circle, color: Colors.red[300]),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraphic(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, i) => _bandtile(bands[i])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addNewBand, child: const Icon(Icons.add)),
    );
  }

  Widget _bandtile(Band band) {
    final socketService = Provider.of<SocketService>(context);
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        // ignore: avoid_print
        // print("direction:$direction");
        // ignore: avoid_print
        // print("id:$band.id");
        socketService.socket.emit("delete-band", {"id": band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: const Text(
          "Borrar banda",
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          // ignore: sort_child_properties_last
          child: Text(band.nombre!.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.nombre!),
        trailing: Text(
          "${band.votes}",
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          socketService.socket.emit("vote-band", {"id": band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("New band name:"),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
                // ignore: sort_child_properties_last
                child: const Text("Add"),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandList(textController.text))
          ],
        );
      },
    );
  }

  void addBandList(String nombre) {
    // ignore: avoid_print
    //print(nombre);
    if (nombre.length > 1) {
      // bands.add(Band(id: DateTime.now().toString(), nombre: nombre, votes: 0));
      // setState(() {});
      //podemos agregarlo
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'nombre': nombre});
    }
    Navigator.pop(context);
  }

  Widget _showGraphic() {
    Map<String, double> dataMap = new Map();
    //dataMap.putIfAbsent('Flutter', () => 5);

    // ignore: avoid_function_literals_in_foreach_calls
    bands.forEach((band) {
      dataMap.putIfAbsent(band.nombre!, () => band.votes!.toDouble());
    });
    // dataMap.putIfAbsent('Flutter', () => 5);
    // ignore: avoid_function_literals_in_foreach_calls

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!,
    ];
    return dataMap.isNotEmpty
        ? Container(
            width: double.infinity,
            height: 200,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "HYBRID",
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
              // gradientList: ---To add gradient colors---
              // emp ) : LinearProgressIndicator(); tyColorGradient: ---Empty Color gradient---
            ))
        : LinearProgressIndicator();
  }
}
