import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';
import 'package:nimo_todo/ui/screens/inbox_screen.dart';
import 'package:nimo_todo/ui/screens/lists_screen.dart';
import 'package:nimo_todo/ui/screens/lock_screen.dart';
import 'package:nimo_todo/ui/screens/settings_screen.dart';
import 'package:nimo_todo/ui/screens/today_screen.dart';
import 'package:nimo_todo/ui/screens/upcoming_screen.dart';
import 'package:nimo_todo/ui/sheets/add_task_sheet.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  final _lock = AppLockController();

  final _screens = const [
    TodayScreen(),
    InboxScreen(),
    ListsScreen(),
    UpcomingScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLock());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeLock();
    }
  }

  Future<void> _maybeLock() async {
    final enabled = await _lock.isEnabled();
    if (!enabled || !mounted) return;

    // Present lock screen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LockScreen(), fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForIndex(_index)),
      ),
      drawer: const _PremiumDrawer(),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'Lists'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Upcoming'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => const AddTaskSheet(),
          );

          if (changed == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }

  String _titleForIndex(int i) {
    return switch (i) {
      0 => 'Today',
      1 => 'Inbox',
      2 => 'Lists',
      3 => 'Upcoming',
      4 => 'Settings',
      _ => 'Nimo Todo Lis',
    };
  }
}

class _PremiumDrawer extends StatelessWidget {
  const _PremiumDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const ListTile(
              title: Text(
                'Nimo Todo Lis',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('Local-first • Private • Fast'),
              leading: CircleAvatar(child: Icon(Icons.check_circle_outline)),
            ),
            const SizedBox(height: 8),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text('Overdue'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('High priority'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Premium'),
              subtitle: const Text('Theme, app lock, more'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
