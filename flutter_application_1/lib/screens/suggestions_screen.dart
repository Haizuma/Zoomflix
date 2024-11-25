import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'conversion_screen.dart';
import 'profile_screen.dart';

class SuggestionsScreen extends StatelessWidget {
  final String userId;

  SuggestionsScreen({required this.userId});

  void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 30),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 30),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, size: 30),
          label: 'Convert',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline, size: 30),
          label: 'Suggestions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 30),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            navigateToScreen(context, HomeScreen(userId: userId));
            break;
          case 1:
            navigateToScreen(context, FavoriteScreen(userId: userId));
            break;
          case 2:
            navigateToScreen(context, ConversionScreen(userId: userId));
            break;
          case 3:
            break;
          case 4:
            navigateToScreen(context, ProfileScreen(userId: userId));
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Saran dan Kesan',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saran:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            Text(
                '1. Tingkatkan Pemahaman tentang Manajemen Data (Database Lokal, API).',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(
                '2. Penyediaan Sumber Belajar Ekstra atau Tutorial untuk Pengembangan Aplikasi.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            SizedBox(height: 20),
            Text('Kesan:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 10),
            Text('1. Praktis dan Langsung Terjun ke Pengembangan Aplikasi.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(
                '2. Peningkatan Keterampilan Penggunaan Tools seperti Visual Studio Code.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(
                '3. Pemahaman Mendalam tentang Struktur dan Arsitektur Aplikasi Mobile.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text('4. Pengalaman Membuat Aplikasi dengan Fitur Lengkap.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(
                '5. Proyek Kelompok yang Meningkatkan Kemampuan Kolaborasi dalam Tim.',
                style: TextStyle(fontSize: 16, color: Colors.white70)),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }
}
