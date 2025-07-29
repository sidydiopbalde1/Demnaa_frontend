import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_controller.dart';

class DeliveryView extends StatelessWidget {
  const DeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryController controller = Get.find<DeliveryController>();

    // Couleurs approximatives basées sur l'image
    const primaryColor = Color(0xFF1E3A8A); // Bleu foncé
    const secondaryColor = Color(0xFF10B981); // Vert
    const accentColor = Color(0xFFDC2626); // Rouge pour "Départ"
    const buttonColor = Color(0xFF06B6D4); // Bleu turquoise pour "Commander"

    return Scaffold(
      body: Stack(
        children: [
          // Fond avec carte
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/400x200'), // Remplace par une vraie carte
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildServiceButton("Moto-Bagage", Icons.badge, primaryColor),
                _buildServiceButton("Livraison", Icons.local_shipping, primaryColor),
                _buildServiceButton("Moto-taxi", Icons.motorcycle, primaryColor),
              ],
            ),
          ),
          // Contenu du formulaire
          Container(
            margin: const EdgeInsets.only(top: 180),
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Adresse de récupération du colis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Départ",
                          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          onChanged: controller.updatePickupAddress,
                          decoration: const InputDecoration(
                            hintText: "77 48 23 24 | Grand Dakar Rue 448",
                            suffixIcon: Icon(Icons.location_on, color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: const Text("+ Ajouter un arrêt"),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Destination de la livraison",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Arriver",
                          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          onChanged: controller.updateDestinationPhone,
                          decoration: const InputDecoration(hintText: "Téléphone"),
                        ),
                        TextField(
                          onChanged: controller.updateDestinationAddress,
                          decoration: const InputDecoration(
                            hintText: "Adresse du destinataire",
                            suffixIcon: Icon(Icons.location_on, color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                    child: const Text("Commander", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(String label, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}