import 'package:demnaa_front/app/widgets/demnaa_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drivers_controller.dart';


class DriversEmptyView extends GetView<DriversController> {
  const DriversEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DemNaaAppBar(
        title: 'Mes conducteurs',
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône centrale avec design original
               Container(
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.only(bottom: 40),
                          decoration: const BoxDecoration(
                            color: Color(0xC7DAD0), // Vert clair
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              // Icône de pin/localisation centrale
                              Center(
                                child: Container(
                                  width: 120, // Augmenté de 70 à 120 (l'image sera plus grande que le container central)
                                  height: 120, // Augmenté de 70 à 120
                                  child: Image.asset(
                                    'assets/images/demna_icone.png',
                                    fit: BoxFit.cover,
                                    width: 140, // Augmenté de 100 à 140
                                    height: 140, // Augmenté de 100 à 140
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFF4A90E2),
                                              Color(0xFF5B9BD5),
                                              Color(0xFF6FA8DC),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),       
                // Texte principal
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Vous n\'avez pas encore de conducteur.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Texte descriptif
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Ajoutez un conducteur pour\ncommencer à gérer vos trajets plus\nfacilement !',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton d'ajout en bas
          Padding(
            padding: const EdgeInsets.all(24),
            child: DemNaaButton(
            text: 'Ajout un conducteur',
            onPressed: controller.addDriver,
            gradientColors: [const Color(0xFF29CA96), const Color(0xFF4463DF)], // Vert vers bleu
            borderRadius: 25,
            height: 50,
          ),
          ),
        ],
      ),
      bottomNavigationBar: DemNaaBottomNavigation(
        currentIndex: 2, // Mon Compte actif
        onTap: (index) {
          switch (index) {
            case 0:
              // Historique
              break;
            case 1:
              // DemNaa (Home)
              Get.offAllNamed('/home');
              break;
            case 2:
              // Mon Compte - navigation vers account
              Get.toNamed('/account');
              break;
          }
        },
      ),
    );
  }
}