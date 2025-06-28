import 'package:gestor_uso_projetores_ufrpe/domain/entities/defeito.dart';

class Projetor {
  final String modelo;
  final String marca;
  final String cor;
  final String codigo_tombamento;
  final String codigo_tag;
  final Defeito? defeito;

  Projetor({
    required this.modelo,
    required this.marca,
    required this.cor,
    required this.codigo_tombamento,
    required this.codigo_tag,
    this.defeito,
  });

  factory Projetor.fromJson(Map<String, dynamic> json) {
    return Projetor(
      modelo: json['modelo'],
      marca: json['marca'],
      cor: json['cor'],
      codigo_tombamento: json['codigo_tombamento'],
      codigo_tag: json['codigo_tag'],
      defeito:
          json['defeito'] != null ? Defeito.fromJson(json['defeito']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'modelo': modelo,
      'marca': marca,
      'cor': cor,
      'codigo_tombamento': codigo_tombamento,
      'codigo_tag': codigo_tag,
    };
    
    return data;
  }
}
