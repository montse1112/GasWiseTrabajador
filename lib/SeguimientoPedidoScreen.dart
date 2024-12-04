import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'HomeScreen.dart';

class SeguimientoPedidoScreen extends StatefulWidget {
  @override
  _SeguimientoPedidoScreenState createState() => _SeguimientoPedidoScreenState();
}

class _SeguimientoPedidoScreenState extends State<SeguimientoPedidoScreen> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = LatLng(19.4326, -99.1332); // Coordenadas iniciales (CDMX)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Seguimiento de pedido',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '####',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Google Map
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId("pedido"),
                      position: _initialPosition, // Posición inicial del pedido
                      infoWindow: InfoWindow(title: "Pedido Actual"),
                    ),
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(nombreUsuario: ''),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Fondo azul
                minimumSize: Size(double.infinity, 50),
                shape: StadiumBorder(), // Forma ovalada
              ),
              child: Text(
                'Notificar que se encuentra fuera del domicilio',
                style: TextStyle(
                  color: Colors.white, // Letras blancas
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Asegura que el texto esté centrado
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(nombreUsuario: ''),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white, // Fondo blanco
                side: BorderSide(color: Colors.black), // Borde negro
                minimumSize: Size(double.infinity, 50),
                shape: StadiumBorder(), // Forma ovalada
              ),
              child: Text(
                'Notificar que el servicio fue realizado correctamente',
                style: TextStyle(
                  color: Colors.black, // Letras negras
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Asegura que el texto esté centrado
              ),
            ),

          ],
        ),
      ),
    );
  }
}
