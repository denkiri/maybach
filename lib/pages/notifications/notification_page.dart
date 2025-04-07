import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/notification_viewmodel.dart';
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationViewModel>(context, listen: false).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        elevation: 4,
        shadowColor: Colors.blue.withOpacity(0.3),
      ),
      body: Column(
        children: [
          // Post Notification Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Notification Message',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: viewModel.isPosting
                      ? null
                      : () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      await viewModel.postNotification(_messageController.text);
                      _messageController.clear();
                    }
                  },
                  child: viewModel.isPosting
                      ? const CircularProgressIndicator()
                      : const Text('Post Notification',style: TextStyle(color: Colors.white))
                ),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          // Notifications List
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.notifications.isEmpty
                ? const Center(child: Text('No notifications available'))
                : ListView.builder(
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];
                return ListTile(
                  title: Text(notification.message),
                  subtitle: Text(
                    'Posted on ${notification.dateCreated.toString()}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  leading: const Icon(Icons.notifications),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}