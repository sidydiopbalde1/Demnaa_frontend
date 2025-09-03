import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://demmna-backend-1-0-6.onrender.com';
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('🚀 Request: ${options.method} ${options.uri}');
        if (options.data != null) {
          print('📤 Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ Response: ${response.statusCode}');
        print('📥 Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ Error: ${error.response?.statusCode}');
        if (error.response?.data != null) {
          print('📥 Error Data: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  // Test de connexion et découverte des endpoints
  Future<bool> testConnection() async {
    try {
      print('🔍 Test de connexion...');
      final response = await _dio.get('/');
      print('✅ Connexion réussie: ${response.statusCode}');
      return true;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      return false;
    }
  }
  
  // Découvrir les endpoints disponibles
  Future<void> discoverEndpoints() async {
    List<String> endpointsToTest = [
      '/',
      '/api/',
      '/swagger/',
      '/docs/',
      '/admin/',
      '/health/',
      '/status/',
    ];
    
    print('🔍 Découverte des endpoints...');
    
    for (String endpoint in endpointsToTest) {
      try {
        final response = await _dio.get(endpoint);
        print('✅ Endpoint disponible: $endpoint (${response.statusCode})');
      } catch (e) {
        print('❌ Endpoint non disponible: $endpoint');
      }
    }
  }
  
  // Mode simulation pour l'instant
  Future<Map<String, dynamic>?> sendOtp({
    required String telephone,
    required String method,
  }) async {
    print('📱 MODE SIMULATION - Envoi OTP vers: $telephone via $method');
    
    // Simuler une requête réussie
    await Future.delayed(const Duration(seconds: 2));
    
    // Toujours retourner un succès en mode simulation
    return {
      'success': true,
      'message': 'Code envoyé avec succès (simulation)',
      'phone': telephone,
      'method': method,
    };
  }
  
  // Mode simulation pour vérification OTP
  Future<Map<String, dynamic>?> verifyOtp({
    required String telephone,
    required String otp,
  }) async {
    print('🔐 MODE SIMULATION - Vérification OTP: $otp pour $telephone');
    
    await Future.delayed(const Duration(seconds: 1));
    
    // Accepter n'importe quel code de 4 chiffres en simulation
    if (otp.length == 4 && otp.contains(RegExp(r'^[0-9]+$'))) {
      // Simuler un token
      await _saveToken('simulation_token_${DateTime.now().millisecondsSinceEpoch}');
      
      return {
        'success': true,
        'message': 'Code vérifié avec succès (simulation)',
        'token': 'simulation_token',
        'user': {
          'phone': telephone,
          'verified': true,
        }
      };
    } else {
      return {
        'error': 'Code invalide (doit être 4 chiffres)',
      };
    }
  }
  
  // Mode simulation pour inscription
  Future<Map<String, dynamic>?> register({
    required String nom,
    required String prenom,
    required String telephone,
    required String profileType,
    required String fonction,
    required String localite,
    required String genre,
    String? carteEtudiant,
  }) async {
    print('📝 MODE SIMULATION - Inscription: $prenom $nom');
    
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'success': true,
      'message': 'Inscription réussie (simulation)',
      'user': {
        'id': DateTime.now().millisecondsSinceEpoch,
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'profile_type': profileType,
        'fonction': fonction,
        'localite': localite,
        'genre': genre,
      }
    };
  }
}
