import 'package:flutter/material.dart';
import 'package:uamshieldproject/analisis_redes_page.dart';

// ✅ Pantalla Principal
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 50),
          Column(
            children: [
              Text(
                'UAM',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(
                'SHIELD',
                style: TextStyle(
                    fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Opciones',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalisisEnlacesPage()),
                    );
                  },
                  icon: Icon(Icons.link),
                  label: Text("Análisis de Enlaces"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalisisRedesPage()),
                    );
                  },
                  icon: Icon(Icons.wifi),
                  label: Text("Análisis de Red"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50)),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 100,
            width: double.infinity,
            color: Colors.orange,
            child: Center(
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

// ✅ Pantalla de Inicio de Sesión
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.orange,
                child: const Center(
                  child: Icon(
                    Icons.security,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegación a MainPage cuando el usuario presiona el botón
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  icon: const Icon(Icons.person_outline),
                  label: const Text("INICIAR SESIÓN"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

// ✅ Pantalla de Análisis de Enlaces
class AnalisisEnlacesPage extends StatefulWidget {
  const AnalisisEnlacesPage({Key? key}) : super(key: key);

  @override
  State<AnalisisEnlacesPage> createState() => _AnalisisEnlacesPageState();
}

class _AnalisisEnlacesPageState extends State<AnalisisEnlacesPage> {
  final TextEditingController _urlController = TextEditingController();
  String _resultado = "";

  void _analizarURL() {
    String url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _resultado = "Por favor, ingresa un enlace.";
      });
      return;
    }

    bool malicioso = _esMalicioso(url);

    setState(() {
      _resultado = malicioso ? "⚠️ Enlace malicioso detectado" : "✅ Enlace seguro";
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado del Análisis"),
        content: Text(_resultado),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }

  bool _esMalicioso(String url) {
    List<String> urlsSeguras = ["google.com", "microsoft.com", "paypal.com"];
    return !urlsSeguras.any((sitioSeguro) => url.contains(sitioSeguro));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Analisis de Enlaces",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "URL...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                IconButton(
                  icon: const Icon(Icons.link, size: 36, color: Colors.grey),
                  onPressed: _analizarURL,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}