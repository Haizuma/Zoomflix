import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_screen.dart';
import '../services/notification_service.dart'; // Import NotificationService

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Box userBox = Hive.box('userBox');
  final Box sessionBox = Hive.box('sessionBox');
  bool _isPasswordVisible = false;

  void _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username dan password tidak boleh kosong.');
      return;
    }

    final storedPassword = userBox.get(username);
    if (storedPassword == null) {
      _showError('Username tidak ditemukan. Silakan daftar terlebih dahulu.');
      return;
    }

    if (storedPassword == password) {
      sessionBox.put('userId', username);

      try {
        // Jadwalkan notifikasi untuk ZOOMFLIX
        await NotificationService().scheduleMovieNotifications();
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }

      // Arahkan ke HomeScreen setelah login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(userId: username)),
      );
    } else {
      _showError('Password salah. Coba lagi.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Login Gagal',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
                const SizedBox(height: 50),
                Text(
                  'SELAMAT DATANG',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan masuk untuk menikmati layanan kami',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[850],
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.person, color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[850],
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.lock, color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Belum punya akun? Daftar di sini',
                    style: TextStyle(color: Colors.red, fontSize: 14),
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
