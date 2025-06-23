class Funcionario {
  final int id;
  final String nome;
  final String email;
  final String codigo_cartao;
  final int curso_id;
  final int cargo_id;
  String? _cargoNome;

  Funcionario({ 
    required this.id,
    this.nome = '',
    required this.email,
    required this.codigo_cartao,
    required this.curso_id,
    required this.cargo_id,
    String? cargoNome,
  }) : _cargoNome = cargoNome;
  
  String? get cargo => _cargoNome;

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'codigo_cartao': codigo_cartao,
      'curso_id': curso_id,
      'cargo_id': cargo_id,
      'cargo_nome': _cargoNome,
    };
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id'] != null ? json['id'] as int : 0,
      nome: json['nome'] != null ? json['nome'] as String : '',
      email: json['email'] != null ? json['email'] as String : '',
      codigo_cartao: json['codigo_cartao'] != null ? json['codigo_cartao'] as String : '',
      curso_id: json['curso_id'] != null ? json['curso_id'] as int : 0,
      cargo_id: json['cargo_id'] != null ? json['cargo_id'] as int : 0,
      cargoNome: json['cargo_nome'] != null ? json['cargo_nome'] as String : '',
    );
  }
}
