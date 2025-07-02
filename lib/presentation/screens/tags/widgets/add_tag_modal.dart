import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/core/constants/access_level.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/rfid_tag.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/projector_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/tags_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class AddTagModal extends StatefulWidget {
  final TagsProvider tagsProvider;
  final ProjectorProvider projectorProvider;
  const AddTagModal(
      {super.key, required this.tagsProvider, required this.projectorProvider});

  @override
  State<AddTagModal> createState() => _AddTagModalState();
}

class _AddTagModalState extends State<AddTagModal> {
  final _formKey = GlobalKey<FormState>();
  String tagId = '';
  String label = '';
  String equipamentoCodigo = '';
  bool waitingForCard = true;
  WebSocketChannel? _channel;
  List<Map<String, dynamic>> equipamentos = [];

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000/add'));
    _channel!.sink.add(json.encode({'event': 'addUid'}));
    _channel!.stream.listen((message) {
      try {
        final data = json.decode(message);
        if (data is Map && data['event'] == 'addUid' && data['id'] != null) {
          setState(() {
            tagId = data['id'];
            waitingForCard = false;
          });
        }
      } catch (_) {}
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.projectorProvider.getProjectors().then((projectors) {
        setState(() {
          equipamentos = projectors;
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
        title: const Text('Adicionar nova tag RFID'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Lottie.asset('assets/animations/scanner_card.json'),
            ),
            const SizedBox(height: 16),
            const Text('Aguardando leitura da tag...'),
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

    if (equipamentos.isEmpty) {
      return AlertDialog(
        title: const Text('Nenhum equipamento encontrado'),
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
      title: const Text('Adicionar nova tag  RFID'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'TagId'),
                initialValue: tagId,
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
              DropdownButtonFormField<String>(
                value: equipamentos.first['codigo_tombamento'],
                decoration: const InputDecoration(labelText: 'Equipamento'),
                items: equipamentos
                    .map<DropdownMenuItem<String>>(
                        (opt) => DropdownMenuItem<String>(
                              value: opt['codigo_tombamento'],
                              child: Row(
                                children: [
                                  const Icon(Icons.device_hub),
                                  const SizedBox(width: 8),
                                  Text(opt['modelo'])
                                ],
                              ),
                            ))
                    .toList(),
                onChanged: (key) => setState(() => equipamentoCodigo = key!),
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
              final newTag = RfidTag(
                nome: label,
                rfid: tagId,
                nivelAcesso: 1,
                status: 'ATIVO',
                ultimaLeitura: null,
                equipamentoCodigo: equipamentoCodigo,
              );
              widget.tagsProvider.addTag(newTag);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
