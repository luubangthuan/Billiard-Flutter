import 'package:flutter/material.dart';
import './tutoral_videos/videolist.dart';
import './tutoral_videos/videoshort.dart';
import './documentary/documentary.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text(
          "Tutorials",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 100),
            _buildCategoryButton(
              context,
              Icons.play_circle_fill,
              "Video",
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoListPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            _buildCategoryButton(
              context,
              Icons.movie,
              "Short Video",
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoShortPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            _buildCategoryButton(
              context,
              Icons.short_text,
              "Documentary",
              Colors.purple,
              () {
                // Handle documentary button press
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentaryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
