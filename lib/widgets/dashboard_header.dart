import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: const [
        StatCard(
          title: 'Total Loans',
          value: '96',
          icon: Icons.account_tree_rounded,
        ),
        StatCard(
          title: 'Most Active Day',
          value: 'Wednesday',
          icon: Icons.calendar_month,
        ),
        StatCard(
          title: 'Most Active Teacher',
          value: 'Michael Johnson',
          icon: Icons.person,
        ),
        StatCard(
          title: 'Most Active Teacher',
          value: 'Michael Johnson',
          icon: Icons.person,
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.21,
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
                  backgroundColor: Colors.grey.shade100,
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
