import 'package:flutter/material.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/charts_section.dart';
import 'widgets/projector_loan_table.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        DashboardHeader(),
        SizedBox(height: 16),
        ChartsSection(),
        SizedBox(height: 16),
        ProjectorLoanTable(),
      ],
    );
  }
}
