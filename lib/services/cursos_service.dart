import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cursos.dart';
import 'package:http/http.dart' as http;

import '../core/config/env.dart';

class CursosService {
  final String _baseUrl;

  CursosService() : _baseUrl = '${Env.baseUrl}/cursos/';

  final http.Client httpClient = http.Client();

  Future<List<Curso>> getCursos() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<Curso>((json) => Curso.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar cursos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cursos: $e');
    }
  }
}