import 'dart:convert';

import 'package:billiard_management_mobile_app/src/api/user_api.dart';
import 'package:billiard_management_mobile_app/src/pages/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../settings/settings_view.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  bool _isValid = false;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _checkValidity() {
    final String fullname = _fullnameController.text;
    final String phone = _phoneController.text;
    final String password = _passwordController.text;

    if (fullname.length >= 3 && phone.length >= 8 && password.length >= 5) {
      _isValid = true;
    } else {
      _isValid = false;
    }

    setState(() {});
  }

  void _register(String fullname, String phone, String password) async {
    final fullname = _fullnameController.text;
    final phone = _phoneController.text;
    final password = _passwordController.text;

    var response = await UserAPI.registerUserRequest(fullname, phone, password);

    if (response.statusCode == 409) {
      CustomDialog.showErrorDialog(
          context, 'Tài khoản đã tồn tại. Vui lòng chọn tài khoản khác.');
    }

    var jsonResponse = jsonDecode(response.body);
    var dataResponse = jsonResponse['data'];

    CustomDialog.showSuccessDialog(
        context,
        'Đăng ký thành công với số điện thoại: ' + dataResponse['phone']);

    _clearAll();
  }

  void _clearAll() {
    _fullnameController.text = "";
    _phoneController.text = "";
    _passwordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền giống trang Home
      appBar: AppBar(
        title: const Text(
          'Đăng ký',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Màu đen cho tiêu đề
        ),
        centerTitle: true, // Canh giữa tiêu đề
        backgroundColor: Colors.transparent, // Không có màu nền cho AppBar
        elevation: 0, // Loại bỏ bóng của AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orange), // Icon màu cam
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Căn chỉnh toàn bộ phần tử
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tạo tài khoản mới',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black), // Màu đen
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _fullnameController,
                  onChanged: (_) => _checkValidity(),
                  decoration: InputDecoration(
                    labelText: "Họ tên",
                    prefixIcon: const Icon(Icons.person, color: Colors.orange), // Icon màu cam
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Góc bo tròn
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _phoneController,
                  onChanged: (_) => _checkValidity(),
                  decoration: InputDecoration(
                    labelText: "Số điện thoại",
                    prefixIcon: const Icon(Icons.phone, color: Colors.orange), // Icon màu cam
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Góc bo tròn
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  onChanged: (_) => _checkValidity(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    prefixIcon: const Icon(Icons.lock, color: Colors.orange), // Icon màu cam
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isValid
                      ? () => _register(_fullnameController.text, _phoneController.text, _passwordController.text)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15), // Độ cao của nút
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Góc bo tròn
                    ),
                    backgroundColor: _isValid ? Colors.orange : Colors.grey, // Màu nền nút dựa trên điều kiện
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 18, color: Colors.white), // Màu trắng cho text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
