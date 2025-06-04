class Funcionario {
  final String email;
  final String codigo_cartao;
  final int curso_id;
  final int cargo_id;

  Funcionario({
    required this.email,
    required this.codigo_cartao,
    required this.curso_id,
    required this.cargo_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': email.replaceAll(RegExp(r'[^0-9]'), ''),
      'codigo_cartao': codigo_cartao,
      'curso_id': curso_id,
      'cargo_id': cargo_id,
    };
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      email: json['email'],
      codigo_cartao: json['codigo_cartao'],
      curso_id: json['curso_id'],
      cargo_id: json['cargo_id'],
    );
  }
}
