import 'package:flutter/material.dart';
import 'utils/colors.dart';
import 'utils/theme.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Discount App',
      theme: appTheme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
