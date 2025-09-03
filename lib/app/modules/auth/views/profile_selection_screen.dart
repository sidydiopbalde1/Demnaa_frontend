import 'package:flutter/material.dart';
import './onboarding_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  String? selectedProfile;

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
                const SizedBox(height: 40),
                // En-tête
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90E2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.wb_sunny_outlined,
                          color: Color(0xFF4A90E2),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text(
                          'Bienvenue dans DemNaa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5BBA),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                const Text(
                  'Choisissez votre profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Options de profil
                ProfileOption(
                  title: 'Client',
                  icon: Icons.person,
                  color: const Color(0xFF4ECDC4),
                  isSelected: selectedProfile == 'client',
                  onTap: () => setState(() => selectedProfile = 'client'),
                ),
                const SizedBox(height: 15),
                
                ProfileOption(
                  title: 'Conducteur',
                  icon: Icons.directions_car,
                  color: const Color(0xFF4A90E2),
                  isSelected: selectedProfile == 'conducteur',
                  onTap: () => setState(() => selectedProfile = 'conducteur'),
                ),
                const SizedBox(height: 15),
                
                ProfileOption(
                  title: 'Propriétaire de motos',
                  icon: Icons.motorcycle,
                  color: const Color(0xFF4A90E2),
                  isSelected: selectedProfile == 'proprietaire',
                  onTap: () => setState(() => selectedProfile = 'proprietaire'),
                ),
                
                const Spacer(),
                
                // Bouton de création de compte
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedProfile != null ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingScreen(profileType: selectedProfile!),
                        ),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Lien de connexion
                Column(
                  children: [
                    Container(
                      height: 1,
                      width: 100,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ou se connecter avec',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Numéro de téléphone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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

class ProfileOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: color, width: 2) : null,
        ),
        child: Row(
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
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E5BBA),
                ),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
