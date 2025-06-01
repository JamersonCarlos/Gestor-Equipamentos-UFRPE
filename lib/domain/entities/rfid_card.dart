import 'package:gestor_uso_projetores_ufrpe/core/constants/access_level.dart';

class RfidCard {
  final String nome;
  final String rfid;
  final AccessLevel nivelAcesso;
  final String status;
  final DateTime? ultimaEntrada;
  final int id;

  RfidCard({
    required this.nome,
    required this.rfid,
    required this.nivelAcesso,
    required this.status,
    required this.ultimaEntrada,
    required this.id,
  });

  factory RfidCard.fromJson(Map<String, dynamic> json) {
    return RfidCard(
      nome: json['nome'] as String,
      rfid: json['rfid'] as String,
      nivelAcesso: AccessLevel.fromValue(json['nivel_acesso'] as int),
      status: json['status'] as String,
      ultimaEntrada: json['ultima_entrada'] != null
          ? DateTime.parse(json['ultima_entrada'] as String)
          : null,
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'rfid': rfid,
      'nivel_acesso': nivelAcesso.value,
      'status': status,
      'ultima_entrada': ultimaEntrada?.toIso8601String(),
      'id': id,
    };
  }
}
