import 'package:flutter/material.dart';
import '../../domain/entities/projector.dart';

class ProjectorProvider extends ChangeNotifier {
  List<Projector> _projectors = [];
  bool _isLoading = false;
  String? _error;

  List<Projector> get projectors => _projectors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjectors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      _projectors = [
        Projector(
          id: '1',
          model: 'Epson PowerLite',
          serialNumber: 'SN001',
          isAvailable: true,
        ),
        Projector(
          id: '2',
          model: 'BenQ MW632ST',
          serialNumber: 'SN002',
          isAvailable: false,
          currentLocation: 'Departamento de Informática',
        ),
      ];
    } catch (e) {
      _error = 'Erro ao carregar projetores: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProjector(Projector projector) async {
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

  Future<void> updateProjector(Projector projector) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implementar chamada ao repositório
      await Future.delayed(const Duration(seconds: 1)); // Simulação de delay
      final index = _projectors.indexWhere((p) => p.id == projector.id);
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
      _projectors.removeWhere((p) => p.id == id);
    } catch (e) {
      _error = 'Erro ao deletar projetor: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
