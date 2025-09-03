import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DemNaaAppBar(
        title: 'Contactez-nous',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Options de contact
            Expanded(
              child: Column(
                children: [
                  // WhatsApp
                  _buildContactOption(
                    icon: Icons.message,
                    iconColor: Colors.white,
                    backgroundColor: const Color(0xFF25D366), 
                    title: 'WhatsApp',
                    subtitle: 'Assistance 24/7',
                    onTap: controller.openWhatsApp,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Téléphone
                  _buildContactOption(
                    icon: Icons.phone,
                    iconColor: Colors.white,
                    backgroundColor: const Color(0xFF4285F4), 
                    title: 'Téléphone',
                    subtitle: 'parlez à notre agent',
                    onTap: controller.makePhoneCall,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Email
                  _buildContactOption(
                    icon: Icons.email,
                    iconColor: Colors.white,
                    backgroundColor: const Color(0xFFDB4437), 
                    title: 'Email',
                    subtitle: 'écrivez-nous',
                    onTap: controller.sendEmail,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Section "Suivez-nous"
                  const Text(
                    'Suivez-nous',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Réseaux sociaux
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        onTap: controller.openFacebook,
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        icon: Icons.camera_alt, 
                        color: const Color(0xFFE4405F),
                        onTap: controller.openInstagram,
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        icon: Icons.close, // X (Twitter)
                        color: const Color(0xFF000000),
                        onTap: controller.openTwitter,
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        icon: Icons.work, // LinkedIn
                        color: const Color(0xFF0A66C2),
                        onTap: controller.openLinkedIn,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/history');
              break;
            case 1:
              Get.offAllNamed('/home');
              break;
            case 2:
              Get.offAllNamed('/account');
              break;
          }
        },
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Flèche
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}