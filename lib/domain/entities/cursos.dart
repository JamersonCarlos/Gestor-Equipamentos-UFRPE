class Curso {
  final String nome;
  final int curso_id;

  Curso({
    required this.nome,
    required this.curso_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'curso_id': curso_id,
    };
  }

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      nome: json['nome'],
      curso_id: json['id'],
    );
  }
}