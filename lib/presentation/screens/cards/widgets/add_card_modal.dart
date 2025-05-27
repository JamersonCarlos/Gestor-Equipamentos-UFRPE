import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provier.dart';
import 'package:lottie/lottie.dart';
import 'rfid_card_item.dart';

class AddCardModal extends StatefulWidget {
  final CardsProvider cardsProvider;
  const AddCardModal({super.key, required this.cardsProvider});

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String cardId = '';
  String accessLevel = '';
  String lastSeen = '';
  IconData icon = Icons.shield_outlined;
  Color color = Colors.blue.shade700;
  bool waitingForCard = true;

  final List<Map<String, dynamic>> iconOptions = [
    {'label': 'Geral', 'icon': Icons.shield_outlined},
    {'label': 'Restrito', 'icon': Icons.lock_outline},
    {'label': 'Admin', 'icon': Icons.admin_panel_settings_outlined},
    {'label': 'Visitante', 'icon': Icons.person_outline},
    {'label': 'Bloqueado', 'icon': Icons.block_outlined},
  ];

  final List<Map<String, dynamic>> colorOptions = [
    {'label': 'Azul', 'color': Colors.blue.shade700},
    {'label': 'Laranja', 'color': Colors.orange.shade700},
    {'label': 'Verde', 'color': Colors.green.shade700},
    {'label': 'Roxo', 'color': Colors.purple.shade700},
    {'label': 'Vermelho', 'color': Colors.red.shade700},
  ];
    @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (waitingForCard) {
      return AlertDialog(
        title: const Text('Adicionar novo cartão RFID'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              SizedBox(
              height: 120,
              child: Lottie.asset('assets/animations/scanner_card.json'),
            ),
            const SizedBox(height: 16),
            const Text('Aguardando leitura do cartão...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() => waitingForCard = false),
            child: const Text('proceguir assim mesmo?'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    }
    return AlertDialog(
      title: const Text('Adicionar novo cartão RFID'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o ID' : null,
                onSaved: (value) => id = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'CardId'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o CardId' : null,
                onSaved: (value) => cardId = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nível de acesso'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe o nível de acesso'
                    : null,
                onSaved: (value) => accessLevel = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Última leitura'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a última leitura'
                    : null,
                onSaved: (value) => lastSeen = value!,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<IconData>(
                value: icon,
                decoration: const InputDecoration(labelText: 'Ícone'),
                items: iconOptions
                    .map<DropdownMenuItem<IconData>>(
                        (opt) => DropdownMenuItem<IconData>(
                              value: opt['icon'] as IconData,
                              child: Row(
                                children: [
                                  Icon(opt['icon'] as IconData),
                                  const SizedBox(width: 8),
                                  Text(opt['label'])
                                ],
                              ),
                            ))
                    .toList(),
                onChanged: (value) => setState(() => icon = value!),
              ),
              DropdownButtonFormField<Color>(
                value: color,
                decoration: const InputDecoration(labelText: 'Cor'),
                items: colorOptions
                    .map<DropdownMenuItem<Color>>(
                        (opt) => DropdownMenuItem<Color>(
                              value: opt['color'] as Color,
                              child: Row(
                                children: [
                                  Container(
                                      width: 18,
                                      height: 18,
                                      color: opt['color'] as Color,
                                      margin: const EdgeInsets.only(right: 8)),
                                  Text(opt['label'])
                                ],
                              ),
                            ))
                    .toList(),
                onChanged: (value) => setState(() => color = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newCard = RfidCardInfo(
                id: id,
                cardId: cardId,
                accessLevel: accessLevel,
                lastSeen: lastSeen,
                icon: icon,
                color: color,
              );
              widget.cardsProvider.addCard(newCard);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
