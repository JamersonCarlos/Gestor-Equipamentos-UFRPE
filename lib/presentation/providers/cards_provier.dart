import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:gestor_uso_projetores_ufrpe/services/card_service.dart';

class CardsProvider extends ChangeNotifier {
  final CardService _cardService = CardService();
  List<RfidCardInfo> _rfidCards = [];
  bool _isInitialized = false;

  Future<List<RfidCardInfo>> rfidCards() async {
    if (!_isInitialized) {
      await getCards();
      _isInitialized = true;
    }
    return _rfidCards;
  }

  void addCard(RfidCardInfo card) {
    _rfidCards.add(card);
    notifyListeners();
  }

  void removeCard(RfidCardInfo card) {
    _rfidCards.remove(card);
    notifyListeners();
  }

  Future<void> getCards() async {
    try {
      final cards = await _cardService.getCards();
      _rfidCards = cards
          .map<RfidCardInfo>(
            (json) => RfidCardInfo(
              id: json.id.toString(),
              cardId: json.rfid,
              accessLevel: json.nivelAcesso.label,
              lastSeen: json.ultimaEntrada.toString(),
              icon: json.nivelAcesso.icon,
              color: json.nivelAcesso.color,
            ),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
    }
  }

  void refreshCards() {
    _isInitialized = false;
    getCards();
  }
}
