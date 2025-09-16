import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Si tu utilises GetX pour la navigation

class DemarageView extends StatefulWidget {
  const DemarageView({super.key});

  @override
  State<DemarageView> createState() => _DemarageViewState();
}

class _DemarageViewState extends State<DemarageView> {

  @override
  void initState() {
    super.initState();

    // Attendre 5 secondes puis naviguer vers Home
    Timer(const Duration(seconds: 10), () {
      Get.offNamed('/profil-selection'); // 🔹 si tu utilises GetX
      // Navigator.pushReplacementNamed(context, '/home'); // 🔹 si tu utilises Navigator classique
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // <-- pour éviter les bugs de layout
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/demnaa_first_page.jpeg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
