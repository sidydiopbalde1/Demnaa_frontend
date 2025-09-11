// widgets/map_with_services_widget.dart
import 'package:demnaa_front/app/widgets/services_overlay_widget.dart';
import 'package:demnaa_front/app/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWithServicesWidget extends StatelessWidget {
  final MapController? mapController;
  final LatLng initialCenter;
  final double initialZoom;
  final Function(LatLng)? onMapTap;
  final bool showServicesSelector;
  final bool showUserProfile;
  final Widget? customOverlay;
  final List<Widget>? additionalLayers;

  const MapWithServicesWidget({
    super.key,
    this.mapController,
    required this.initialCenter,
    this.initialZoom = 15.0,
    this.onMapTap,
    this.showServicesSelector = true,
    this.showUserProfile = false,
    this.customOverlay,
    this.additionalLayers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Carte OpenStreetMap
          Positioned.fill(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: initialZoom,
                onTap: onMapTap != null 
                  ? (tapPosition, point) => onMapTap!(point)
                  : null,
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
                // Couches additionnelles (marqueurs, polylines, etc.)
                if (additionalLayers != null) ...additionalLayers!,
              ],
            ),
          ),

          // Overlay personnalisé ou services par défaut
          if (customOverlay != null)
            customOverlay!
          else
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: _buildDefaultOverlay(),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultOverlay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profil utilisateur (si activé)
        if (showUserProfile) UserProfileWidget(),

        // Sélecteur de services (si activé)
        if (showServicesSelector) ServicesOverlayWidget(),
      ],
    );
  }
}

// widgets/services_overlay_widget.dart
