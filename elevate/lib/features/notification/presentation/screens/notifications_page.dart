import 'package:flutter/material.dart';
import '../../data/models/notification_item.dart';

// Notifications Page
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(title: 'Your order has been shipped!', isRead: false),
    NotificationItem(
      title:
          'A chance to gain 2000 points only for loyal customers if you purchase an order before New Year\'s Eve! Hurry up!',
      isRead: true,
    ),
    NotificationItem(
      title:
          'You have gained 200 free points for purchasing an order above 1500 EGP.\nDouble them now!',
      isRead: true,
    ),
    NotificationItem(
      title:
          'A new discount has been added for your favorite items, make an order NOW!',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Text(
            'Notifications',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 30),
              height: 2,
              color: Colors.grey[300],
              width: double.infinity,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return _buildNotificationCard(context, notification);
                },
              ),
            ),
            SizedBox(height: 30), // Add padding at the bottom if needed
          ],
        ),
      ),
    );
  }

  // Helper widget to build each notification card
  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItem notification,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color:
            notification.isRead
                ? Colors.grey[200]
                : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (!notification.isRead) {
                  setState(() {
                    notification.isRead = true;
                  });
                }
              },
              child: Row(
                children: [
                  if (!notification.isRead) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.primary, // Unread indicator
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            notification.isRead
                                ? FontWeight.normal
                                : FontWeight.w500,
                        color:
                            notification.isRead
                                ? Colors.grey[600]
                                : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!notification.isRead)
                    InkWell(
                      onTap: () {
                        setState(() {
                          notification.isRead = true;
                        });
                      },
                      child: Icon(
                        Icons.mark_email_read_rounded,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
