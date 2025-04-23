import 'package:flutter/material.dart';
import 'main.dart'; // ✅ Importamos MainPage para la navegación

class AnalisisRedesPage extends StatefulWidget {
  const AnalisisRedesPage({Key? key}) : super(key: key);

  @override
  State<AnalisisRedesPage> createState() => _AnalisisRedesPageState();
}

class _AnalisisRedesPageState extends State<AnalisisRedesPage> {
  final TextEditingController _nombreRedController = TextEditingController();
  final TextEditingController _tipoCifradoController = TextEditingController();
  final TextEditingController _velocidadController = TextEditingController();
  String _resultado = "";

  @override
  void dispose() {
    _nombreRedController.dispose();
    _tipoCifradoController.dispose();
    _velocidadController.dispose();
    super.dispose();
  }

  void _analizarRed() {
    String nombreRed = _nombreRedController.text.trim().toLowerCase();
    String tipoCifrado = _tipoCifradoController.text.trim().toLowerCase();
    double velocidad = double.tryParse(_velocidadController.text.trim()) ?? 0;

    bool esPeligrosa = _esRedPeligrosa(nombreRed, tipoCifrado, velocidad);

    setState(() {
      _resultado = esPeligrosa ? "⚠️ Red WiFi peligrosa detectada" : "✅ Red WiFi segura";
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

  bool _esRedPeligrosa(String nombre, String cifrado, double velocidad) {
    List<String> listaNegra = [
      "free wifi", "wifi gratis", "open network",
      "public wifi", "free internet", "airport wifi", "hotel wifi"
    ];

    bool enListaNegra = listaNegra.any((prohibido) => nombre.contains(prohibido));
    if (enListaNegra) return true;

    bool sinCifrado = cifrado == "none" || cifrado == "open";
    if (!sinCifrado) return false;

    bool traficoElevado = velocidad > 24;

    return traficoElevado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Análisis de Redes WiFi"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/uam_shield_logo.PNG',
                    height: 100,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Análisis de Redes WiFi",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Nombre de la red WiFi:", style: TextStyle(color: Colors.orange)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nombreRedController,
                    decoration: InputDecoration(
                      hintText: "Ej. Free WiFi",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Tipo de cifrado:", style: TextStyle(color: Colors.orange)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tipoCifradoController,
                    decoration: InputDecoration(
                      hintText: "Ej. WPA2, WPA3, open",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Velocidad estimada (Mbps):", style: TextStyle(color: Colors.orange)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _velocidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Ej. 150",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  IconButton(
                    icon: const Icon(Icons.wifi, size: 36, color: Colors.grey),
                    onPressed: _analizarRed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
