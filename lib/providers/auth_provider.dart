import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    state = AuthLoading();
    final url = Uri.parse('http://181.71.32.199:8570/clinica/api/authenticate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = AuthAuthenticated(token: data['access_token']);
      } else {
        state = AuthError(message: 'Credenciales incorrectas');
      }
    } catch (e) {
      state = AuthError(message: 'Error de conexión');
    }
  }
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  AuthAuthenticated({required this.token});
}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
