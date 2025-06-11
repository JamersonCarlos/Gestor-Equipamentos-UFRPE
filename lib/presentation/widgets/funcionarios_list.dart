import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateFuncionario(
      Funcionario funcionario, String novoCodigoCartao) async {
    try {
      final funcionarioAtualizado = Funcionario(
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
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover professor: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  final List<String> filters = [
    'Ordem Alfabética A - Z',
    'Ordem Alfabética Z - A',
  ];

  List<Funcionario>? _funcionarios; 
  List<Funcionario> filteredFuncionarios = [];
  String selectedFilter = 'Ordem Alfabética A - Z';

  final TextEditingController _nomeController = TextEditingController();


  void _filtrarFuncionarios() {
    String filtro = _nomeController.text.toLowerCase();

    if(_funcionarios != null) { 
      setState(() {
        filteredFuncionarios = _funcionarios!.where((func) {
          return func.nome.toLowerCase().contains(filtro);
        }).toList();
      });
    }
   }


  @override
  Widget build(BuildContext context) {
    CardsProvider cardsProvider = Provider.of<CardsProvider>(context);
    return Column(
      children: [
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
                    decoration: _buildInputDecoration(
                      'Nome',
                      'Digite o nome do professor',
                    ).copyWith(
                      suffixIcon: const Icon(Icons.search, color: AppColors.primary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite o nome';
                      }
                      return null;
                    },
                    onChanged: (value) => _filtrarFuncionarios(),
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
                    setState(() {
                      selectedFilter = value!;
                    });
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
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
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
        Expanded(
          child: FutureBuilder(
              future: _funcionarioService.getFuncionarios(),
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

                setState(() {
                  _funcionarios = asyncSnapshot.data!;
                  filteredFuncionarios = _funcionarios!;
                });
                return ListView.builder(
                  itemCount: filteredFuncionarios.length,
                  itemBuilder: (context, index) {
                    final funcionario = filteredFuncionarios[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                                Text(
                                  'Código do cartão: ${funcionario.codigo_cartao}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.credit_card),
                                  label: const Text('Código Cartão'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController
                                            codigoCartaoController =
                                            TextEditingController(
                                                text:
                                                    funcionario.codigo_cartao);

                                        return AlertDialog(
                                          title: const Center(
                                              child: Text(
                                            'Código do Cartão',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FutureBuilder<RfidCardInfo?>(
                                                future: cardsProvider.findCard(
                                                    funcionario.codigo_cartao),
                                                builder: (context, snapshot) {
                                                  RfidCardInfo? card;
                                                  try {
                                                    card = snapshot.data;
                                                  } catch (_) {
                                                    card = null;
                                                  }
                                                  if (card == null) {
                                                    return const Text(
                                                        'Cartão não encontrado');
                                                  }
                                                  return SizedBox(
                                                    width: 400,
                                                    height: 220,
                                                    child: RfidCardItem(
                                                        cardInfo: card),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Fechar"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _updateFuncionario(
                                                    funcionario,
                                                    codigoCartaoController
                                                        .text);
                                              },
                                              child: const Text(
                                                  'Salvar Alterações'),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                        color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 8),
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
InputDecoration _buildInputDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: AppColors.surface,
    labelStyle: const TextStyle(color: AppColors.primary),
    hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.6)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );
}
