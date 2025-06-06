import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/charts_section.dart';
import 'widgets/projector_loan_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmprestimosDiaProvider()),
      ],
      child: ListView(
      children: const [
        DashboardHeader(),
        SizedBox(height: 16),
        ChartsSection(),
        SizedBox(height: 16),
        ProjectorLoanTable(),
      ],
    ),

    );
  }
}
