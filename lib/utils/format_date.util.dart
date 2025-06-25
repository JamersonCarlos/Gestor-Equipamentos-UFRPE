import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}

String formatDateToHour(DateTime date) {
  return DateFormat('HH:mm').format(date);
}

String formatDateToDay(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatDateToMonth(DateTime date) {
  return DateFormat('MM/yyyy').format(date);
}

String formatRelativeDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  // Se a data é no futuro, retorna "agora"
  if (difference.isNegative) {
    return "agora";
  }

  // Se a diferença é menor que 1 minuto
  if (difference.inMinutes < 1) {
    return "agora";
  }

  // Se a diferença é menor que 1 hora
  if (difference.inHours < 1) {
    final minutes = difference.inMinutes;
    return "a $minutes min";
  }

  // Se a diferença é menor que 1 dia
  if (difference.inDays < 1) {
    final hours = difference.inHours;
    return "a ${hours}hr";
  }

  // Se a diferença é menor que 1 semana
  if (difference.inDays < 7) {
    final days = difference.inDays;
    return "a $days dia${days > 1 ? 's' : ''}";
  }

  // Se a diferença é menor que 1 mês (aproximadamente 30 dias)
  if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return "a $weeks semana${weeks > 1 ? 's' : ''}";
  }

  // Se a diferença é menor que 1 ano
  if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return "a $months mês${months > 1 ? 'es' : ''}";
  }

  // Se a diferença é maior que 1 ano
  final years = (difference.inDays / 365).floor();
  return "a $years ano${years > 1 ? 's' : ''}";
}
