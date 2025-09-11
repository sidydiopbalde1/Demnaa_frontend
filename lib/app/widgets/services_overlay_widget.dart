import 'package:demnaa_front/app/modules/adresse_search/controllers/adresse_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesOverlayWidget extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Function(dynamic)? onServiceSelected;
  final List<dynamic>? customServices;
  final bool isHorizontalLayout;
  final String? selectedService; // Nouveau paramètre pour le service sélectionné

  const ServicesOverlayWidget({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
    this.onServiceSelected,
    this.customServices,
    this.isHorizontalLayout = true,
    this.selectedService, // Ajout du paramètre
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          // Bouton retour (si activé)
          if (showBackButton) _buildBackButton(),
          
          if (showBackButton) const SizedBox(height: 4),
          
          // Services
          _buildServicesRow(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: double.infinity,
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Color.fromARGB(255, 27, 93, 207),
              ),
              onPressed: onBackPressed ?? () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesRow() {
    return Container(
      height: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _buildServiceItems(),
        ),
      ),
    );
  }

  List<Widget> _buildServiceItems() {
    // Si des services personnalisés sont fournis, les utiliser
    if (customServices != null) {
      return customServices!.map((service) {
        final isSelected = _isServiceSelected(service);
        return _buildServiceItem(service, isSelected: isSelected);
      }).toList();
    }

    // Sinon essayer de récupérer depuis le controller
    try {
      final controller = Get.find<AddressSearchController>();
      return controller.availableServices.map((service) {
        final isSelected = selectedService != null 
            ? _isServiceSelected(service)
            : controller.selectedServiceModel.value?.id == service.id;
        return _buildServiceItem(service, isSelected: isSelected);
      }).toList();
    } catch (e) {
      // Fallback : services par défaut avec sélection basée sur selectedService
      return [
        _buildDefaultServiceItem('Livraison', Icons.local_shipping, 
            isSelected: selectedService?.toLowerCase().contains('livraison') ?? false),
        _buildDefaultServiceItem('Moto-taxi', Icons.motorcycle, 
            isSelected: selectedService?.toLowerCase().contains('taxi') ?? selectedService?.toLowerCase().contains('moto') ?? false),
        _buildDefaultServiceItem('Bagage', Icons.shopping_bag, 
            isSelected: selectedService?.toLowerCase().contains('bagage') ?? false),
      ];
    }
  }

  // Fonction pour vérifier si un service est sélectionné
  bool _isServiceSelected(dynamic service) {
    if (selectedService == null) return false;
    
    // Vérifier par displayName, libelle ou nom
    final serviceName = service.displayName ?? service.libelle ?? service.toString();
    return serviceName.toLowerCase().contains(selectedService!.toLowerCase()) ||
           selectedService!.toLowerCase().contains(serviceName.toLowerCase());
  }

  Widget _buildServiceItem(dynamic service, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (onServiceSelected != null) {
          // Passer le nom du service plutôt que l'objet complet
          final serviceName = service.displayName ?? service.libelle ?? service.toString();
          onServiceSelected!(serviceName);
        } else {
          // Fallback vers le controller si disponible
          try {
            final controller = Get.find<AddressSearchController>();
            controller.selectServiceFromMap(service);
          } catch (e) {
            print('Aucun controller trouvé pour sélectionner le service');
          }
        }
      },
      child: Container(
        width: isSelected ? 150 : 95,
        height: isSelected ? 50 : 24,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.95)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          // Ajouter une bordure pour le service sélectionné
          // border: isSelected 
          //     ? Border.all(color: const Color(0xFF10B981), width: 2)
          //     : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              service.icon ?? _getDefaultIcon(service),
              color: 
                   const Color(0xFF2E5BBA),
              size: 16,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                service.displayName ?? service.libelle ?? service.toString(),
                style: TextStyle(
                  color:  const Color(0xFF2E5BBA),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour obtenir l'icône par défaut selon le type de service
  IconData _getDefaultIcon(dynamic service) {
    final serviceName = (service.displayName ?? service.libelle ?? service.toString()).toLowerCase();
    
    if (serviceName.contains('taxi') || serviceName.contains('moto')) {
      return Icons.motorcycle;
    } else if (serviceName.contains('livraison')) {
      return Icons.local_shipping;
    } else if (serviceName.contains('bagage')) {
      return Icons.shopping_bag;
    }
    
    return Icons.local_shipping; // Icône par défaut
  }

  Widget _buildDefaultServiceItem(String name, IconData icon, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (onServiceSelected != null) {
          onServiceSelected!(name);
        }
      },
      child: Container(
        width: isSelected ? 102 : 90,
        height: isSelected ? 32 : 24,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.95)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          // Ajouter une bordure pour le service sélectionné
          border: isSelected 
              ? Border.all(color: const Color(0xFF10B981), width: 2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: isSelected 
                  ? const Color(0xFF10B981) 
                  : const Color(0xFF2E5BBA), 
              size: 16
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFF2E5BBA),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}