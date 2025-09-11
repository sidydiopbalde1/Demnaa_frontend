// payment_selection_view.dart - Version simplifiée
import 'package:demnaa_front/app/modules/PaymentSelection/controllers/payment_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PaymentSelectionView extends GetView<PaymentSelectionController> {
  const PaymentSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte en plein écran
          _buildFullScreenMap(),

          // Moyens de paiement en overlay
          _buildPaymentOverlay(),
        ],
      ),
    );
  }

  Widget _buildFullScreenMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(14.716677, -17.467686),
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.demnaa_front',
        ),
        // Trajet avec ligne continue
        PolylineLayer(
          polylines: [
            Polyline(
              points: [
                LatLng(14.716677, -17.467686),
                LatLng(14.720000, -17.470000),
              ],
              color: const Color(0xFF3B82F6),
              strokeWidth: 4.0,
              // Note: pattern n'est pas supporté dans toutes les versions
            ),
          ],
        ),
        // Marqueurs de départ et arrivée
        MarkerLayer(
          markers: [
            // Marqueur de départ (bleu)
            Marker(
              point: LatLng(14.716677, -17.467686),
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.location_on,
                    color: Colors.white, size: 20),
              ),
            ),
            // Marqueur d'arrivée (vert)
            Marker(
              point: LatLng(14.720000, -17.470000),
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.flag, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
Widget _buildPaymentOverlay() {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Petit indicateur draggable
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Première ligne de paiement
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPaymentIcon(
                index: 0,
                logoPath: 'assets/images/wave.png',
                backgroundColor: const Color(0xFF00A8E8),
              ),
              _buildPaymentIcon(
                index: 1,
                logoPath: 'assets/images/orange_money.png',
                backgroundColor: const Color(0xFFFF6600),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Deuxième ligne de paiement
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPaymentIcon(
                index: 2,
                logoPath: 'assets/images/k_pay.png',
                backgroundColor: const Color(0xFF10B981),
              ),
              _buildPaymentIcon(
                index: 3,
                logoPath: 'assets/images/cash_money.png',
                backgroundColor: const Color(0xFF6B7280),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget _buildPaymentIcon({
  required int index,
  required String logoPath,
  required Color backgroundColor,
}) {
  return Obx(() => GestureDetector(
        onTap: () {
          controller.selectPaymentMethod(index);
          controller.proceedToPayment(); // 👈 déclenche directement
        },
        child: Container(
          width: 140,
          child: Row(
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    logoPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.payment,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Indicateur sélection
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: controller.selectedPaymentIndex.value == index
                        ? backgroundColor
                        : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: controller.selectedPaymentIndex.value == index
                      ? backgroundColor
                      : Colors.white,
                ),
                child: controller.selectedPaymentIndex.value == index
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ));
}

}
