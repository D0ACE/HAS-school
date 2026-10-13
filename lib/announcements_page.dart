import 'package:flutter/material.dart';

import 'hsb_colors.dart';
import 'models/announcement.dart';
import 'services/announcement_service.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final _service = AnnouncementService();

  Future<void> _openEditor([Announcement? announcement]) async {
    final result = await showDialog<_AnnouncementInput>(
      context: context,
      builder: (_) => _AnnouncementDialog(announcement: announcement),
    );
    if (result == null) {
      return;
    }

    try {
      if (announcement == null) {
        await _service.createAnnouncement(
          title: result.title,
          message: result.message,
        );
      } else {
        await _service.updateAnnouncement(
          id: announcement.id,
          title: result.title,
          message: result.message,
        );
      }
      if (mounted) {
        _showMessage('Announcement saved.');
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Could not save announcement: $error');
      }
    }
  }

  Future<void> _delete(Announcement announcement) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete announcement?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    try {
      await _service.deleteAnnouncement(announcement.id);
      if (mounted) {
        _showMessage('Announcement deleted.');
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Could not delete announcement: $error');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: HsbColors.cream,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: HsbColors.coral,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New announcement'),
      ),
      body: StreamBuilder<List<Announcement>>(
        stream: _service.watchAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.cloud_off_rounded,
              message: 'Could not load announcements.\n${snapshot.error}',
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final announcements = snapshot.data ?? const <Announcement>[];
          if (announcements.isEmpty) {
            return const _MessageState(
              icon: Icons.campaign_outlined,
              message: 'No announcements yet.\nCreate the first one.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                elevation: 0,
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    announcement.title,
                    style: const TextStyle(
                      color: HsbColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(announcement.message),
                  ),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: () => _openEditor(announcement),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _delete(announcement),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: HsbColors.muted, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: HsbColors.muted, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementInput {
  const _AnnouncementInput({required this.title, required this.message});

  final String title;
  final String message;
}

class _AnnouncementDialog extends StatefulWidget {
  const _AnnouncementDialog({this.announcement});

  final Announcement? announcement;

  @override
  State<_AnnouncementDialog> createState() => _AnnouncementDialogState();
}

class _AnnouncementDialogState extends State<_AnnouncementDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.announcement?.title ?? '',
    );
    _messageController = TextEditingController(
      text: widget.announcement?.message ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.pop(
      context,
      _AnnouncementInput(
        title: _titleController.text,
        message: _messageController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.announcement == null ? 'New announcement' : 'Edit announcement',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Message'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
