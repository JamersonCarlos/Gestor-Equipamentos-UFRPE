import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cargo.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cursos.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/funcionario.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cards_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cargos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/cursos_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/funcionarios_list.dart';
import 'package:gestor_uso_projetores_ufrpe/utils/inputDecoration.dart';
import 'package:provider/provider.dart';
import '../../services/funcionarioService.dart';

import '../../core/theme/app_colors.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _codigoCartaoController = TextEditingController();
  final _cursoIdController = TextEditingController();
  final _cargoIdController = TextEditingController();
  final _funcionarioService = FuncionarioService();
  // String? _selectedCartao;
  String? _selectedCurso;
  String? _selectedCargo;
  int _listKey = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final funcionario = Funcionario(
          id: 0,
          nome: _nomeController.text,
          email: '${_emailController.text}@ufrpe.br',
          codigo_cartao: _codigoCartaoController.text,
          curso_id: int.parse(_cursoIdController.text),
          cargo_id: int.parse(_cargoIdController.text),
        );
        await _funcionarioService.createFuncionario(funcionario);
        await _funcionarioService.getFuncionarios();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Professor cadastrado com sucesso!'),
            backgroundColor: AppColors.primary,
          ),
        );

        setState(() {
          _nomeController.text = '';
          _emailController.text = '';
          _codigoCartaoController.text = '';
          _cursoIdController.text = '';
          _cargoIdController.text = '';
          _selectedCurso = null;
          _selectedCargo = null;
          _listKey++;
        });
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
    final cargosProvider = Provider.of<CargosProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
            ),
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1600),
                    padding:
                        const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 80,
                              child: TextFormField(
                                controller: _nomeController,
                                decoration: buildInputDecoration(
                                    'Nome', 'Digite o nome do professor', null),
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
                              height: 80, // Altura fixa para todos os campos
                              child: TextFormField(
                                controller: _emailController,
                                decoration: buildInputDecoration('Email',
                                        'Digite o email do professor', null)
                                    .copyWith(
                                  suffixText: '@ufrpe.br',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9._%-]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, digite o email';
                                  }
                                  // Regex para validar apenas o usuário do email (sem domínio)
                                  final userRegex =
                                      RegExp(r'^[a-zA-Z0-9._%-]+$');
                                  if (!userRegex.hasMatch(value.trim())) {
                                    return 'Formato de email inválido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Expanded(
                          //   child: SizedBox(
                          //     height: 80,
                          //     child: FutureBuilder<List<RfidCardInfo>>(
                          //       future: cardsProvider.getCardNotUsed(),
                          //       builder: (context, snapshot) {
                          //         return DropdownButtonFormField<String>(
                          //           isExpanded: true,
                          //           value: _selectedCartao,
                          //           decoration: buildInputDecoration(
                          //               'Cartão',
                          //               'Selecione o cartão do professor',
                          //               null),
                          //           items: snapshot.hasData
                          //               ? snapshot.data!
                          //                   .map((RfidCardInfo card) {
                          //                   return DropdownMenuItem<String>(
                          //                     value: card.cardId,
                          //                     child: Text(card.cardId),
                          //                   );
                          //                 }).toList()
                          //               : [],
                          //           onChanged: (String? newValue) {
                          //             setState(() {
                          //               _selectedCartao = newValue;
                          //               _codigoCartaoController.text =
                          //                   newValue ?? '';
                          //             });
                          //           },
                          //           validator: (value) {
                          //             if (value == null || value.isEmpty) {
                          //               return 'Por favor, selecione um cartão';
                          //             }
                          //             return null;
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
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
                                    decoration: buildInputDecoration(
                                      'Curso',
                                      'Selecione o curso do professor',
                                      null,
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
                                        _cursoIdController.text =
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
                            child: SizedBox(
                              height: 80,
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
                                        _cargoIdController.text =
                                            newValue ?? '';
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
              child: FuncionariosList(
            key: ValueKey(_listKey), // força rebuild
            onListUpdated: () {
              setState(() {
                _listKey++;
              });
            },
          )),
        ],
      ),
    );
  }
}
