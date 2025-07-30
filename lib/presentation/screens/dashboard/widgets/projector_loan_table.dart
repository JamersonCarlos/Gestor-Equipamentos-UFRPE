import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/projector_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: (currentPage > 1 && !isLoading) ? onPrevious : null,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Página $currentPage'),
        ),
        IconButton(
          onPressed: (currentPage < totalPages && !isLoading) ? onNext : null,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}

class ProjectorLoanTable extends StatefulWidget {
  const ProjectorLoanTable({super.key});

  @override
  State<ProjectorLoanTable> createState() => _ProjectorLoanTableState();
}

class _ProjectorLoanTableState extends State<ProjectorLoanTable>
    with AutomaticKeepAliveClientMixin {
  bool _isUpdating = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  void _handleWebSocketUpdate() {
    if (!_isUpdating && mounted) {
      _isUpdating = true;
      // Usar Future.delayed para dar tempo do scroll se estabilizar
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          // Usar o método refreshUsos que força a atualização
          final provider = context.read<ProjectorProvider>();
          provider.refreshUsos();
          _isUpdating = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Necessário para o AutomaticKeepAliveClientMixin

    final provider = context.watch<ProjectorProvider>();
    final entries = provider.entries;

    if (provider.isLoading && entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return const Center(
        child: Text(
          'Erro: Sem conexão com o servidor',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historico de locação',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Autor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Funcionario',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Objeto Alocado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'CHECK-OUT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'CHECK-IN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),
            const Divider(height: 0),
            ...entries.map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    // Avatar, nome e email
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              e['avatar'].toString(),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['name'].toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                e['email'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Função e subtítulo
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['function'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            e['subtitle'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ID do projetor (centralizado e largura fixa)
                    Expanded(
                      flex: 6,
                      child: Text(
                        e['id'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Check-Out
                    Expanded(
                      flex: 6,
                      child: Text(
                        e['out'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Check-In
                    Expanded(
                      flex: 6,
                      child: Text(
                        e['in'].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Status badge
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: (e['statusColor'] as Color).withOpacity(
                                0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              e['status'].toString(),
                              style: TextStyle(
                                color: e['statusColor'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botão More
                    SizedBox(
                      width: 60,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('More'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PaginationControls(
              currentPage: provider.currentPage,
              totalPages: provider.totalPages,
              isLoading: provider.isLoading,
              onPrevious: provider.currentPage > 1
                  ? () {
                      context.read<ProjectorProvider>().getUsos(
                            page: provider.currentPage - 1,
                            limit: 10,
                          );
                    }
                  : null,
              onNext: provider.currentPage < provider.totalPages
                  ? () {
                      context.read<ProjectorProvider>().getUsos(
                            page: provider.currentPage + 1,
                            limit: 10,
                          );
                    }
                  : null,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
