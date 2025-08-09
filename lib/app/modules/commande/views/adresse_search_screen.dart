import 'package:flutter/material.dart';

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final TextEditingController _departureController = TextEditingController(text: '77 HB 23 24');
  final TextEditingController _destinationController = TextEditingController();

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
            
            // Address Input Section
            _buildAddressSection(),
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
      child: const Center(
        child: Text(
          'Recherche adresse',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
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
          // Service selector en haut à gauche
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E5BBA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Livraison',
                    style: TextStyle(
                      color: Color(0xFF2E5BBA),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pin de localisation central
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5BBA),
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
                      size: 20,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 16,
                  color: const Color(0xFF2E5BBA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // Départ
          _buildAddressField(
            title: 'Adresse de récupération du colis',
            label: 'Départ',
            controller: _departureController,
            backgroundColor: const Color(0xFFFFF5F5),
            borderColor: const Color(0xFFFEB2B2),
            labelColor: const Color(0xFFDC2626),
            subtitle: 'Grand Dakar Rue 449',
            subtitleColor: const Color(0xFF059669),
            dotColor: const Color(0xFF2E5BBA),
          ),
          
          // Ajouter un arrêt
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GestureDetector(
              onTap: () {
                // Action pour ajouter un arrêt
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: const Color(0xFF2E5BBA),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ajouter un arrêt',
                    style: TextStyle(
                      color: const Color(0xFF2E5BBA),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Destination
          _buildAddressField(
            title: 'Destination de la livraison',
            label: 'Arriver',
            controller: _destinationController,
            backgroundColor: const Color(0xFFF9FAFB),
            borderColor: const Color(0xFFD1D5DB),
            labelColor: const Color(0xFF059669),
            subtitle: 'Adresse du destinataire',
            subtitleColor: const Color(0xFF059669),
            dotColor: const Color(0xFFDC2626),
            placeholder: 'Téléphone',
          ),
          
          const SizedBox(height: 24),
          
          // Commander Button
          Container(
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
              onPressed: () {
                // Action pour commander
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Commander',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField({
    required String title,
    required String label,
    required TextEditingController controller,
    required Color backgroundColor,
    required Color borderColor,
    required Color labelColor,
    required String subtitle,
    required Color subtitleColor,
    required Color dotColor,
    String? placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconButton(Icons.home_outlined),
                      _buildIconButton(Icons.access_time),
                      _buildIconButton(Icons.location_on_outlined),
                      _buildIconButton(Icons.navigation_outlined),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: subtitleColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () {
          // Action pour l'icône
        },
        child: Icon(
          icon,
          color: const Color(0xFF9CA3AF),
          size: 18,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _departureController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}