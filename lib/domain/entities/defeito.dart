class Defeito {
  final int id;
  final String descricao;
  final String equipamentoCodigo;

  Defeito({
    required this.descricao,
    required this.equipamentoCodigo,
    required this.id, 
  });

  factory Defeito.fromJson(Map<String, dynamic> json) {
    return Defeito(
      descricao: json['descricao'] as String,
      equipamentoCodigo: json['equipamento_codigo'] as String,
      id: json['id'] != null ? json['id'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'equipamento_codigo': equipamentoCodigo,
    };
  }


}
