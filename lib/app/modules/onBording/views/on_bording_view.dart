import 'package:demnaa_front/app/modules/onBording/controllers/on_bording_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => _buildCurrentStep()),
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildAdvantagesStep();
      case 1:
        return _buildRegistrationFormStep();
      case 2:
        return _buildStudentDocumentsStep();
      case 3:
        return _buildProfessionalFormStep();
      default:
        return _buildAdvantagesStep();
    }
  }

  // Étape 1: Avantages - ADAPTÉE AVEC VOS ASSETS
  Widget _buildAdvantagesStep() {
    return Container(
      child: Column(
        children: [
          // Header avec votre image de fond
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                // Image de fond
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    "assets/images/demnaa_header.png",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si l'image n'existe pas
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bouton retour
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),

                // Titre
                Center(
                  child: Text(
                    'Découvrez les avantages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenu des avantages
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 40),

                  // Liste des avantages avec vos assets
                  _buildAdvantageItem(
                    iconColor: Color(0xFF10B981),
                    title: 'Assurances médicales',
                    description:
                        'Message accompagnant le texte sur la sécurité. Ceci est un autre paragraphe de texte',
                    image: "assurance_medicale.png",
                  ),

                  SizedBox(height: 30),

                  _buildAdvantageItem(
                    iconColor: Color(0xFF10B981),
                    title: 'La sécurité',
                    description:
                        'Message accompagnant le texte sur la sécurité.Ceci est un autre paragraphe de texte',
                    image: "security_badge.png",
                  ),

                  SizedBox(height: 30),

                  _buildAdvantageItem(
                    iconColor: Color(0xFF10B981),
                    title: 'Bonus',
                    description:
                        'Message accompagnant le texte sur la sécurité.Ceci est un autre paragraphe de texte',
                    image: "gift.png",
                  ),

                  Spacer(),

                  // Bouton Suivant
                  _buildActionButton(
                    text: 'Suivant',
                    onPressed: controller.nextStep,
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Étape 2: Formulaire d'inscription - CORRIGÉ POUR ÉVITER L'ERREUR GETX
// Étape 2: Formulaire d'inscription - ADAPTÉ POUR INCLURE LES CHAMPS SI ÉTUDIANT
Widget _buildRegistrationFormStep() {
  return Container(
    child: Column(
      children: [
        _buildHeaderWithTitle('INSCRIPTION'),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // Champ Nom
                _buildTextField(
                  label: 'Nom',
                  onChanged: (value) {
                    controller.updateFirstName(value);
                  },
                ),

                SizedBox(height: 20),

                // Champ Prénom
                _buildTextField(
                  label: 'Prénom',
                  onChanged: (value) {
                    controller.updateLastName(value);
                  },
                ),

                SizedBox(height: 20),

                // Dropdown Fonction
                GetBuilder<OnboardingController>(
                  builder: (ctrl) => _buildDropdownField(
                    label: 'Fonction',
                    value: ctrl.selectedFunction.value.isEmpty
                        ? null
                        : ctrl.selectedFunction.value,
                    items: ctrl.functions,
                    onChanged: ctrl.selectFunction,
                  ),
                ),

                SizedBox(height: 20),

                // Dropdown Localisation
                GetBuilder<OnboardingController>(
                  builder: (ctrl) => _buildDropdownField(
                    label: 'Localisation',
                    value: ctrl.selectedLocation.value.isEmpty
                        ? null
                        : ctrl.selectedLocation.value,
                    items: ctrl.locations,
                    onChanged: ctrl.selectLocation,
                  ),
                ),

                SizedBox(height: 20),

                // Sélection Genre
                Text(
                  'Genre',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12),

                GetBuilder<OnboardingController>(
                  builder: (ctrl) => Row(
                    children: [
                      _buildRadioOption('Homme', 'Homme', ctrl),
                      SizedBox(width: 40),
                      _buildRadioOption('Femme', 'Femme', ctrl),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // 👇 Champs conditionnels : Carte étudiant et Certificat
                GetBuilder<OnboardingController>(
                  builder: (ctrl) {
                    if (ctrl.selectedFunction.value == "Etudiant / Élève") {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Carte étudiant / Carte scolaire',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildDocumentUpload(
                            placeholder: 'Cliquez ici pour télécharger le fichier',
                            onTap: ctrl.uploadStudentCard,
                            hasFile: ctrl.studentCard.value != null,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Certificat d\'inscription d\'année en cours',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildDocumentUpload(
                            placeholder: 'Cliquez ici pour télécharger le fichier',
                            onTap: ctrl.uploadEnrollmentCertificate,
                            hasFile: ctrl.enrollmentCertificate.value != null,
                          ),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),

                SizedBox(height: 40),

                // Bouton Suivant
                GetBuilder<OnboardingController>(
                  builder: (ctrl) => _buildActionButton(
                    text: 'Suivant',
                    onPressed: ctrl.canProceedFromStep(1) ? ctrl.nextStep : null,
                    isEnabled: ctrl.canProceedFromStep(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


  // Étape 3: Documents étudiant - CORRIGÉ
  Widget _buildStudentDocumentsStep() {
    return GetBuilder<OnboardingController>(
      builder: (ctrl) {
        // Vérifier si c'est un étudiant
        if (ctrl.selectedFunction.value != 'Étudiant /Élève') {
          // Passer automatiquement à l'étape suivante
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ctrl.nextStep();
          });
          return Container();
        }

        return Container(
          child: Column(
            children: [
              _buildHeaderWithTitle('INSCRIPTION'),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Carte étudiant/ Carte scolaire',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDocumentUpload(
                        placeholder: 'Cliquez ici pour télécharger le fichier',
                        onTap: ctrl.uploadStudentCard,
                        hasFile: ctrl.studentCard.value != null,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Certificat d\'inscription d\'année en cours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildDocumentUpload(
                        placeholder: 'Cliquez ici pour télécharger le fichier',
                        onTap: ctrl.uploadEnrollmentCertificate,
                        hasFile: ctrl.enrollmentCertificate.value != null,
                      ),
                      Spacer(),
                      _buildActionButton(
                        text: 'Suivant',
                        onPressed:
                            ctrl.canProceedFromStep(2) ? ctrl.nextStep : null,
                        isEnabled: ctrl.canProceedFromStep(2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Étape 4: Récapitulatif - CORRIGÉ
  Widget _buildProfessionalFormStep() {
    return Container(
      child: Column(
        children: [
          _buildHeaderWithTitle('INSCRIPTION'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // Récapitulatif des informations
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Récapitulatif de votre inscription',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),

                        // CORRIGÉ avec GetBuilder
                        GetBuilder<OnboardingController>(
                          builder: (ctrl) => Column(
                            children: [
                              _buildInfoRow('Nom',
                                  '${ctrl.firstName.value} ${ctrl.lastName.value}'),
                              _buildInfoRow(
                                  'Fonction', ctrl.selectedFunction.value),
                              _buildInfoRow(
                                  'Localisation', ctrl.selectedLocation.value),
                              _buildInfoRow('Genre', ctrl.selectedGender.value),
                              if (ctrl.selectedFunction.value ==
                                  'Étudiant /Élève')
                                _buildInfoRow(
                                    'Documents',
                                    ctrl.studentCard.value != null ||
                                            ctrl.enrollmentCertificate.value !=
                                                null
                                        ? 'Téléchargés'
                                        : 'Non fournis'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Message de confirmation
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF10B981).withOpacity(0.1),
                          Color(0xFF3B82F6).withOpacity(0.1)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: controller.profileColor, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Vos informations sont prêtes à être sauvegardées. Cliquez sur "Terminer" pour finaliser votre inscription.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Bouton Terminer - garde Obx car isLoading est simple
                  Obx(() => _buildActionButton(
                        text: controller.isLoading.value
                            ? 'Finalisation...'
                            : 'Terminer',
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.completeOnboarding,
                        isEnabled: !controller.isLoading.value,
                        showLoading: controller.isLoading.value,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper adapté avec vos assets - CORRIGÉ
  Widget _buildAdvantageItem({
    required Color iconColor,
    required String title,
    required String description,
    required String image,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          child: Image.asset(
            "assets/images/$image",
            color: iconColor,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              // Fallback vers une icône si l'image n'existe pas
              IconData fallbackIcon = Icons.star;
              if (image.contains('assurance'))
                fallbackIcon = Icons.medical_services;
              if (image.contains('security')) fallbackIcon = Icons.security;
              if (image.contains('gift')) fallbackIcon = Icons.card_giftcard;

              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(fallbackIcon, color: iconColor, size: 24),
              );
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widgets helper restent identiques mais quelques corrections
  Widget _buildHeaderWithTitle(String title) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Image(
              image: AssetImage("assets/images/demnaa_header.png"),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150),

          // Bouton retour
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              onPressed: controller.previousStep,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),

          // Titre
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativePin() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.location_pin,
        color: Colors.white.withOpacity(0.3),
        size: 16,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[900]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }

  // Widget radio corrigé pour éviter l'erreur GetX
  Widget _buildRadioOption(
      String title, String value, OnboardingController ctrl) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: ctrl.selectedGender.value,
          onChanged: (newValue) {
            if (newValue != null) ctrl.selectGender(newValue);
          },
          activeColor: Color(0xFF3B82F6),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUpload({
    required String placeholder,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasFile ? Color(0xFF10B981) : Colors.grey[300]!,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: hasFile ? Color(0xFF10B981).withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle : Icons.upload_file,
              color: hasFile ? Color(0xFF10B981) : Colors.grey[600],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                hasFile ? 'Document téléchargé' : placeholder,
                style: TextStyle(
                  color: hasFile ? Color(0xFF10B981) : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    VoidCallback? onPressed,
    bool isEnabled = true,
    bool showLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled
              ? [Color(0xFF10B981), Color(0xFF3B82F6)]
              : [Colors.grey[300]!, Colors.grey[400]!],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isEnabled ? onPressed : null,
          child: Container(
            child: Center(
              child: showLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
