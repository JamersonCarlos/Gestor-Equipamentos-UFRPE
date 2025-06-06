import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/sidebar_menu/widgets/item_menu.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/sidebar_menu/widgets/item_sub_menu.dart';
import 'package:go_router/go_router.dart';

class SidebarMenu extends StatefulWidget {
  final double width;
  const SidebarMenu({super.key, this.width = 260});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  bool _isCardsMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    return Container(
      width: widget.width,
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
                SidebarMenuItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  selected: location == '/' || location.startsWith('/dashboard'),
                  onTap: () => context.goNamed('dashboard'),
                ),
                SidebarMenuItem(
                  icon: Icons.video_camera_front,
                  label: 'Projetores',
                  selected: location.startsWith('/projectors'),
                  onTap: () => context.goNamed('projectors'),
                ),
                SidebarMenuItem(
                  icon: Icons.people,
                  label: 'Professores',
                  selected: location.startsWith('/teachers'),
                  onTap: () => context.goNamed('teachers'),
                ),
                SidebarMenuItem(
                  icon: Icons.credit_card,
                  label: 'Cartões RFID',
                  selected: false,
                  onTap: () {
                    setState(() {
                      _isCardsMenuOpen = !_isCardsMenuOpen;
                    });
                  },
                  hasSubmenu: true,
                  isSubmenuOpen: _isCardsMenuOpen,
                  submenuItems: [
                    SubmenuItem(
                      icon: Icons.table_rows_rounded,
                      label: 'Cartões',
                      selected: location == '/cards',
                      onTap: () => context.goNamed('cards'),
                    ),
                    SubmenuItem(
                      label: 'Tags',
                      icon: Icons.tag,
                      selected: location.startsWith('/tags-associateds'),
                      onTap: () => context.goNamed('tags-associateds'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



