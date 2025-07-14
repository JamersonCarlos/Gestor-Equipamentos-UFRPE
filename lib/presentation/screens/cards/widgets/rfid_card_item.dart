import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/core/constants/access_level.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/format_date.util.dart';

class RfidCardInfo {
  final String id;
  final String cardId;
  final String label;
  final AccessLevel accessLevel;
  String? lastSeen;
  final int funcionarioId;
  RfidCardInfo({
    required this.id,
    required this.cardId,
    required this.accessLevel,
    this.lastSeen,
    required this.label,
    required this.funcionarioId,
  });
}

class RfidCardItem extends StatelessWidget {
  final RfidCardInfo cardInfo;

  const RfidCardItem({super.key, required this.cardInfo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cardInfo.accessLevel.color.withOpacity(0.92),
              cardInfo.accessLevel.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Icon(cardInfo.accessLevel.icon,
                          color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'RFID Card',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cardInfo.accessLevel.label,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(62, 255, 255, 255),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ID: ${cardInfo.cardId}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Última leitura: ${formatRelativeDate(DateTime.parse(cardInfo.lastSeen ?? DateTime.now().toString()))}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: cardInfo.accessLevel.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Card ${cardInfo.cardId} selecionado.'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text(
                        'Detalhes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: Icon(Icons.wifi,
                  color: Colors.white.withOpacity(0.85), size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
