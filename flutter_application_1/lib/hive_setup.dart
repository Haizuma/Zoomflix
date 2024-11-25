import 'package:flutter_application_1/models/user.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('userBox');
  await Hive.openBox('favorites');
}
