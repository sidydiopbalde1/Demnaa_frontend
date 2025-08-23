import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

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
          'Mon compte',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profil utilisateur
              _buildUserProfile(),
              
              const SizedBox(height: 40),
              
              // Liste des options
              Expanded(
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.group,
                      title: 'Mes Conducteurs',
                      onTap: controller.goToDrivers,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.phone,
                      title: 'Modifier le numéro',
                      onTap: controller.goToModifyNumber,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.drive_eta,
                      title: 'Devenir conducteur',
                      onTap: controller.goToBecomeDriver,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.motorcycle,
                      title: 'Devenir propriétaire de moto',
                      onTap: controller.goToBecomeOwner,
                    ),
                    const SizedBox(height: 40),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: 'Paramètres',
                      onTap: controller.goToSettings,
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Informations',
                      onTap: controller.goToInformations,
                    ),
                  ],
                ),
              ),
              
              // Logo en bas
              _buildBottomLogo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: controller.goToProfile,
      child: Container(
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
            // Avatar
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
            
            const SizedBox(width: 16),
            
            // Informations
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.userPhone.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            
            // Flèche
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Icône
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF10B981),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Titre
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            
            // Flèche
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomLogo() {
    return Column(
      children: [
        const Text(
          'DemNaa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF10B981),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.directions_bike,
            color: Color(0xFF10B981),
            size: 30,
          ),
        ),
      ],
    );
  }
}