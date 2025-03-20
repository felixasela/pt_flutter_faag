import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

final registerUserProvider = Provider((ref) => RegisterUserRepository(ref));

class RegisterUserRepository {
  final Ref ref;
  RegisterUserRepository(this.ref);

  Future<String> registerUser({
    required String tipoDocumento,
    required String numeroDocumento,
    required String primerNombre,
    required String primerApellido,
  }) async {
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      return 'Error: No autenticado';
    }

    final url = Uri.parse('http://181.71.32.199:8570/clinica/api/medico');

    final body = jsonEncode({
      'tipoDocumento': tipoDocumento,
      'numeroDocumento': numeroDocumento,
      'primerNombre': primerNombre,
      'primerApellido': primerApellido,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authState.token}',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return 'Usuario registrado con éxito';
    } else {
      return 'Error al registrar usuario: ${response.body}';
    }
  }
}
