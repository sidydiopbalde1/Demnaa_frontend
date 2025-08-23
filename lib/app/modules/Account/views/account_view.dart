import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';


class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DemNaaAppBar(
        title: 'Mon compte',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profil utilisateur avec Obx pour la réactivité
                  Obx(() => DemNaaUserProfileCard(
                    name: controller.userName.value,
                    phone: controller.userPhone.value,
                    onTap: controller.goToProfile,
                  )),
                  
                  const SizedBox(height: 16),
                  
                  // Bloc blanc avec tous les menu items regroupés
                  DemNaaCard(
                    padding: EdgeInsets.zero, // Pas de padding pour que les items touchent les bords
                    child: Column(
                      children: [
                        DemNaaMenuItem(
                          icon: Icons.phone,
                          title: 'Modifier le numéro',
                          onTap: controller.goToModifyNumber,
                          showBorder: false, // Pas d'ombre individuelle
                        ),
                        
                        _buildDivider(), // Ligne de séparation
                        
                        DemNaaMenuItem(
                          icon: Icons.drive_eta,
                          title: 'Devenir conducteur',
                          onTap: controller.goToBecomeDriver,
                          showBorder: false,
                        ),
                        
                        _buildDivider(),
                        
                        DemNaaMenuItem(
                          icon: Icons.motorcycle,
                          title: 'Devenir propriétaire de moto',
                          onTap: controller.goToBecomeOwner,
                          showBorder: false,
                        ),
                        
                        _buildDivider(),
                        
                        DemNaaMenuItem(
                          icon: Icons.settings,
                          title: 'Paramètres',
                          onTap: controller.goToSettings,
                          showBorder: false,
                        ),
                        
                        _buildDivider(),
                        
                        DemNaaMenuItem(
                          icon: Icons.info_outline,
                          title: 'Informations',
                          onTap: controller.goToInformations,
                          showBorder: false,
                          isLast: true, // Dernier élément sans marge
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logo DemNaa
                  const DemNaaLogo(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 2, // Mon Compte est actif
        onTap: (index) {
          switch (index) {
            case 0:
              // Historique
              break;
            case 1:
              // DemNaa (Home)
              Get.offAllNamed('/home');
              break;
            case 2:
              // Mon Compte - déjà sur cette page
              break;
          }
        },
      ),
    );
  }

  // Widget pour créer les lignes de séparation
  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 56), // Aligné avec le texte (20 + 20 + 16)
      color: Colors.grey[200],
    );
  }
}