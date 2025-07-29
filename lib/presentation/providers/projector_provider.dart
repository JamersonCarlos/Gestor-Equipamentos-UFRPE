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
  int _totalElements = 0;
  int _totalPages = 0;

  List<Projetor> get projectors => _projectors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<UsoEquipamento> get usos => _usos;
  int get currentPage => _currentPage;
  int get totalElements => _totalElements;
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

  Future<void> getUsos({int page = 1, int limit = 10}) async {
    // Permitir requisição inicial quando não há dados
    if (!_isLoading && (_currentPage != page || _usos.isEmpty)) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else if (!_isLoading) {
      // Se for a mesma página e já há dados, não fazer nada
      return;
    }

    try {
      final skip = (page - 1) * limit;
      final result = await _usoEquipamentoService.getUsos(
          skip: skip, limit: limit) as Map<String, dynamic>;

      final newUsos = result['usos'] as List<UsoEquipamento>;
      final newTotalElements = (result['total'] as int?) ?? 0;
      final newTotalPages = ((newTotalElements + limit - 1) ~/ limit);

      // Só notificar se os dados realmente mudaram
      bool hasChanged = _usos.length != newUsos.length ||
          _totalElements != newTotalElements ||
          _currentPage != page ||
          _totalPages != newTotalPages;

      if (hasChanged) {
        _usos = newUsos;
        _totalElements = newTotalElements;
        _currentPage = page;
        _totalPages = newTotalPages;
      }

      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar usos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método específico para atualizações do WebSocket
  Future<void> refreshUsos() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final skip = (_currentPage - 1) * 10; // Usar limit padrão de 10
      final result = await _usoEquipamentoService.getUsos(skip: skip, limit: 10)
          as Map<String, dynamic>;

      final newUsos = result['usos'] as List<UsoEquipamento>;
      final newTotalElements = (result['total'] as int?) ?? 0;
      final newTotalPages = ((newTotalElements + 10 - 1) ~/ 10);

      // Sempre atualizar os dados no refresh
      _usos = newUsos;
      _totalElements = newTotalElements;
      _totalPages = newTotalPages;

      _error = null;
    } catch (e) {
      _error = 'Erro ao atualizar usos: $e';
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
