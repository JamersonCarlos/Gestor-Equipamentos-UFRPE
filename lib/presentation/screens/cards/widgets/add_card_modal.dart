import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/core/constants/access_level.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'rfid_card_item.dart';

class AddCardModal extends StatefulWidget {
  final CardsProvider cardsProvider;
  const AddCardModal({super.key, required this.cardsProvider});

  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  final _formKey = GlobalKey<FormState>();
  String cardId = '';
  String label = '';
  Funcionario funcionario = Funcionario(id: 0, nome: '', email: '', codigo_cartao: '', curso_id: 0, cargo_id: 0);
  AccessLevel accessLevel = AccessLevel.admin;
  bool waitingForCard = true;
  WebSocketChannel? _channel;
  List<Funcionario> funcionarios = [];

  @override
  void initState() {
    super.initState();
    _channel =
        WebSocketChannel.connect(Uri.parse('ws://localhost:8000/add'));
    _channel!.sink.add(json.encode({'event': 'addCard'}));
    _channel!.stream.listen((message) {
      try {
        final data = json.decode(message);
        if (data is Map &&
            data['event'] == 'addCard' &&
            data['id'] != null) {
          setState(() {
            cardId = data['id'];
            waitingForCard = false;
          });
        }
      } catch (_) {}
    });
     WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.cardsProvider.getFuncionariosSemCartao().then((data) {
        setState(() {
          funcionarios = data;
        });
      });
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    }
    if (funcionarios.isEmpty) {
      return AlertDialog(
        title: const Text('Nenhum funcionário encontrado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 300,
              child: Lottie.asset('assets/animations/not-found.json'),
            ),
          ],
        ),
        actions: [
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
                decoration: const InputDecoration(labelText: 'CardId'),
                initialValue: cardId,
                enabled: false,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                initialValue: '',
                enabled: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
                onSaved: (value) => label = value!,
              ),
              DropdownButtonFormField<Funcionario>(
                value: funcionarios.first,
                decoration: const InputDecoration(labelText: 'Funcionário'),
                items: funcionarios.map<DropdownMenuItem<Funcionario>>((opt) => DropdownMenuItem<Funcionario>(
                  value: opt,
                  child: Text(opt.nome),
                )).toList(),
                onChanged: (value) => setState(() => funcionario = value!),
              ),
              DropdownButtonFormField<AccessLevel>(
                value: AccessLevel.values.firstWhere(
                  (e) => e.value == accessLevel,
                  orElse: () => AccessLevel.admin,
                ),
                decoration: const InputDecoration(labelText: 'Nível de acesso'),
                items: AccessLevel.values
                    .map<DropdownMenuItem<AccessLevel>>(
                        (opt) => DropdownMenuItem<AccessLevel>(
                              value: opt,
                              child: Row(
                                children: [
                                  Icon(opt.icon),
                                  const SizedBox(width: 8),
                                  Text(opt.label)
                                ],
                              ),
                            ))
                    .toList(),
                onChanged: (value) => setState(() => accessLevel = value!),
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
                id: '',
                cardId: cardId,
                accessLevel: accessLevel,
                lastSeen: '',
                label: accessLevel.label,
                funcionarioId: funcionario.id,
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
