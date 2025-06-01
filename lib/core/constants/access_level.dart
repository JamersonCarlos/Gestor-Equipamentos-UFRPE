import 'package:flutter/material.dart';

enum AccessLevel {
  admin(
    value: 0,
    label: 'Administrador',
    icon: Icons.admin_panel_settings_outlined,
    color: Colors.indigo,
  ),
  professor(
    value: 1,
    label: 'Professor',
    icon: Icons.school_outlined,
    color: Colors.blue,
  ),
  tecnico(
    value: 2,
    label: 'Técnico',
    icon: Icons.shield_outlined,
    color: Color(0xFF388E3C),
  ),
  bloqueado(
    value: 3,
    label: 'Bloqueado',
    icon: Icons.block_outlined,
    color: Colors.red,
  ),
  visitante(
    value: 4,
    label: 'Visitante',
    icon: Icons.person_outline,
    color: Colors.purple,
  ),
  estudante(
    value: 5,
    label: 'Estudante',
    icon: Icons.person_outline,
    color: Colors.orange,
  );

  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const AccessLevel({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  static AccessLevel fromValue(int value) {
    return AccessLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => AccessLevel.estudante,
    );
  }

  static AccessLevel fromString(String label) {
    return AccessLevel.values.firstWhere(
      (level) => level.label.toLowerCase() == label.toLowerCase(),
      orElse: () => AccessLevel.estudante,
    );
  }
}
