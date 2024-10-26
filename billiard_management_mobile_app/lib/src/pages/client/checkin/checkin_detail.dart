import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckinDetailPage extends StatelessWidget {
  final String hallName;
  final String hallLocation;
  final String bookingDate;
  final double pricePerHour;
  final String imagePath;
  final String description;
  final String personName;
  final String phone;
  final String tableType;
  final double totalPayment;
  final String typeHall;

  const CheckinDetailPage({
    Key? key,
    required this.hallName,
    required this.hallLocation,
    required this.bookingDate,
    required this.pricePerHour,
    required this.imagePath,
    required this.description,
    required this.personName,
    required this.phone,
    required this.tableType,
    required this.totalPayment,
    required this.typeHall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Check-in Detail",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hall Image
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // Hall Information
              _buildInfoSection("Hall Information", [
                _buildInfoRow(Icons.location_on, hallName, Colors.orange),
                _buildInfoRow(Icons.place, hallLocation, Colors.grey),
                _buildInfoRow(
                  Icons.star,
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(pricePerHour)} VND / hour',
                  Colors.orange,
                ),
              ]),
              const SizedBox(height: 20),
              // Person Information
              _buildInfoSection("Person Information", [
                _buildInfoRow(Icons.person, "Name: $personName", Colors.black87),
                _buildInfoRow(Icons.phone, "Phone: $phone", Colors.black87),
              ]),
              const SizedBox(height: 20),
              // Booking Information
              _buildInfoSection("Booking Information", [
                _buildInfoRow(Icons.table_chart, "Table Type: $tableType", Colors.black87),
                _buildInfoRow(Icons.pool, "Type of Hall: $typeHall", Colors.black87),
                _buildInfoRow(
                  Icons.date_range,
                  "Booking Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(bookingDate))}",
                  Colors.black87,
                ),
              ]),
              const SizedBox(height: 20),
              // Payment Information
              _buildInfoSection("Payment Information", [
                _buildInfoRow(
                  Icons.payment,
                  'Total Payment: ${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(totalPayment)} VND',
                  Colors.black87,
                ),
              ]),
              const SizedBox(height: 20),
              // Description
              _buildInfoSection("Description", [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
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
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
