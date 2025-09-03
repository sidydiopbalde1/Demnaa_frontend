import 'package:flutter/material.dart';
import 'registration_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final String profileType;

  const OnboardingScreen({super.key, required this.profileType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFF2E5BBA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // En-tête avec bouton retour
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Titre
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Découvrez les avantages',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E5BBA),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
                // Liste des avantages
                Expanded(
                  child: Column(
                    children: [
                      AdvantageItem(
                        icon: Icons.local_hospital,
                        title: 'Assurances médicales',
                        description: 'Message accompagnant le texte sur la sécurité. Ceci est un autre paragraphe de texte',
                        color: const Color(0xFF4ECDC4),
                      ),
                      const SizedBox(height: 20),
                      
                      AdvantageItem(
                        icon: Icons.security,
                        title: 'La sécurité',
                        description: 'Message accompagnant le texte sur la sécurité. Ceci est un autre paragraphe de texte',
                        color: const Color(0xFF4ECDC4),
                      ),
                      const SizedBox(height: 20),
                      
                      AdvantageItem(
                        icon: Icons.card_giftcard,
                        title: 'Bonus',
                        description: 'Message accompagnant le texte sur la sécurité. Ceci est un autre paragraphe de texte',
                        color: const Color(0xFF4ECDC4),
                      ),
                    ],
                  ),
                ),
                
                // Bouton suivant
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(profileType: profileType),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdvantageItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const AdvantageItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E5BBA),
                  ),
                ),
                const SizedBox(height: 5),
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
      ),
    );
  }
}
