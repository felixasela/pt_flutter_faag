import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

final updateUserProvider = Provider((ref) => UpdateUserRepository(ref));

class UpdateUserRepository {
  final Ref ref;
  UpdateUserRepository(this.ref);

  Future<String> updateUser({
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

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authState.token}',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return 'Usuario actualizado correctamente';
    } else {
      return 'Error al actualizar usuario: ${response.body}';
    }
  }
}
