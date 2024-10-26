import '../chat/chat_page.dart';
import '../../../api/billiard_halls_api.dart';
import '../../../api/user_api.dart';
import '../../../api/service_api.dart';
import '../../../api/booking_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final Color color;
  final String hallId;
  final String imagePath;

  const DetailPage({
    Key? key,
    required this.color,
    required this.hallId,
    required this.imagePath,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? data;
  Map<String, dynamic>? userInfo;
  bool isBookmarked = false;
  List<dynamic> foodData = [];
  List<dynamic> drinkData = [];
  List<dynamic> othersData = [];
  List<Map<String, dynamic>> services = [];
  TextEditingController personNameController = TextEditingController();
  TextEditingController personPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBilliardHallDetails();
    _loadUserInfo();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks = prefs.getStringList('bookmarked_halls');
    if (savedBookmarks != null) {
      setState(() {
        isBookmarked = savedBookmarks.contains(widget.hallId);
      });
    }
  }

  Future<void> _toggleBookmark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBookmarks =
        prefs.getStringList('bookmarked_halls') ?? [];

    setState(() {
      if (isBookmarked) {
        savedBookmarks.remove(widget.hallId);
        isBookmarked = false;
      } else {
        savedBookmarks.add(widget.hallId);
        isBookmarked = true;
      }
    });

    await prefs.setStringList('bookmarked_halls', savedBookmarks);
  }

  Future<void> _fetchBilliardHallDetails() async {
    try {
      var response =
          await BilliardHallAPI.getBilliardHallByIDRequest(widget.hallId);
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
        });
        List<dynamic> services = data?['data']?['services'] ?? [];
        for (var service in services) {
          String serviceId = service['service_id'];
          await _fetchServiceById(serviceId);
        }
        _filterServicesByType();
      } else {
        print(
            "Failed to load billiard hall details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching billiard hall details: $e");
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoString = prefs.getString('user_info');

    if (userInfoString != null) {
      Map<String, dynamic> storedUserInfo = jsonDecode(userInfoString);
      setState(() {
        userInfo = storedUserInfo;
      });
      await _fetchUserByPhone(storedUserInfo['phone']);
    } else {
      print("No user info found in SharedPreferences");
    }
  }

  Future<void> _fetchUserByPhone(String phone) async {
    try {
      var response = await UserAPI.getUserByPhoneRequest(phone);
      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          personNameController.text = userData['data']['fullname'] ?? '';
          personPhoneController.text = userData['data']['phone'] ?? '';
        });
      } else if (response.statusCode == 404) {
        print("User not found");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching user by phone: $e");
    }
  }

  Future<void> _fetchServiceById(String serviceId) async {
    try {
      var response = await ServiceAPI.getServiceByIDRequest(serviceId);
      if (response.statusCode == 200) {
        var serviceData = json.decode(response.body);

        setState(() {
          services.add(serviceData);
        });
      } else {
        print(
            "Failed to load service details. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching service details: $e");
    }
  }

  void _filterServicesByType() {
    for (var service in services) {
      var serviceData = service['data'];
      if (serviceData != null) {
        var type = serviceData['type'];
        var name = serviceData['name'];
        var price = serviceData['price'];

        if (type == 'food') {
          foodData.add({"name": name, "price": price});
        } else if (type == 'drink') {
          drinkData.add({"name": name, "price": price});
        } else if (type == 'others') {
          othersData.add({"name": name, "price": price});
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                // Toggle based on state
                color: Colors.orange,
              ),
              onPressed: _toggleBookmark, // Call the toggle function
            ),
          ],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              // Toggle based on state
              color: Colors.orange,
            ),
            onPressed: _toggleBookmark, // Call the toggle function
          ),
        ],
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
                  color: widget.color.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?['data']?['name'] ?? 'No name available',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.orange, size: 20),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${data?['data']?['address']?['street'] ?? 'No street'}, '
                                '${data?['data']?['address']?['district'] ?? 'No district'}, '
                                '${data?['data']?['address']?['city'] ?? 'No city'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                child: const Row(
                  children: [
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
                    final randomImagePath =
                        'assets/images/$randomImageIndex.jpg';
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
                      icon: const Icon(Icons.chat_bubble_outline,
                          color: Colors.orange),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatPage()),
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return BookingBottomSheet(
                              foodData: foodData,
                              drinkData: drinkData,
                              othersData: othersData,
                              hallId: widget.hallId,
                              personNameController: personNameController,
                              services: services,
                              personPhoneController: personPhoneController,
                            );
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
            style: const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final String hallId;
  final TextEditingController personNameController;
  final TextEditingController personPhoneController;
  final List<dynamic> foodData;
  final List<dynamic> drinkData;
  final List<dynamic> othersData;
  final List<Map<String, dynamic>> services;

  const BookingBottomSheet({
    Key? key,
    required this.foodData,
    required this.drinkData,
    required this.othersData,
    required this.hallId,
    required this.personNameController,
    required this.personPhoneController,
    required this.services,
  }) : super(key: key);

  @override
  _BookingBottomSheetState createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet>
    with SingleTickerProviderStateMixin {
  TimeOfDay? _selectedTime;
  double totalAfterDiscount = 0;
  List<String> tableTypes = [
    'Aileex',
    'Diamond Aileex',
    'Hero Mr-Sung',
    'OX Rasson',
    'Vitory II Plus Rasson'
  ];
  String? selectedTableType;
  late TabController _tabController;
  int _activeStep = 0;
  TextEditingController _timeController = TextEditingController();
  int _selectedHour = 1;
  int _selectedMinute = 0;
  List<dynamic> selectedExtras = [];

  @override
  void initState() {
    super.initState();
    selectedTableType = tableTypes[0];
    _tabController = TabController(length: 4, vsync: this);
    _selectedTime = TimeOfDay.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timeController.text = _selectedTime!.format(context);
  }

  @override
  void dispose() {
    _timeController.dispose();
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

  Future<void> _confirmBooking() async {
    String name = widget.personNameController.text;
    String phone = widget.personPhoneController.text;

    String tableType = selectedTableType!;
    DateTime now = DateTime.now();
    DateTime bookingTime =
        DateFormat('HH:mm').parse(_timeController.text).copyWith(
              year: now.year,
              month: now.month,
              day: now.day,
            );
    int amountTimeBooking = _selectedHour * 60 + _selectedMinute;
    double totalPayment = totalAfterDiscount;

    List<Map<String, dynamic>> extras = selectedExtras.map((extra) {
      return {
        "name": extra['name'],
        "price": extra['price'],
      };
    }).toList();

    String hallId = widget.hallId;

    // Gọi API thêm booking
    var response = await BookingAPI.addBookingRequest(
      name,
      phone,
      tableType,
      bookingTime,
      amountTimeBooking,
      extras,
      hallId,
      totalPayment,
    );

    // Xử lý kết quả response
    if (response.statusCode == 201) {
      print("Booking created successfully");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created successfully')),
      );
      Navigator.of(context).pop();
    } else {
      // Nếu tạo booking thất bại
      print("Failed to create booking: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking: ${response.body}')),
      );
    }
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
          const Text('Person Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.personNameController,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                widget.personNameController.text = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.personPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                widget.personPhoneController.text = value;
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
          const Text('Booking Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                initialTime:
                    TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Select Extras',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildExtrasCard('Food', widget.foodData, 10),
          const SizedBox(height: 20),
          _buildExtrasCard('Drink', widget.drinkData, 10),
          const SizedBox(height: 20),
          _buildExtrasCard('Others', widget.othersData, 10),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
                              Image.asset('assets/images/bg-card.jpg',
                                  width: 50, height: 50),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(item['price']).trim()} VND',
                                    ),
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
    double extrasTotal =
        selectedExtras.fold(0, (sum, item) => sum + item['price']);

    double totalBeforeDiscount =
        (baseRatePerHour * totalBookingHours) + extrasTotal;
    double discountAmount = totalBeforeDiscount * discountPercentage;
    totalAfterDiscount = totalBeforeDiscount - discountAmount;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text('Payment Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Name:', style: TextStyle(fontSize: 16)),
              Text(widget.personNameController.text,
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Phone Number:', style: TextStyle(fontSize: 16)),
              Text(widget.personPhoneController.text,
                  style: const TextStyle(fontSize: 16)),
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
              Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(baseRatePerHour).trim()} VND',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Booking Time:', style: TextStyle(fontSize: 16)),
              Text('${totalBookingHours.toStringAsFixed(2)} hours',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Extras:', style: TextStyle(fontSize: 16)),
              Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(extrasTotal).trim()} VND',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount:', style: TextStyle(fontSize: 16)),
              Text('5%', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Payment:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                  '${NumberFormat.currency(locale: 'vi_VN', symbol: '').format(totalAfterDiscount).trim()} VND',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
