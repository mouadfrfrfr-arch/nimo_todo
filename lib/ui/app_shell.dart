import 'package:flutter/material.dart';
import 'package:nimo_todo/security/app_lock_controller.dart';
import 'package:nimo_todo/ui/screens/inbox_screen.dart';
import 'package:nimo_todo/ui/screens/lists_screen.dart';
import 'package:nimo_todo/ui/screens/lock_screen.dart';
import 'package:nimo_todo/ui/screens/settings_screen.dart';
import 'package:nimo_todo/ui/screens/today_screen.dart';
import 'package:nimo_todo/ui/screens/upcoming_screen.dart';
import 'package:nimo_todo/ui/sheets/add_task_sheet.dart';
import 'package:nimo_todo/ui/widgets/glass_bottom_nav.dart';
import 'package:nimo_todo/ui/widgets/premium_drawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  final _lock = AppLockController();

  DateTime? _lastUnlockedAt;
  bool _lockScreenOpen = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLock(reason: 'startup'));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _onBackgrounded();
    }

    if (state == AppLifecycleState.resumed) {
      _maybeLock(reason: 'resume');
    }
  }

  Future<void> _onBackgrounded() async {
    final enabled = await _lock.isEnabled();
    if (!enabled) return;

    final lockOnBg = await _lock.lockOnBackground();
    if (!lockOnBg) return;

    _lastUnlockedAt = null;
  }

  Future<void> _maybeLock({required String reason}) async {
    if (_lockScreenOpen) return;

    final enabled = await _lock.isEnabled();
    if (!enabled || !mounted) return;

    final delay = await _lock.lockDelaySeconds();
    final now = DateTime.now();

    final last = _lastUnlockedAt;
    final needsLock = (last == null) || now.difference(last).inSeconds >= delay;

    if (!needsLock) return;

    _lockScreenOpen = true;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LockScreen(), fullscreenDialog: true),
    );
    _lockScreenOpen = false;

    if (ok == true) {
      _lastUnlockedAt = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PremiumDrawer(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _screens[_index],
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        index: _index,
        onSelect: (i) => setState(() => _index = i),
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
}
