import 'package:billiard_management_mobile_app/src/pages/client/booking/booking_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/client/bookmark/bookmark.dart';
import 'package:billiard_management_mobile_app/src/pages/client/home/home.dart';
import 'package:billiard_management_mobile_app/src/pages/client/notifications/notifications.dart';
import 'package:billiard_management_mobile_app/src/pages/client/profile/profile.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  static const routeName = 'client/home';

  final String token;
  const ClientHomePage({required this.token, Key? key}) : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  late String currentUserPhone;
  late String currentUserFullName;
  late String currentUserID;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Đảm bảo token có chứa thông tin
  }

  // Danh sách các trang
  static List<Widget> _pages = [
    HomePage(),
    BookmarkPage(),
    NotificationsPage(),
    ProfilesPage(),
  ];

  // Xử lý chuyển trang
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ mục trang hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Hiển thị trang dựa trên chỉ mục
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Chỉ mục trang hiện tại
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped, // Xử lý sự kiện nhấn vào biểu tượng
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
