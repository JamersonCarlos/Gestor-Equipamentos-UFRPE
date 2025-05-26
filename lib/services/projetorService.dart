import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/entities/projetor.dart';

import '../core/config/env.dart';

class ProjetorService {
    final String _baseUrl;

  ProjetorService() : _baseUrl = '${Env.baseUrl}/equipamentos/';

  Future<List<Projetor>> getProjetores() async {
    final response = await http.get(Uri.parse(_baseUrl));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Projetor.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar projetores');
    }
  }

  Future<void> addProjetor(Projetor projetor) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(projetor.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode!= 200 && response.statusCode!= 204) {
      throw Exception('Falha ao adicionar projetor');
    }
  }

  Future<void> deleteProjetor(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao remover projetor');
    }
  
  }
  Future<void> updateProjetor(Projetor projetor) async {
    final response = await http.put(
      Uri.parse('$_baseUrl${projetor.codigo_tombamento}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(projetor.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao atualizar projetor');
    }
  }
}