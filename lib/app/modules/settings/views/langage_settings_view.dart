import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class LanguageSettingsView extends GetView<SettingsController> {
  const LanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DemNaaAppBar(
        title: 'Langue',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: DemNaaCard(
                padding: EdgeInsets.zero,
                child: Obx(() => Column(
                  children: [
                    // Français
                    _buildLanguageItem(
                      language: 'Français',
                      isSelected: controller.selectedLanguage.value == 'Français',
                      onTap: () => controller.selectLanguage('Français'),
                    ),
                    
                    _buildDivider(),
                    
                    // Anglais
                    _buildLanguageItem(
                      language: 'Anglais',
                      isSelected: controller.selectedLanguage.value == 'Anglais',
                      onTap: () => controller.selectLanguage('Anglais'),
                    ),
                    
                    _buildDivider(),
                    
                    // Espagnol
                    _buildLanguageItem(
                      language: 'Espagnol',
                      isSelected: controller.selectedLanguage.value == 'Espagnol',
                      onTap: () => controller.selectLanguage('Espagnol'),
                    ),
                    
                    _buildDivider(),
                    
                    // Arabe
                    _buildLanguageItem(
                      language: 'Arabe',
                      isSelected: controller.selectedLanguage.value == 'Arabe',
                      onTap: () => controller.selectLanguage('Arabe'),
                    ),
                    
                    _buildDivider(),
                    
                    // Portugais
                    _buildLanguageItem(
                      language: 'Portugais',
                      isSelected: controller.selectedLanguage.value == 'Portugais',
                      onTap: () => controller.selectLanguage('Portugais'),
                    ),
                    
                    _buildDivider(),
                    
                    // Russe
                    _buildLanguageItem(
                      language: 'Russ',
                      isSelected: controller.selectedLanguage.value == 'Russ',
                      onTap: () => controller.selectLanguage('Russ'),
                      isLast: true,
                    ),
                  ],
                )),
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
              // Historique
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

  Widget _buildLanguageItem({
    required String language,
    required bool isSelected,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isLast ? 20 : 16,
          ),
          child: Row(
            children: [
              // Nom de la langue
              Expanded(
                child: Text(
                  language,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              // Switch pour indiquer la sélection
              Switch(
                value: isSelected,
                onChanged: (value) {
                  if (value) onTap();
                },
                activeColor: const Color(0xFF10B981),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey[200],
    );
  }
}