import 'package:flutter/material.dart';
import '../../utils/format_date.util.dart';

class NotificationItem {
  final String title;
  final String? subtitle;
  final DateTime date;
  final IconData icon;

  NotificationItem({
    required this.title,
    this.subtitle,
    required this.date,
    required this.icon,
  });
}

class NotificationWidget extends StatelessWidget {
  final List<NotificationItem> newNotifications;
  final List<NotificationItem> oldNotifications;

  const NotificationWidget({
    super.key,
    required this.newNotifications,
    required this.oldNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Notificações",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (newNotifications.isNotEmpty) ...[
              const _SectionTitle(title: "NOVAS"),
              ...newNotifications.map((n) => _NotificationTile(item: n)),
            ],
            if (oldNotifications.isNotEmpty) ...[
              const SizedBox(height: 12),
              const _SectionTitle(title: "ANTIGAS"),
              ...oldNotifications.map((n) => _NotificationTile(item: n)),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text("Ver todas"),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  const _NotificationTile({required this.item});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(item.icon, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      title:
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: Text(
        formatRelativeDate(item.date),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
    );
  }
}
