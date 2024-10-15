import 'package:flutter/material.dart';

class BookmarkPage extends StatelessWidget {
  static const routeName = '/bookmark';

  // Dữ liệu ảo
  final List<Map<String, String>> bookmarks = [
    {
      'title': 'Victory Billiards 59',
      'description': 'Family-Friendly, Futuristic',
    },
    {
      'title': 'Master Billiards 96',
      'description': 'Cozy, Modern, Family-Friendly',
    },
    {
      'title': 'Royal Snooker 66',
      'description': 'Modern, Busy, Vintage',
    },
    {
      'title': 'Fantasy Billiards 14',
      'description': 'Traditional, Romantic, Warm',
    },
    {
      'title': 'Top Spin 36',
      'description': 'Family-Friendly, Luxury, Modern',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền giống Home và Profile
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Bookmarks",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.bookmark,
              color: Colors.orange, // Icon màu cam để đồng bộ với chủ đề
              size: 30,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Your Bookmarks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return BookmarkCard(
                    title: bookmark['title']!,
                    description: bookmark['description']!,
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

class BookmarkCard extends StatelessWidget {
  final String title;
  final String description;

  const BookmarkCard({
    Key? key,
    required this.title,
    required this.description,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange, // Màu cam chủ đạo giống với profile
            ),
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
