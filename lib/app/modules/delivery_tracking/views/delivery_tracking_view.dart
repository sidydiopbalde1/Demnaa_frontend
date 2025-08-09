import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/delivery_tracking_controller.dart';

class DeliveryTrackingView extends GetView<DeliveryTrackingController> {
  const DeliveryTrackingView({super.key});

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
            
            // Course Info Section
            _buildCourseInfoSection(),
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
            'Livreur disponible',
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
            top: 80,
            left: 60,
            child: _buildMapPin(Colors.red, Icons.location_on),
          ),
          Positioned(
            bottom: 120,
            right: 80,
            child: _buildMapPin(Colors.green, Icons.location_on),
          ),
          
          // Ligne de trajet simulée
          Positioned(
            top: 100,
            left: 80,
            child: CustomPaint(
              size: const Size(200, 150),
              painter: RoutePainter(),
            ),
          ),
          
          // Pin principal de localisation
          Positioned(
            top: Get.height * 0.15,
            left: Get.width * 0.5 - 20,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: const Color(0xFFDC2626),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(Color color, IconData icon) {
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

  Widget _buildCourseInfoSection() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Type Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votre course moto-taxi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Transport Options
                Obx(() => Row(
                  children: List.generate(
                    controller.transportOptions.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => controller.selectTransport(index),
                        child: Container(
                          margin: EdgeInsets.only(
                            right: index < controller.transportOptions.length - 1 ? 12 : 0,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: controller.selectedTransport.value == index 
                                ? const Color(0xFFEFF6FF) 
                                : const Color(0xFFF9FAFB),
                            border: Border.all(
                              color: controller.selectedTransport.value == index 
                                  ? const Color(0xFF3B82F6) 
                                  : const Color(0xFFE5E7EB),
                              width: controller.selectedTransport.value == index ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              controller.transportOptions[index]['icon'],
                              color: controller.selectedTransport.value == index 
                                  ? const Color(0xFF3B82F6) 
                                  : const Color(0xFF9CA3AF),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          // Arrival Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFEFF6FF),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF2563EB),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Arrive dans ~${controller.arrivalTime.value} min',
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Distance: ${controller.distance.value} km',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )),
          ),
          
          // Price Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(() => Text(
                  'Prix ${controller.price.value} FCFA',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                )),
                const SizedBox(height: 16),
                
                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AnimatedBuilder(
                    animation: controller.progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF2563EB)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Validate Button
                Obx(() => Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF2E5BBA)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E5BBA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: controller.isValidating.value ? null : controller.validateCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isValidating.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Valider ta course',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
                
                const SizedBox(height: 12),
                
                // Cancel Button
                TextButton(
                  onPressed: controller.cancelCourse,
                  child: const Text(
                    'Annuler la course',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
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

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width, size.height * 0.6);

    // Create dashed effect
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final nextDistance = distance + dashWidth;
        if (nextDistance > pathMetric.length) {
          canvas.drawPath(
            pathMetric.extractPath(distance, pathMetric.length),
            paint,
          );
          break;
        }
        canvas.drawPath(
          pathMetric.extractPath(distance, nextDistance),
          paint,
        );
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}