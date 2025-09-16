import 'package:demnaa_front/app/modules/profil_selection/controllers/profil_selection_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProfileSelectionView extends GetView<ProfileSelectionController> {
  const ProfileSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec image de fond
            _buildHeader(),

            // Contenu principal
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/demnaa_header.png'), // Image de fond
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        child: Stack(
          children: [
            // Bouton retour
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Titre centré
            Center(
              child: Text(
                'Bienvenue dans DemNaa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          // Titre de sélection
          Text(
            'Choisissez votre profil',
            style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),

          SizedBox(height: 10),

          // Profil Client - Sélectionné
          _buildProfileCard(
            title: 'Client',
            icon: Icons.person,
            color: Color(0xFF10B981),
            isSelected: true,
            isActive: true,
            onTap: () => controller.selectProfile('client'),
          ),

          SizedBox(height: 10),

          // Profil Conducteur - Non sélectionné
          _buildProfileCard(
            title: 'Conducteur',
            icon: Icons.person_4,
            color: Color(0xFF3B82F6),
            isSelected: false,
            isActive: true,
            onTap: () => controller.selectProfile('driver'),
          ),

          SizedBox(height: 10),

          // Profil Propriétaire - Non sélectionné
          _buildProfileCard(
            title: 'Propriétaire de motos',
            icon: Icons.motorcycle,
            color: Color(0xFF3B82F6),
            isSelected: false,
            isActive: true,
            onTap: () => controller.selectProfile('owner'),
          ),

          Spacer(),

          // Bouton créer un compte
          _buildCreateAccountButton(),

          SizedBox(height: 10),

          // Séparateur
          _buildDivider(),

          SizedBox(height: 10),

          // Bouton connexion
          _buildLoginButton(),

          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected && isActive
              ? LinearGradient(
                  colors: [Color(0x39A4B2), Color(0x31AEAF)],
                )
              : null,
          color: !isActive
              ? Colors.grey[200]
              : (isSelected ? null : Colors.grey[50]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected && isActive ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 50,
              height: 50,
            
              child: Image(
                  image: AssetImage(
                      "assets/images/${title.toLowerCase().replaceAll(' ', '_')}.png")),
            ),

            SizedBox(width: 10),

            // Texte
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected && isActive
                      ? Colors.white
                      : (isActive ? Color(0xFF2D3748) : Colors.grey[500]),
                ),
              ),
            ),

            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected && isActive ? Colors.white : Colors.grey[400]!,
                  width: 2,
                ),
                color:
                    isSelected && isActive ? Colors.white : Colors.transparent,
              ),
              child: isSelected && isActive
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.continueToPhoneVerification,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Créer un compte',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ou se connecter avec',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ElevatedButton(
        onPressed: controller.loginWithPhone,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Numéro de téléphone',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
