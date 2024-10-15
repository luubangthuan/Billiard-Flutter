import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart'; // Đường dẫn tới file config chứa URL API của bạn

class TableAPI {
  // Lấy tất cả các table
  static Future<http.Response> getAllTablesRequest() async {
    var response = await http.get(
      Uri.parse(TABLE_API_URL),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  // Lấy table theo ID
  static Future<http.Response> getTableByIdRequest(String id) async {
    var response = await http.get(
      Uri.parse('$TABLE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  // Tạo mới table
  static Future<http.Response> addTableRequest(
      String name,
      int amount,
      List<String> hallIds, // List of billiard hall IDs
      int numberOfTables,
      String status,
      ) async {
    var reqBody = {
      "name": name,
      "amount": amount,
      "hall_id": hallIds, // Danh sách ID các billiard halls
      "number_of_tables": numberOfTables,
      "status": status,
    };

    var response = await http.post(
      Uri.parse(TABLE_API_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  // Cập nhật thông tin table theo ID
  static Future<http.Response> updateTableRequest(
      String id,
      String name,
      int amount,
      List<String> hallIds, // List of billiard hall IDs
      int numberOfTables,
      String status,
      ) async {
    var reqBody = {
      "name": name,
      "amount": amount,
      "hall_id": hallIds, // Danh sách ID các billiard halls
      "number_of_tables": numberOfTables,
      "status": status,
    };

    var response = await http.put(
      Uri.parse('$TABLE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    return response;
  }

  // Xóa table theo ID
  static Future<http.Response> deleteTableRequest(String id) async {
    var response = await http.delete(
      Uri.parse('$TABLE_API_URL/$id'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  // Lấy tất cả table theo hall_id
  static Future<http.Response> getTablesByHallIdRequest(String hallId) async {
    var response = await http.get(
      Uri.parse('$TABLE_API_URL/hall/$hallId'),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }
}
