import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/defeito.dart';
import 'package:gestor_uso_projetores_ufrpe/services/defeito_service.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/inputDecoration.dart';
import '../../domain/entities/projetor.dart';
import '../../core/theme/app_colors.dart';
import '../../services/projetorService.dart';

class ProjetoresList extends StatefulWidget {
  final VoidCallback onListUpdated;

  const ProjetoresList({Key? key, required this.onListUpdated})
      : super(key: key);

  @override
  State<ProjetoresList> createState() => _ProjetoresListState();
}

class _ProjetoresListState extends State<ProjetoresList> {
  final _projetorService = ProjetorService();
  final _defeitoService = DefeitoService();

  void atualizarProjetores() {
    setState(() {});
    _futureProjetores = fetchProjetores();
  }

  Future<void> _deleteProjetor(Projetor projetor) async {
    try {
      await _projetorService.deleteProjetor(projetor.codigo_tombamento);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Projetor removido com sucesso!'),
          backgroundColor: AppColors.primary,
        ),
      );
      setState(() {
        widget.onListUpdated.call();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover projetor: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<List<Projetor>>? _futureProjetores;
  List<Projetor> _todosProjetores = [];
  List<Projetor> _projetoresFiltrados = [];
  bool atualizarReparo = false;

  final TextEditingController _codigoTombController = TextEditingController();

  String? _selectedMarca;

  // Listas de opções para os dropdown
  final List<String> _marcas = [
    'Epson',
    'BenQ',
    'ViewSonic',
    'Optoma',
    'Sony',
    'LG',
    'Acer',
  ];

  Future<List<Projetor>> fetchProjetores() async {
    try {
      _todosProjetores = await _projetorService.getProjetores();
      _projetoresFiltrados = _todosProjetores;
      return _todosProjetores;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar projetores: $e'),
          backgroundColor: AppColors.error,
        ),
      );
      return [];
    }
  }

  void _filterProjetores(String? selectedMarca) {
    setState(() {
      _projetoresFiltrados = _todosProjetores.where((projetor) {
        final codigoTombamentoMatch = _codigoTombController.text.isEmpty ||
            projetor.codigo_tombamento
                .toLowerCase()
                .contains(_codigoTombController.text.toLowerCase());
        final marcaMatch =
            selectedMarca == null || projetor.marca == selectedMarca;
        return codigoTombamentoMatch && marcaMatch;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureProjetores = fetchProjetores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            spacing: 10,
            children: [
              const Text(
                'Filtros de Projetores',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Expanded(
                  child: Divider(
                color: AppColors.primary,
                thickness: 2,
              )),
              Text(
                '${_projetoresFiltrados.length}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              SizedBox(
                width: 400,
                child: TextFormField(
                  controller: _codigoTombController,
                  decoration: buildInputDecoration(
                    'Código de Tombamento',
                    'Digite o código de tombamento do projetor',
                    const Icon(Icons.search,
                        color: AppColors.primary, size: 24),
                  ),
                  onChanged: (value) => _filterProjetores(_selectedMarca),
                ),
              ),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: _selectedMarca,
                  decoration: buildInputDecoration(
                    'Marca',
                    'Selecione a marca do projetor',
                    null,
                  ),
                  items: _marcas.map((String marca) {
                    return DropdownMenuItem<String>(
                      value: marca,
                      child: Text(marca),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMarca = newValue;
                      _filterProjetores(newValue);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione a marca';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: FutureBuilder(
              future: _futureProjetores,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return const Center(
                      child: Text('Erro: Sem conexão com o servidor'));
                } else if (!asyncSnapshot.hasData ||
                    asyncSnapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum projetor cadastrado.'));
                }

                return ListView.builder(
                  itemCount: _projetoresFiltrados.length,
                  itemBuilder: (context, index) {
                    final projetor = _projetoresFiltrados[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: projetor.defeito != null
                              ? AppColors.error
                              : AppColors.background,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  projetor.codigo_tombamento,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Modelo: ${projetor.modelo}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Marca: ${projetor.marca}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Cor: ${projetor.cor}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    mostrarDialogoDefeito(
                                      onDefeitoUpdated: atualizarProjetores,
                                      context: context,
                                      projetor: projetor,
                                      defeitoService: _defeitoService,
                                    );
                                  },
                                  icon: const Icon(Icons.warning),
                                  label: const Text('Defeito'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.warning,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Center(
                                              child: Text(
                                            'Código da Tag',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                          content: TextFormField(
                                            controller: TextEditingController(
                                                text: projetor.codigo_tag),
                                            decoration: InputDecoration(
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon:
                                                        const Icon(Icons.copy),
                                                    onPressed: () {
                                                      // Implementar a cópia do código
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Código copiado!'),
                                                          backgroundColor:
                                                              AppColors.primary,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Fechar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Código copiado!'),
                                                    backgroundColor:
                                                        AppColors.primary,
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Salvar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.qr_code),
                                  label: const Text('Código Tag'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Remover'),
                                  onPressed: () => _deleteProjetor(projetor),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}

void mostrarDialogoDefeito({
  required BuildContext context,
  required Projetor projetor,
  required DefeitoService defeitoService,
  required VoidCallback onDefeitoUpdated,
}) {
  final TextEditingController descricaoController = TextEditingController(
    text: projetor.defeito?.descricao ?? '',
  );

  bool atualizarReparo = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.warning, color: AppColors.error),
                SizedBox(width: 10),
                Text(
                  'Registrar Defeito',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            content: TextFormField(
              controller: descricaoController,
              maxLines: 5,
              minLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: buildInputDecoration(
                'Descrição do defeito',
                'Descreva o defeito do projetor',
                null,
              ),
              onChanged: (value) {
                setState(() {
                  atualizarReparo = true;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              projetor.defeito == null
                  ? TextButton(
                      onPressed: () async {
                        try {
                          await defeitoService.createDefeito(
                            Defeito(
                              descricao: descricaoController.text,
                              equipamentoCodigo: projetor.codigo_tombamento,
                              id: 0, // O ID será gerado pelo servidor
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Defeito registrado!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                          onDefeitoUpdated();
                          Navigator.of(context).pop();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao registrar defeito: $e'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      },
                      child: const Text('Registrar'),
                    )
                  : TextButton(
                      onPressed: () async {
                        if (atualizarReparo) {
                          try {
                            await defeitoService.updateDefeito(
                              Defeito(
                                id: projetor.defeito!.id,
                                descricao: descricaoController.text,
                                equipamentoCodigo: projetor.codigo_tombamento,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Alterações salvas com sucesso!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            onDefeitoUpdated();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao atualizar defeito: $e'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }
                        } else {
                          try {
                            await defeitoService
                                .removerDefeito(projetor.defeito!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Defeito removido com Sucesso!'),
                                backgroundColor: AppColors.warning,
                              ),
                            );
                            onDefeitoUpdated();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao remover defeito: $e'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        atualizarReparo
                            ? 'Salvar Alterações'
                            : 'Remover Defeito',
                      ),
                    ),
            ],
          );
        },
      );
    },
  );
}
