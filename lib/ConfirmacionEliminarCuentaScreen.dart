import 'package:flutter/material.dart';

import 'EliminacionCuentaDialog.dart';

class ConfirmacionEliminarCuentaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿ESTÁS SEGURO DE ELIMINAR LA CUENTA?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EliminacionExitosaScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  minimumSize: Size(double.infinity, 50), // Ancho del botón al máximo del contenedor
                  padding: EdgeInsets.symmetric(horizontal: 40), // Espacio alrededor del texto
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF0D99FF)),
                  backgroundColor: Color(0xFF0D99FF),
                  minimumSize: Size(double.infinity, 50), // Ancho del botón al máximo del contenedor
                  padding: EdgeInsets.symmetric(horizontal: 40), // Espacio alrededor del texto
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
