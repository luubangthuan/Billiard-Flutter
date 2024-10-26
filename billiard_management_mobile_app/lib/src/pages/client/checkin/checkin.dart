import 'package:billiard_management_mobile_app/src/pages/client/checkin/checkin_detail.dart';

import '../../../api/booking_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class CheckinPage extends StatefulWidget {
  static const routeName = '/checkin';

  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  Map<String, dynamic>? userInfo;
  List<dynamic> bookedHalls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString('user_info');

    if (userInfoString != null) {
      Map<String, dynamic> storedUserInfo = jsonDecode(userInfoString);
      setState(() {
        userInfo = storedUserInfo;
      });
      _fetchBookingsByPhone(storedUserInfo['phone']);
    } else {
      print("No user info found in SharedPreferences");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBookingsByPhone(String phone) async {
    try {
      var response = await BookingAPI.getBookingByPhoneRequest(phone);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          bookedHalls = data['data'];
          isLoading = false;
        });
        print(bookedHalls);
      } else {
        print("Error fetching bookings: ${response.statusCode}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Check-in",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Booked Billiard Halls",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookedHalls.isEmpty
                    ? const Center(child: Text("No bookings available"))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: bookedHalls.length,
                          itemBuilder: (context, index) {
                            var hall = bookedHalls[index];
                            return _buildCheckinCard(
                              context,
                              hall,
                              'assets/images/${index + 1}.jpg', // Placeholder for images
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckinCard(
    BuildContext context,
    Map<String, dynamic> hallData,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckinDetailPage(
              hallName: hallData['hallInfo']['hall_id']['name'],
              hallLocation:
                  '${hallData['hallInfo']['hall_id']['address']['street']}, ${hallData['hallInfo']['hall_id']['address']['district']}, ${hallData['hallInfo']['hall_id']['address']['city']}',
              bookingDate: DateFormat('yyyy-MM-dd').format(
                DateTime.parse(hallData['bookingInfo']['bookingTime']),
              ),
              pricePerHour:
                  (hallData['hallInfo']['hall_id']['price_per_hour'] as num)
                      .toDouble(),
              imagePath: imagePath,
              description: hallData['hallInfo']['hall_id']
                  ['vibe_short_description'],
              personName: hallData['personInfo']['name'],
              phone: hallData['personInfo']['phone'],
              tableType: hallData['bookingInfo']['tableType'],
              totalPayment: (hallData['totalPayment'] as num).toDouble(),
              typeHall: hallData['hallInfo']['hall_id']['type_halls'],
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
                    hallData['hallInfo']['hall_id']['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Booking Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(hallData['bookingInfo']['bookingTime']))}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hallData['hallInfo']['hall_id']['address']['street']}, ${hallData['hallInfo']['hall_id']['address']['district']}, ${hallData['hallInfo']['hall_id']['address']['city']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(hallData['hallInfo']['hall_id']['price_per_hour']).trim()} VND / hour',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
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
