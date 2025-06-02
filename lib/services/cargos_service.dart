import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';
import '../domain/entities/cargo.dart';

class CargosService {
  final String _baseUrl;

  CargosService() : _baseUrl = '${Env.baseUrl}/cargos/';

  final http.Client httpClient = http.Client();

  Future<List<Cargo>> getCargos() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<Cargo>((json) => Cargo.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar cargos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cargos: $e');
    }
  }
}