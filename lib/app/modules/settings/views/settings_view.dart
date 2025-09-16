import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DemNaaAppBar(
        title: 'Paramètres du compte',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Bloc 1 : Notifications, Langue, Thème
            DemNaaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Obx(() => _buildSettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications push',
                        hasSwitch: true,
                        switchValue: controller.pushNotifications.value,
                        onSwitchChanged: controller.togglePushNotifications,
                      )),
                  _buildDivider(),
                  Obx(() => _buildSettingsItem(
                        icon: Icons.translate,
                        title: 'Langue',
                        subtitle: controller.selectedLanguage.value,
                        hasArrow: true,
                        onTap: controller.goToLanguageSettings,
                      )),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.dark_mode_outlined,
                    title: 'Thème',
                    hasArrow: true,
                    onTap: controller.goToThemeSettings,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bloc 2 : Politique + Conditions
            DemNaaCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildSettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politique de confidentialité',
                    hasArrow: true,
                    onTap: controller.goToPrivacyPolicy,
                  ),
                  _buildDivider(),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: 'Conditions d\'éligibilité',
                    hasArrow: true,
                    onTap: controller.goToTermsConditions,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bloc 3 : Déconnexion
            DemNaaCard(
              padding: EdgeInsets.zero,
              child: _buildSettingsItem(
                icon: Icons.logout,
                title: 'Déconnexion',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onTap: controller.logout,
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

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool hasSwitch = false,
    bool switchValue = false,
    Function(bool)? onSwitchChanged,
    bool hasArrow = false,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
    bool showBorder = true,
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
              // Icône
              Container(
                width: 24,
                height: 24,
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.grey[600],
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              // Titre et sous-titre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: titleColor ?? Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Switch ou flèche
              if (hasSwitch)
                Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeColor: const Color(0xFF10B981),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              else if (hasArrow)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
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
      margin: const EdgeInsets.only(left: 56),
      color: Colors.grey[200],
    );
  }
}
