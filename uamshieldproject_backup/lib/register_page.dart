// lib/register_page.dart

import 'package:flutter/material.dart';
import 'services/auth_service.dart';  // Ajusta la ruta si tu carpeta es distinta

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final correo = _emailController.text.trim();
    final pass   = _passwordController.text;

    await AuthService.register(correo, pass);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("¡Registro exitoso!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro"), backgroundColor: Colors.orange),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nombre completo"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor ingresa tu nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Correo
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Correo electrónico"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor ingresa un correo";
                    }
                    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!regex.hasMatch(value.trim())) {
                      return "Ingresa un correo válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa una contraseña";
                    }
                    if (value.length < 6) {
                      return "La contraseña debe tener al menos 6 caracteres";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botón Registrar
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text("Registrar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
