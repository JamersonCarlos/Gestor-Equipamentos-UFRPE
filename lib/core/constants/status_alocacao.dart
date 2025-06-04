import 'package:flutter/material.dart';

class StatusAlocacao {
  static const String alocado = 'ALOCADO';
  static const String devolvido = 'DEVOLVIDO';
  static const String cancelado = 'CANCELADO';
  
  final String value;
  final Color color;

  const StatusAlocacao({
    required this.value,
    required this.color,
  });

  static StatusAlocacao fromValue(String value) {
    switch (value.toUpperCase()) {
      case StatusAlocacao.alocado:
        return StatusAlocacao(value: value, color: Colors.green);
      case StatusAlocacao.devolvido:
        return StatusAlocacao(value: value, color: Colors.grey);
      case StatusAlocacao.cancelado:
        return StatusAlocacao(value: value, color: Colors.red);
      default:
        throw Exception('StatusAlocacao desconhecido: $value');
    }
  }
}