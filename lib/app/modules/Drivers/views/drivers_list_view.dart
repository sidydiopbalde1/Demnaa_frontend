import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drivers_controller.dart';

class DriversListView extends GetView<DriversController> {
  const DriversListView({super.key});

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
          // Zone de recherche avec tooltip
          _buildSearchSection(),
          
          // Liste des conducteurs
          Expanded(
            child: _buildDriversList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tooltip avec position
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  '5 m de ta position',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriversList() {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: controller.drivers.length,
        itemBuilder: (context, index) {
          final driver = controller.drivers[index];
          return _buildDriverCard(driver, index);
        },
      ),
    ));
  }

  Widget _buildDriverCard(Driver driver, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Avatar avec indicateur de statut
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF10B981),
                  size: 30,
                ),
              ),
              // Indicateur de statut
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: driver.isActive 
                        ? const Color(0xFF10B981) 
                        : const Color(0xFFDC2626),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 16),
          
          // Informations du conducteur
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
                const SizedBox(height: 8),
                _buildDistanceInfo(driver, index),
              ],
            ),
          ),
          
          // Actions
          Column(
            children: [
              _buildActionRow(driver),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceInfo(Driver driver, int index) {
    // Différents types d'affichage selon l'index
    switch (index) {
      case 0: // Premier conducteur avec position
        return Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Color(0xFF10B981),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              driver.distance,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      case 1: // Deuxième conducteur inactif
        return Row(
          children: [
            const Icon(
              Icons.location_off,
              color: Color(0xFFDC2626),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              driver.distance,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      case 2: // Troisième conducteur - position désactivée
        return Text(
          driver.distance,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        );
      default: // Autres conducteurs avec distance
        return Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Color(0xFF6B7280),
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              driver.distance,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildActionRow(Driver driver) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.motorcycle,
          color: const Color(0xFF3B82F6),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.phone,
          color: const Color(0xFF10B981),
          onTap: () {},
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.message,
          color: const Color(0xFF10B981),
          onTap: () {},
        ),
      ],
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }
}