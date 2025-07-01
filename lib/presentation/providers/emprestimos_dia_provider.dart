import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/services/uso_equipamento_service.dart';

class EmprestimosDiaProvider extends ChangeNotifier {
  final UsoEquipamentoService _service = UsoEquipamentoService();
  List<Map<String, dynamic>> _emprestimosPorDia = [];
  bool _isLoading = false;

  EmprestimosDiaProvider();

  List<Map<String, dynamic>> get emprestimosPorDia => _emprestimosPorDia;
  bool get isLoading => _isLoading;

  Future<void> carregarEmprestimosPorDia() async {
    _isLoading = true;
    notifyListeners();

    try {
      _emprestimosPorDia = await _service.getEmprestimosPorDia();
    } catch (e) {
      debugPrint('Erro ao carregar empréstimos por dia: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> getDiaMaisAtivo() async {
    if (_emprestimosPorDia.isEmpty) {
      return '';
    }
    final diaMaisAtivo = _emprestimosPorDia.firstWhere(
      (dia) =>
          dia['total_emprestimos'] ==
          _emprestimosPorDia
              .map((dia) => dia['total_emprestimos'])
              .reduce((a, b) => a > b ? a : b),
      orElse: () => {},
    );
    return diaMaisAtivo.isNotEmpty ? diaMaisAtivo['dia_semana'] ?? '' : '';
  }

  String getProfessorMaisAtivo() {
    if (_emprestimosPorDia.isEmpty) {
      return '';
    }
    final professorMaisAtivo = _emprestimosPorDia.firstWhere(
      (dia) =>
          dia['total_emprestimos'] ==
          _emprestimosPorDia
              .map((dia) => dia['total_emprestimos'])
              .reduce((a, b) => a > b ? a : b),
      orElse: () => {},
    );
    return professorMaisAtivo.isNotEmpty
        ? professorMaisAtivo['professor'] ?? ''
        : '';
  }

  Future<List<Map<String, dynamic>>> getUsosPendentesProvider() async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _service.getUsosPendentes();
    } catch (e) {
      debugPrint('Erro ao carregar empréstimos pendentes: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

