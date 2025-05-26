class Projetor {
  final String modelo;
  final String marca;
  final String cor;
  final String codigo_tombamento;
  final String codigo_tag;

  Projetor({
    required this.modelo,
    required this.marca,
    required this.cor,
    required this.codigo_tombamento,
    required this.codigo_tag,
  });

  factory Projetor.fromJson(Map<String, dynamic> json) {
    return Projetor(
      modelo: json['modelo'],
      marca: json['marca'],
      cor: json['cor'],
      codigo_tombamento: json['codigo_tombamento'],
      codigo_tag: json['codigo_tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelo': modelo,
      'marca': marca,
      'cor': cor,
      'codigo_tombamento': codigo_tombamento,
      'codigo_tag': codigo_tag,
    };
  }
}