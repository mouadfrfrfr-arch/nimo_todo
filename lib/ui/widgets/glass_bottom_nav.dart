import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;

  const GlassBottomNav({
    super.key,
    required this.index,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface.withOpacity(0.75),
            border: Border(top: BorderSide(color: cs.outline.withOpacity(0.8))),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: index,
            onDestinationSelected: onSelect,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
              NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
              NavigationDestination(icon: Icon(Icons.list_alt), label: 'Projects'),
              NavigationDestination(icon: Icon(Icons.event), label: 'Upcoming'),
              NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
