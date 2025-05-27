import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarMenu extends StatelessWidget {
  final double width;
  const SidebarMenu({super.key, this.width = 260});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    return Container(
      width: width,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.widgets_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventário',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'UFRPE',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFE0E0E0),
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          // Menu principal
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _SidebarMenuItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  selected: location == '/' || location.startsWith('/?'),
                  onTap: () => context.goNamed('dashboard'),
                ),
                _SidebarMenuItem(
                  icon: Icons.video_camera_front,
                  label: 'Projetores',
                  selected: location.startsWith('/projectors'),
                  onTap: () => context.goNamed('projectors'),
                ),
                _SidebarMenuItem(
                  icon: Icons.people,
                  label: 'Professores',
                  selected: location.startsWith('/teachers'),
                  onTap: () => context.goNamed('teachers'),
                ),
                _SidebarMenuItem(
                  icon: Icons.credit_card,
                  label: 'Cartões',
                  selected: location.startsWith('/cards'),
                  onTap: () => context.goNamed('cards'),
                ),
              ],
            ),
          ),
          // Espaço para promo/usuário (opcional)
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SidebarMenuItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: selected
          ? BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.black54),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
