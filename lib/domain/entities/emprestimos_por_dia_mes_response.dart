class EmprestimosPorDiaMesResponse {
  final int diaMes;
  final int totalEmprestimos;

  EmprestimosPorDiaMesResponse({
    required this.diaMes,
    required this.totalEmprestimos,
  });

  factory EmprestimosPorDiaMesResponse.fromJson(Map<String, dynamic> json) {
    return EmprestimosPorDiaMesResponse(
      diaMes: json['dia_mes'] as int,
      totalEmprestimos: json['total_emprestimos'] as int,
    );
  }
}
