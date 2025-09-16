import 'package:demnaa_front/app/modules/auth/controllers/phone_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerificationView extends GetView<PhoneVerificationController> {
  const PhoneVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 
                   MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Header avec image de fond
                Expanded(
                  flex: 2,
                  child: _buildHeader(),
                ),
                
                // Contenu principal
                Expanded(
                  flex: 3,
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
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
            // Motifs décoratifs
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: -20,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Bouton retour
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: controller.goBackToProfileSelection,
                child: Container(
                  width: 40,
                  height: 40,
                 
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            
            // Contenu centré
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icône du profil avec animation
                  TweenAnimationBuilder<double>(
                    duration: Duration(seconds: 1),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image(
                                image: AssetImage('assets/images/phone_auth.png'),
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getProfileIcon() {
    switch (controller.selectedProfileType.value) {
      case 'client':
        return Icons.person;
      case 'driver':
        return Icons.person_4;
      case 'owner':
        return Icons.motorcycle;
      default:
        return Icons.person;
    }
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titre dynamique
          Obx(() => Text(
            controller.pageTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          )),
          
          SizedBox(height: 16),
          
          // Description dynamique
          Obx(() => Text(
            controller.pageDescription,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          )),
          
          SizedBox(height: 40),
          
          // Champ de saisie téléphone
          _buildPhoneInput(),
          
          Spacer(),
          
          // Bouton Valider avec couleur du profil
          _buildValidateButton(),
          
          SizedBox(height: 16),
          
          // Conditions d'utilisation
          _buildTermsText(),
          
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Row(
      children: [
        // Sélecteur de code pays
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇸🇳', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Obx(() => Text(
                  controller.selectedCountryCode.value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
        
        SizedBox(width: 12),
        
        // Champ numéro
        Expanded(
          child: Container(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
              decoration: InputDecoration(
                hintText: '77 123 45 67',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: controller.profileColor, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidateButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: controller.isPhoneValid.value
            ? LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF2E5BBA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[400]!],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: controller.isPhoneValid.value
            ? [
                BoxShadow(
                  color: controller.profileColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: controller.isPhoneValid.value && !controller.isValidating.value
            ? controller.validatePhoneNumber
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: controller.isValidating.value
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                controller.isLoginMode.value ? 'Valider' : 'Continuer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    ));
  }

  Widget _buildTermsText() {
    return Obx(() => RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: controller.isLoginMode.value
            ? 'En vous connectant, vous acceptez nos\n'
            : 'En créant un compte, vous acceptez nos\n',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: 'conditions d\'utilisation',
            style: TextStyle(
              color: controller.profileColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(text: ' et notre '),
          TextSpan(
            text: 'politique de confidentialité.',
            style: TextStyle(
              color: controller.profileColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    ));
  }

  void _showCountryPicker() {
    Get.bottomSheet(
      Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choisir un pays',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.countryCodes.length,
                itemBuilder: (context, index) {
                  final country = controller.countryCodes[index];
                  return ListTile(
                    leading: Text(
                      country['flag']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(country['country']!),
                    trailing: Text(
                      country['code']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      controller.selectCountryCode(country['code']!);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}