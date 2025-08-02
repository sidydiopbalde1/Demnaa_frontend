import 'package:demnaa_front/app/modules/create_favorite_place/controllers/create_favorite_place_controller.dart';
import 'package:demnaa_front/app/services/api_service.dart';
import 'package:get/get.dart';


class FavoritePlaceService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // Endpoints
  static const String _favoritePlacesEndpoint = '/favorite-places';
  static const String _searchAddressEndpoint = '/search-address';

  // Récupérer tous les lieux favoris
  Future<List<FavoritePlace>> getFavoritePlaces() async {
    try {
      final response = await _apiService.getRequest(_favoritePlacesEndpoint);

      if (response['statusCode'] == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => FavoritePlace.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la récupération');
      }
    } catch (e) {
      throw Exception('Impossible de récupérer les lieux favoris: $e');
    }
  }

  // Créer un nouveau lieu favori
  Future<FavoritePlace> createFavoritePlace({
    required String name,
    required String address,
    required String iconData,
  }) async {
    try {
      final body = {
        'name': name,
        'address': address,
        'icon_data': iconData,
      };

      final response = await _apiService.postRequest(_favoritePlacesEndpoint, body);

      if (response['statusCode'] == 201 && response['data'] != null) {
        return FavoritePlace.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la création');
      }
    } catch (e) {
      throw Exception('Impossible de créer le lieu favori: $e');
    }
  }

  // Mettre à jour un lieu favori
  Future<FavoritePlace> updateFavoritePlace({
    required String id,
    String? name,
    String? address,
    String? iconData,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (address != null) body['address'] = address;
      if (iconData != null) body['icon_data'] = iconData;

      final response = await _apiService.putRequest(
        '$_favoritePlacesEndpoint/$id',
        body,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        return FavoritePlace.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      throw Exception('Impossible de mettre à jour le lieu favori: $e');
    }
  }

  // Supprimer un lieu favori
  Future<bool> deleteFavoritePlace(String id) async {
    try {
      final response = await _apiService.getRequest('$_favoritePlacesEndpoint/$id/delete');

      if (response['statusCode'] == 200) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la suppression');
      }
    } catch (e) {
      throw Exception('Impossible de supprimer le lieu favori: $e');
    }
  }

  // Rechercher des adresses
  Future<List<String>> searchAddresses(String query) async {
    try {
      final response = await _apiService.getRequest(
        '$_searchAddressEndpoint?q=${Uri.encodeComponent(query)}&limit=5',
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((item) => item['display_name'] as String).toList();
      } else {
        throw Exception(response['message'] ?? 'Erreur lors de la recherche');
      }
    } catch (e) {
      throw Exception('Impossible de rechercher les adresses: $e');
    }
  }

  // Obtenir la position actuelle (géolocalisation)
  Future<String> getCurrentPosition() async {
    try {
      final response = await _apiService.getRequest('/current-position');

      if (response['statusCode'] == 200 && response['data'] != null) {
        return response['data']['formatted_address'] as String;
      } else {
        throw Exception(response['message'] ?? 'Erreur de géolocalisation');
      }
    } catch (e) {
      throw Exception('Impossible d\'obtenir la position actuelle: $e');
    }
  }
}