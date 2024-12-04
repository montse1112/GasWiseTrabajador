import 'package:flutter/material.dart';

class DetallesPedidoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(height: 20),
            Center(
              child:Text(
                'Hay un pedido entrante',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.check,
              size: 50,
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              'Actuamente hay un pedido solicitado cerca de tu zona, aceptalo para ocultarlo a los demas y esperar el visto bueno del cliente. ¡Suerte!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Información del Trabajador
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Datos del cliente', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Nombre: Juan Pérez'),
                  Text('Teléfono: 555-1234'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Información del Peedido
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Datos del Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Direccion'),
                  Text('Metodo del pago'),
                  Text('Cntidad de litros'),
                  Text('Precio del gas'),
                  Text('Total a pagar'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Botones
            ElevatedButton(
              onPressed: () {
                // Acción para confirmar pedido

              },
              child: Text('Confirmar Surtido'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white, // Color del texto
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Acción para cancelar pedido

              },
              child: Text('Rechazar Surtido'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black),
                foregroundColor: Colors.blue, // Color del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
