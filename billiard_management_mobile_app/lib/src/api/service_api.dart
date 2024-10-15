import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class ServiceAPI {
  // Lấy tất cả các dịch vụ
  static Future<http.Response> getAllServicesRequest() async {
    var response = await http.get(
      Uri.parse(SERVICE_API_URL),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Lấy các dịch vụ theo billiard_halls_id và type (lọc theo ID của billiard halls và type)
  static Future<http.Response> getServicesByBilliardHallIdAndTypeRequest(String billiardHallId, String type) async {
    var response = await http.get(
      Uri.parse('$SERVICE_API_URL/filter?billiard_halls_id=$billiardHallId&type=$type'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Lấy thông tin chi tiết của một dịch vụ theo ID
  static Future<http.Response> getServiceByIDRequest(String id) async {
    var response = await http.get(
      Uri.parse('$SERVICE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }

  // Thêm mới một dịch vụ
  static Future<http.Response> addServiceRequest(
      String name,
      String type,
      List<String> billiardHallsId, // List of billiard halls ID (nhiều halls)
      double price,
      ) async {
    var reqBody = {
      "name": name,
      "type": type,
      "billiard_halls_id": billiardHallsId, // Nhiều halls ID
      "price": price,
    };

    var response = await http.post(
      Uri.parse(SERVICE_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  // Cập nhật thông tin dịch vụ theo ID
  static Future<http.Response> updateServiceRequest(
      String id,
      String name,
      String type,
      List<String> billiardHallsId, // List of billiard halls ID (nhiều halls)
      double price,
      ) async {
    var reqBody = {
      "name": name,
      "type": type,
      "billiard_halls_id": billiardHallsId, // Nhiều halls ID
      "price": price,
    };

    var response = await http.put(
      Uri.parse('$SERVICE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    return response;
  }

  // Xóa một dịch vụ theo ID
  static Future<http.Response> deleteServiceRequest(String id) async {
    var response = await http.delete(
      Uri.parse('$SERVICE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }
}
