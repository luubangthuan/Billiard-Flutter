import 'dart:math';
import 'package:flutter/material.dart';
import '../../../api/billiard_halls_api.dart';
import '../details/detail.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Random random = Random(); // Khởi tạo đối tượng random để chọn ngẫu nhiên ảnh

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

  @override
  Widget build(BuildContext context) {
    int imageIndex = random.nextInt(50) + 1; // Chọn ngẫu nhiên số từ 1 đến 50
    String imagePath = 'assets/images/$imageIndex.jpg'; // Đường dẫn đến ảnh

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
              backgroundImage: AssetImage(imagePath), // Sử dụng hình ảnh ngẫu nhiên từ 1 đến 50
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        decoration: InputDecoration(
                          hintText: "Where are you going?",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryItem(Icons.place, "Best Place"),
                  _buildCategoryItem(Icons.check, "Check-in"),
                  _buildCategoryItem(Icons.local_offer, "Voucher"),
                ],
              ),
              const SizedBox(height: 20),
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
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No data available"));
                  }
                  return SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var hall = snapshot.data![index];
                        var address = hall['address'];
                        var districtAndCity = '${address['district']}, ${address['city']}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildDestinationCard(
                            context,
                            hall['name'],
                            districtAndCity,
                            Colors.orange,
                            'assets/images/bg-card.jpg',
                            double.tryParse(hall['rating']?.toString() ?? '0') ?? 0.0,
                            double.tryParse(hall['price_per_hour']?.toString() ?? '0') ?? 0.0,
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
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No data available"));
                  }
                  return SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var hall = snapshot.data![index];
                        var address = hall['address'];
                        var districtAndCity = '${address['district']}, ${address['city']}';
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildDestinationCard(
                            context,
                            hall['name'],
                            districtAndCity,
                            Colors.purpleAccent,
                            'assets/images/bg-card.jpg',
                            double.tryParse(hall['rating']?.toString() ?? '0') ?? 0.0,
                            double.tryParse(hall['price_per_hour']?.toString() ?? '0') ?? 0.0,
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

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
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
          style: TextStyle(fontSize: 16),
        ),
      ],
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
    // Chọn ngẫu nhiên số từ 1 đến 50 để sử dụng hình ảnh tương ứng
    int imageIndex = random.nextInt(50) + 1;
    String randomImagePath = 'assets/images/$imageIndex.jpg'; // Đường dẫn đến ảnh

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: title,
              location: location,
              color: color,
              hallId: hallId,
              imagePath: randomImagePath, // Truyền hình ảnh ngẫu nhiên
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
                randomImagePath, // Sử dụng hình ảnh ngẫu nhiên
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
                Icon(Icons.star, color: Colors.orange, size: 18),
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
              '${pricePerHour.toStringAsFixed(0)}.000 VND / hour',
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
