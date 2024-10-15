import 'package:billiard_management_mobile_app/src/api/booking_api.dart';
import 'package:billiard_management_mobile_app/src/helpers/datetime_helper.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/defaultFooter.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:billiard_management_mobile_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ClientBookingListView extends StatefulWidget {
  static const routeName = 'client/booking';
  final String token;

  const ClientBookingListView({required this.token, Key? key}) : super(key: key);

  @override
  State<ClientBookingListView> createState() => _ClientBookingListViewState();
}

class _ClientBookingListViewState extends State<ClientBookingListView> {
  late String currentUserPhone;
  late String currentUserFullName;
  late String currentUserID;

  List? bookingList;
  DateTime _dateTime = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    currentUserPhone = jwtDecodedToken['phone'];
    currentUserFullName = jwtDecodedToken['fullname'];
    currentUserID = jwtDecodedToken['_id'];

    _getBookingList();
  }

  void _getBookingList() async {
    try {
      var response = await BookingAPI.getAllBookingsRequest();
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        bookingList = jsonResponse['data'];
      });
    } catch (error) {
      print("Error fetching booking list: $error");
    }
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, StateSetter setState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý đặt bàn',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Body
                Expanded(
                  flex: 8,
                  child: bookingList == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                      itemCount: bookingList!.length,
                      itemBuilder: (context, int index) {
                        var userInfor = bookingList![index]['userInfor'];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16), // Khoảng cách giữa các item
                          padding: const EdgeInsets.all(16), // Padding cho từng item
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15), // Bo tròn góc
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              userInfor != null
                                  ? '${userInfor['fullname']} (${userInfor['phone']})'
                                  : "",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thời gian đặt: ${DateTimeConverter.fromMongoDBDisplayText(bookingList![index]['createdDate'])}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                Text(
                                  'Thời gian đến: ${DateTimeConverter.fromMongoDBDisplayText(bookingList![index]['arrivalTime'])}',
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                // Footer
                Container(
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      'Phần mềm quản lý quán bi-a',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // FloatingActionButton
            Positioned(
              bottom: 80, // Điều chỉnh khoảng cách từ bottom để nút nâng lên
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  _showBookingFormDialog(context);
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingFormDialog(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    phoneController.text = currentUserPhone;
    fullNameController.text = currentUserFullName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bo tròn góc của dialog
              ),
              title: const Text(
                'Thêm đơn đặt bàn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    enabled: false,
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: "Số điện thoại",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: "Tên người đặt",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thời gian: ${_dateTime.day}-${_dateTime.month} / ${_time.format(context)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today, color: Colors.blue),
                        onPressed: () => _selectDate(context, setState),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time, color: Colors.blue),
                        onPressed: () => _selectTime(context, setState),
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Lưu',
                    style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    final phoneTxt = phoneController.text;
                    final fullNameTxt = fullNameController.text;
                    String arrivalTime =
                    DateTimeConverter.toMongoDB(_dateTime, _time);
                    Response response;

                    response = await BookingAPI.addNewBookingRequest(
                        phoneTxt, fullNameTxt, arrivalTime);

                    if (response.statusCode == 200) {
                      Future.delayed(Duration.zero, () {
                        CustomDialog.showSuccessDialog(
                            context, '($phoneTxt) Thêm đơn đặt bàn thành công');
                      });
                      _getBookingList();
                    } else {
                      Future.delayed(Duration.zero, () {
                        CustomDialog.showErrorDialog(context, "Có lỗi xảy ra!");
                      });
                    }
                  },
                ),
                TextButton(
                  child: const Text(
                    'Hủy',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
