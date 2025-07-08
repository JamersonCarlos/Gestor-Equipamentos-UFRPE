import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/uso_equipamento.dart';
import 'package:gestor_uso_projetores_ufrpe/services/projetorService.dart';
import 'package:gestor_uso_projetores_ufrpe/services/uso_equipamento_service.dart';
import '../../domain/entities/projetor.dart';

class ProjectorProvider extends ChangeNotifier {
  final UsoEquipamentoService _usoEquipamentoService = UsoEquipamentoService();
  final ProjetorService _projetorService = ProjetorService();
  List<Projetor> _projectors = [];
  List<UsoEquipamento> _usos = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;

  List<Projetor> get projectors => _projectors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<UsoEquipamento> get usos => _usos;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  List<Map<String, dynamic>> get entries {
    return _usos.map((uso) {
      final funcionario = uso.funcionario;
      final equipamento = uso.equipamento;

      return {
        'name': funcionario['nome'] ?? 'N/A',
        'email': funcionario['email'] ?? 'N/A',
        'avatar':
            'https://ui-avatars.com/api/?name=${funcionario['nome'] ?? 'U'}&background=random',
        'function': funcionario['cargo']['nome'] ?? 'N/A',
        'subtitle': funcionario['curso']['nome'] ?? 'N/A',
        'status': uso.status.value,
        'statusColor': uso.status.color,
        'id': equipamento['codigo_tombamento'] ?? 'N/A',
        'in': _formatDate(uso.dataAluguel),
        'out': uso.dataDevolucao != null
            ? _formatDate(uso.dataDevolucao!)
            : 'Pendente',
      };
    }).toList();
  }

  String _formatDate(DateTime date) {
    final dia = date.day.toString().padLeft(2, '0');
    final mes = date.month.toString().padLeft(2, '0');
    final hora = date.hour.toString().padLeft(2, '0');
    final minuto = date.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${date.year} $hora:$minuto hr';
  }

  Future<void> loadProjectors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      _projectors = [
        Projetor(
          codigo_tag: "",
          codigo_tombamento: "232",
          cor: "preto",
          marca: "LG",
          modelo: "1234",
        ),
      ];
    } catch (e) {
      _error = 'Erro ao carregar projetores: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUsos({int skip = 0, int limit = 100}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _usoEquipamentoService.getUsos(skip: skip, limit: limit) as Map<String, dynamic>;
      _usos = result['usos'] as List<UsoEquipamento>;
      _totalPages = result['total'];
      _currentPage = skip ~/ limit + 1;
    } catch (e) {
      _error = 'Erro ao carregar usos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> getProjectors() async {
    final projectors = await _projetorService.getProjetoresNotInUse();
    return projectors
        .map((projetor) => {
              'codigo_tombamento': projetor.codigo_tombamento,
              'modelo': projetor.modelo,
            })
        .toList();
  }
}
