import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class BookingAPI {
  static Future<http.Response> getAllBookingsRequest() async {
    var response = await http.get(
      Uri.parse(BOOKING_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getBookingByIDRequest(String id) async {
    var response = await http.get(
      Uri.parse('$BOOKING_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getBookingByPhoneRequest(String phone) async {
    var response = await http.get(
      Uri.parse('$BOOKING_API_URL/phone/$phone'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> addBookingRequest(
    String name,
    String phone,
    String tableType,
    DateTime bookingTime,
    int amountTimeBooking,
    List<Map<String, dynamic>> extras,
    String hallId,
    double totalPayment,
  ) async {
    var reqBody = {
      "personInfo": {
        "name": name,
        "phone": phone,
      },
      "bookingInfo": {
        "tableType": tableType,
        "bookingTime": bookingTime.toIso8601String(),
        "amountTimeBooking": amountTimeBooking,
        "extras": extras,
      },
      "hallInfo": {
        "hall_id": hallId,
      },
      "totalPayment": totalPayment,
    };

    var response = await http.post(
      Uri.parse(BOOKING_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  static Future<http.Response> updateBookingRequest(
    String id,
    String name,
    String phone,
    String tableType,
    DateTime bookingTime,
    int amountTimeBooking,
    List<Map<String, dynamic>> extras,
    String hallId,
  ) async {
    var reqBody = {
      "personInfo": {
        "name": name,
        "phone": phone,
      },
      "bookingInfo": {
        "tableType": tableType,
        "bookingTime": bookingTime.toIso8601String(),
        "amountTimeBooking": amountTimeBooking,
        "extras": extras,
      },
      "hallInfo": {
        "hall_id": hallId,
      }
    };

    var response = await http.put(
      Uri.parse('$BOOKING_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  static Future<http.Response> deleteBookingRequest(String id) async {
    var response = await http.delete(
      Uri.parse('$BOOKING_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }
}
