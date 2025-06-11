class Funcionario {
  final String nome;
  final String email;
  final String codigo_cartao;
  final int curso_id;
  final int cargo_id;
  String? _cargoNome;

  Funcionario({
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
      nome: json['nome'] ?? '',
      email: json['email'],
      codigo_cartao: json['codigo_cartao'],
      curso_id: json['curso_id'],
      cargo_id: json['cargo_id'],
      cargoNome: json['cargo_nome'],
    );
  }
}
