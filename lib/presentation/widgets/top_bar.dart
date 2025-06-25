import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/widgets/notification_widget.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final EmprestimosDiaProvider provider;
  const TopBar({super.key, required this.userName, required this.provider});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      color: Colors.white,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            // Campo de busca
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Ícones de ação
            IconButton(
              icon: const Icon(Icons.notifications_none,fill: 1,),
              onPressed: () {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position =
                    button.localToGlobal(Offset.zero, ancestor: overlay);

                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (context) {
                    return Stack(
                      children: [
                        Positioned(
                          left: position.dx + 1200,
                          top: position.dy +
                              button.size.height +
                              8,
                          child: Material(
                            color: Colors.transparent,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: provider.getUsosPendentesProvider(),
                              builder: (context, snapshot) {
                                final usosPendentes = snapshot.data ?? [];
                                return NotificationWidget(
                                  newNotifications: usosPendentes.map((uso) => NotificationItem(
                                    title: '${uso['nome']} - ${uso['curso']['nome']}',
                                    subtitle: 'Uso pendente de devolução',
                                    date: DateTime.now(),
                                    icon: Icons.notifications_none,
                                  )).toList(),
                                  oldNotifications: [],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              tooltip: 'Notificações',
              focusNode: FocusNode(),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                context.goNamed('settings');
              },
              tooltip: 'Configurações',
            ),
            const SizedBox(width: 16),
            // Avatar e nome do usuário
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/women/44.jpg'),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
