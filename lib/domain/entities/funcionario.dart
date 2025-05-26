class Funcionario {
  final String cpf;
  final String codigo_cartao;
  final String nome;
  final int curso_id;

  Funcionario({
    required this.cpf,
    required this.codigo_cartao,
    required this.nome,
    required this.curso_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf.replaceAll(RegExp(r'[^0-9]'), ''),
      'codigo_cartao': codigo_cartao,
      'nome': nome,
      'curso_id': curso_id,
    };
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      cpf: json['cpf'],
      codigo_cartao: json['codigo_cartao'],
      nome: json['nome'],
      curso_id: json['curso_id'],
    );
  }
}