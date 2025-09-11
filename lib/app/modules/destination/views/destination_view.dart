import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/destination_controller.dart';
import '../widgets/cancellation_modal_widget.dart';

class DestinationView extends GetView<DestinationController> {
  const DestinationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            // Carte en arrière-plan
            _buildMapArea(),
            
            // Section d'informations en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomInfoSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea() {
    return Positioned.fill(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(14.716677, -17.467686), // Dakar
          initialZoom: 13.0,
          interactionOptions: const InteractionOptions(
            enableScrollWheel: true,
            enableMultiFingerGestureRace: true,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.demnaa_front',
            maxZoom: 19,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSectionWithNotification() {
    return _buildBottomInfoSection();
  }

  Widget _buildBottomInfoSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification intégrée dans le bloc blanc
            Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: controller.isWaitingResponse.value 
                    ? const Color(0xFF10B981) 
                    : Colors.green.shade600,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Bouton retour
                      GestureDetector(
                        onTap: controller.goBack,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.isWaitingResponse.value
                              ? 'Veuillez patientez la réponse du conducteur'
                              : 'Conducteur trouvé !',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  if (controller.isWaitingResponse.value) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recherche en cours...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            )),
            
            // Trajet avec icônes et adresses - centré
            _buildRouteInfo(),
            
            const SizedBox(height: 24),
            
            // Bouton d'annulation
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

Widget _buildRouteInfo() {
  return Column(
    children: [
      // Départ avec layout horizontal
      Row(
        children: [
          // Boîte "Départ"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'Départ',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Icône de départ
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Boîte adresse de départ - DYNAMIQUE
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Obx(() => Text(
                controller.departureAddress.value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis, // Gérer les adresses longues
              )),
            ),
          ),
        ],
      ),
      
      // Ligne de connexion pointillée bleue
      Container(
        child: Row(
          children: [
            const SizedBox(width: 90), // Centrer la ligne sous l'icône
            Container(
              width: 24,
              child: Column(
                children: List.generate(8, (index) => Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  width: 2,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6), // Bleu comme dans l'image
                    borderRadius: BorderRadius.circular(1),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
      
      // Arrivée avec layout horizontal
      Row(
        children: [
          // Boîte "Arrivée"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'Arrivée',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Icône d'arrivée
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Boîte adresse d'arrivée - DYNAMIQUE
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Obx(() => Text(
                controller.destinationAddress.value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis, // Gérer les adresses longues
              )),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => _showCancellationModal(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Annuler la commande X',
          style: TextStyle(
            color: Color(0xFFDC2626),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Afficher le modal d'annulation
void _showCancellationModal() {
  if (controller.isFromHome.value) {
    // Si vient de home, utiliser le modal existant
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CancellationModalWidget(),
    );
  } else {
    // Sinon, afficher un dialog simple
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Voulez-vous vraiment annuler votre commande ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                // Bouton Oui
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back(); // Fermer le dialog
                      controller.handleCancellation(); // CORRECTION: Appeler la méthode du controller
                    },
                    child: const Text(
                      'Oui',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                
                // Bouton Non
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                    ),
                    child: const Text(
                      'Non',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Méthode pour gérer l'annulation après confirmation

}