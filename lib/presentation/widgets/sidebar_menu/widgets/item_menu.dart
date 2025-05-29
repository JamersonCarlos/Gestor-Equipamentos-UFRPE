import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/sidebar_menu/widgets/item_sub_menu.dart';

class SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool hasSubmenu;
  final bool isSubmenuOpen;
  final List<SubmenuItem>? submenuItems;

  const SidebarMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hasSubmenu = false,
    this.isSubmenuOpen = false,
    this.submenuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            trailing: hasSubmenu
                ? AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: isSubmenuOpen ? 0.5 : 0,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: selected ? Colors.blue : Colors.black54,
                    ),
                  )
                : null,
          ),
        ),
        if (hasSubmenu && isSubmenuOpen && submenuItems != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              children: submenuItems!
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: item,
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}