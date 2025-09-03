import 'package:flutter/material.dart';
import 'dart:async';

import '../../../services/api_service_f.dart';
import 'location_permission_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String method;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.method,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final _apiService = ApiService();
  
  int _countdown = 298; // 4:58 en secondes
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedCountdown {
    int minutes = _countdown ~/ 60;
    int seconds = _countdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete()) {
      _showError('Veuillez entrer le code complet');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _apiService.verifyOtp(
        telephone: widget.phoneNumber,
        otp: _otpCode,
      );

      if (result != null && result['error'] == null) {
        // Succès
        _showSuccess('Code vérifié avec succès !');
        
        // Attendre un peu puis naviguer
        await Future.delayed(const Duration(milliseconds: 1500));
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LocationPermissionScreen(),
            ),
          );
        }
      } else {
        // Erreur
        final errorMessage = result?['error']?.toString() ?? 'Code invalide';
        _showError(errorMessage);
        
        // Effacer les champs en cas d'erreur
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      _showError('Erreur de connexion: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.sendOtp(
        telephone: widget.phoneNumber,
        method: widget.method,
      );

      if (result != null && result['error'] == null) {
        _showSuccess('Code renvoyé avec succès !');
        
        // Redémarrer le compteur
        setState(() {
          _countdown = 298;
        });
        _timer?.cancel();
        _startCountdown();
        
        // Effacer les champs
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      } else {
        final errorMessage = result?['error']?.toString() ?? 'Erreur lors du renvoi';
        _showError(errorMessage);
      }
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
                      
                      // Icône de vérification
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 60,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Description
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: 'Un code à 4 chiffres a été envoyé par '),
                            TextSpan(
                              text: widget.method,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(text: ' au numéro '),
                            TextSpan(
                              text: widget.phoneNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E5BBA),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Champs OTP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _otpControllers[index].text.isNotEmpty 
                                    ? const Color(0xFF4ECDC4) 
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E5BBA),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) {
                                setState(() {});
                                if (value.isNotEmpty && index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                                
                                // Auto-vérification quand les 4 chiffres sont saisis
                                if (_isOtpComplete() && !_isLoading) {
                                  _verifyOtp();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 30),
                      
                      // Compteur de temps
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          children: [
                            const TextSpan(text: 'Le code expire dans '),
                            TextSpan(
                              text: _formattedCountdown,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _countdown > 60 ? const Color(0xFF4ECDC4) : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Indicateur de chargement
                      if (_isLoading)
                        const Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Vérification en cours...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                          ],
                        ),
                      
                      const Spacer(),
                      
                      // Bouton confirmer manuel (si besoin)
                      if (!_isLoading)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isOtpComplete() ? _verifyOtp : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4ECDC4),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Vérifier le code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      
                      // Lien de renvoi du code
                      TextButton(
                        onPressed: _isLoading ? null : _resendOtp,
                        child: const Text(
                          'Code non reçu ? Renvoyer le code',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A90E2),
                            decoration: TextDecoration.underline,
                          ),
                        ),
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

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
