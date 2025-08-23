import 'package:demnaa_front/app/modules/Profil/controllers/profil_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

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
          'Profil',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() => TextButton(
            onPressed: controller.isEditing.value 
                ? controller.toggleEdit 
                : controller.toggleEdit,
            child: Text(
              controller.isEditing.value ? 'Sauvegarder' : 'Modifier',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Avatar
            _buildAvatar(),
            
            const SizedBox(height: 32),
            
            // Formulaire
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFB8E6D3), // Vert clair comme dans l'image
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFF10B981),
            size: 50,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Text(
          '${controller.firstName.value} ${controller.lastName.value}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        )),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildFormField(
          label: 'Prénom',
          controller: controller.firstNameController,
          isEditing: controller.isEditing,
        ),
        const SizedBox(height: 20),
        _buildFormField(
          label: 'Nom',
          controller: controller.lastNameController,
          isEditing: controller.isEditing,
        ),
        const SizedBox(height: 20),
        _buildFormField(
          label: 'Numéro de téléphone',
          controller: controller.phoneController,
          isEditing: controller.isEditing,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        _buildFormField(
          label: 'Adresse',
          controller: controller.addressController,
          isEditing: controller.isEditing,
        ),
        const SizedBox(height: 20),
        _buildFormField(
          label: 'Profession',
          controller: controller.professionController,
          isEditing: controller.isEditing,
          suffixIcon: Icons.arrow_forward_ios,
        ),
        
        const SizedBox(height: 40),
        
        // Bouton d'annulation (visible seulement en mode édition)
        Obx(() => controller.isEditing.value
            ? SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: controller.cancelEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required RxBool isEditing,
    TextInputType? keyboardType,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEditing.value 
                  ? const Color(0xFF10B981) 
                  : Colors.grey[300]!,
            ),
          ),
          child: TextFormField(
            controller: controller,
            enabled: isEditing.value,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      color: Colors.grey[400],
                      size: 16,
                    )
                  : null,
            ),
          ),
        )),
      ],
    );
  }
}