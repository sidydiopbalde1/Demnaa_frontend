import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import 'otp_verification_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneController = TextEditingController();
  // final _apiService = ApiService();
  String _selectedMethod = 'WhatsApp';
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().isEmpty) {
      _showError('Veuillez entrer votre numéro de téléphone');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phoneNumber = '+221${_phoneController.text.trim()}';
      
      print('📱 Envoi OTP vers: $phoneNumber via $_selectedMethod');
      
      // Simulation d'appel API - remplacez par votre vraie logique
      await Future.delayed(const Duration(seconds: 2));
      
      // final result = await _apiService.sendOtp(
      //   telephone: phoneNumber,
      //   method: _selectedMethod,
      // );

      // Simulation de succès - remplacez par votre vraie logique
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              phoneNumber: phoneNumber,
              method: _selectedMethod,
            ),
          ),
        );
      }

      // Code original commenté pour référence
      /*
      if (result != null && result['error'] == null) {
        // Succès
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                phoneNumber: phoneNumber,
                method: _selectedMethod,
              ),
            ),
          );
        }
      } else {
        // Erreur
        final errorMessage = result?['error']?.toString() ?? 'Erreur lors de l\'envoi du code';
        _showError(errorMessage);
      }
      */
    } catch (e) {
      _showError('Erreur de connexion: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
          child: Column(
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'VÉRIFICATION',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5BBA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Contenu principal
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      
                      // Icône téléphone - CORRIGÉ
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4ECDC4).withOpacity(0.1), // CORRIGÉ: withOpacity au lieu de withValues
                        ),
                        child: const Icon(
                          Icons.smartphone,
                          size: 60,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Titre
                      const Text(
                        'Numéro de téléphone',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E5BBA),
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Description
                      Text(
                        'Entrez votre numéro de téléphone pour recevoir un code de vérification.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      // Saisie du numéro avec indicatif pays
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            // Indicatif Sénégal
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: const Row(
                                children: [
                                  Text('🇸🇳', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 8),
                                  Text(
                                    '+221',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2E5BBA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey[300],
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: '77 123 45 67',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2E5BBA),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Question sur la méthode de réception
                      const Text(
                        'Comment voulez-vous recevoir votre code ?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E5BBA),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Options de réception
                      Row(
                        children: [
                          Expanded(
                            child: _buildMethodOption(
                              icon: Icons.chat,
                              label: 'WhatsApp',
                              isSelected: _selectedMethod == 'WhatsApp',
                              onTap: () => setState(() => _selectedMethod = 'WhatsApp'),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildMethodOption(
                              icon: Icons.sms,
                              label: 'SMS',
                              isSelected: _selectedMethod == 'SMS',
                              onTap: () => setState(() => _selectedMethod = 'SMS'),
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Bouton valider
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_phoneController.text.isNotEmpty && !_isLoading) ? _sendOtp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4ECDC4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Envoyer le code',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Conditions d'utilisation
                      Text(
                        'En continuant, vous acceptez nos Conditions d\'utilisation',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4).withOpacity(0.1) : Colors.grey[100], // CORRIGÉ: withOpacity
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: const Color(0xFF4ECDC4)) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

// Classe temporaire pour éviter les erreurs de compilation
class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String method;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification OTP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Numéro: $phoneNumber'),
            Text('Méthode: $method'),
            const Text('Page de vérification OTP à implémenter'),
          ],
        ),
      ),
    );
  }
}