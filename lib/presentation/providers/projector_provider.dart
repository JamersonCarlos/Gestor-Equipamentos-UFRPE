import 'package:flutter/material.dart';
import '../../domain/entities/projetor.dart';

class ProjectorProvider extends ChangeNotifier {
  List<Projetor> _projectors = [];
  bool _isLoading = false;
  String? _error;
  final _entries = [
      {
        'name': 'John Michael',
        'email': 'john@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
        'function': 'Manager',
        'subtitle': 'Organization',
        'status': 'ALOCADO',
        'statusColor': Color(0xFF2ECC71),
        'date': '23/04/18',
        'id': 'PRJ001',
        'out': '4/16/2024 14:36',
        'in': '4/17/2024 9:00',
      },
      {
        'name': 'Alexa Liras',
        'email': 'alexa@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
        'function': 'Programator',
        'subtitle': 'Developer',
        'status': 'DEVOLVIDO',
        'statusColor': Color(0xFF6C757D),
        'date': '11/01/19',
        'id': 'PRJ002',
        'out': '4/14/2024 00:30',
        'in': '4/14/2024 10:45',
      },
      {
        'name': 'Laurent Perrier',
        'email': 'laurent@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/men/43.jpg',
        'function': 'Executive',
        'subtitle': 'Projects',
        'status': 'ALOCADO',
        'statusColor': Color(0xFF2ECC71),
        'date': '19/09/17',
        'id': 'PRJ003',
        'out': '4/14/2024 11:00',
        'in': '4/15/2024 16:30',
      },
      {
        'name': 'Miriam Eric',
        'email': 'miriam@creative-tim.com',
        'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
        'function': 'Programtor',
        'subtitle': 'Developer',
        'status': 'ALOCADO',
        'statusColor': Color(0xFF2ECC71),
        'date': '14/09/20',
        'id': 'PRJ004',
        'out': '4/15/2024 14:35',
        'in': '4/15/2024 16:35',
      },
    ];

  List<Projetor> get projectors => _projectors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, Object>> get entries => _entries;

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

  Future<void> addProjector(Projetor projector) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implementar chamada ao repositório
      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      _projectors.add(projector);
    } catch (e) {
      _error = 'Erro ao adicionar projetor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProjector(Projetor projector) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implementar chamada ao repositório
      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      final index = _projectors.indexWhere((p) => p.codigo_tombamento == projector.codigo_tombamento);
      if (index != -1) {
        _projectors[index] = projector;
      }
    } catch (e) {
      _error = 'Erro ao atualizar projetor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProjector(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implementar chamada ao repositório
      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      _projectors.removeWhere((p) => p.codigo_tombamento == id);
    } catch (e) {
      _error = 'Erro ao deletar projetor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
