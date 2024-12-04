import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:crypto/crypto.dart'; // Importamos la librería crypto para encriptar
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'PasswordRecoveryScreen.dart';
import 'Registro_Screen.dart';

// Clase que define el estado de la pantalla de inicio de sesión (LoginScreen)
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos de correo y contraseña
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable para controlar la visibilidad de la contraseña
  bool _isObscure = true;

  // Función asincrónica que maneja el inicio de sesión
  Future<void> _inicioSesion() async {
    String correo = correoController.text; // Obtiene el valor del campo de correo
    String password = passwordController.text; // Obtiene el valor del campo de contraseña

    // Verifica si ambos campos están llenos
    if (correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')), // Muestra un mensaje si faltan datos
      );
      return;
    }

    // Construye el cuerpo de la solicitud HTTP con los datos del usuario
    final Map<String, dynamic> requestBody = {
      'email': correo,
      'password': password
    };

    try {
      // Realiza la solicitud HTTP POST para iniciar sesión
      final response = await http.post(
        Uri.parse('http://192.168.100.19:3000/login'), // Cambia esta URL según tu configuración
        headers: {'Content-Type': 'application/json'}, // Cabecera para indicar que el contenido es JSON
        body: jsonEncode(requestBody), // Convierte el cuerpo de la solicitud a JSON
      );

      print('Response status: ${response.statusCode}'); // Imprime el estado de la respuesta (ej. 200)
      print('Response body: ${response.body}'); // Imprime el cuerpo de la respuesta

      // Si la respuesta es exitosa (código 200)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decodifica el cuerpo de la respuesta

        // Verifica si en la respuesta existen los campos 'token' y 'nombre'
        if (data.containsKey('token') && data.containsKey('nombre')) {
          final String token = data['token']; // Obtiene el token del usuario
          final String nombreUsuario = data['nombre']; // Obtiene el nombre del usuario

          // Almacena el token y el nombre del usuario en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token); // Almacena el token
          await prefs.setString('nombreUsuario', nombreUsuario); // Almacena el nombre del usuario

          print(token);
          print('Nombre de usuario: ' + nombreUsuario);

          // Navega a la pantalla del menú principal, pasando el nombre del usuario
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(nombreUsuario: nombreUsuario), // Pasa el nombre del usuario
            ),
          );
        } else {
          // Muestra un mensaje de error si no se encuentran los campos 'token' o 'nombre'
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: No se encontró el campo "token" o "nombre".')),
          );
        }
      } else {
        // Muestra un mensaje de error si la respuesta no es exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e'); // Imprime el error en la consola
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor')), // Muestra un mensaje de error si falla la conexión
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Parte superior con la imagen de fondo y el logo
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/bg3.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Contenedor para el formulario de inicio de sesión
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Texto de bienvenida centrado
                      Center(
                        child: Text(
                          'Bienvenido a Gas Wise',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campo de correo electrónico con tamaño reducido
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: correoController,
                          decoration: InputDecoration(
                            labelText: 'Correo',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Campo de contraseña con tamaño reducido
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Color personalizado con opacidad completa
                            padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _inicioSesion,
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(nombreUsuario: '',)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: Text('Boton Home'),
                        ),
                      ),
                      SizedBox(height: 10),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PasswordRecoveryScreen()),
                            );
                          },
                          child: Text('¿Olvidaste tu contraseña?'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}