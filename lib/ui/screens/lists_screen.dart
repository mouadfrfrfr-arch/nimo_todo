import 'package:flutter/material.dart';
import 'package:nimo_todo/data/models/todo_list.dart';
import 'package:nimo_todo/data/repos/list_repository.dart';
import 'package:nimo_todo/ui/screens/list_detail_screen.dart';
import 'package:nimo_todo/ui/widgets/premium_button.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final _repo = ListRepository();

  Future<List<TodoList>> _load() => _repo.listAll();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TodoList>>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snap.data ?? const <TodoList>[];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            Row(
              children: [
                Text('Projects', style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                PremiumButton(
                  label: 'Add',
                  icon: Icons.add,
                  onPressed: _createList,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (l) => Card(
                child: ListTile(
                  leading: Icon(l.id == 'inbox' ? Icons.inbox : Icons.folder_outlined),
                  title: Text(l.name),
                  subtitle: (l.id == 'inbox') ? const Text('Default capture list') : null,
                  trailing: (l.id == 'inbox')
                      ? null
                      : PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'rename') _renameList(l);
                            if (v == 'delete') _deleteList(l);
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'rename', child: Text('Rename')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListDetailScreen(list: l)),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createList() async {
    final name = await _promptText(title: 'New project', hint: 'e.g. Work');
    if (name == null) return;
    await _repo.createList(name: name);
    if (mounted) setState(() {});
  }

  Future<void> _renameList(TodoList l) async {
    final name = await _promptText(title: 'Rename project', initial: l.name);
    if (name == null) return;
    await _repo.renameList(id: l.id, name: name);
    if (mounted) setState(() {});
  }

  Future<void> _deleteList(TodoList l) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "${l.name}"?'),
        content: const Text('Tasks in this project will be moved to Inbox.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (ok != true) return;
    await _repo.deleteList(id: l.id);
    if (mounted) setState(() {});
  }

  Future<String?> _promptText({
    required String title,
    String? hint,
    String? initial,
  }) async {
    final ctrl = TextEditingController(text: initial ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text('Save')),
        ],
      ),
    );
    ctrl.dispose();
    return result;
  }
}
