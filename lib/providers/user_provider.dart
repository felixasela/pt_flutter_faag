import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

final userProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState is! AuthAuthenticated) {
    throw Exception('No autenticado');
  }

  final url = Uri.parse('http://181.71.32.199:8570/clinica/api/medico');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer ${authState.token}'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error al cargar usuarios');
  }
});
