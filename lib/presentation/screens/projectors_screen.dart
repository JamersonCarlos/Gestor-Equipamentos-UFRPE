import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/projetores_list.dart';
import '../../domain/entities/projetor.dart';
import '../../services/projetorService.dart';
import '../../core/theme/app_colors.dart';

class ProjectorsScreen extends StatefulWidget {
  const ProjectorsScreen({super.key});

  @override
  State<ProjectorsScreen> createState() => _ProjectorsScreenState();
}

class _ProjectorsScreenState extends State<ProjectorsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projetorService = ProjetorService();


  // Controladores para os campos do formulário
  final _nomeController = TextEditingController();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _corController = TextEditingController();

  // Adicione o novo controller
  final _tombamentoController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final projetor = Projetor(
          codigo_tag: "",
          modelo: _modeloController.text,
          marca: _marcaController.text,
          cor: _corController.text,
          codigo_tombamento: _tombamentoController.text, // Adicione o novo campo
        );

        await _projetorService.addProjetor(projetor);
        
        _nomeController.clear();
        _modeloController.clear();
        _marcaController.clear();
        _corController.clear();
        _tombamentoController.clear(); // Limpe o novo campo
        setState(() {
          
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projetor adicionado com sucesso!'),
            backgroundColor: AppColors.primary,
          ),
        );

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código de Tombamento já está cadastrado!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
    }

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

  // Valor selecionado para o dropdown de cor
  String? _selectedCor;

  // Lista de cores para o dropdown
  final List<String> _cores = [
    'Preto',
    'Branco',
  ];

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.only(top: 24, bottom: 10, left: 24, right: 24),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: TextFormField(
                              controller: _tombamentoController,
                              decoration: _buildInputDecoration(
                                'Código de Tombamento',
                                'Digite o código de tombamento',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite a marca';
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
                            child: DropdownButtonFormField<String>(
                              value: _selectedMarca,
                              decoration: _buildInputDecoration(
                                'Marca',
                                'Selecione a marca do projetor',
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
                                  _marcaController.text = newValue ?? '';
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
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: TextFormField(
                              controller: _modeloController,
                              decoration: _buildInputDecoration(
                                'Modelo',
                                'Digite o modelo do projetor',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite a marca';
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
                            child: DropdownButtonFormField<String>(
                              value: _selectedCor,
                              decoration: _buildInputDecoration(
                                'Cor',
                                'Selecione a cor do projetor',
                              ),
                              items: _cores.map((String cor) {
                                return DropdownMenuItem<String>(
                                  value: cor,
                                  child: Text(cor),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCor = newValue;
                                  _corController.text = newValue ?? '';
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione a cor';
                                }
                                return null;
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
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  minimumSize: const Size(120, 56),
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
          Expanded(child: 
            ProjetoresList(onListUpdated: () { 
              setState(() {
                
              });
            },)
          ),
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
