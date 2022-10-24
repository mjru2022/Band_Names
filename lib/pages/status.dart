import 'package:bands_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Estado del servidor:${socketService.serverStatus}")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () {
            //  TAREA
            // emitir: emitir-mensaje
            socketService.emit("emitir-mensaje",
                {"nombre": "flutter", 'mensaje': "hola desde cliente futter"});
          }),
    );
  }
}
