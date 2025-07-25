import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;

import '../domain/entities/projetor.dart';

import '../core/config/env.dart';

class ProjetorService {
  final String _baseUrl;

  ProjetorService() : _baseUrl = '${Env.baseUrl}/equipamentos';

  Future<List<Projetor>> getProjetores() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Projetor.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Projetor>> getProjetoresNotInUse() async {
    final headers = await getHeaders();
    final response =
        await http.get(Uri.parse('$_baseUrl/nao_associados'), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Projetor.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> addProjetor(Projetor projetor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/'),
      headers: await getHeaders(),
      body: json.encode(projetor.toJson()),
    );

    if (response.statusCode != 201 &&
        response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception('Falha ao adicionar projetor');
    }
  }

  Future<void> deleteProjetor(String codigo_tombamento) async {
    final headers = await getHeaders();
    final response = await http
        .delete(Uri.parse('$_baseUrl/$codigo_tombamento'), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Falha ao remover projetor');
    }
  }

  Future<void> updateProjetor(Projetor projetor) async {
    final response = await http.put(
      Uri.parse('$_baseUrl${projetor.codigo_tombamento}'),
      headers: await getHeaders(),
      body: json.encode(projetor.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao atualizar projetor');
    }
  }
}
