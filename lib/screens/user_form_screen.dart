import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pt_flutter_faag/providers/user_provider.dart';
import '../providers/register_user_provider.dart';

class UserFormScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _tipoDocumentoController =
      TextEditingController();

  UserFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nombreController, 'Nombre'),
              const SizedBox(height: 10),
              _buildTextField(_apellidoController, 'Apellido'),
              const SizedBox(height: 10),
              _buildTextField(_documentoController, 'Número de Documento',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(
                  _tipoDocumentoController, 'Tipo de Documento (CC, TI, etc.)'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _registrarUsuario(ref, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007FFF),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Registrar',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFF00509E),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Ingrese $label' : null,
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _registrarUsuario(WidgetRef ref, BuildContext context) async {
    final registerUser = ref.read(registerUserProvider);
    final mensaje = await registerUser.registerUser(
      tipoDocumento: _tipoDocumentoController.text,
      numeroDocumento: _documentoController.text,
      primerNombre: _nombreController.text,
      primerApellido: _apellidoController.text,
    );

    if (mensaje.contains('correctamente')) {
      context.go('/home');
      ref.invalidate(registerUserProvider);
      ref.invalidate(userProvider);
    }
  }
}
