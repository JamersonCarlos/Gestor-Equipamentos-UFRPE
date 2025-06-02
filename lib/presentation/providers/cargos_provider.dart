import 'package:flutter/material.dart';
import '../../domain/entities/cargo.dart';
import '../../services/cargos_service.dart';

class CargosProvider extends ChangeNotifier {
  final CargosService _cargosService = CargosService();
  List<Cargo> _cargos = [];
  bool _isLoading = false;
  String? _error;

  List<Cargo> get cargos => _cargos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<List<Cargo>> fetchCargos() async {
    _isLoading = true;
    _error = null;

    try {
      if (_cargos.isEmpty) {
        _cargos = await _cargosService.getCargos();
      }
      return _cargos;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
