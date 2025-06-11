class RfidTag {
  final String nome;
  final String rfid;
  final int nivelAcesso;
  final String status;
  final DateTime? ultimaLeitura;
  final int? id;
  final String? equipamentoCodigo;

  RfidTag({
    required this.nome,
    required this.rfid,
    required this.nivelAcesso,
    required this.status,
    required this.ultimaLeitura,
    this.id,
    this.equipamentoCodigo,
  });


  factory RfidTag.fromJson(Map<String, dynamic> json) {
    return RfidTag(
      nome: json['nome'] as String,
      rfid: json['rfid'] as String,
      nivelAcesso: json['nivel_acesso'] as int,
      status: json['status'] as String,
      ultimaLeitura: json['ultima_leitura'] != null
          ? DateTime.parse(json['ultima_leitura'] as String)
          : null,
      id: json['id'] as int,
      equipamentoCodigo: json['equipamento_codigo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'rfid': rfid,
      'nivel_acesso': nivelAcesso,
      'status': status.toUpperCase(),
      'ultima_leitura': ultimaLeitura?.toIso8601String() ?? '',
      'id': id,
      'equipamento_codigo': equipamentoCodigo,
    };
  }
}
