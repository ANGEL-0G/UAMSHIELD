import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'main.dart';

class AnalisisEnlacesPage extends StatefulWidget {
  const AnalisisEnlacesPage({Key? key}) : super(key: key);

  @override
  State<AnalisisEnlacesPage> createState() => _AnalisisEnlacesPageState();
}

class _AnalisisEnlacesPageState extends State<AnalisisEnlacesPage> {
  final TextEditingController _urlController = TextEditingController();
  final Map<String, String> _csvData = {};      // url → tipo
  final List<String> _benignDomains = [];       // dominios “benign” para fuzzy match

  // Leet‑speak: dígitos → letras
  static const Map<String, String> _subs = {
    '0': 'o', '1': 'l', '3': 'e', '4': 'a', '5': 's', '7': 't',
  };

  @override
  void initState() {
    super.initState();
    _cargarCsv();
  }

  Future<void> _cargarCsv() async {
    final raw = await rootBundle.loadString('assets/malicious_phish.csv');
    final rows = const CsvToListConverter().convert(raw, eol: '\n');
    for (var i = 1; i < rows.length; i++) {
      final url  = rows[i][0].toString().trim().toLowerCase();
      final tipo = rows[i][1].toString().trim().toLowerCase();
      _csvData[url] = tipo;
      if (tipo == 'benign') {
        // extrae solo el dominio (sin path)
        final domain = url.split('/')[0];
        _benignDomains.add(domain);
      }
    }
  }

  void _analizarURL() {
    final inputRaw = _urlController.text.trim().toLowerCase();
    if (inputRaw.isEmpty) {
      return _mostrarDialogo("⚠️ Por favor, ingresa una URL");
    }

    // toma solo el dominio
    final input = inputRaw.split('/')[0];

    // 1) exact match
    final tipoExacto = _csvData[input];
    if (tipoExacto != null) {
      return _mostrarDialogo(
        tipoExacto == 'benign'
          ? "✅ Enlace seguro"
          : "⚠️ Enlace malicioso detectado ($tipoExacto)"
      );
    }

    // 2) leet‑speak
    final norm = input.split('').map((c) => _subs[c] ?? c).join();
    if (norm != input && _csvData.containsKey(norm)) {
      return _mostrarDialogo(
        "⚠️ Posible typo‑squatting (leet): '$input' → '$norm'"
      );
    }

    // 3) fuzzy match con Levenshtein
    for (final domain in _benignDomains) {
      final dist = _levenshtein(input, domain);
      if (dist > 0 && dist <= 1) {
        return _mostrarDialogo(
          "⚠️ Posible typo‑squatting: '$input' parecido a '$domain'"
        );
      }
    }

    // 4) no encontrado
    _mostrarDialogo("❓ URL no encontrada en el CSV");
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    final rows = List.generate(s.length + 1,
        (_) => List<int>.filled(t.length + 1, 0));
    for (var i = 0; i <= s.length; i++) rows[i][0] = i;
    for (var j = 0; j <= t.length; j++) rows[0][j] = j;
    for (var i = 1; i <= s.length; i++) {
      for (var j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        rows[i][j] = [
          rows[i - 1][j] + 1,
          rows[i][j - 1] + 1,
          rows[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return rows[s.length][t.length];
  }

  void _mostrarDialogo(String mensaje) {
    final mal = mensaje.startsWith("⚠️");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: mal ? Colors.red[100] : Colors.green[100],
        title: const Text("Resultado del Análisis"),
        content: Text(mensaje),
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
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis de Enlaces"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/uam_shield_logo.PNG', height: 100),
                const SizedBox(height: 30),
                const Text(
                  "Análisis de Enlaces",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
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
                ElevatedButton.icon(
                  onPressed: _analizarURL,
                  icon: const Icon(Icons.link),
                  label: const Text("Analizar URL"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
