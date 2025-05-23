import 'package:flutter/material.dart';
import '../widgets/sidebar_menu.dart';
import '../widgets/top_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Row(
        children: [
          // Sidebar fixa
          if (isLargeScreen) const SidebarMenu(),
          // Conteúdo principal
          Expanded(
            child: Column(
              children: [
                // TopBar
                const TopBar(userName: 'Emma Kwan'),
                // Conteúdo
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Drawer para telas pequenas (opcional)
      drawer: isLargeScreen ? null : const Drawer(child: SidebarMenu()),
    );
  }
}
