class Cargo {
  final int id;
  final String nome;

  Cargo({
    required this.id,
    required this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json['id'],
      nome: json['nome'],
    );
  }
}