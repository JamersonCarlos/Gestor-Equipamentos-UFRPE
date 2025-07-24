import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cargo.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cursos.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cargos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cursos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/inputDecoration.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/funcionario.dart';
import '../../core/theme/app_colors.dart';

import '../../services/funcionarioService.dart';

class FuncionariosList extends StatefulWidget {
  final Function?
      onListUpdated; // Callback opcional para notificar atualizações

  const FuncionariosList({Key? key, this.onListUpdated}) : super(key: key);

  @override
  State<FuncionariosList> createState() => _FuncionariosListState();
}

class _FuncionariosListState extends State<FuncionariosList> {
  final _funcionarioService = FuncionarioService();
  bool copiado = false;

  Future<void> _updateFuncionario(
      Funcionario funcionario, String novoCodigoCartao) async {
    try {
      final funcionarioAtualizado = Funcionario(
        id: funcionario.id,
        email: funcionario.email,
        codigo_cartao: novoCodigoCartao,
        curso_id: funcionario.curso_id,
        cargo_id: funcionario.cargo_id,
      );

      await _funcionarioService.updateFuncionario(funcionarioAtualizado);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código do cartão atualizado com sucesso!'),
          backgroundColor: AppColors.primary,
        ),
      );

      setState(() {});
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar código do cartão: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteFuncionario(Funcionario funcionario) async {
    try {
      await _funcionarioService.deleteFuncionario(funcionario.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Professor removido com sucesso!'),
          backgroundColor: AppColors.primary,
        ),
      );
      setState(() {
        widget.onListUpdated?.call();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover professor: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<List<Funcionario>> _fetchFuncionarios() async {
    try {
      final funcionarios = await _funcionarioService.getFuncionarios();
      _todosFuncionarios = funcionarios;
      _funcionariosFiltrados = funcionarios;
      return funcionarios;
    } catch (e) {
      throw Exception('Erro ao buscar professores: $e');
    }
  }

  void _filtrarFuncionarios(
      String selectedFilter, String selectedCurso, String? selectedCargo) {
    String filtro = _nomeController.text.toLowerCase();

    if (selectedFilter == 'Ordem Alfabética A - Z') {
      setState(() {
        _funcionariosFiltrados = _todosFuncionarios
            .where((f) => f.nome.toLowerCase().contains(filtro))
            .toList()
          ..sort((a, b) => a.nome.compareTo(b.nome));
      });
    } else if (selectedFilter == 'Ordem Alfabética Z - A') {
      setState(() {
        _funcionariosFiltrados = _todosFuncionarios
            .where((f) => f.nome.toLowerCase().contains(filtro))
            .toList()
          ..sort((a, b) => b.nome.compareTo(a.nome));
      });
    }

    if (filtro.isNotEmpty) {
      setState(() {
        _funcionariosFiltrados = _todosFuncionarios
            .where((f) => f.nome.toLowerCase().contains(filtro))
            .toList();
      });
    }
    if (selectedCurso.isNotEmpty) {
      setState(() {
        _funcionariosFiltrados = _funcionariosFiltrados
            .where((f) => f.curso_id.toString() == selectedCurso)
            .toList();
      });
    }
    if (selectedCargo != null && selectedCargo.isNotEmpty) {
      setState(() {
        _funcionariosFiltrados = _funcionariosFiltrados
            .where((f) => f.cargo_id.toString() == selectedCargo)
            .toList();
      });
    }
  }

  final List<String> filters = [
    'Ordem Alfabética A - Z',
    'Ordem Alfabética Z - A',
  ];

  Future<List<Funcionario>>? _futureFuncionarios;
  List<Funcionario> _todosFuncionarios = [];
  List<Funcionario> _funcionariosFiltrados = [];

  String selectedFilter = 'Ordem Alfabética A - Z';
  String? selectedCurso;
  String? _selectedCargo;

  final TextEditingController _nomeController = TextEditingController();

  void copiarCodigo(String codigoCartao) {
    Clipboard.setData(ClipboardData(text: codigoCartao));
    setState(() => copiado = true);

    // Oculta o texto após 2 segundos
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) setState(() => copiado = false);
    });
  }

  @override
  void initState() {
    super.initState();
    _futureFuncionarios = _fetchFuncionarios();
  }

  @override
  Widget build(BuildContext context) {
    final cursosProvider = Provider.of<CursosProvider>(context);
    final cargosProvider = Provider.of<CargosProvider>(context);
    CardsProvider cardsProvider = Provider.of<CardsProvider>(context);
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            spacing: 10,
            children: [
              const Text(
                'Filtros de Professores',
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
                '${_funcionariosFiltrados.length}',
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
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: TextFormField(
                  controller: _nomeController,
                  decoration: buildInputDecoration(
                    'Nome',
                    'Digite o nome do professor',
                    const Icon(Icons.search,
                        color: AppColors.primary, size: 24),
                  ),
                  onChanged: (value) => _filtrarFuncionarios(
                      selectedFilter, selectedCurso ?? '', _selectedCargo),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: 200,
                      child: FutureBuilder<List<Curso>>(
                        future: cursosProvider.fetchCursos(),
                        builder: (context, snapshot) {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedCurso,
                            decoration: buildInputDecoration(
                              'Curso',
                              'Selecione o curso do professor',
                              null,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.primary,
                            ),
                            items: snapshot.hasData
                                ? snapshot.data!.map((Curso curso) {
                                    return DropdownMenuItem<String>(
                                      value: curso.curso_id.toString(),
                                      child: Text(curso.nome),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCurso = newValue;

                                _filtrarFuncionarios(selectedFilter,
                                    selectedCurso ?? '', _selectedCargo);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecione um cartão';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: FutureBuilder<List<Cargo>>(
                        future: cargosProvider.fetchCargos(),
                        builder: (context, snapshot) {
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedCargo,
                            decoration: buildInputDecoration('Cargo',
                                'Selecione o cargo do professor', null),
                            items: snapshot.hasData
                                ? snapshot.data!.map((Cargo cargo) {
                                    return DropdownMenuItem<String>(
                                      value: cargo.id.toString(),
                                      child: Text(cargo.nome),
                                    );
                                  }).toList()
                                : [],
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCargo = newValue;
                                _filtrarFuncionarios(selectedFilter,
                                    selectedCurso ?? '', _selectedCargo);
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, selecione um cargo';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: filters
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedFilter,
                        onChanged: (String? value) {
                          if (value == null) return;
                          setState(() {
                            selectedFilter = value;
                          });
                          _filtrarFuncionarios(
                              value, selectedCurso ?? '', _selectedCargo);
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 200,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.primary,
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: AppColors.surface,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: AppColors.textLight,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder(
              future: _futureFuncionarios,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Erro: ${asyncSnapshot.error}'));
                } else if (!asyncSnapshot.hasData ||
                    asyncSnapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhum professor cadastrado.'));
                }

                return ListView.builder(
                  itemCount: _funcionariosFiltrados.length,
                  itemBuilder: (context, index) {
                    final funcionario = _funcionariosFiltrados[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
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
                                  funcionario.email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Código do cartão: ${funcionario.codigo_cartao}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy,
                                          size: 18, color: Colors.blueAccent),
                                      tooltip: 'Copiar código',
                                      onPressed: () => copiarCodigo(
                                          funcionario.codigo_cartao),
                                    ),
                                    if (copiado)
                                      Text(
                                        'Copiado!',
                                        style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 12),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text('Remover'),
                                  onPressed: () =>
                                      _deleteFuncionario(funcionario),
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
