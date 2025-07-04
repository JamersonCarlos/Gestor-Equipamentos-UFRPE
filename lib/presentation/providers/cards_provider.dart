import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:gestor_uso_projetores_ufrpe/services/card_service.dart';
import 'package:gestor_uso_projetores_ufrpe/services/funcionarioService.dart';

class CardsProvider extends ChangeNotifier {
  final CardService _cardService = CardService();
  final FuncionarioService _funcionarioService = FuncionarioService();
  List<RfidCardInfo> _rfidCards = [];
  bool _isInitialized = false;

  Future<List<RfidCardInfo>> rfidCards() async {
    if (!_isInitialized) {
      await getCards();
      _isInitialized = true;
    }
    return _rfidCards;
  }

  Future<void> addCard(RfidCardInfo card) async {
    try {
      await _cardService.createCard(card);
      _rfidCards.add(card);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void removeCard(RfidCardInfo card) {
    _rfidCards.remove(card);
    notifyListeners();
  }

  Future<RfidCardInfo?> findCard(String cardId) async {
    try {
      final card = await _cardService.findCard(cardId);
      if (card == null) {
        return null;
      }
      return RfidCardInfo(
        id: card.id.toString(),
        cardId: card.rfid,
        accessLevel: card.nivelAcesso,
        lastSeen: card.ultimaEntrada.toString(),
        label: card.nivelAcesso.label,
        funcionarioId: 0,
      );
    } catch (e) {
      print('Erro ao buscar cartão: $e');
      return null;
    }
  }

  Future<void> getCards() async {
    try {
      final cards = await _cardService.getCards();
      _rfidCards = cards
          .map<RfidCardInfo>(
            (json) => RfidCardInfo(
              id: json.id.toString(),
              cardId: json.rfid,
              accessLevel: json.nivelAcesso,
              lastSeen: json.ultimaEntrada.toString(),
              label: json.nivelAcesso.label,
              funcionarioId: json.funcionarioId,
            ),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
    }
  }

  Future<List<Funcionario>> getFuncionariosSemCartao() async {
    final funcionarios = await _funcionarioService.getFuncionariosSemCartao();
    return funcionarios;
  }

  Future<List<RfidCardInfo>> getCardNotUsed() async {
    try {
      final cards = await _cardService.getCardNotUsed();
      return cards
          .map<RfidCardInfo>(
            (json) => RfidCardInfo(
              id: json.id.toString(),
              cardId: json.rfid,
              accessLevel: json.nivelAcesso,
              lastSeen: json.ultimaEntrada?.toString(),
              label: json.nivelAcesso.label,
              funcionarioId: json.funcionarioId,
            ),
          )
          .toList();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
      return [];
    }
  }

  void refreshCards() {
    _isInitialized = false;
    getCards();
  }
}
