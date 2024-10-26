import 'package:flutter/material.dart';
import '../../../api/billiard_halls_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../details/detail.dart';
import 'package:intl/intl.dart';
import '../home.dart';

class BookmarkPage extends StatefulWidget {
  static const routeName = '/bookmark';

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarked_halls');
    if (savedBookmarks != null) {
      List<Map<String, dynamic>> loadedBookmarks = [];
      for (String hallId in savedBookmarks) {
        var response = await BilliardHallAPI.getBilliardHallByIDRequest(hallId);
        if (response.statusCode == 200) {
          var hallData = json.decode(response.body)['data'];
          loadedBookmarks.add({
            'id': hallId,
            'title': hallData['name'],
            'address': hallData['address']?['street'] ?? 'No address',
            'stars': hallData['stars'] ?? 0,
            'pricePerHour': hallData['price_per_hour'] ?? 0,
          });
        }
      }
      setState(() {
        bookmarks = loadedBookmarks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        title: const Text(
          "Bookmarks",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bookmarks.isEmpty
            ? const Center(
                child: Text(
                  'No bookmarks yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return BookmarkCard(
                    hallId: bookmark['id'],
                    title: bookmark['title'],
                    address: bookmark['address'],
                    stars: bookmark['stars'],
                    pricePerHour: bookmark['pricePerHour'].toDouble(),
                  );
                },
              ),
      ),
    );
  }
}

class BookmarkCard extends StatelessWidget {
  final String hallId;
  final String title;
  final String address;
  final int stars;
  final double pricePerHour;

  const BookmarkCard({
    Key? key,
    required this.hallId,
    required this.title,
    required this.address,
    required this.stars,
    required this.pricePerHour,
  }) : super(key: key);

  void _navigateToDetailPage(BuildContext context) {
    Color randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    int imageIndex = Random().nextInt(50) + 1;
    String randomImagePath = 'assets/images/$imageIndex.jpg';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          color: randomColor,
          hallId: hallId,
          imagePath: randomImagePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetailPage(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                'assets/images/${Random().nextInt(50) + 1}.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: List.generate(
                      stars,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(pricePerHour).trim()} VND',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
