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
              ),
              onChanged: (value) => controller.searchLocation(value),
            ),
          ),
          // Affichage de l'adresse actuelle
          Obx(() => controller.address.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
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
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = controller.searchResults[index];
                    return ListTile(
                      title: Text(result['display_name']),
                      onTap: () {
                        controller.selectLocation(result);
                      },
                    );
                  },
                );
              }
              return FlutterMap(
                mapController: controller.mapController,
                options: MapOptions(
                  initialCenter: controller.center.value,
                  initialZoom: 12.0,
                  onTap: (tapPosition, point) {
                    controller.updateLocation(point.latitude, point.longitude);
                    controller.fetchAddress(point.latitude, point.longitude);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.demnaa_front',
                  ),
                  MarkerLayer(
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
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.updateLocation(48.8606, 2.3376); // Exemple: Tour Eiffel
          controller.fetchAddress(48.8606, 2.3376);
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }
}