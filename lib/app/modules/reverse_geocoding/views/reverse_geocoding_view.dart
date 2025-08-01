import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/reverse_geocoding_controller.dart';

class ReverseGeocodingView extends GetView<ReverseGeocodingController> {
  const ReverseGeocodingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher une localité',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
                hintText: 'Ex: Dakar, Plateau...',
              ),
              onChanged: (value) => controller.searchLocation(value),
            ),
          ),
          // Affichage de l'adresse actuelle
          Obx(() => controller.address.value.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    'Adresse: ${controller.address.value}',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox.shrink()),
          Expanded(
            child: Obx(() {
              if (controller.searchResults.isNotEmpty) {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final result = controller.searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        child: ListTile(
                          leading: const Icon(Icons.location_on, color: Colors.red),
                          title: Text(
                            result['display_name'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            controller.selectLocation(result);
                          },
                        ),
                      );
                    },
                  ),
                );
              }
              
              // Afficher la carte seulement si pas de résultats de recherche
              return Container(
                key: const ValueKey('map_container'), // Clé stable pour éviter les rebuilds
                child: FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: controller.center.value,
                    initialZoom: 12.0,
                    onTap: (tapPosition, point) {
                      controller.center.value = point;
                      controller.fetchAddress(point.latitude, point.longitude);
                    },
                    interactionOptions: const InteractionOptions(
                      enableScrollWheel: true,
                      enableMultiFingerGestureRace: true,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.demnaa_front',
                      maxZoom: 19,
                    ),
                    Obx(() => MarkerLayer(
                      markers: [
                        Marker(
                          point: controller.center.value,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Retour à Dakar
          controller.center.value = LatLng(14.716677, -17.467686);
          controller.fetchAddress(14.716677, -17.467686);
          if (controller.mapController != null) {
            try {
              controller.mapController!.move(LatLng(14.716677, -17.467686), 12.0);
            } catch (e) {
              print('Erreur lors du retour à Dakar: $e');
            }
          }
        },
        child: const Icon(Icons.home_outlined),
        tooltip: 'Retour à Dakar',
      ),
    );
  }
}