import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';
import '../domain/entities/cargo.dart';

class CargosService {
  final String _baseUrl;

  CargosService() : _baseUrl = '${Env.baseUrl}/cargos/';

  final http.Client httpClient = http.Client();

  Future<List<Cargo>> getCargos() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse(_baseUrl), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<Cargo>((json) => Cargo.fromJson(json)).toList();
      } else {
        final errorDetail = json.decode(response.body)['detail'] ?? 'Erro desconhecido';
        throw Exception('Erro ao carregar cargos: $errorDetail');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cargos: $e');
    }
  }
}