import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cursos.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provier.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cursos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/funcionarios_list.dart';
import 'package:provider/provider.dart';
import '../../services/funcionarioService.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/cards/widgets/rfid_card_item.dart';

import '../../core/theme/app_colors.dart';
import 'package:brasil_fields/brasil_fields.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _codigoCartaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _cursoIdController = TextEditingController();
  final _funcionarioService = FuncionarioService();
  String? _selectedCartao;
  String? _selectedCurso;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final funcionario = Funcionario(
          cpf: _cpfController.text,
          codigo_cartao: _codigoCartaoController.text,
          nome: _nomeController.text,
          curso_id: int.parse(_cursoIdController.text),
        );
        await _funcionarioService.createFuncionario(funcionario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Professor cadastrado com sucesso!'),
            backgroundColor: AppColors.primary,
          ),
        );
        _formKey.currentState!.reset();
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CPF já cadastrado'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsProvider = Provider.of<CardsProvider>(context);
    final cursosProvider = Provider.of<CursosProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: Center(
              child: Card(
                elevation: 4,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1600),
                  padding: const EdgeInsets.only(
                      top: 24, bottom: 10, left: 24, right: 24),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 80, // Altura fixa para todos os campos
                            child: TextFormField(
                              controller: _cpfController,
                              decoration: _buildInputDecoration(
                                'CPF',
                                'Digite o CPF do professor',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CpfInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite o CPF';
                                }
                                value = value.replaceAll(RegExp(r'[^0-9]'), '');
                                if (value.length != 11) {
                                  return 'O CPF deve conter 11 dígitos';
                                }
                                if (!UtilBrasilFields.isCPFValido(value)) {
                                  return 'CPF inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: FutureBuilder<List<RfidCardInfo>>(
                              future: cardsProvider.rfidCards(),
                              builder: (context, snapshot) {
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: _selectedCartao,
                                  decoration: _buildInputDecoration(
                                    'Cartão',
                                    'Selecione o cartão do professor',
                                  ),
                                  items: snapshot.hasData
                                      ? snapshot.data!.map((RfidCardInfo card) {
                                          return DropdownMenuItem<String>(
                                            value: card.cardId,
                                            child: Text(card.cardId),
                                          );
                                        }).toList()
                                      : [],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCartao = newValue;
                                      _codigoCartaoController.text =
                                          newValue ?? '';
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
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 80,
                            child: TextFormField(
                              controller: _nomeController,
                              decoration: _buildInputDecoration(
                                'Nome',
                                'Digite o nome do professor',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite o nome';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: FutureBuilder<List<Curso>>(
                              future: cursosProvider.fetchCursos(),
                              builder: (context, snapshot) {
                                return DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: _selectedCurso,
                                  decoration: _buildInputDecoration(
                                    'Curso',
                                    'Selecione o curso do professor',
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
                                      _selectedCurso = newValue;
                                      _cursoIdController.text = newValue ?? '';
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
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  minimumSize: const Size(
                                      120, 56), // Altura fixa do botão
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cadastrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: FuncionariosList(
            onListUpdated: () {
              setState(() {});
            },
          ))
        ],
      ),
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
