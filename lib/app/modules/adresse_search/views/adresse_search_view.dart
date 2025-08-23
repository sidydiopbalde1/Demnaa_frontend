import 'package:demnaa_front/app/modules/adresse_search/controllers/adresse_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddressSearchView extends GetView<AddressSearchController> {
  const AddressSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
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
          // Bouton retour
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF2D3748),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Recherche adresse',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
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
          
          // Overlays profil utilisateur et service
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Profil utilisateur à gauche
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
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
                ),
                
                // Service Livraison à droite
                Obx(() => Container(
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
                      // Icône du service
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
                      // Texte du service
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
                )),
              ],
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
              decoration: const BoxDecoration(
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
                      _buildIconButton(Icons.home_outlined, 'home'),
                      _buildIconButton(Icons.access_time, 'history'),
                      _buildIconButton(Icons.location_on_outlined, 'location'),
                      _buildIconButton(Icons.navigation_outlined, 'favorites'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

            SizedBox(
  width: 200, // largeur réduite ici
  child: TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: placeholder,
      hintStyle: const TextStyle(
        color: Color(0xFF9CA3AF),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      isDense: true,
    ),
    style: const TextStyle(
      color: Color(0xFF1F2937),
      fontWeight: FontWeight.w500,
    ),
  ),
),

              Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      backgroundColor: Color.fromARGB(255, 115, 226, 191),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: subtitleColor,
                    size: 14,
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


  // Widget _buildAddressSection() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 10,
  //           offset: Offset(0, -2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         // Départ avec autocomplétion
  //         _buildAddressFieldWithAutocomplete(
  //           title: 'Adresse de récupération du colis',
  //           label: 'Départ',
  //           controller: controller.departureController,
  //           backgroundColor: const Color(0xFFFFFF),
  //           borderColor: const Color.fromARGB(255, 39, 49, 187),
  //           labelColor: const Color(0xFFDC2626),
  //           subtitle: controller.departureAddress.value,
  //           subtitleColor: const Color(0xFF059669),
  //           isDeparture: true,
  //         ),
          
  //         // Ajouter un arrêt
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 12),
  //           child: GestureDetector(
  //             onTap: controller.addStop,
  //             child: Row(
  //               children: [
  //                 const Icon(
  //                   Icons.add,
  //                   color: Color(0xFF2E5BBA),
  //                   size: 16,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 const Text(
  //                   'Ajouter un arrêt',
  //                   style: TextStyle(
  //                     color: Color(0xFF2E5BBA),
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
          
  //         // Destination avec autocomplétion
  //         _buildAddressFieldWithAutocomplete(
  //           title: 'Destination de la livraison',
  //           label: 'Arriver',
  //           controller: controller.destinationController,
  //           backgroundColor: const Color(0xFFFFFF),
  //           borderColor: const Color(0xFF059669),
  //           labelColor: const Color(0xFF059669),
  //           subtitle: controller.destinationAddress.value,
  //           subtitleColor: const Color(0xFF059669),
  //           placeholder: 'Téléphone',
  //           isDeparture: false,
  //         ),
          
  //         const SizedBox(height: 24),
          
  //         // Commander Button
  //         Obx(() => Container(
  //           width: double.infinity,
  //           height: 56,
  //           decoration: BoxDecoration(
  //             gradient: const LinearGradient(
  //               colors: [Color(0xFF10B981), Color(0xFF2E5BBA)],
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //             ),
  //             borderRadius: BorderRadius.circular(16),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: const Color(0xFF2E5BBA).withOpacity(0.3),
  //                 blurRadius: 12,
  //                 offset: const Offset(0, 6),
  //               ),
  //             ],
  //           ),
  //           child: ElevatedButton(
  //             onPressed: controller.isLoading.value ? null : controller.commander,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.transparent,
  //               shadowColor: Colors.transparent,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //             ),
  //             child: controller.isLoading.value
  //               ? const CircularProgressIndicator(
  //                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //                 )
  //               : const Text(
  //                   'Commander',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //           ),
  //         )),
  //       ],
  //     ),
  //   );
  // }

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
        children: [
          // Départ
          _buildAddressField(
            title: 'Adresse de récupération du colis',
            label: 'Départ',
            controller: controller.departureController,
            backgroundColor: const Color(0xFFFFFF),
            borderColor: const Color.fromARGB(255, 39, 49, 187),
            labelColor: const Color(0xFFDC2626),
            subtitle: controller.departureAddress.value,
            subtitleColor: const Color(0xFF059669),
          ),
          
          // Ajouter un arrêt
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
          
          // Destination
          _buildAddressField(
            title: 'Destination de la livraison',
            label: 'Arriver',
            controller: controller.destinationController,
            backgroundColor: const Color(0xFFFFFF),
            borderColor: const Color(0xFF059669),
            labelColor: const Color(0xFF059669),
            subtitle: controller.destinationAddress.value,
            subtitleColor: const Color(0xFF059669),
            placeholder: 'Téléphone',
          ),
          
          const SizedBox(height: 24),
          
          // Commander Button
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
  // Widget _buildAddressFieldWithAutocomplete({
  //   required String title,
  //   required String label,
  //   required TextEditingController controller,
  //   required Color backgroundColor,
  //   required Color borderColor,
  //   required Color labelColor,
  //   required String subtitle,
  //   required Color subtitleColor,
  //   String? placeholder,
  //   required bool isDeparture,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             width: 12,
  //             height: 12,
  //             decoration: const BoxDecoration(
  //               shape: BoxShape.circle,
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           Text(
  //             title,
  //             style: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w500,
  //               color: Color(0xFF6B7280),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
        
  //       // Container principal avec autocomplétion
  //       Stack(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: backgroundColor,
  //               border: Border.all(color: borderColor),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       label,
  //                       style: TextStyle(
  //                         color: labelColor,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         _buildIconButton(Icons.home_outlined, 'home'),
  //                         _buildIconButton(Icons.access_time, 'history'),
  //                         _buildIconButton(Icons.location_on_outlined, 'location'),
  //                         _buildIconButton(Icons.navigation_outlined, 'favorites'),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: TextFormField(
  //                         controller: controller,
  //                         decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: placeholder ?? 'Saisissez une adresse...',
  //                           hintStyle: const TextStyle(
  //                             color: Color(0xFF9CA3AF),
  //                           ),
  //                         ),
  //                         style: const TextStyle(
  //                           color: Color(0xFF1F2937),
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                     // Indicateur de chargement pour la recherche
  //                     Obx(() => isDeparture 
  //                       ? (this.controller.isSearchingDeparture.value 
  //                           ? const SizedBox(
  //                               width: 16,
  //                               height: 16,
  //                               child: CircularProgressIndicator(strokeWidth: 2),
  //                             )
  //                           : const SizedBox.shrink())
  //                       : (this.controller.isSearchingDestination.value
  //                           ? const SizedBox(
  //                               width: 16,
  //                               height: 16,
  //                               child: CircularProgressIndicator(strokeWidth: 2),
  //                             )
  //                           : const SizedBox.shrink())),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     const SizedBox(width: 4),
  //                     Expanded(
  //                       child: Text(
  //                         subtitle,
  //                         style: const TextStyle(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                           color: Color.fromARGB(255, 115, 226, 191),
  //                         ),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                     Icon(
  //                       Icons.location_on,
  //                       color: subtitleColor,
  //                       size: 14,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
            
  //           // Liste d'autocomplétion
  //           Obx(() {
  //             final showSuggestions = isDeparture 
  //               ? this.controller.showDepartureSuggestions.value
  //               : this.controller.showDestinationSuggestions.value;
              
  //             final suggestions = isDeparture 
  //               ? this.controller.departureSuggestions
  //               : this.controller.destinationSuggestions;
              
  //             if (!showSuggestions || suggestions.isEmpty) {
  //               return const SizedBox.shrink();
  //             }
              
  //             return Positioned(
  //               top: 90,
  //               left: 0,
  //               right: 0,
  //               child: Container(
  //                 constraints: const BoxConstraints(maxHeight: 200),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: Colors.grey[300]!),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.1),
  //                       blurRadius: 8,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: suggestions.length,
  //                   itemBuilder: (context, index) {
  //                     final suggestion = suggestions[index];
  //                     return ListTile(
  //                       dense: true,
  //                       leading: const Icon(
  //                         Icons.location_on,
  //                         color: Color(0xFF2E5BBA),
  //                         size: 20,
  //                       ),
  //                       title: Text(
  //                         suggestion.address,
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                           color: Color(0xFF1F2937),
  //                         ),
  //                         maxLines: 1,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       subtitle: Text(
  //                         suggestion.displayName,
  //                         style: const TextStyle(
  //                           fontSize: 12,
  //                           color: Color(0xFF6B7280),
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                       onTap: () {
  //                         if (isDeparture) {
  //                           this.controller.selectDepartureSuggestion(suggestion);
  //                         } else {
  //                           this.controller.selectDestinationSuggestion(suggestion);
  //                         }
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           }),
  //         ],
  //       ),
  //       const SizedBox(height: 16),
  //     ],
  //   );
  // }

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