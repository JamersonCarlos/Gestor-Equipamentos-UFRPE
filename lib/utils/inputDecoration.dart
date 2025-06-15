import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/core/theme/app_colors.dart';


InputDecoration buildInputDecoration(
    String label, String hint, Widget? suffixIcon) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    suffixIcon: suffixIcon,
    fillColor: AppColors.surface,
    labelStyle: const TextStyle(color: AppColors.primary),
    hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.6)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );
}
