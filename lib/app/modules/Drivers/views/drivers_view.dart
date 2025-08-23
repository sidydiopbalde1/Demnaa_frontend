import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drivers_controller.dart';

class DriversView extends GetView<DriversController> {
  const DriversView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        title: const Text(
          'Mes conducteurs',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.addDriver,
            icon: const Icon(
              Icons.add,
              color: Color(0xFF10B981),
              size: 28,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Section centrale avec icône
          _buildCenterSection(),
          
          // Liste des conducteurs
          Expanded(
            child: _buildDriversList(),
          ),
          
          // Bouton ajouter
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildCenterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          // Icône centrale avec design original
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFB8E6D3), // Vert clair
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                // Icône de pin/localisation
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Texte descriptif
          const Text(
            'Vous n\'avez pas encore de conducteur.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Ajoutez un conducteur pour\ncommencer à gérer vos trajets plus\nfacilement !',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDriversList() {
    return Obx(() => controller.drivers.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Titre de la liste
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Conducteurs disponibles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Liste des conducteurs
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.drivers.length,
                    itemBuilder: (context, index) {
                      final driver = controller.drivers[index];
                      return _buildDriverCard(driver);
                    },
                  ),
                ),
              ],
            ),
          ));
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Color(0xFF10B981),
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      driver.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: driver.isActive 
                            ? const Color(0xFF10B981) 
                            : const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        driver.status,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  driver.distance,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Icônes d'action
          Row(
            children: [
              _buildActionIcon(Icons.motorcycle, const Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              _buildActionIcon(Icons.phone, const Color(0xFF10B981)),
              const SizedBox(width: 8),
              _buildActionIcon(Icons.message, const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.addDriver,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Ajout un conducteur',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}