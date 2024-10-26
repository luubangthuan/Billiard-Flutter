import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import '../../../api/billiard_halls_api.dart';
import '../details/detail.dart';
import 'package:intl/intl.dart';

class SearchResultPage extends StatefulWidget {
  final String name;
  final String city;
  final String district;
  final String street;

  const SearchResultPage({
    Key? key,
    required this.name,
    required this.city,
    required this.district,
    required this.street,
  }) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  Random random = Random();

  Future<List<dynamic>> fetchSearchResults({
    String? name,
    String? city,
    String? district,
    String? street,
  }) async {
    var response = await BilliardHallAPI.searchBilliardHallsRequest(
      name: name,
      city: city,
      district: district,
      street: street,
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: Text(
          "Results for '${widget.name}'",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchSearchResults(
          name: widget.name,
          city: widget.city,
          district: widget.district,
          street: widget.street,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No results found"));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68, // Adjusted to provide more space
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var hall = snapshot.data![index];
                var address = hall['address'];
                var districtAndCity =
                    '${address['district']}, ${address['city']}';

                return _buildResultCard(
                  context,
                  hall['name'],
                  districtAndCity,
                  Colors.blueAccent,
                  'assets/images/bg-card.jpg',
                  double.tryParse(hall['rating']?.toString() ?? '0') ?? 0.0,
                  double.tryParse(hall['price_per_hour']?.toString() ?? '0') ??
                      0.0,
                  hall['vibe_short_description'] ?? '',
                  hall['_id'] ?? 'default_hall_id',
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultCard(
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
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              const SizedBox(height: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        vibeDescription,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
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
              const SizedBox(height: 8),
              Text(
                '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(pricePerHour).trim()} VND / hour',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
