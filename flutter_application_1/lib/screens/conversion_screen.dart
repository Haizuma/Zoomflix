import 'package:flutter/material.dart';
import 'trailer_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'suggestions_screen.dart';
import 'profile_screen.dart';

class ConversionScreen extends StatefulWidget {
  final String userId;

  ConversionScreen({required this.userId});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final List<String> currencies = [
    'USD',
    'EUR',
    'IDR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'CNY',
    'INR',
    'SGD'
  ];
  String selectedCurrency = 'USD';
  double amount = 0.0;
  String convertedAmount = '';

  final Map<String, double> currencyRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'IDR': 14400.0,
    'JPY': 110.0,
    'GBP': 0.75,
    'AUD': 1.35,
    'CAD': 1.25,
    'CNY': 6.5,
    'INR': 75.0,
    'SGD': 1.35,
  };

  final Map<String, String> timeZones = {
    'WIB': 'GMT+7',
    'WITA': 'GMT+8',
    'WIT': 'GMT+9',
    'London': 'GMT+0',
    'New York': 'GMT-5',
    'Tokyo': 'GMT+9',
    'Paris': 'GMT+1',
    'Sydney': 'GMT+11',
    'Los Angeles': 'GMT-8',
    'Moscow': 'GMT+3',
  };

  String selectedTimeZone = '';
  String currentTime = '';

  void convertCurrency() {
    double rate = currencyRates[selectedCurrency] ?? 1.0;
    setState(() {
      convertedAmount =
          '${(amount * rate).toStringAsFixed(2)} $selectedCurrency';
    });
  }

  void getCurrentTime() {
    if (selectedTimeZone.isEmpty) return;

    DateTime now = DateTime.now().toUtc();
    switch (selectedTimeZone) {
      case 'WIB':
        now = now.add(Duration(hours: 7));
        break;
      case 'WITA':
        now = now.add(Duration(hours: 8));
        break;
      case 'WIT':
        now = now.add(Duration(hours: 9));
        break;
      case 'London':
        now = now.add(Duration(hours: 0));
        break;
      case 'New York':
        now = now.subtract(Duration(hours: 5));
        break;
      case 'Tokyo':
        now = now.add(Duration(hours: 9));
        break;
      case 'Paris':
        now = now.add(Duration(hours: 1));
        break;
      case 'Sydney':
        now = now.add(Duration(hours: 11));
        break;
      case 'Los Angeles':
        now = now.subtract(Duration(hours: 8));
        break;
      case 'Moscow':
        now = now.add(Duration(hours: 3));
        break;
      default:
        break;
    }
    setState(() {
      currentTime = now.toString();
    });
  }

  void navigateToTrailerScreen() {
    if (amount >= 1 && selectedTimeZone.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrailerScreen(userId: widget.userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ISI SEMUA INFORMASI UNTUK MELANJUTKAN',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(userId: widget.userId)),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FavoriteScreen(userId: widget.userId)),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SuggestionsScreen(userId: widget.userId)),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(userId: widget.userId)),
        );
        break;
    }
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 30),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border, size: 30),
          label: 'Favorit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, size: 30),
          label: 'Konversi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline, size: 30),
          label: 'Saran',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, size: 30),
          label: 'Profil',
        ),
      ],
      onTap: navigateToScreen,
    );
  }

  Widget buildSection(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Trailer',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSection(
                'PEMBAYARAN',
                Column(
                  children: [
                    const Text(
                      'Mata uang berdasar pada 1 USD sebagai standar.',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan jumlah',
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          amount = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: selectedCurrency,
                      items: currencies.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurrency = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: convertCurrency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Konversi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hasil Konversi: $convertedAmount',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              buildSection(
                'WAKTU ANDA',
                Column(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value:
                          selectedTimeZone.isNotEmpty ? selectedTimeZone : null,
                      hint: const Text(
                        'Pilih Zona Waktu',
                        style: TextStyle(color: Colors.white70),
                      ),
                      items: timeZones.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTimeZone = value!;
                          getCurrentTime();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    if (selectedTimeZone.isNotEmpty)
                      Text(
                        'Waktu Saat Ini: $currentTime',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: navigateToTrailerScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Lihat Trailer',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'ISI SEMUA INFORMASI UNTUK MELANJUTKAN',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
