import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'ConfigurarContrasena.dart';
import 'DetallesPedidoScreen.dart';
import 'HistorialPedidosScreen.dart';
import 'SeguimientoPedidoScreen.dart';

class HomeScreen extends StatelessWidget {
  final String nombreUsuario;

  // Constructor que requiere el parámetro nombreUsuario
  HomeScreen({required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Sin sombra en la appBar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
               MaterialPageRoute(builder: (context) => PerfilScreen()),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context), // Sección modularizada del Drawer
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Círculo naranja de fondo
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black, // Color naranja
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(100), // Círculo invertido
                    ),
                  ),
                ),
                Positioned(
                  top: 40, // Ajusta la posición según sea necesario
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png', // Cambia esto por tu imagen del logo
                        height: 130,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Nivel del tanque
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  Text(
                    'Bienvenido a Gas Wise',
                    style: TextStyle(
                      color: Color(0xFF0D99FF), // Color personalizado con opacidad completa
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$nombreUsuario',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  SizedBox(height: 10),

                  Center(
                  child: Text(
                    'Si estas listo para trabajar, presiona "DISPONIBLE AHORA"',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  ),

                  SizedBox(height: 20),
                  SizedBox(height: 32),
                  _buildButton(context, 'DISPONIBLE AHORA', Colors.black),
                  SizedBox(height: 32),
                  _buildButton1(context, 'DESACTIVAR DISPONIBILIDAD', Colors.black),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Acción al presionar el botón
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildButton1(BuildContext context, String text, Color color) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Acción al presionar el botón
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetallesPedidoScreen()),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  // Función para construir el Drawer
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'GasWise Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Para cerrar el menú después de selección
            },
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historial de pedidos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistorialPedidosScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text('Seguimiento de pedido'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeguimientoPedidoScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () async {
              /*SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token'); // Elimina el token de sesión

              // Redirigir a la pantalla de inicio de sesión
              Navigator.pushReplacement(
                context,
               MaterialPageRoute(builder: (context) => LoginScreen()),
              );*/
            },
          ),
        ],
      ),
    );
  }

  // Widget helper para construir cada fila de estadísticas
  Widget _buildStatisticRow(String label, String value, {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) Icon(icon, color: Colors.orange),
            if (icon != null) SizedBox(width: 5),
            Text(label),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
