import 'package:flutter/material.dart';
import 'package:asesmen_kidk_rumah_sakit/ui/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Asesmen Pasien Rumah Sakit',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}