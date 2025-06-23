import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;

import '../core/config/env.dart';


class FuncionarioService {
  final String _baseUrl;

  FuncionarioService() : _baseUrl = '${Env.baseUrl}/funcionarios';

  Future<List<Funcionario>> getFuncionarios() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse(_baseUrl), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map<Funcionario>((json) => Funcionario.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar funcionários: ${response.statusCode}');
      }
    } on Exception {
      return [];
    }
  }

  Future<void> createFuncionario(Funcionario funcionario) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await getHeaders(),
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
        headers: await getHeaders(),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar funcionário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar funcionário: $e');
    }
  }
  Future<List<Funcionario>> getFuncionariosSemCartao() async {
    final response = await http.get(Uri.parse('$_baseUrl/nao_associados'), headers: await getHeaders());
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map<Funcionario>((json) => Funcionario.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> updateFuncionario(Funcionario funcionario) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${funcionario.email}'),
        headers: await getHeaders(),
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