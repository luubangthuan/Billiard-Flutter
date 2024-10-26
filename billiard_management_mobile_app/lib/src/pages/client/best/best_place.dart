import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../api/billiard_halls_api.dart';
import '../details/detail.dart';

class BestPlacePage extends StatefulWidget {
  static const routeName = '/near-location';

  @override
  _BestPlacePageState createState() => _BestPlacePageState();
}

class _BestPlacePageState extends State<BestPlacePage> {
  List<dynamic> nearbyHalls = [];
  bool isLoading = true;
  late Position _currentPosition;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _fetchNearbyHalls();
  }

  Future<void> _fetchNearbyHalls() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = position;
      });
      // double latitude = position.latitude;
      // double longitude = position.longitude;
      double latitude = 13.0285;
      double longitude = 106.4794;

      var response = await BilliardHallAPI.getNearbyBilliardHallsRequest(
        latitude: latitude,
        longitude: longitude,
        maxDistance: 500000,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          nearbyHalls = data['data'];
          _markers = [
            // Adding markers for each hall
            ...nearbyHalls.map((hall) {
              return Marker(
                point: LatLng(hall['location']['latitude'],
                    hall['location']['longitude']),
                width: 80,
                height: 80,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              );
            }).toList(),
            // Marker for the user's location
            Marker(
              point:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              width: 80,
              height: 80,
              builder: (ctx) => const Icon(
                Icons.my_location, // A distinct icon for the user’s location
                color: Colors.blue, // Different color for the user marker
                size: 40,
              ),
            ),
          ];
          isLoading = false;
        });
      } else {
        print("Error fetching nearby halls: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check the permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // If permissions are denied forever, show an error
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permission is granted, get the current position
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Near Your Location",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(_currentPosition.latitude,
                          _currentPosition.longitude),
                      zoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: _markers,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: nearbyHalls.isEmpty
                      ? const Center(child: Text("No nearby halls found"))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: nearbyHalls.length,
                            itemBuilder: (context, index) {
                              var hall = nearbyHalls[index];
                              return _buildHallCard(
                                context,
                                hall['name'],
                                '${hall['address']['street']}, ${hall['address']['district']}, ${hall['address']['city']}',
                                hall['vibe_short_description'] ?? '',
                                hall['rating']?.toDouble() ?? 0.0,
                                hall['price_per_hour']?.toDouble() ?? 0.0,
                                hall['_id'],
                                'assets/images/${index % 50 + 1}.jpg',
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildHallCard(
    BuildContext context,
    String hallName,
    String hallLocation,
    String vibeDescription,
    double rating,
    double pricePerHour,
    String hallId,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              color: Colors.orange,
              hallId: hallId,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hallName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hallLocation,
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
                  const SizedBox(height: 8),
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
                      const Spacer(),
                      Text(
                        '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(pricePerHour)} VND / hour',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
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
