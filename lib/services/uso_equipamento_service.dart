import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/uso_equipamento.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';

class UsoEquipamentoService {
  final String _baseUrl;

  UsoEquipamentoService() : _baseUrl = '${Env.baseUrl}/uso-equipamento/';

  Future<List<UsoEquipamento>> getUsos({int skip = 0, int limit = 100}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?skip=$skip&limit=$limit'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map<UsoEquipamento>((json) => UsoEquipamento.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEmprestimosPorDia() async {
    final response = await http.get(
      Uri.parse('${_baseUrl}emprestimos-por-dia'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }
}
