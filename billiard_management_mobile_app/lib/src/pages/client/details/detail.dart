import '../booking/booking_page.dart';
import '../chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DetailPage extends StatelessWidget {
  final String title;
  final String location;
  final Color color;
  final String hallId;
  final String imagePath;

  const DetailPage({
    Key? key,
    required this.title,
    required this.location,
    required this.color,
    required this.hallId,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.orange, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  distanceWidget(),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_offer, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      "Limited time offer! 10% discount",
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Today's visitor forecast",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildVisitorForecast('8AM', 0.3),
                  _buildVisitorForecast('', 0.5),
                  _buildVisitorForecast('', 0.7),
                  _buildVisitorForecast('11AM', 0.8),
                  _buildVisitorForecast('', 0.9),
                  _buildVisitorForecast('', 0.85),
                  _buildVisitorForecast('2PM', 1.0),
                  _buildVisitorForecast('', 0.7),
                  _buildVisitorForecast('', 0.6),
                  _buildVisitorForecast('5PM', 0.3),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Popular Spots",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(5, (index) {
                    // Randomly generate a number between 1 and 50
                    int randomImageIndex = Random().nextInt(50) + 1;
                    final randomImagePath = 'assets/images/$randomImageIndex.jpg'; // Generate path like assets/images/1.jpg
                    return _buildImageItem(randomImagePath);
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatPage()), // Navigate to ChatPage
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return BookingBottomSheet(hallId: hallId); // Pass hallId to BookingBottomSheet
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Book Now",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorForecast(String time, double percentage) {
    return Column(
      children: [
        SizedBox(
          height: 150 * percentage,
          child: Container(
            width: 25,
            decoration: BoxDecoration(
              color: Colors.orange[400],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(time),
      ],
    );
  }

  Widget _buildImageItem(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget distanceWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.navigation_rounded, color: Colors.orange, size: 16),
          const SizedBox(width: 4),
          Text(
            '4 km',
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final String hallId;

  const BookingBottomSheet({Key? key, required this.hallId}) : super(key: key);

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> with SingleTickerProviderStateMixin {
  TimeOfDay? _selectedTime;
  List<String> tableTypes = ['Aileex', 'Diamond Aileex', 'Hero Mr-Sung', 'OX Rasson', 'Vitory II Plus Rasson'];
  String? selectedTableType;
  late TabController _tabController;
  int _activeStep = 0;
  TextEditingController _timeController = TextEditingController();
  int _selectedHour = 1;
  int _selectedMinute = 0;
  String personName = '';
  String personPhone = '';
  List<dynamic> selectedExtras = [];

  @override
  void initState() {
    super.initState();
    selectedTableType = tableTypes[0];
    _tabController = TabController(length: 4, vsync: this);
    _timeController.text = 'Select Time';
  }

  @override
  void dispose() {
    _timeController.dispose(); // Dispose controller
    super.dispose();
  }

  void _nextTab() {
    if (_activeStep < 3) {
      setState(() {
        _activeStep++;
        _tabController.animateTo(_activeStep);
      });
    }
  }

  void _previousTab() {
    if (_activeStep > 0) {
      setState(() {
        _activeStep--;
        _tabController.animateTo(_activeStep);
      });
    }
  }

  void _confirmBooking() {
    print("Person Info:");
    print("Name: $personName");
    print("Phone: $personPhone");

    print("Booking Info:");
    print("Table Type: $selectedTableType");
    print("Booking Time: ${_timeController.text} at $_selectedHour:$_selectedMinute");

    print("Extras:");
    print(widget.hallId);
    print(selectedExtras);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            WillPopScope(
              onWillPop: () async => false,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Person Info"),
                  Tab(text: "Booking Info"),
                  Tab(text: "Extras"),
                  Tab(text: "Payment"),
                ],
                indicatorColor: Colors.orange,
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                onTap: (index) {
                  if (index != _activeStep) {
                    _tabController.animateTo(_activeStep);
                  }
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonInfoTab(),
                  _buildBookingInfoTab(),
                  _buildExtrasTab(),
                  _buildPaymentTab(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_activeStep > 0)
                  TextButton(
                    onPressed: _previousTab,
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ),
                if (_activeStep < 3)
                  ElevatedButton(
                    onPressed: _nextTab,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                if (_activeStep == 3)
                  ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPersonInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Person Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                personName = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                personPhone = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingInfoTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Booking Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Booking Time',
              border: OutlineInputBorder(),
            ),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
              );

              if (pickedTime != null) {
                setState(() {
                  _selectedTime = pickedTime;
                  _selectedHour = pickedTime.hour;
                  _selectedMinute = pickedTime.minute;
                  _timeController.text = _selectedTime!.format(context);
                });
              }
            },
            controller: _timeController,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Hours',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedHour,
                  items: List.generate(24, (index) => index).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Hours'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedHour = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Minutes',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedMinute,
                  items: List.generate(60, (index) => index).map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value Minutes'),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMinute = newValue;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasTab() {
    List<dynamic> foodData = [
      {"name": "Pizza", "price": 100000},
      {"name": "Burger", "price": 50000}
    ];
    List<dynamic> drinkData = [
      {"name": "Coke", "price": 20000},
      {"name": "Beer", "price": 30000}
    ];
    List<dynamic> othersData = [
      {"name": "Chips", "price": 10000},
      {"name": "Cookies", "price": 20000}
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Select Extras', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildExtrasCard('Food', foodData, 4),
          const SizedBox(height: 20),
          _buildExtrasCard('Drink', drinkData, 4),
          const SizedBox(height: 20),
          _buildExtrasCard('Others', othersData, 4),
        ],
      ),
    );
  }

  Widget _buildExtrasCard(String category, List<dynamic> items, int limit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: items.take(limit).map((item) {
                    int quantity = 0;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Image.asset('assets/images/bg-card.jpg', width: 50, height: 50),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text("${item['price']} VND"),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 0) {
                                        setState(() {
                                          quantity--;
                                          selectedExtras.remove(item);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(quantity.toString()),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                        selectedExtras.add(item);
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTab() {
    double baseRatePerHour = 50000;
    double discountPercentage = 0.05;

    double totalBookingHours = _selectedHour + (_selectedMinute / 60);
    double extrasTotal = selectedExtras.fold(0, (sum, item) => sum + item['price']);

    double totalBeforeDiscount = (baseRatePerHour * totalBookingHours) + extrasTotal;
    double discountAmount = totalBeforeDiscount * discountPercentage;
    double totalAfterDiscount = totalBeforeDiscount - discountAmount;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Payment Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name:', style: TextStyle(fontSize: 16)),
              Text(personName, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Phone Number:', style: TextStyle(fontSize: 16)),
              Text(personPhone, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Start Time:', style: TextStyle(fontSize: 16)),
              Text(_timeController.text, style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total (per hour):', style: TextStyle(fontSize: 16)),
              Text('${baseRatePerHour.toStringAsFixed(0)} VND', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Booking Time:', style: TextStyle(fontSize: 16)),
              Text('${totalBookingHours.toStringAsFixed(2)} hours', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Extras:', style: TextStyle(fontSize: 16)),
              Text('${extrasTotal.toStringAsFixed(0)} VND', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Discount:', style: TextStyle(fontSize: 16)),
              Text('5%', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Payment:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${totalAfterDiscount.toStringAsFixed(0)} VND', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),


        ],
      ),
    );
  }
}
