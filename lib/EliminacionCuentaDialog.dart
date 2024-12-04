import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';

class EliminacionExitosaScreen extends StatelessWidget {
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
                'Cuenta eliminada correctamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Icon(
                Icons.check,
                color: Colors.black,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                '¡Has eliminado la cuenta de manera exitosa!\nAgradecemos tu estadía en nuestra App',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token'); // Elimina el token de sesión

                  // Redirigir a la pantalla de inicio de sesión y eliminar todas las pantallas anteriores
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false, // Esta condición elimina todas las rutas previas
                  );
                },

                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF0D99FF)),
                  backgroundColor: Color(0xFF0D99FF),
                ),
                child: Text(
                  'Continuar y salir de la aplicacion',
                  style: TextStyle(color: Colors.white,
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
