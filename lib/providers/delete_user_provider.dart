import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

final deleteUserProvider = Provider((ref) => DeleteUserRepository(ref));

class DeleteUserRepository {
  final Ref ref;
  DeleteUserRepository(this.ref);

  Future<bool> deleteUser(String tipoDocumento, String numeroDocumento) async {
    final authState = ref.read(authProvider);
    if (authState is! AuthAuthenticated) {
      return false;
    }

    final url = Uri.parse(
        'http://181.71.32.199:8570/clinica/api/medico/$tipoDocumento/$numeroDocumento');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${authState.token}',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
