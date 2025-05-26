import 'package:flutter/material.dart';
import '../../domain/entities/projetor.dart';
import '../../core/theme/app_colors.dart';
import '../../services/projetorService.dart';

class ProjetoresList extends StatefulWidget {
  final Function? onListUpdated; // Callback opcional para notificar atualizações

  const ProjetoresList({Key? key, this.onListUpdated}) : super(key: key);

  @override
  State<ProjetoresList> createState() => _ProjetoresListState();
}

class _ProjetoresListState extends State<ProjetoresList> {
  final _projetorService = ProjetorService();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _projetorService.getProjetores(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text('Erro: ${asyncSnapshot.error}')); 
        } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum projetor cadastrado.'));
        }
        
        List<Projetor> _projetores = asyncSnapshot.data!;
        return ListView.builder(
              itemCount: _projetores.length,
              itemBuilder: (context, index) {
                final projetor = _projetores[index];
                return Card(
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
                                showDialog(
                                  context: context,
                                  builder: (context) { 
                                    TextEditingController codigoTagController = TextEditingController(text: projetor.codigo_tag);
                                    return AlertDialog(
                                      title: const Center(child: Text('Código da Tag', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
                                      content: TextFormField(
                                        controller: codigoTagController,
                                        decoration: InputDecoration(
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.copy),
                                                onPressed: () {
                                                  // Implementar a cópia do código
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('Código copiado!'),
                                                      backgroundColor: AppColors.primary,
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
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Código copiado!'),
                                                backgroundColor: AppColors.primary,
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
      }
    );
  }
}