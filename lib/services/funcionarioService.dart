import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:http/http.dart' as http;

import '../core/config/env.dart';


class FuncionarioService {
  final String _baseUrl;

  FuncionarioService() : _baseUrl = '${Env.baseUrl}/funcionarios/';

  Future<List<Funcionario>> getFuncionarios() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<Funcionario>((json) => Funcionario.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar funcionários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar funcionários: $e');
    }
  }

  Future<void> createFuncionario(Funcionario funcionario) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(funcionario.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode == 400) {
        throw Exception(json.decode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao criar funcionário: \$e');
    }
  }

  Future<void> deleteFuncionario(String cpf) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$cpf'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar funcionário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar funcionário: $e');
    }
  }

  Future<void> updateFuncionario(Funcionario funcionario) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${funcionario.email}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(funcionario.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar funcionário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar funcionário: $e');
    }
  }
}