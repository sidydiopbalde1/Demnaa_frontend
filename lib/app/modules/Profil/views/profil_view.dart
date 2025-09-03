import 'package:demnaa_front/app/modules/Profil/controllers/profil_controller.dart';
import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxBool showDropdown = false.obs;
    final GlobalKey professionKey = GlobalKey();

    return Obx(() => Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DemNaaAppBar(
        title: 'Profil',
        actions: [
          TextButton(
            onPressed: () {
              controller.toggleEdit();
            },
            child: Text(
              controller.isEditing.value ? 'Sauvegarder' : 'Modifier',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Fermer le dropdown si on clique ailleurs
          if (showDropdown.value) {
            showDropdown.value = false;
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildAvatar(),
                  const SizedBox(height: 32),
                  DemNaaCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildFormFieldItem(
                          label: 'Prénom',
                          textController: controller.firstNameController,
                          value: controller.firstName,
                          isFirst: true,
                        ),
                        _buildDivider(),
                        _buildFormFieldItem(
                          label: 'Nom',
                          textController: controller.lastNameController,
                          value: controller.lastName,
                        ),
                        _buildDivider(),
                        _buildFormFieldItem(
                          label: 'Numéro de téléphone',
                          textController: controller.phoneController,
                          value: controller.phone,
                        ),
                        _buildDivider(),
                        _buildFormFieldItem(
                          label: 'Adresse',
                          textController: controller.addressController,
                          value: controller.address,
                        ),
                        _buildDivider(),
                        _buildFormFieldItem(
                          key: professionKey,
                          label: 'Profession',
                          textController: controller.professionController,
                          value: controller.profession,
                          suffixIcon: Icons.arrow_drop_down,
                          onTap: () {
                            print('Profession tapped!'); // Debug
                            print('isEditing: ${controller.isEditing.value}'); // Debug
                            if (controller.isEditing.value) {
                              showDropdown.value = !showDropdown.value;
                              print('showDropdown: ${showDropdown.value}'); // Debug
                            }
                          },
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            _buildDropdownOverlay(showDropdown, professionKey),
          ],
        ),
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Get.offAllNamed('/home');
              break;
            case 2:
              break;
          }
        },
      ),
    ));
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 206, 228, 219),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFF10B981),
            size: 50,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildFormFieldItem({
    required String label,
    required TextEditingController? textController,
    required RxString value,
    IconData? suffixIcon,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
    Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: () {
        // Empêcher la propagation du tap pour le champ Profession
        if (label == 'Profession' && onTap != null) {
          onTap();
          // Ne pas propager le tap vers le parent
          return;
        }
        // Pour les autres champs, appeler onTap normalement
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          // Indicateur visuel pour le champ Profession en mode édition
          color: (label == 'Profession' && controller.isEditing.value) 
              ? Colors.grey[50] 
              : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isEditing.value && label != 'Profession' && textController != null) {
                      return TextFormField(
                        controller: textController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E5BBA),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        keyboardType: label == 'Numéro de téléphone'
                            ? TextInputType.phone
                            : TextInputType.text,
                      );
                    } else {
                      return Text(
                        value.value.isEmpty && label == 'Profession' && controller.isEditing.value
                            ? 'Sélectionnez votre profession'
                            : value.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: value.value.isEmpty && label == 'Profession' && controller.isEditing.value
                              ? Colors.grey[500]
                              : const Color(0xFF2E5BBA),
                        ),
                      );
                    }
                  }),
                ),
                if (suffixIcon != null)
                  Obx(() => Icon(
                    suffixIcon,
                    color: (label == 'Profession' && controller.isEditing.value)
                        ? const Color(0xFF2E5BBA)
                        : Colors.grey[400],
                    size: label == 'Profession' ? 20 : 14,
                  )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 20),
      color: Colors.grey[200],
    );
  }

  Widget _buildDropdownOverlay(RxBool showDropdown, GlobalKey professionKey) {
    return Obx(() {
      if (!showDropdown.value) return const SizedBox.shrink();

      final RenderBox? renderBox = professionKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return const SizedBox.shrink();

      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      return Positioned(
        top: position.dy + size.height + 8,
        left: 16,
        right: 16,
        child: GestureDetector(
          // Empêcher la fermeture du dropdown quand on clique dessus
          onTap: () {
            // Ne rien faire - empêche la propagation
          },
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black.withOpacity(0.15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownOption(
                    'Etudiant',
                    onTap: () {
                      controller.professionController.text = 'Etudiant';
                      controller.profession.value = 'Etudiant';
                      showDropdown.value = false;
                    },
                    isFirst: true,
                  ),
                  _buildDropdownDivider(),
                  _buildDropdownOption(
                    'Professionnels',
                    onTap: () {
                      controller.professionController.text = 'Professionnels';
                      controller.profession.value = 'Professionnels';
                      showDropdown.value = false;
                    },
                  ),
                  _buildDropdownDivider(),
                  _buildDropdownOption(
                    'Elève',
                    onTap: () {
                      controller.professionController.text = 'Elève';
                      controller.profession.value = 'Elève';
                      showDropdown.value = false;
                    },
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDropdownOption(
    String text, {
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(12) : Radius.zero,
        bottom: isLast ? const Radius.circular(12) : Radius.zero,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownDivider() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}