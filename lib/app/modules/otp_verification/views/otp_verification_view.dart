import 'package:demnaa_front/app/modules/otp_verification/controllers/otp_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation du contrôleur
    Get.put(OtpVerificationController());

    return Scaffold(
      body: Column(
        children: [
          // Section supérieure avec image de fond
          Expanded(
            flex: 2,
            child: _buildHeaderSection(),
          ),
          
          // Section inférieure blanche
          Expanded(
            flex: 3,
            child: _buildContentSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/demnaa_header.png'), // Votre image de fond bleue
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Bouton retour
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: 40,
                  height: 40,
                  // decoration: BoxDecoration(
                  //   color: Colors.white.withOpacity(0.2),
                  //   shape: BoxShape.circle,
                  // ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            
            Spacer(),
            
            // Icône centrale (téléphone avec code)
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/images/phone_otp.png', // Votre icône de téléphone avec code
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 8),
            // Message de vérification
            _buildVerificationMessage(), 
            SizedBox(height: 32),
            // Champs OTP
            _buildOtpFields(),          
            SizedBox(height: 24),
            // Timer d'expiration
            _buildExpirationTimer(),        
            SizedBox(height: 32),         
            // Bouton confirmer
            _buildConfirmButton(),
            SizedBox(height: 20),
            // Section renvoyer le code
            _buildResendSection(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationMessage() {
    return Column(
      children: [
        Text(
          'Un code à 5 chiffres a été envoyé votre numéro',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'par SMS / Whatsapp',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Veuillez le saisir pour sécuriser votre connexion',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: controller.otpControllers[index],
            focusNode: controller.otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFFF5F5F5), // Gris clair comme dans l'image
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => controller.onOtpChanged(value, index),
            onTap: () {
              controller.otpControllers[index].selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.otpControllers[index].text.length,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildExpirationTimer() {
    return Obx(() => Text(
      'Le code expire dans ${controller.formattedExpirationTime}',
      style: TextStyle(
        fontSize: 14,
        color: Colors.red[400],
        fontWeight: FontWeight.w500,
      ),
    ));
  }

  Widget _buildConfirmButton() {
    return Obx(() => Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4ADEBC), // Vert clair
            Color(0xFF4F9CF9), // Bleu comme dans l'image
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4ADEBC).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(27),
          onTap: controller.otpCode.value.length >= 5 && !controller.isVerifying.value
              ? controller.verifyOtp
              : null,
          child: Center(
            child: controller.isVerifying.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.5,
                  )
                : Text(
                    'Confirmer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    ));
  }

  Widget _buildResendSection() {
    return Obx(() => Column(
      children: [
        if (!controller.canResend.value)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Code non reçu ? ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              children: [
                TextSpan(
                  text: 'Renvoyer dans 00:${controller.resendTimer.value.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        
        if (controller.canResend.value)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: controller.resendCode,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Code non reçu ? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    children: [
                      TextSpan(
                        text: 'Renvoyer maintenant',
                        style: TextStyle(
                          color: Color(0xFF4ADEBC),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    ));
  }
}