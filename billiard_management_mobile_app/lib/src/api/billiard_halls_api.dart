import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class BilliardHallAPI {
  static Future<http.Response> getAllBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse(BILLIARD_HALL_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getHighRatingBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/high_rating'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getHighPopularBilliardHallsRequest() async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/high_popular'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getBilliardHallByIDRequest(String id) async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> searchBilliardHallsRequest({
    String? name,
    String? city,
    String? district,
    String? street,
  }) async {
    String queryParams = '';

    if (name != null) {
      queryParams += 'name=${Uri.encodeComponent(name)}&';
    }
    if (city != null) {
      queryParams += 'city=${Uri.encodeComponent(city)}&';
    }
    if (district != null) {
      queryParams += 'district=${Uri.encodeComponent(district)}&';
    }
    if (street != null) {
      queryParams += 'street=${Uri.encodeComponent(street)}&';
    }

    queryParams = queryParams.isNotEmpty
        ? queryParams.substring(0, queryParams.length - 1)
        : queryParams;

    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/search?$queryParams'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> filterBilliardHallsByTypeRequest(
      String type) async {
    var response = await http.get(
      Uri.parse('$BILLIARD_HALL_API_URL/filter_by_type?type=$type'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  static Future<http.Response> getNearbyBilliardHallsRequest({
    required double latitude,
    required double longitude,
    int maxDistance = 5000,
  }) async {
    var response = await http.get(
      Uri.parse(
          '$BILLIARD_HALL_API_URL/nearby?latitude=$latitude&longitude=$longitude&maxDistance=$maxDistance'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }
}
