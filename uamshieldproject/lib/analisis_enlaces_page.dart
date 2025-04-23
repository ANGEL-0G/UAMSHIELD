import 'package:flutter/material.dart';
import 'main.dart'; // ✅ Importamos MainPage para la navegación

class AnalisisEnlacesPage extends StatefulWidget {
  const AnalisisEnlacesPage({Key? key}) : super(key: key);

  @override
  State<AnalisisEnlacesPage> createState() => _AnalisisEnlacesPageState();
}

class _AnalisisEnlacesPageState extends State<AnalisisEnlacesPage> {
  final TextEditingController _urlController = TextEditingController();
  String _resultado = "";

  @override
  void dispose() {
    _urlController.dispose(); // ✅ Liberación del controlador para evitar fugas de memoria
    super.dispose();
  }

  void _analizarURL() {
    String url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _resultado = "⚠️ Por favor, ingresa un enlace.";
      });
      _mostrarResultado(false);
      return;
    }

    bool malicioso = _esMalicioso(url);

    setState(() {
      _resultado = malicioso ? "⚠️ Enlace malicioso detectado" : "✅ Enlace seguro";
    });

    _mostrarResultado(malicioso);
  }

  bool _esMalicioso(String url) {
    final urlLower = url.toLowerCase();
    List<String> urlsSeguras = ["google.com", "facebook.com", "microsoft.com"];
    bool esSeguro = urlsSeguras.any((sitioSeguro) => urlLower.contains(sitioSeguro));
    return !esSeguro;
  }

  void _mostrarResultado(bool esMalicioso) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: esMalicioso ? Colors.red[100] : Colors.green[100], // ✅ Cambio de color según resultado
        title: Text("Resultado del Análisis"),
        content: Text(_resultado),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Análisis de Enlaces"),
        backgroundColor: Colors.orange,
        leading: IconButton( // ✅ Botón de regreso a MainPage
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    );
  }
}