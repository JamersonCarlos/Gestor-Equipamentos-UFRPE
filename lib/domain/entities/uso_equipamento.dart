import 'package:gestor_uso_projetores_ufrpe/core/constants/status_alocacao.dart';

class UsoEquipamento {
  final int protocolo;
  final String equipamentoCodigo;
  final String funcionarioCpf;
  final String email;
  final DateTime dataAluguel;
  final DateTime? dataDevolucao;
  final StatusAlocacao status;
  final Map<String, dynamic> equipamento;
  final Map<String, dynamic> funcionario;

  UsoEquipamento({
    required this.protocolo,
    required this.equipamentoCodigo,
    required this.funcionarioCpf,
    required this.dataAluguel,
    required this.email,
    this.dataDevolucao,
    required this.status,
    required this.equipamento,
    required this.funcionario,
  });

  factory UsoEquipamento.fromJson(Map<String, dynamic> json) {
    return UsoEquipamento(
      protocolo: json['protocolo'],
      equipamentoCodigo: json['equipamento_codigo'],
      funcionarioCpf: json['funcionario_cpf'],
      email: json['email'],
      dataAluguel: DateTime.parse(json['data_aluguel']),
      dataDevolucao: json['data_devolucao'] != null
          ? DateTime.tryParse(json['data_devolucao'])
          : null,
      status: StatusAlocacao.fromValue(json['status']),
      equipamento: json['equipamento'],
      funcionario: json['funcionario'],
    );
  }
}
