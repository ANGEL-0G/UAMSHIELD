import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'analisis_enlaces_page.dart';
import 'analisis_redes_page.dart';
import 'register_page.dart';

void main() {
  runApp(UAMShieldApp());
}

class UAMShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAMShield',
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ✅ Pantalla de Inicio de Sesión con validación JSON, logo y registro
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  List<Map<String, dynamic>> _usuarios = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    final String data = await rootBundle.loadString('assets/usuarios.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _usuarios = jsonResult.cast<Map<String, dynamic>>();
      _loading = false;
    });
  }

  void _iniciarSesion() {
    final correo = emailController.text.trim();
    final contrasena = passwordController.text;
    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Por favor ingresa correo y contraseña')),
      );
      return;
    }
    final encontrado = _usuarios.any((u) =>
        u['correo'] == correo && u['contrasena'] == contrasena);
    if (encontrado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Credenciales inválidas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Logo en encabezado
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.orange,
                      child: Center(
                        child: Image.asset(
                          'assets/uam_shield_logo.PNG',
                          height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Campos de ingreso
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botones iniciar sesión y registrarse
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _iniciarSesion,
                            icon: const Icon(Icons.person_outline),
                            label: const Text('INICIAR SESIÓN'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('REGISTRARSE'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ✅ Pantalla Principal con logo
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),

          // Logo UAMShield
          Image.asset(
            'assets/uam_shield_logo.PNG',
            height: 80,
          ),
          const SizedBox(height: 20),

          // Texto UAM SHIELD
          Column(
            children: const [
              Text(
                'UAM',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                'SHIELD',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Opciones',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnalisisEnlacesPage()),
                    );
                  },
                  icon: const Icon(Icons.link),
                  label: const Text('Análisis de Enlaces'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnalisisRedesPage()),
                    );
                  },
                  icon: const Icon(Icons.wifi),
                  label: const Text('Análisis de Red'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.orange,
            child: const Center(
              child: Text(
                'UAMShield',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
