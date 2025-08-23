import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  // Controllers pour les champs de texte
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final professionController = TextEditingController();
  
  // Variables observables
  var isEditing = false.obs;
  var firstName = 'Mamadou'.obs;
  var lastName = 'Ndiaye'.obs;
  var phone = '77 333 00 23'.obs;
  var address = 'Sacré Cœur'.obs;
  var profession = 'Étudiant'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    firstNameController.text = firstName.value;
    lastNameController.text = lastName.value;
    phoneController.text = phone.value;
    addressController.text = address.value;
    professionController.text = profession.value;
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Sauvegarder les modifications
      firstName.value = firstNameController.text;
      lastName.value = lastNameController.text;
      phone.value = phoneController.text;
      address.value = addressController.text;
      profession.value = professionController.text;
    }
  }

  void cancelEdit() {
    isEditing.value = false;
    // Restaurer les valeurs originales
    _initializeControllers();
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    professionController.dispose();
    super.onClose();
  }
}