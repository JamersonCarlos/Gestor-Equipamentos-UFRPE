import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/services/uso_equipamento_service.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/emprestimos_por_dia_mes_response.dart';

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
        ? professorMaisAtivo['nome_professor'] ?? ''
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

  Future<List<Map<String, dynamic>>> getEmprestimosPorMes() async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _service.getEmprestimosPorMes();
    } catch (e) {
      debugPrint('Erro ao carregar empréstimos por mes: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<EmprestimosPorDiaMesResponse>>
      getEmprestimosPorMesResponse() async {
    try {
      final list = await _service.getEmprestimosPorMes();
      return list.map((e) => EmprestimosPorDiaMesResponse.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Erro ao carregar empréstimos por mes response: $e');
      return [];
    }
  }

  // Método para atualizar dados do dashboard via WebSocket
  Future<void> refreshDashboardData() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Recarregar todos os dados do dashboard
      _emprestimosPorDia = await _service.getEmprestimosPorDia();
    } catch (e) {
      debugPrint('Erro ao atualizar dados do dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para recarregar dados por mês (sem notifyListeners durante execução)
  Future<List<EmprestimosPorDiaMesResponse>> refreshEmprestimosPorMes() async {
    try {
      final list = await _service.getEmprestimosPorMes();
      return list.map((e) => EmprestimosPorDiaMesResponse.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Erro ao recarregar empréstimos por mes: $e');
      return [];
    }
  }
}
