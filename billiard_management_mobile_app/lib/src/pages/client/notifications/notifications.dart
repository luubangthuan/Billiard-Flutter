import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  static const routeName = '/notifications';

  // Dữ liệu ảo cho các thông báo
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Course Available',
      'description': 'A new course on Flutter has been added to your list.',
      'time': '10 mins ago',
    },
    {
      'title': 'Profile Updated',
      'description': 'Your profile information has been successfully updated.',
      'time': '30 mins ago',
    },
    {
      'title': 'New Achievement Unlocked',
      'description': 'You have unlocked a new achievement in the Data Science course.',
      'time': '1 hour ago',
    },
    {
      'title': 'Subscription Expiring',
      'description': 'Your subscription will expire in 3 days. Renew now to continue learning.',
      'time': '2 hours ago',
    },
    {
      'title': 'Friend Joined',
      'description': 'Your friend John has joined the platform. Connect with him now!',
      'time': '4 hours ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Loại bỏ nền của AppBar
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.notifications,
              color: Colors.orange, // Đổi icon thành màu chủ đạo mới (cam)
              size: 30,
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Loại bỏ nút back
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationCard(
                    title: notification['title']!,
                    description: notification['description']!,
                    time: notification['time']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange, // Đổi màu chữ thành màu cam chủ đạo
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
