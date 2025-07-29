import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reverse_geocoding_controller.dart';

class ReverseGeocodingView extends GetView<ReverseGeocodingController> {
  const ReverseGeocodingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reverse Geocoding'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Adresse : ${controller.address}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exemple : Récupère les coordonnées actuelles de la carte (à adapter)
                controller.fetchAddress(40.748442, -73.985658); // Coordonnées par défaut
              },
              child: const Text('Rechercher l\'adresse'),
            ),
          ],
        ),
      ),
    );
  }
}