import 'package:demnaa_front/app/models/services_model.dart';
import 'package:demnaa_front/app/services/api_service.dart';
import 'package:get/get.dart';

import '../config/config.dart'; // 🆕 Import du config

class ServiceService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // 🆕 Utiliser la config pour les endpoints
  static String get _servicesEndpoint => Config.servicesEndpoint;

  // Récupérer tous les services
  Future<List<ServiceModel>> getServices() async {
    try {
      print('🔍 Récupération des services depuis: ${Config.getFullEndpoint(_servicesEndpoint)}');
      
      final response = await _apiService.getRequest(_servicesEndpoint);

      if (response['statusCode'] == 200) {
        final data = response['data'] ?? {};
        final servicesList = data['services'] as List<dynamic>? ?? [];
        
        final services = servicesList.map((service) => ServiceModel.fromJson(service)).toList();
        
        print('✅ ${services.length} services récupérés avec succès');
        return services;
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la récupération des services');
      }
    } catch (e) {
      print('❌ Erreur ServiceService.getServices(): $e');
      throw Exception('Impossible de récupérer les services: $e');
    }
  }

  // Services par défaut en cas d'erreur
  List<ServiceModel> getDefaultServices() {
    return [
      ServiceModel(
        id: 1,
        libelle: 'moto-colis',
        photo: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 2,
        libelle: 'moto-taxi',
        photo: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ServiceModel(
        id: 3,
        libelle: 'moto-santé',
        photo: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}