import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/update_user_provider.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;

  const EditUserScreen({super.key, required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _documentoController;
  late final TextEditingController _tipoDocumentoController;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.user['primerNombre']);
    _apellidoController =
        TextEditingController(text: widget.user['primerApellido']);
    _documentoController =
        TextEditingController(text: widget.user['numeroDocumento']);
    _tipoDocumentoController =
        TextEditingController(text: widget.user['tipoDocumento']);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _documentoController.dispose();
    _tipoDocumentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese el apellido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _actualizarUsuario();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _actualizarUsuario() async {
    final updateUser = ref.read(updateUserProvider);
    final mensaje = await updateUser.updateUser(
      tipoDocumento: _tipoDocumentoController.text,
      numeroDocumento: _documentoController.text,
      primerNombre: _nombreController.text,
      primerApellido: _apellidoController.text,
    );

    if (mensaje.contains('actualizado')) {
      if (mounted) {
        ref.invalidate(updateUserProvider);
        context.go('/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el usuario')),
        );
      }
    }
  }
}
