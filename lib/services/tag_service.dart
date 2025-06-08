import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';

class TagService {
  final String _baseUrl;

  TagService() : _baseUrl = '${Env.baseUrl}/tags/';

  Future<List<Map<String, dynamic>>> getTags() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar tags: [${response.statusCode}]');
    }
  }
}
