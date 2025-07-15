import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/rfid_tag.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';

class TagService {
  final String _baseUrl;

  TagService() : _baseUrl = '${Env.baseUrl}/tags/';

  Future<List<Map<String, dynamic>>> getTags() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar tags: [${response.statusCode}]');
    }
  }

  Future<Map<String, dynamic>> addTag(RfidTag tag) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: await getHeaders(),
      body: json.encode(tag),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao adicionar tag: [${response.statusCode}]');
    }
  }

  Future<void> updateTagStatus(String id, bool isActive) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$id?status=$isActive'),
      headers: await getHeaders(),
    );
  
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao atualizar status da tag: [${response.statusCode}]');
    }
  }
}
