import 'package:flutter/material.dart';

class SubmenuItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SubmenuItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      decoration: selected
          ? BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ListTile(
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
