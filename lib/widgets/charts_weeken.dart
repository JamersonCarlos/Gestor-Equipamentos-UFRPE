import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartsWeekend extends StatelessWidget {
  const ChartsWeekend({super.key});

  @override
  Widget build(BuildContext context) {
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
            barTouchData: BarTouchData(enabled: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 2,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 4,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 8,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                    toY: 12,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                    toY: 6,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 5,
                barRods: [
                  BarChartRodData(
                    toY: 5,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
              BarChartGroupData(
                x: 6,
                barRods: [
                  BarChartRodData(
                    toY: 1,
                    color: Colors.teal,
                    width: 40,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            ],
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
