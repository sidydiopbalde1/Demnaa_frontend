import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/destination_controller.dart';

class DestinationView extends GetView<DestinationController> {
  const DestinationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Map Area
            Expanded(
              flex: 3,
              child: _buildMapArea(),
            ),
            
            // Green Waiting Bar
            _buildWaitingBar(),
            
            // Destination Section
            _buildDestinationSection(),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Recherche adresse',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFE8F5E8),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Points sur la carte
          Positioned(
            top: Get.height * 0.08,
            left: Get.width * 0.3,
            child: _buildMapPin(Colors.red),
          ),
          Positioned(
            bottom: Get.height * 0.12,
            right: Get.width * 0.25,
            child: _buildMapPin(Colors.green),
          ),

          // Ligne de trajet
          Positioned(
            top: Get.height * 0.1,
            left: Get.width * 0.32,
            child: CustomPaint(
              size: Size(
                Get.width * 0.4,
                Get.height * 0.15,
              ),
              painter: DashedRoutePainter(),
            ),
          ),
          
          // Pin principal de localisation avec animation
          Center(
            child: AnimatedBuilder(
              animation: controller.pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: controller.pulseAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 16,
                        color: const Color(0xFFDC2626),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingBar() {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: controller.isWaitingResponse.value 
            ? const Color(0xFF10B981) 
            : const Color(0xFF059669),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.isWaitingResponse.value) ...[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Veuillez patienter la réponse du conducteur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'Conducteur trouvé ! Préparation du trajet...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    ));
  }

  Widget _buildDestinationSection() {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Destination',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            
            // Destination Address Card
            Obx(() => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                border: Border.all(
                  color: const Color(0xFF6EE7B7),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
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
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.destinationAddress.value,
                          style: const TextStyle(
                            color: Color(0xFF065F46),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.destinationSubtitle.value,
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Add Stop Button
            GestureDetector(
              onTap: controller.addStop,
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: Color(0xFF2563EB),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ajouter un arrêt',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Options
            Column(
              children: [
                _buildActionOption(
                  'Point de prise en charge',
                  [
                    {'icon': Icons.navigation_outlined, 'action': 'navigation'},
                    {'icon': Icons.home_outlined, 'action': 'home'},
                    {'icon': Icons.access_time, 'action': 'time'},
                    {'icon': Icons.location_on_outlined, 'action': 'location'},
                  ],
                ),
                const SizedBox(height: 12),
                _buildActionOption(
                  'Utiliser votre position ou rechercher une adresse',
                  [
                    {'icon': Icons.search, 'action': 'search'},
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Cancel Course Button
            Center(
              child: TextButton(
                onPressed: controller.cancelCourse,
                child: const Text(
                  'Annuler la course',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionOption(String title, List<Map<String, dynamic>> actions) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (actions.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions.map((actionData) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => controller.onActionTap(actionData['action']),
                  child: Icon(
                    actionData['icon'],
                    color: const Color(0xFF9CA3AF),
                    size: 18,
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}

class DashedRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.7, 
      size.height * 0.3, 
      size.width, 
      size.height
    );

    double distance = 0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double nextDistance = distance + dashWidth;
        canvas.drawPath(
          pathMetric.extractPath(
            distance, 
            nextDistance > pathMetric.length ? pathMetric.length : nextDistance
          ),
          paint,
        );
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}