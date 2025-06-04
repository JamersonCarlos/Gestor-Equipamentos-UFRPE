import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/user_entity.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl;

  AuthService({required this.baseUrl});

  static const _tokenKey = 'auth_token';

  Future<User> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      if (token == null) {
        throw Exception('Token não recebido');
      }

      final userJson = data['user'] ?? data; // dependendo da API
      await _storage.write(key: _tokenKey, value: token);
      final user = User.fromJson(userJson, token);

      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Credenciais inválidas. Por favor, verifique seu email e senha.');
    } else {
      throw Exception('Falha no login: ${response.statusCode}');
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final url = Uri.parse('$baseUrl/verify-token');
    final response = await http.get(
      url,
      headers: await getHeaders(),
    );

    if(response.statusCode == 200) { 
      return true; 
    }
    return false; 
  }
}
