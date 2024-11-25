import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Box userBox = Hive.box('userBox');
  bool _isPasswordVisible = false;

  void _register() {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username dan password tidak boleh kosong.');
      return;
    }

    if (password.length <= 6) {
      _showError('Password harus lebih dari 6 karakter.');
      return;
    }

    if (userBox.containsKey(username)) {
      _showError('Username sudah terdaftar. Silakan pilih username lain.');
      return;
    }

    userBox.put(username, password);

    _showSuccess('Registrasi berhasil! Silakan login.');
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Registrasi Gagal',
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

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Registrasi Berhasil',
          style: TextStyle(color: Colors.green),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'BUAT AKUN',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.person, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
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
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Sudah punya akun? Login di sini',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
