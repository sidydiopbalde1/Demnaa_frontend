import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancellationModalWidget extends StatefulWidget {
  const CancellationModalWidget({super.key});

  @override
  CancellationModalWidgetState createState() => CancellationModalWidgetState();
}

class CancellationModalWidgetState extends State<CancellationModalWidget> {
  String selectedReason = '';
  String selectedContact = '';
  String selectedWaitTime = '';
  String selectedSignal = '';
  final TextEditingController customReasonController = TextEditingController();

  final List<String> reasons = [
    "Le conducteur a mis trop de temps à arriver",
    "Le conducteur est sur un mauvais itinéraire", 
    "Je n'ai pas pu joindre le conducteur",
    "Le prix est trop élevé",
    "La moto ne correspond pas à ce que j'attendais",
    "Le conducteur a annulé sans prévenir",
    "Autre"
  ];

  final List<String> waitTimes = [
    "Moins de 5 minutes",
    "5 à 10 minutes", 
    "Plus de 10 minutes"
  ];

  bool get isFormComplete {
    return selectedReason.isNotEmpty &&
           selectedContact.isNotEmpty &&
           selectedWaitTime.isNotEmpty &&
           selectedSignal.isNotEmpty &&
           (selectedReason != "Autre" || customReasonController.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header avec X de fermeture
          // _buildHeader(),

          // Contenu scrollable
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question 1: Raison principale
                  _buildReasonSection(),
                  
                  const SizedBox(height: 24),

                  // Question 2: Contact conducteur
                  _buildContactSection(),

                  const SizedBox(height: 24),

                  // Question 3: Temps d'attente
                  _buildWaitTimeSection(),

                  const SizedBox(height: 24),

                  // Question 4: Signaler conducteur
                  _buildSignalSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bouton Envoyer
          _buildSendButton(),
        ],
      ),
    );
  }



  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre avec X de fermeture
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Quelle est la raison principale de votre annulation ?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Text(
                  'X',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        ...reasons.map((reason) => _buildRadioOption(
          value: reason,
          groupValue: selectedReason,
          onChanged: (value) => setState(() => selectedReason = value!),
          title: reason,
        )),
        
        // Champ texte si "Autre" sélectionné
        if (selectedReason == "Autre")
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: TextFormField(
              controller: customReasonController,
              maxLines: 2,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Précisez la raison...",
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Avez-vous essayé de contacter le conducteur ?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Flexible(
              child: _buildRadioOption(
                value: "Oui",
                groupValue: selectedContact,
                onChanged: (value) => setState(() => selectedContact = value!),
                title: "Oui",
              ),
            ),
            const SizedBox(width: 32),
            Flexible(
              child: _buildRadioOption(
                value: "Non",
                groupValue: selectedContact,
                onChanged: (value) => setState(() => selectedContact = value!),
                title: "Non",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaitTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Combien de temps après avoir commandé avez-vous décidé d\'annuler ?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        
        ...waitTimes.map((time) => _buildRadioOption(
          value: time,
          groupValue: selectedWaitTime,
          onChanged: (value) => setState(() => selectedWaitTime = value!),
          title: time,
        )),
      ],
    );
  }

  Widget _buildSignalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Souhaitez-vous signaler ce conducteur ?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Flexible(
              child: _buildRadioOption(
                value: "Oui",
                groupValue: selectedSignal,
                onChanged: (value) => setState(() => selectedSignal = value!),
                title: "Oui",
              ),
            ),
            const SizedBox(width: 32),
            Flexible(
              child: _buildRadioOption(
                value: "Non",
                groupValue: selectedSignal,
                onChanged: (value) => setState(() => selectedSignal = value!),
                title: "Non",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isFormComplete ? _handleSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormComplete ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
            foregroundColor: isFormComplete ? Colors.white : const Color(0xFF9CA3AF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Envoyer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
    required String title,
  }) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => onChanged(value),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: value,
                groupValue: groupValue.isEmpty ? null : groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFF2563EB),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    // Préparer les données du formulaire
    final Map<String, String> formData = {
      'reason': selectedReason == "Autre" 
          ? customReasonController.text.trim() 
          : selectedReason,
      'contacted_driver': selectedContact,
      'wait_time': selectedWaitTime,
      'report_driver': selectedSignal,
    };

    // Fermer le modal
    Navigator.pop(context);

    // Afficher message de confirmation
    Get.snackbar(
      'Annulation confirmée',
      'Votre retour a été envoyé avec succès',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Ici vous pouvez ajouter l'envoi des données vers votre API
    // ApiService.sendCancellationFeedback(formData);
  }

  @override
  void dispose() {
    customReasonController.dispose();
    super.dispose();
  }
}