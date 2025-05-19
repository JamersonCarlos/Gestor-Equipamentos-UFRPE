import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/charts_section.dart';
import 'widgets/projector_loan_table.dart';
import 'widgets/side_menu.dart';

void main() {
  runApp(
    MaterialApp(
      home: const ProjectorDashboard(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    ),
  );
}

class ProjectorDashboard extends StatelessWidget {
  const ProjectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Gestor de Projetores'),
        actions: const [
          CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar apenas para telas grandes (opcional)
            if (MediaQuery.of(context).size.width > 900)
              const SizedBox(width: 200, child: SideMenu()),
            const SizedBox(width: 16),
            Expanded(
              child: ListView(
                children: const [
                  DashboardHeader(),
                  SizedBox(height: 16),
                  ChartsSection(),
                  SizedBox(height: 16),
                  ProjectorLoanTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
