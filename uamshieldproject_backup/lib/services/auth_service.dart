import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _key = 'usuarios';

  /// Inicializa SharedPreferences con el JSON de assets si aún no existe.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      final raw = await rootBundle.loadString('assets/usuarios.json');
      await prefs.setString(_key, raw);
    }
  }

  /// Lee la lista de usuarios desde prefs y la devuelve como lista de Map.
  static Future<List<Map<String, dynamic>>> _getUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key) ?? '[]';
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Intenta iniciar sesión; devuelve true si encontró coincidencia.
  static Future<bool> login(String correo, String password) async {
    final usuarios = await _getUsuarios();
    return usuarios.any((u) =>
      u['correo'] == correo && u['contrasena'] == password
    );
  }

  /// Registra un nuevo usuario y actualiza prefs.
  static Future<void> register(String correo, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usuarios = await _getUsuarios();
    usuarios.add({'correo': correo, 'contrasena': password});
    final jsonString = json.encode(usuarios);
    await prefs.setString(_key, jsonString);
  }
}
