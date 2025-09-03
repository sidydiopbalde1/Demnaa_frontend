import 'package:demnaa_front/app/modules/adresse_search/controllers/adresse_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

class AddressSearchView extends GetView<AddressSearchController> {
  const AddressSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      
      body: SafeArea(
        child: Column(
          children: [
           
            // _buildHeader(),
            
            // Map Area avec vraie carte
            Expanded(
              flex: 3,
              child: _buildMapArea(),
            ),
           
            // Header
            
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
      
      child: Row(
        children: [
          // Bouton retour
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 27, 93, 207),
            ),
          ),
          
          const SizedBox(width: 48), // Pour équilibrer le bouton retour
        ],
      ),
    );
  }

  Widget _buildMapArea() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Carte OpenStreetMap en arrière-plan
          Positioned.fill(
            child: Obx(() => FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.currentLocation.value,
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  controller.onMapTap(point);
                },
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
                MarkerLayer(
                  markers: [
                    // Marqueur de position actuelle
                    Marker(
                      point: controller.currentLocation.value,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    // Marqueurs pour départ et destination si définis
                    if (controller.departureLocation.value != null)
                      Marker(
                        point: controller.departureLocation.value!,
                        width: 35,
                        height: 35,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E5BBA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    if (controller.destinationLocation.value != null)
                      Marker(
                        point: controller.destinationLocation.value!,
                        width: 35,
                        height: 35,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF059669),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.flag,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )),
          ),
          
          // Overlays profil utilisateur et services
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profil utilisateur à gauche
                Obx(() => controller.comesFromDriversList.value 
                ? _buildUserProfile()
                : const SizedBox.shrink()),
                
                // Services à droite - Conditionnellement affichés
                Obx(() => controller.showServicesOnMap.value 
                  ? _buildServicesSelector()
                  : _buildSingleService()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      
      child: Column(
        children: [
          // Photo de profil
          Container(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E5BBA), width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user_map_icone.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2E5BBA),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Nom de l'utilisateur
          Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: const Column(
              children: [
                Text(
                  'Demnaa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E5BBA),
                  ),
                ),
                Text(
                  'Déme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E5BBA),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sélecteur de services multiples (quand on vient de HomeView)
Widget _buildServicesSelector() {
  return Container(
    height: 60,
    child: Column(
      children: [
        // Bouton retour centré en haut
        Center(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: Color.fromARGB(255, 27, 93, 207),
            ),
            onPressed: () => Get.back(),
          ),
        ),
        
        const SizedBox(height: 8), // Espace entre bouton et services

        // Services en ligne
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer les services
          children: controller.availableServices.map((service) {
            final isSelected = controller.selectedServiceModel.value?.id == service.id;
            return GestureDetector(
              onTap: () => controller.selectServiceFromMap(service),
              child: Container(
                width: 100,
                height: 32, // Réduit pour s'adapter dans les 60px totaux
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.white.withOpacity(0.95)
                    : Colors.white.withOpacity(0.7), 
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Réduit l'opacité
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      service.icon,
                      color: const Color(0xFF2E5BBA),
                      size: 16, // Taille réduite
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        service.displayName,
                        style: const TextStyle(
                          color: Color(0xFF2E5BBA),
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
          }).toList(),
        ),
      ],
    ),
  );
}

  // Service unique (quand on vient de DriversListFullView)
  Widget _buildSingleService() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5BBA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(
                Icons.delivery_dining,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            controller.selectedService.value,
            style: const TextStyle(
              color: Color(0xFF2E5BBA),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(10),
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
        children: [
          Container(
            height: 2,
            width: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 10,),
          // Départ - Seulement adresse
          _buildDepartureField(),
          
          // Ajouter un arrêt
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: GestureDetector(
              onTap: controller.addStop,
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: Color(0xFF2E5BBA),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ajouter un arrêt',
                    style: TextStyle(
                      color: Color(0xFF2E5BBA),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Destination - Téléphone + Adresse
          _buildDestinationField(),
          
          // const SizedBox(height: 24),
          
          // Commander Button
          Obx(() => Container(
            width: double.infinity,
            height: 35,
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
              onPressed: controller.isLoading.value ? null : controller.commander,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isLoading.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    'Commander',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          )),
        ],
      ),
    );
  }

  // Bloc Départ - Seulement champ adresse
  Widget _buildDepartureField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
          
            // Container(
            //   width: 12,
            //   height: 12,
            //   decoration: const BoxDecoration(
            //     color: Color.fromARGB(255, 39, 49, 187),
            //     shape: BoxShape.circle,
            //   ),
            // ),
            // const SizedBox(width: 12),
            const Text(
              'Adresse de récupération du colis',
              style: TextStyle(
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
            color: Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 39, 49, 187)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Départ',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconButton(Icons.home_outlined, 'home'),
                      _buildIconButton(Icons.access_time, 'history'),
                      _buildIconButton(Icons.location_on_outlined, 'location'),
                      _buildIconButton(Icons.navigation_outlined, 'favorites'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Champ adresse avec autocomplétion
              _buildAddressInput(
                textController: controller.departureController,
                focusNode: controller.departureFocusNode,
                hintText: 'Saisissez une adresse...',
                isDeparture: true,
              ),
              
              const SizedBox(height: 4),
              TextFormField(
                // ERREUR CORRIGÉE : Doit être departurePhoneController
                controller: controller.departurePhoneController, 
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Numéro de téléphone',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              // Adresse sélectionnée
              Obx(() => Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF059669),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      controller.departureAddress.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Bloc Destination - Téléphone + Adresse
  Widget _buildDestinationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Destination de la livraison',
              style: TextStyle(
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
            color: Colors.white,
            border: Border.all(color: const Color(0xFF059669)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Arriver',
                    style: TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      _buildIconButton(Icons.home_outlined, 'home'),
                      _buildIconButton(Icons.access_time, 'history'),
                      _buildIconButton(Icons.location_on_outlined, 'location'),
                      _buildIconButton(Icons.navigation_outlined, 'favorites'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Champ téléphone
              TextFormField(
                controller: controller.destinationPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Numéro de téléphone ',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF059669), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Champ adresse avec autocomplétion
              _buildAddressInput(
                textController: controller.destinationController,
                focusNode: controller.destinationFocusNode,
                hintText: 'Adresse du destinataire',
                isDeparture: false,
              ),
              const SizedBox(height: 4),
              
              // Adresse sélectionnée
              Obx(() => Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color(0xFF059669),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      controller.destinationAddress.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Champ adresse avec autocomplétion
  // Dans AddressSearchView

  Widget _buildAddressInput({
    required TextEditingController textController, // Renommé pour la clarté
    required FocusNode focusNode,
    required String hintText,
    required bool isDeparture,
  }) {
    return Stack(
      // AJOUT IMPORTANT : Permet à la liste de déborder visuellement du champ
      clipBehavior: Clip.none, 
      children: [
        TextFormField(
          controller: textController,
          focusNode: focusNode,
          // La recherche est déjà gérée par le listener dans le contrôleur,
          // donc pas besoin de code ici.
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDeparture 
                  ? const Color.fromARGB(255, 39, 49, 187)
                  : const Color(0xFF059669), 
                width: 2
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
          ),
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // Liste d'autocomplétion
        Obx(() {
          // CORRECTION : Utiliser 'controller' (le GetxController) et non 'this.controller'
          final showSuggestions = isDeparture
            ? controller.showDepartureSuggestions.value
            : controller.showDestinationSuggestions.value;
          final suggestions = isDeparture
            ? controller.departureSuggestions
            : controller.destinationSuggestions;
          
          if (!showSuggestions || suggestions.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return Positioned(
            top: 55, // Légèrement ajusté pour un meilleur espacement
            left: 0,
            right: 0,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.location_on,
                      color: Color(0xFF2E5BBA),
                      size: 18,
                    ),
                    title: Text(
                      suggestion.address,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      suggestion.displayName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // CORRECTION : Utiliser 'controller' et non 'this.controller'
                      if (isDeparture) {
                        controller.selectDepartureSuggestion(suggestion);
                      } else {
                        controller.selectDestinationSuggestion(suggestion);
                      }
                    },
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }


  Widget _buildIconButton(IconData icon, String type) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => controller.onIconTap(type),
        child: Icon(
          icon,
          color: const Color(0xFF9CA3AF),
          size: 18,
        ),
      ),
    );
  }
}