import 'package:flutter/material.dart';

class ProjectorLoanTable extends StatelessWidget {
  const ProjectorLoanTable({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      {
        'name': 'Alan Smith',
        'id': 'PRJ001',
        'out': '4/16/2024 14:36',
        'in': '4/17/2024 9:00',
      },
      {
        'name': 'Lisa Brown',
        'id': 'PRJ002',
        'out': '4/14/2024 00:30',
        'in': '4/14/2024 10:45',
      },
      {
        'name': 'Michael Johns',
        'id': 'PRJ003',
        'out': '4/14/2024 11:00',
        'in': '4/15/2024 16:30',
      },
      {
        'name': 'Emily White',
        'id': 'PRJ004',
        'out': '4/15/2024 14:35',
        'in': '4/15/2024 16:35',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        const Text(
          'Empréstimos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DataTable(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          columns: const [
            DataColumn(label: Text('Nome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Projector ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Check-Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Check-In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(label: Text('', style: TextStyle(fontSize: 18))),
          ],
          rows:
              entries.map((e) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,

                            child: Icon(Icons.person, size: 14),
                          ),
                          const SizedBox(width: 8),
                          Text(e['name']!),
                        ],
                      ),
                    ),
                    DataCell(Text(e['id']!)),
                    DataCell(Text(e['out']!)),
                    DataCell(Text(e['in']!)),
                    const DataCell(Icon(Icons.arrow_forward_ios, size: 16)),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }
}
