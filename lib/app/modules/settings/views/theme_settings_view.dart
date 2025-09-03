import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class ThemeSettingsView extends GetView<SettingsController> {
  const ThemeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DemNaaAppBar(title: 'Thème'),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.1),
            child: Column(
              children: [
                _buildThemeItem(
                  title: 'Clair',
                  isSelected: controller.selectedTheme.value == ThemeMode.light,
                  onChanged: (_) => controller.setTheme(ThemeMode.light),
                ),
                Divider(height: 1, color: Colors.grey[300]),
                _buildThemeItem(
                  title: 'Sombre',
                  isSelected: controller.selectedTheme.value == ThemeMode.dark,
                  onChanged: (_) => controller.setTheme(ThemeMode.dark),
                ),
              ],
            ),
          ),
        );
      }),
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

  Widget _buildThemeItem({
    required String title,
    required bool isSelected,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : Colors.grey[700],
            ),
          ),
          Switch(
            value: isSelected,
            onChanged: onChanged,
            activeColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }
}