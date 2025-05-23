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
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.video_camera_front,
                    color: Colors.blue[700], size: 32),
                const SizedBox(width: 8),
                Text(
                  'Projetores UFRPE',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
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
                  icon: Icons.settings,
                  label: 'Configurações',
                  selected: location.startsWith('/settings'),
                  onTap: () => context.goNamed('settings'),
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
