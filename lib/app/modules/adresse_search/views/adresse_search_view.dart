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

          const SizedBox(width: 40), 
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
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.demnaa_front',
                      maxZoom: 19,
                    ),
                  ],
                )),
          ),

          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Obx(() {
              if (controller.showServicesOnMap.value) {
                return _buildServicesSelector();
              } else {
                // User + Service sur la même ligne
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profil utilisateur
                    if (controller.comesFromDriversList.value)
                      _buildUserProfile(),

                    // Service sélectionné
                    _buildSingleService(),
                  ],
                );
              }
            }),
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
      height: 100,
      width: double.infinity,
      child: Column(
        children: [
          // Bouton retour en haut à gauche
          Container(
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
                    color: const Color.fromARGB(0, 247, 246, 246),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Color.fromARGB(255, 27, 93, 207),
                    ),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Services centrés en dessous
          Container(
            height: 40,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: controller.availableServices.map((service) {
                  final isSelected =
                      controller.selectedServiceModel.value?.id == service.id;
                  return GestureDetector(
                    onTap: () => controller.selectServiceFromMap(service),
                    child: Container(
                      width: isSelected ? 102 : 90,
                      height: isSelected ? 35 : 24,
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            service.icon,
                            color: const Color(0xFF2E5BBA),
                            size: 16,
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
            ),
          ),
        ],
      ),
    );
  }

  // Service unique (quand on vient de DriversListFullView)
  Widget _buildSingleService() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
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
            width: 30,
            height: 30,
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
          const SizedBox(
            height: 10,
          ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
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
                width: 250,
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
                  onPressed:
                      controller.isLoading.value ? null : controller.commander,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
        const SizedBox(height: 4),
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
                      fontSize: 12,
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
                    borderSide:
                        const BorderSide(color: Color(0xFF059669), width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              // Champ adresse avec autocomplétion
              _buildAddressInput(
                textController: controller.departureController,
                focusNode: controller.departureFocusNode,
                hintText: 'Saisissez une adresse...',
                isDeparture: true,
              ),

              // Adresse sélectionnée
              // Obx(() => Row(
              //       children: [
              //         const Icon(
              //           Icons.location_on,
              //           color: Color(0xFF059669),
              //           size: 14,
              //         ),
              //         const SizedBox(width: 4),
              //         Expanded(
              //           child: Text(
              //             controller.departureAddress.value,
              //             style: const TextStyle(
              //               fontSize: 10,
              //               fontWeight: FontWeight.w500,
              //               color: Color(0xFF059669),
              //             ),
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ),
              //       ],
              //     )),
            ],
          ),
        ),
        const SizedBox(height: 4),
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
        const SizedBox(height: 4),
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
                      fontSize: 12,
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
                    borderSide:
                        const BorderSide(color: Color(0xFF059669), width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              // Champ adresse avec autocomplétion
              _buildAddressInput(
                textController: controller.destinationController,
                focusNode: controller.destinationFocusNode,
                hintText: 'Adresse du destinataire',
                isDeparture: false,
              ),
              const SizedBox(height: 4),

              // Adresse sélectionnée
              // Obx(() => Row(
              //       children: [
              //         const Icon(
              //           Icons.location_on,
              //           color: Color(0xFF059669),
              //           size: 14,
              //         ),
              //         const SizedBox(width: 4),
              //         Expanded(
              //           child: Text(
              //             controller.destinationAddress.value,
              //             style: const TextStyle(
              //               fontSize: 10,
              //               fontWeight: FontWeight.w500,
              //               color: Color(0xFF059669),
              //             ),
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //         ),
              //       ],
              //     )),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Champ adresse avec autocomplétion
  // Dans AddressSearchView

  // Dans AddressSearchView

// Dans AddressSearchView

  Widget _buildAddressInput({
    required TextEditingController textController,
    required FocusNode focusNode,
    required String hintText,
    required bool isDeparture,
  }) {
    // Utilisation d'une Column pour éviter le chevauchement
    return Column(
      mainAxisSize: MainAxisSize
          .min, // Pour que la Column ne prenne que la place nécessaire
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Le champ de saisie de l'adresse
        TextFormField(
          controller: textController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
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
                  width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            isDense: true,
          ),
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),

        // 2. La liste des suggestions (qui n'est plus dans un Stack/Positioned)
        Obx(() {
          final showSuggestions = isDeparture
              ? controller.showDepartureSuggestions.value
              : controller.showDestinationSuggestions.value;
          final suggestions = isDeparture
              ? controller.departureSuggestions
              : controller.destinationSuggestions;

          if (!showSuggestions || suggestions.isEmpty) {
            return const SizedBox
                .shrink(); // Ne rien afficher si pas de suggestions
          }

          // Un peu d'espace entre le champ et la liste
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Material(
              elevation: 4.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 220),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!)),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[200],
                    indent: 50,
                  ),
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return InkWell(
                      onTap: () {
                        if (isDeparture) {
                          controller.selectDepartureSuggestion(suggestion);
                        } else {
                          controller.selectDestinationSuggestion(suggestion);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 14.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: isDeparture
                                    ? const Color(0xFFDC2626)
                                    : const Color(0xFF059669),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    suggestion.address,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    suggestion.displayName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF6B7280),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

// Dans AddressSearchView

  Widget _buildIconButton(IconData icon, String type) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => controller.onIconTap(type),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6B7280),
            size: 14,
          ),
        ),
      ),
    );
  }
}
