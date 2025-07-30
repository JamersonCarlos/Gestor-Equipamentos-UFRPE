import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:provider/provider.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  @override
  Widget build(BuildContext context) {
    final emprestimosDiaProvider = context.watch<EmprestimosDiaProvider>();

    return FutureBuilder(
      future: emprestimosDiaProvider.getDiaMaisAtivo(),
      builder: (context, snapshot) {
        final diaMaisAtivo = snapshot.data ?? '';
        final professorMaisAtivo =
            emprestimosDiaProvider.getProfessorMaisAtivo();
        return Wrap(
          spacing: 18,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            StatCard(
              title: 'Total Loans',
              value: emprestimosDiaProvider.emprestimosPorDia.length.toString(),
              icon: Icons.account_tree_rounded,
              color: Colors.purple,
            ),
            StatCard(
              title: 'Most Active Day',
              value: diaMaisAtivo,
              icon: Icons.calendar_month,
              color: Colors.purple,
            ),
            StatCard(
              title: 'Most Active Teacher',
              value: professorMaisAtivo,
              icon: Icons.person,
              color: Colors.purple,
            ),
          ],
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.272,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (icon != null) ...[
                CircleAvatar(
                  backgroundColor: color,
                  child: Icon(icon),
                ),
                const SizedBox(width: 8),
              ],
              Text(value, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
