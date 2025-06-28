import 'dart:convert';

import '../core/config/env.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/defeito.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;

class DefeitoService {
  final String _baseUrl;

  DefeitoService() : _baseUrl = '${Env.baseUrl}/defeitos';

  Future<void> createDefeito(Defeito defeito) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/"),
        headers: await getHeaders(),
        body: json.encode(defeito.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Erro ao criar defeito: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar defeito: $e');
    }
  }

  Future<void> updateDefeito(Defeito defeito) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/${defeito.id}"),
        headers: await getHeaders(),
        body: json.encode(defeito.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar defeito: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar defeito: $e');
    }
  }

  Future<void> removerDefeito(Defeito defeito) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl/${defeito.id}"),
        headers: await getHeaders(),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao remover defeito: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao remover defeito: $e');
    }
  }
}
