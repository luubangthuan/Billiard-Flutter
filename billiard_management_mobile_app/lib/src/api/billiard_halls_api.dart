import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class BilliardHallAPI {
  // Lấy tất cả các billiard halls
  static Future<http.Response> getAllBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse(BILLIARD_HALL_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Lấy các billiard halls có rating cao (4 sao trở lên)
  static Future<http.Response> getHighRatingBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/high_rating'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Lấy các billiard halls có độ phổ biến cao (popular từ 60 trở lên)
  static Future<http.Response> getHighPopularBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/high_popular'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Lấy thông tin một billiard hall theo ID
  static Future<http.Response> getBilliardHallByIDRequest(String id) async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Thêm mới một billiard hall
  static Future<http.Response> addBilliardHallRequest(
      String name,
      String longitude,
      String latitude,
      double rating,
      Map<String, String> address,
      double pricePerHour,
      String vibeShortDescription,
      int popular, // Thêm trường popular
      String typeHalls, // Thêm trường type_halls
      ) async {

    var reqBody = {
      "name": name,
      "longitude": longitude,
      "latitude": latitude,
      "rating": rating,
      "address": {
        "street": address["street"],
        "district": address["district"],
        "city": address["city"],
      },
      "price_per_hour": pricePerHour,
      "vibe_short_description": vibeShortDescription,
      "popular": popular, // Thêm popular
      "type_halls": typeHalls, // Thêm type_halls
    };

    var response = await http.post(
      Uri.parse(BILLIARD_HALL_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  // Cập nhật thông tin billiard hall theo ID
  static Future<http.Response> updateBilliardHallRequest(
      String id,
      String name,
      String longitude,
      String latitude,
      double rating,
      Map<String, String> address,
      double pricePerHour,
      String vibeShortDescription,
      int popular, // Thêm trường popular
      String typeHalls, // Thêm trường type_halls
      ) async {

    var reqBody = {
      "name": name,
      "longitude": longitude,
      "latitude": latitude,
      "rating": rating,
      "address": {
        "street": address["street"],
        "district": address["district"],
        "city": address["city"],
      },
      "price_per_hour": pricePerHour,
      "vibe_short_description": vibeShortDescription,
      "popular": popular, // Thêm popular
      "type_halls": typeHalls, // Thêm type_halls
    };

    var response = await http.put(
      Uri.parse('$BILLIARD_HALL_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  // Xóa một billiard hall theo ID
  static Future<http.Response> deleteBilliardHallRequest(String id) async {
    var response = await http.delete(
      Uri.parse('$BILLIARD_HALL_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }
}
