import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/cursos.dart';
import 'package:gestor_uso_projetores_ufrpe/services/cursos_service.dart';

class CursosProvider extends ChangeNotifier {
  final CursosService _cursosService = CursosService();
  List<Curso> _cursos = [];
  bool _isLoading = false;
  String? _error;

  List<Curso> get cursos => _cursos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<List<Curso>> fetchCursos() async {
    _isLoading = true;
    _error = null;
    if (_cursos.isEmpty) {
      _cursos = await _cursosService.getCursos();
    }
    _isLoading = false;
    return _cursos;

  }
  
  
}