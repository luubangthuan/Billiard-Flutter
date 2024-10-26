import 'dart:math';
import 'package:billiard_management_mobile_app/src/pages/client/best/best_place.dart';
import 'package:billiard_management_mobile_app/src/pages/client/checkin/checkin.dart';
import 'package:billiard_management_mobile_app/src/pages/client/search/search.dart';
import 'package:billiard_management_mobile_app/src/pages/client/toturial/tutorial.dart';
import 'package:flutter/material.dart';
import '../../../api/billiard_halls_api.dart';
import '../details/detail.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random random = Random();
  TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'Name';
  final List<String> _searchTypes = ['Name', 'City', 'District', 'Street'];

  Future<List<dynamic>> fetchPopularBilliardHalls() async {
    var response = await BilliardHallAPI.getHighPopularBilliardHallsRequest();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load popular billiard halls');
    }
  }

  Future<List<dynamic>> fetchHighRatingBilliardHalls() async {
    var response = await BilliardHallAPI.getHighRatingBilliardHallsRequest();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load high rating billiard halls');
    }
  }

  void _navigateToSearchResult() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultPage(
            name: _selectedSearchType == 'Name' ? query : '',
            city: _selectedSearchType == 'City' ? query : '',
            district: _selectedSearchType == 'District' ? query : '',
            street: _selectedSearchType == 'Street' ? query : '',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      print("Current search query: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int imageIndex = random.nextInt(50) + 1;
    String imagePath = 'assets/images/$imageIndex.jpg';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Hello, Johny",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(imagePath),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for search type
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSearchType,
                    isExpanded: true,
                    underline: Container(),
                    // Remove default underline
                    items: _searchTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSearchType = newValue!;
                      });
                    },
                  ),
                ),
              ),
              // Search bar
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Enter your search term...",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        onSubmitted: (value) {
                          _navigateToSearchResult();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.orange,
                        size: 30,
                      ),
                      onPressed: _navigateToSearchResult,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Category section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryItem(
                    Icons.place,
                    "Best Place",
                    () {
                      // Define the behavior when "Best Place" is tapped
                      // For example, navigating to a BestPlacePage (you need to create this page)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BestPlacePage(),
                        ),
                      );
                    },
                  ),
                  _buildCategoryItem(
                    Icons.check,
                    "Check-in",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinPage(),
                        ),
                      );
                    },
                  ),
                  _buildCategoryItem(
                    Icons.school,
                    "Tutorials",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorialPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Popular Destinations section
              const Text(
                "Popular Destinations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: fetchPopularBilliardHalls(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }
                  return SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var hall = snapshot.data![index];
                        var address = hall['address'];
                        var districtAndCity =
                            '${address['district']}, ${address['city']}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildDestinationCard(
                            context,
                            hall['name'],
                            districtAndCity,
                            Colors.orange,
                            'assets/images/bg-card.jpg',
                            double.tryParse(
                                    hall['rating']?.toString() ?? '0') ??
                                0.0,
                            double.tryParse(
                                    hall['price_per_hour']?.toString() ??
                                        '0') ??
                                0.0,
                            hall['vibe_short_description'] ?? '',
                            hall['_id'] ?? 'default_hall_id',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Recommended section
              const Text(
                "Recommended for You",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: fetchHighRatingBilliardHalls(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }
                  return SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var hall = snapshot.data![index];
                        var address = hall['address'];
                        var districtAndCity =
                            '${address['district']}, ${address['city']}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildDestinationCard(
                            context,
                            hall['name'],
                            districtAndCity,
                            Colors.purpleAccent,
                            'assets/images/bg-card.jpg',
                            double.tryParse(
                                    hall['rating']?.toString() ?? '0') ??
                                0.0,
                            double.tryParse(
                                    hall['price_per_hour']?.toString() ??
                                        '0') ??
                                0.0,
                            hall['vibe_short_description'] ?? '',
                            hall['_id'] ?? 'default_hall_id',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
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
            child: Icon(
              icon,
              color: Colors.orange,
              size: 35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(
    BuildContext context,
    String title,
    String location,
    Color color,
    String imagePath,
    double rating,
    double pricePerHour,
    String vibeDescription,
    String hallId,
  ) {
    int imageIndex = random.nextInt(50) + 1;
    String randomImagePath = 'assets/images/$imageIndex.jpg';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              color: color,
              hallId: hallId,
              imagePath: randomImagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                randomImagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              vibeDescription,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(pricePerHour).trim()} VND / hour',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
