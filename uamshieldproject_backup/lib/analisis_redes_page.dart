import 'package:flutter/material.dart';
import 'main.dart'; // Para navegar de regreso a MainPage

class AnalisisRedesPage extends StatefulWidget {
  const AnalisisRedesPage({Key? key}) : super(key: key);

  @override
  State<AnalisisRedesPage> createState() => _AnalisisRedesPageState();
}

class _AnalisisRedesPageState extends State<AnalisisRedesPage> {
  final TextEditingController _nombreRedController   = TextEditingController();
  final TextEditingController _tipoCifradoController = TextEditingController();
  final TextEditingController _velocidadController    = TextEditingController();
  String _resultado = "";

  // Umbral de velocidad (Mbps) para considerar la red muy lenta
  static const double _velocidadUmbral = 10.0;

  @override
  void dispose() {
    _nombreRedController.dispose();
    _tipoCifradoController.dispose();
    _velocidadController.dispose();
    super.dispose();
  }

  void _analizarRed() {
    final nombre  = _nombreRedController.text.trim().toLowerCase();
    final cifrado = _tipoCifradoController.text.trim().toLowerCase();
    final velocidad = double.tryParse(_velocidadController.text.trim()) ?? 0.0;

    if (nombre.isEmpty || cifrado.isEmpty) {
      _mostrarDialogo("⚠️ Por favor completa todos los campos");
      return;
    }

    final score = _calcularPuntuacion(cifrado, velocidad);
    final esPeligrosa = score >= 2.0;
    final estado = esPeligrosa ? "PELIGROSA" : "segura";

    _mostrarDialogo(
      esPeligrosa
        ? "⚠️ Red WiFi $estado (puntuación: ${score.toStringAsFixed(1)})"
        : "✅ Red WiFi $estado (puntuación: ${score.toStringAsFixed(1)})",
    );
  }

  double _calcularPuntuacion(String cifrado, double velocidad) {
    double puntos = 0.0;

    // Cifrado abierto → +2.0 puntos
    if (cifrado == 'none' || cifrado == 'open') {
      puntos += 2.0;
    }
    // Cifrado WEP → +1.0 punto
    else if (cifrado.contains('wep')) {
      puntos += 1.0;
    }

    // Velocidad muy lenta → +1.0 punto
    if (velocidad > 0 && velocidad < _velocidadUmbral) {
      puntos += 1.0;
    }

    return puntos;
  }

  void _mostrarDialogo(String mensaje) {
    final esPeligrosa = mensaje.startsWith("⚠️");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: esPeligrosa ? Colors.red[100] : Colors.green[100],
        title: const Text("Resultado del Análisis"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Aceptar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de Redes WiFi"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                  Image.asset('assets/uam_shield_logo.PNG', height: 100),
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
                      hintText: "Ej. MiRedPrivada",
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
                      hintText: "Ej. WPA2, WPA3, open, WEP",
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
                      hintText: "Ej. 5",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _analizarRed,
                    icon: const Icon(Icons.wifi),
                    label: const Text("Analizar Red"),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
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
