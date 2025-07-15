import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/screens/dashboard/widgets/charts_weeken.dart';
import 'package:provider/provider.dart';
import 'package:gestor_uso_projetores_ufrpe/domain/entities/emprestimos_por_dia_mes_response.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EmprestimosDiaProvider>();
    return FutureBuilder<List<EmprestimosPorDiaMesResponse>>(
      future: provider.getEmprestimosPorMesResponse(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'));
        }
        final emprestimosPorMes = snapshot.data ?? [];
        final List<FlSpot> spots = emprestimosPorMes
            .map((e) =>
                FlSpot(e.diaMes.toDouble(), e.totalEmprestimos.toDouble()))
            .toList();
        final dias = spots.map((e) => e.x).toList();
        final minX = dias.isNotEmpty
            ? dias.reduce((a, b) => a < b ? a : b).toDouble()
            : 0.0;
        final maxX = dias.isNotEmpty
            ? dias.reduce((a, b) => a > b ? a : b).toDouble()
            : 0.0;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estatísticas de Empréstimos por Mês',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 38,
                                  getTitlesWidget: (value, meta) {
                                    // Mostra apenas os dias presentes nos dados
                                    final dias =
                                        spots.map((e) => e.x.toInt()).toSet();
                                    if (dias.contains(value.toInt())) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            minY: 0,
                            maxY: spots.isNotEmpty
                                ? (spots
                                        .map((e) => e.y)
                                        .reduce((a, b) => a > b ? a : b) +
                                    5)
                                : 40,
                            minX: minX,
                            maxX: maxX,
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withOpacity(0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Empréstimos por Dia',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 300, child: ChartsWeekend()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
