import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

import '../api/user_api.dart';
import '../pages/admin/home.dart';
import '../pages/client/home.dart';
import '../pages/signup.dart';
import '../pages/widgets/dialog.dart';
import '../settings/settings_view.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late SharedPreferences prefs;
  late String role;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _login() async {
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (_phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      var response = await UserAPI.loginRequest(phone, password);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);

        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);

        role = jwtDecodedToken['role'];
        if (role == "admin" || role == "staff") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminHomePage(token: myToken)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientHomePage(token: myToken)),
          );
        }
      } else {
        CustomDialog.showErrorDialog(context, 'Something went wrong');
      }
    } else {
      CustomDialog.showErrorDialog(context, 'Vui lòng nhập đủ thông tin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền giống trang Home
      appBar: AppBar(
        title: const Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Màu đen
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, // Không có màu nền cho AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orange), // Icon màu cam
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Padding dọc và ngang
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40), // Thêm khoảng trống
              const Text(
                'Chào mừng trở lại!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Màu đen giống Home
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone, color: Colors.orange), // Icon màu cam
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Góc bo tròn
                    borderSide: BorderSide.none, // Loại bỏ đường viền
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock, color: Colors.orange), // Icon màu cam
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true, // Mật khẩu bị ẩn
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.orange, // Màu nền nút cam
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.restorablePushNamed(context, SignUpPage.routeName);
                },
                child: const Text(
                  'Đăng ký tài khoản mới',
                  style: TextStyle(
                    color: Colors.orange, // Text màu cam
                    decoration: TextDecoration.underline, // Gạch chân
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
