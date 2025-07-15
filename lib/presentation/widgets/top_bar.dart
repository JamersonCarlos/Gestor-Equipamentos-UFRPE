import 'package:flutter/material.dart';
import 'package:gestor_uso_projetores_ufrpe/presentation/providers/emprestimos_dia_provider.dart';
import 'package:gestor_uso_projetores_ufrpe/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final EmprestimosDiaProvider provider;

  const TopBar({super.key, required this.provider});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoadingNotifications = false;
  bool _hasLoadedNotifications = false;
  final AuthService authService = AuthService.instance();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    if (_hasLoadedNotifications) return;

    setState(() {
      _isLoadingNotifications = true;
    });

    try {
      final notifications = await widget.provider.getUsosPendentesProvider();
      setState(() {
        _notifications = notifications;
        _isLoadingNotifications = false;
        _hasLoadedNotifications = true;
      });
    } catch (e) {
      setState(() {
        _isLoadingNotifications = false;
        _hasLoadedNotifications = true;
      });
      debugPrint('Erro ao carregar notificações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double notificationWidth = 350.0;
    const double margin = 16.0;
    final user = authService.getUser();
    return Material(
      elevation: 1.5,
      color: Colors.white,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
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
              icon: _IconWithNotification(_notifications.length),
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final Offset position =
                    button.localToGlobal(Offset.zero, ancestor: overlay);

                double leftPosition;
                if (position.dx +
                        button.size.width +
                        margin +
                        notificationWidth >
                    screenSize.width) {
                  leftPosition = position.dx - notificationWidth - margin;
                  if (leftPosition < margin) {
                    leftPosition =
                        screenSize.width - notificationWidth - margin;
                    if (leftPosition < margin) leftPosition = margin;
                  }
                } else {
                  leftPosition = position.dx + button.size.width + margin;
                }

                if (leftPosition < margin) {
                  leftPosition = margin;
                }

                showDialog(
                  context: context,
                  barrierColor: Colors.transparent,
                  barrierDismissible: true,
                  builder: (context) {
                    return Stack(
                      children: [
                        // Overlay invisível para permitir fechar clicando fora
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        Positioned(
                          left: leftPosition,
                          top: position.dy + button.size.height + 8,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 350,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Notificações",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_isLoadingNotifications)
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  else if (_notifications.isEmpty)
                                    const Text(
                                      "Nenhuma notificação pendente",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  else
                                    ..._notifications.map((uso) => ListTile(
                                          leading: const CircleAvatar(
                                            child: Icon(
                                                Icons.notifications_none,
                                                color: Colors.white),
                                            backgroundColor: Colors.blue,
                                          ),
                                          title: Text(
                                              '${uso['nome']} - ${(uso['curso'] as Map<String, dynamic>?)?['nome'] ?? 'Curso não informado'}'),
                                          subtitle: const Text(
                                              'Uso pendente de devolução'),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 2),
                                        )),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Fechar"),
                                  ),
                                ],
                              ),
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
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://ui-avatars.com/api/?name=${user?.fullName.split(' ')[0] ?? 'U'}&background=random"),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  user?.fullName.split(' ')[0] ?? 'Usuário',
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

  Widget _IconWithNotification(int notificationsCount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_none),
        if (notificationsCount > 0)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$notificationsCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
