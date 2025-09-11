import 'package:demnaa_front/app/modules/Drivers/controllers/drivers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';

class DriversListFullView extends GetView<DriversController> {
  const DriversListFullView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DemNaaAppBar(
        title: 'Mes conducteurs',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color.fromARGB(255, 75, 13, 219), size: 24),
            onPressed: controller.addDriver,
          ),
        ],
      ),
      body: Padding(
   
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color.fromARGB(255, 107, 9, 235).withOpacity(1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      ),
                    );
                  }

                  if (controller.drivers.isEmpty) {
                    return DemNaaEmptyState(
                      icon: Icons.person_add,
                      title: 'Aucun conducteur',
                      subtitle: 'Vous n\'avez pas encore ajouté de conducteurs.\nCommencez par ajouter votre premier conducteur.',
                      buttonText: 'Ajouter un conducteur',
                      onButtonPressed: controller.addDriver,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: controller.drivers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final driver = controller.drivers[index];
                      return _buildDriverItem(driver);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/history');
              break;
            case 1:
              Get.offAllNamed('/home');
              break;
            case 2:
              Get.offAllNamed('/profil');
              break;
          }
        },
      ),
    );
  }

  Widget _buildDriverItem(Driver driver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Distance - en dehors de la card
        Text(
          driver.distance,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 19, 17, 17),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        // Card du conducteur
        _buildDriverCard(driver),
      ],
    );
  }

  Widget _buildDriverCard(Driver driver) {
    final statusColor = driver.isActive ? const Color(0xFF10B981) : Colors.red;
    final statusText = driver.status;

    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(driver),
          const SizedBox(width: 10),
          // Nom et statut
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                
                  child: Text(
                    '• $statusText',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
             Image(image: Image.asset(driver.service).image, width: 20, height: 20,),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.location_on,
                color: const Color(0xFF10B981),
                onTap: () => controller.trackDriver(driver.id),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.phone,
                color: const Color(0xFF059669),
                onTap: () => controller.callDriver(driver.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Driver driver) {
    return Container(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        color: Color(0xFFE6F3FF),
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: driver.avatar.isNotEmpty
            ? Image.asset(
                driver.avatar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Icon(
      Icons.person,
      color: Color(0xFF3B82F6),
      size: 25,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: color,
          size: 16,
        ),
      ),
    );
  }
}