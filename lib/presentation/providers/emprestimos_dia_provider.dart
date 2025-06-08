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
    final diaMaisAtivo = _emprestimosPorDia.firstWhere((dia) => dia['total_emprestimos'] == _emprestimosPorDia.map((dia) => dia['total_emprestimos']).reduce((a, b) => a > b ? a : b));
    return diaMaisAtivo['dia_semana'];
  }
  Future<String> getProfessorMaisAtivo() async {
    final professorMaisAtivo = _emprestimosPorDia.firstWhere((dia) => dia['emprestimos'] == _emprestimosPorDia.map((dia) => dia['emprestimos']).reduce((a, b) => a > b ? a : b));
    return professorMaisAtivo['professor'];
  }
}
