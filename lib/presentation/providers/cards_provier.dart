import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:gestor_uso_projetores_ufrpe/services/card_service.dart';

class CardsProvider extends ChangeNotifier {
  final CardService _cardService = CardService();

  final List<RfidCardInfo> _rfidCards = [
    RfidCardInfo(
        id: '1',
        cardId: 'A1:B2:C3:D4',
        accessLevel: 'Nível 1 - Geral',
        lastSeen: '25/05/2025 10:30',
        icon: Icons.shield_outlined,
        color: Colors.blue.shade700),
    RfidCardInfo(
        id: '2',
        cardId: 'E5:F6:A7:B8',
        accessLevel: 'Nível 2 - Restrito',
        lastSeen: '25/05/2025 09:15',
        icon: Icons.lock_outline,
        color: Colors.orange.shade700),
    RfidCardInfo(
        id: '3',
        cardId: 'C9:DA:EB:FC',
        accessLevel: 'Nível 3 - Admin',
        lastSeen: '24/05/2025 17:45',
        icon: Icons.admin_panel_settings_outlined,
        color: Colors.green.shade700),
    RfidCardInfo(
        id: '4',
        cardId: '1D:2E:3F:4A',
        accessLevel: 'Visitante',
        lastSeen: '25/05/2025 14:00',
        icon: Icons.person_outline,
        color: Colors.purple.shade700),
    RfidCardInfo(
        id: '5',
        cardId: 'B5:C6:D7:E8',
        accessLevel: 'Nível 1 - Geral',
        lastSeen: '23/05/2025 08:22',
        icon: Icons.shield_outlined,
        color: Colors.blue.shade700),
    RfidCardInfo(
        id: '6',
        cardId: 'F9:AA:BB:CC',
        accessLevel: 'Nível 2 - Bloqueado',
        lastSeen: '22/05/2025 11:50',
        icon: Icons.block_outlined,
        color: Colors.red.shade700),
  ];

  Future<List<RfidCardInfo>> rfidCards() async {
    // final cards = await _cardService.getCards();
    // return cards.map<RfidCardInfo>((json) => RfidCardInfo(
    //     id: json['id'],
    //     cardId: json['cardId'],
    //     accessLevel: json['accessLevel'],
    //     lastSeen: json['lastSeen'],
    //     icon: Icons.person_outline,
    //     color: Colors.purple.shade700,
    //   ),
    // ).toList();
    return Future.delayed(const Duration(seconds: 2), () => _rfidCards);
  }

  void addCard(RfidCardInfo card) {
    _rfidCards.add(card);
    notifyListeners();
  }

  void removeCard(RfidCardInfo card) {
    _rfidCards.remove(card);
    notifyListeners();
  }
}
