import 'package:flutter/material.dart';

class PremiumDrawer extends StatelessWidget {
  const PremiumDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: cs.outline),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C4DFF), Color(0xFF8B5CFF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nimo Todo Lis', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text('Local-first • Encrypted • App lock', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(),
            _Item(
              icon: Icons.warning_amber_rounded,
              title: 'Overdue',
              subtitle: 'What needs attention',
              onTap: () => Navigator.pop(context),
            ),
            _Item(
              icon: Icons.star_rounded,
              title: 'High priority',
              subtitle: 'Focus items',
              onTap: () => Navigator.pop(context),
            ),
            const Divider(height: 28),
            _Item(
              icon: Icons.workspace_premium_rounded,
              title: 'Premium',
              subtitle: 'Themes, widgets, more',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Item({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
