import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gestor_uso_projetores_ufrpe/widgets/charts_weeken.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Estatísticas de Empréstimos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
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
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text(
                                      'Apr 1',
                                      style: TextStyle(fontSize: 12),
                                    );
                                  case 2:
                                    return const Text(
                                      'Apr 5',
                                      style: TextStyle(fontSize: 12),
                                    );
                                  case 5:
                                    return const Text(
                                      'Apr 11',
                                      style: TextStyle(fontSize: 12),
                                    );
                                  case 7:
                                    return const Text(
                                      'Apr 15',
                                      style: TextStyle(fontSize: 12),
                                    );
                                  default:
                                    return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        minY: 0,
                        maxY: 40,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 38),
                              const FlSpot(1, 28),
                              const FlSpot(2, 15),
                              const FlSpot(3, 8),
                              const FlSpot(4, 10),
                              const FlSpot(5, 16),
                              const FlSpot(6, 22),
                              const FlSpot(7, 23),
                            ],
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
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
        Expanded(
          flex: 1,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Empréstimos por Dia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 300, child: ChartsWeekend()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
