import 'package:flutter/material.dart';

class DriverSearchView extends StatefulWidget {
  const DriverSearchView({super.key});

  @override
  State<DriverSearchView> createState() => _DriverSearchScreenState();
}

class _DriverSearchScreenState extends State<DriverSearchView> {
  String? selectedReason;
  String? selectedContact;
  String? selectedWait;
  String? selectedSignal;
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

  bool get isFormComplete {
    return selectedReason != null &&
           selectedContact != null &&
           selectedWait != null &&
           selectedSignal != null &&
           (selectedReason != "Autre" || customReasonController.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question 1
                    _buildQuestionSection(
                      title: "Quelle est la raison principale de votre annulation ?",
                      content: Column(
                        children: [
                          ...reasons.map((reason) => _buildRadioOption(
                            value: reason,
                            groupValue: selectedReason,
                            onChanged: (value) {
                              setState(() {
                                selectedReason = value;
                              });
                            },
                            title: reason,
                          )),
                          if (selectedReason == "Autre") ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: customReasonController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "Précisez la raison...",
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                                ),
                                contentPadding: const EdgeInsets.all(12),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Question 2
                    _buildQuestionSection(
                      title: "Avez-vous essayé de contacter le conducteur ?",
                      content: Row(
                        children: [
                          _buildRadioOption(
                            value: "Oui",
                            groupValue: selectedContact,
                            onChanged: (value) {
                              setState(() {
                                selectedContact = value;
                              });
                            },
                            title: "Oui",
                          ),
                          const SizedBox(width: 32),
                          _buildRadioOption(
                            value: "Non",
                            groupValue: selectedContact,
                            onChanged: (value) {
                              setState(() {
                                selectedContact = value;
                              });
                            },
                            title: "Non",
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Question 3
                    _buildQuestionSection(
                      title: "Combien de temps après avoir commandé avez-vous décidé d'annuler ?",
                      content: Column(
                        children: [
                          "Moins de 5 minutes",
                          "5 à 10 minutes",
                          "Plus de 10 minutes"
                        ].map((time) => _buildRadioOption(
                          value: time,
                          groupValue: selectedWait,
                          onChanged: (value) {
                            setState(() {
                              selectedWait = value;
                            });
                          },
                          title: time,
                        )).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Question 4
                    _buildQuestionSection(
                      title: "Souhaitez-vous signaler ce conducteur ?",
                      content: Row(
                        children: [
                          _buildRadioOption(
                            value: "Oui",
                            groupValue: selectedSignal,
                            onChanged: (value) {
                              setState(() {
                                selectedSignal = value;
                              });
                            },
                            title: "Oui",
                          ),
                          const SizedBox(width: 32),
                          _buildRadioOption(
                            value: "Non",
                            groupValue: selectedSignal,
                            onChanged: (value) {
                              setState(() {
                                selectedSignal = value;
                              });
                            },
                            title: "Non",
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Send Button
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: const Center(
              child: Text(
                'Recherche de conducteur à proximité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection({
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildRadioOption({
    required String value,
    required String? groupValue,
    required Function(String?) onChanged,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
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
    );
  }

  Widget _buildSendButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isFormComplete ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isFormComplete ? [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ] : null,
        ),
        child: ElevatedButton(
          onPressed: isFormComplete ? () {
            // Action d'envoi
            _sendForm();
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Envoyer',
                style: TextStyle(
                  color: isFormComplete ? Colors.white : const Color(0xFF9CA3AF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.send,
                color: isFormComplete ? Colors.white : const Color(0xFF9CA3AF),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendForm() {
    // Logique d'envoi du formulaire
    final Map<String, String> formData = {
      'reason': selectedReason == "Autre" ? customReasonController.text.trim() : selectedReason!,
      'contacted_driver': selectedContact!,
      'wait_time': selectedWait!,
      'report_driver': selectedSignal!,
    };
    
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre retour a été envoyé avec succès'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
    
    // Fermer l'écran
    Navigator.pop(context);
  }

  @override
  void dispose() {
    customReasonController.dispose();
    super.dispose();
  }
}