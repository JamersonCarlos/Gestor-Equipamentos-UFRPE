import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';
import '../domain/entities/rfid_card.dart';

class CardService {
  final String _baseUrl;

  CardService() : _baseUrl = '${Env.baseUrl}/cartoes/';

  Future<List<RfidCard>> getCards({int skip = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?skip=$skip&limit=$limit'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map<RfidCard>((json) => RfidCard.fromJson(json))
            .toList();
      } else {
        throw Exception('Falha ao carregar cartões: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar cartões: $e');
    }
  }

  Future<void> createCard(RfidCard card) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(card.toJson()),
      );
      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode == 400) {
        throw Exception(json.decode(response.body)['detail']);
      }
    } catch (e) {
      throw Exception('Erro ao criar cartão: $e');
    }
  }

  Future<void> deleteCard(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao deletar cartão: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar cartão: $e');
    }
  }

  Future<void> updateCard(RfidCard card) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${card.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(card.toJson()),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar cartão: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar cartão: $e');
    }
  }
}
