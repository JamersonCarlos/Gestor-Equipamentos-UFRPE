import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';

class ChartsWeekend extends StatefulWidget {
  const ChartsWeekend({super.key});

  @override
  State<ChartsWeekend> createState() => _ChartsWeekendState();
}

class _ChartsWeekendState extends State<ChartsWeekend> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmprestimosDiaProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final emprestimos = provider.emprestimosPorDia;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 300,
        width: 400,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            minY: 0,
            barTouchData: const BarTouchData(enabled: false),
            barGroups: List.generate(7, (index) {
              final emprestimo = emprestimos.firstWhere(
                (e) => e['dia_semana_num'] == index,
                orElse: () => {'total_emprestimos': 0},
              );

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: emprestimo['total_emprestimos'].toDouble() ?? 0,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    const days = [
                      'Dom',
                      'Seg',
                      'Ter',
                      'Qua',
                      'Qui',
                      'Sex',
                      'Sáb',
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        days[value.toInt()],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 4,
            ),
            borderData: FlBorderData(
              show: false,
              border: Border.all(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
