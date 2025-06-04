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

  @override
  Widget build(BuildContext context) {
    CardsProvider cardsProvider = Provider.of<CardsProvider>(context);
    return FutureBuilder(
        future: _funcionarioService.getFuncionarios(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return Center(child: Text('Erro: ${asyncSnapshot.error}'));
          } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum professor cadastrado.'));
          }

          List<Funcionario> _funcionarios = asyncSnapshot.data!;
          return ListView.builder(
            itemCount: _funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = _funcionarios[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                  TextEditingController codigoCartaoController =
                                      TextEditingController(
                                          text: funcionario.codigo_cartao);

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
                                        FutureBuilder<List<RfidCardInfo>>(
                                          future: cardsProvider.rfidCards(),
                                          builder: (context, snapshot) {
                                            RfidCardInfo? card;
                                            try {
                                              card = snapshot.data!.firstWhere(
                                                (card) =>
                                                    card.cardId ==
                                                    funcionario.codigo_cartao,
                                              );
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
                                          _updateFuncionario(funcionario,
                                              codigoCartaoController.text);
                                        },
                                        child: const Text('Salvar Alterações'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Remover'),
                            onPressed: () => _deleteFuncionario(funcionario),
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
        });
  }
}
