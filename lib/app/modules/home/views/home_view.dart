import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    // Couleurs approximatives basées sur l'image
    const primaryColor = Color(0xFF1E3A8A); // Bleu foncé
    const secondaryColor = Color(0xFF3B82F6); // Bleu clair
    const accentColor = Color(0xFF10B981); // Vert pour icônes

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, Color(0xFF2A4370)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: primaryColor),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Bonjour, User",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    const Icon(Icons.notifications, color: Colors.white, size: 24),
                  ],
                ),
              ),
              // Services
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceCard("Moto-colis", Icons.local_shipping, secondaryColor),
                    _buildServiceCard("Moto-taxi", Icons.motorcycle, secondaryColor),
                    _buildServiceCard("Moto-santé", Icons.local_hospital, secondaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Lieux favoris
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                      child: const Text("Domicile"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                      child: const Text("Travail"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                      child: const Text("+ Ajouter"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Liste des conducteurs
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Mes conducteurs",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.search, color: secondaryColor),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: controller.drivers.length,
                            itemBuilder: (context, index) {
                              final driver = controller.drivers[index];
                              String distanceText = driver.distance >= 1
                                  ? "${driver.distance.toStringAsFixed(0)} km"
                                  : "${(driver.distance * 1000).toStringAsFixed(0)} m";
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: secondaryColor,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(driver.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${driver.status}"),
                                      if (driver.positionStatus != null)
                                        Text(driver.positionStatus!, style: const TextStyle(color: Colors.red)),
                                      Text("$distanceText de ta position"),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.motorcycle, color: accentColor),
                                      SizedBox(width: 8),
                                      Icon(Icons.phone, color: accentColor),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Barre de navigation inférieure
              BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Agent"),
                  BottomNavigationBarItem(icon: Icon(Icons.directions_bike), label: "Conducteurs"),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mon Compte"),
                ],
                currentIndex: 1, // Actif sur "Conducteurs"
                selectedItemColor: secondaryColor,
                onTap: (index) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return Card(
      color: color,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}