import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_setup.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();
  await initHive();
  await Hive.openBox('userBox');
  await Hive.openBox('favorites');
  await Hive.openBox('sessionBox');


  tz.initializeTimeZones();

  
  await NotificationService().init();


  await NotificationService().scheduleMovieNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZOOMFLIX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _checkLoginStatus(),
      routes: {
        '/register': (context) => RegisterScreen(),
      },
    );
  }

  Widget _checkLoginStatus() {
    final sessionBox = Hive.box('sessionBox');
    final String? userId = sessionBox.get('userId');

    if (userId != null && userId.isNotEmpty) {
      return HomeScreen(userId: userId);
    } else {
      return LoginScreen();
    }
  }
}
