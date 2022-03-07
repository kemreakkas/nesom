// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:nesom/auth/Screens/login_page.dart';
import 'package:nesom/auth/Screens/register_page.dart';
import 'package:nesom/kurye/firebase_sipariskabul.dart';
import 'package:nesom/kurye/kuryeekle.dart';
import 'package:nesom/market/firebase_siparisekle.dart';
import 'package:nesom/market/marketekle.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Firebasemarketekle()),
                );
              },
              child: const Text('market ekle'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Firebasekuryeekle()),
                );
              },
              child: const Text('kurye ekle'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Firebasesiparisgir()),
                );
              },
              child: const Text('Sipariş gör'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Firebasekuryekabul()),
                );
              },
              child: const Text('kurye sipariş kabul'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('giriş yap'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('kayıt ol'),
            ),
          ],
        ),
      ),
    ));
  }
}
