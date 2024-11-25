import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../screens/login_screen.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'conversion_screen.dart';
import 'suggestions_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({required this.userId});

  String getUsername() {
    return 'Muhammad Haizuma & Jianfaghna Rulvy Haqi';
  }

  void logout(BuildContext context) {
    final sessionBox = Hive.box('sessionBox');
    sessionBox.delete('userId');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

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
      currentIndex: 4,
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
            navigateToScreen(context, SuggestionsScreen(userId: userId));
            break;
          case 4:
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
          'Profil',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                '$userId',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                getUsername(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'NIM: 124220084 & 124220105',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () => logout(context),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }
}
