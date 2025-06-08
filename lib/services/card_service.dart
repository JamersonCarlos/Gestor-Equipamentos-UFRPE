import 'dart:convert';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:http/http.dart' as http;
import '../core/config/env.dart';
import '../domain/entities/rfid_card.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/headerRequest.dart';

class CardService {
  final String _baseUrl;

  CardService() : _baseUrl = '${Env.baseUrl}/cartoes';

  Future<List<RfidCard>> getCards({int skip = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?skip=$skip&limit=$limit'),
        headers: await getHeaders(),
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
  
  Future<List<RfidCard>> getCardNotUsed({int skip = 0, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/nao_associados?skip=$skip&limit=$limit'),
        headers: await getHeaders(),
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

  Future<RfidCard?> findCard(String cardId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/rfid/$cardId'),
      headers: await getHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return RfidCard.fromJson(jsonData);
    } else {
      throw Exception('Falha ao buscar cartão: ${response.statusCode}');
    }
  }

  Future<void> createCard(RfidCardInfo card) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await getHeaders(),
        body: json.encode({
          'rfid': card.cardId,
          'nome': card.label,
          'nivel_acesso': card.accessLevel.value,
          'status': card.accessLevel.label,
        }),
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
        headers: await getHeaders(),
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
