import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'LoginScreen.dart';

class Registro_Screen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<Registro_Screen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;
  double _passwordStrength = 0.0;

  bool validarContrasena(String password) {
    bool tieneMinimo6Caracteres = password.length >= 6;
    bool tieneMayuscula = password.contains(RegExp(r'[A-Z]'));
    bool tieneMinuscula = password.contains(RegExp(r'[a-z]'));
    bool tieneNumero = password.contains(RegExp(r'[0-9]'));
    bool tieneCaracterEspecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return tieneMinimo6Caracteres && tieneMayuscula && tieneMinuscula && tieneNumero && tieneCaracterEspecial;
  }

  void _actualizarFuerzaContrasena(String password) {
    double fuerza = 0.0;

    if (password.length >= 6) fuerza += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) fuerza += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) fuerza += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) fuerza += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) fuerza += 0.2;

    setState(() {
      _passwordStrength = fuerza;
    });
  }

  Future<void> _registrarUsuario() async {
    String nombre = nombreController.text;
    String correo = correoController.text;
    String password = passwordController.text;

    if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    if (!validarContrasena(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La contraseña debe tener al menos 6 caracteres, con mayúsculas, minúsculas, números y símbolos.')),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      'nombre': nombre,
      'email': correo,
      'contraseña': password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.19:3000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar usuario: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView( // Aquí agregamos el SingleChildScrollView
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
                  image: AssetImage('assets/bg1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),

            // Segundo contenedor, con el formulario
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registro_Screen()),
                          );
                        },
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    onChanged: _actualizarFuerzaContrasena,
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: Colors.redAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 10,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registrarUsuario,
                    child: Text('Registrar'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
