import 'package:flutter/material.dart';

class ServiceModel {
  final int id;
  final String libelle;
  final String photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.libelle,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  // Conversion depuis JSON (API)
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      libelle: json['libelle'] ?? '',
      photo: json['photo'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'photo': photo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Getter pour l'affichage formaté du nom
  String get displayName {
    // Convertir "moto-course" en "Moto-course"
    if (libelle.isEmpty) return 'Service';
    
    return libelle.split('-').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('-');
  }

  // Getter pour l'icône selon le libellé
  IconData get icon {
    final normalizedLibelle = libelle.toLowerCase();
    
    if (normalizedLibelle.contains('course') || normalizedLibelle.contains('taxi')) {
      return Icons.motorcycle;
    } else if (normalizedLibelle.contains('colis') || normalizedLibelle.contains('livraison')) {
      return Icons.local_shipping;
    } else if (normalizedLibelle.contains('santé') || normalizedLibelle.contains('sante')) {
      return Icons.medical_services;
    } else if (normalizedLibelle.contains('food') || normalizedLibelle.contains('restaurant')) {
      return Icons.restaurant;
    } else {
      return Icons.miscellaneous_services;
    }
  }

  // Getter pour le dégradé de couleurs
  LinearGradient get gradient {
    final normalizedLibelle = libelle.toLowerCase();
    
    if (normalizedLibelle.contains('course') || normalizedLibelle.contains('taxi')) {
      return const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
      );
    } else if (normalizedLibelle.contains('colis') || normalizedLibelle.contains('livraison')) {
      return const LinearGradient(
        colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
      );
    } else if (normalizedLibelle.contains('santé') || normalizedLibelle.contains('sante')) {
      return const LinearGradient(
        colors: [Color(0xFFEF5350), Color(0xFFE53935)],
      );
    } else if (normalizedLibelle.contains('food') || normalizedLibelle.contains('restaurant')) {
      return const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
      );
    }
  }

  @override
  String toString() {
    return 'Service(id: $id, libelle: $libelle, photo: $photo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Modèle pour la réponse API
class ServicesResponse {
  final String message;
  final int code;
  final List<ServiceModel> services;
  final int total;

  ServicesResponse({
    required this.message,
    required this.code,
    required this.services,
    required this.total,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final servicesList = data['services'] as List<dynamic>? ?? [];
    
    return ServicesResponse(
      message: json['message'] ?? '',
      code: json['code'] ?? 200,
      services: servicesList.map((service) => ServiceModel.fromJson(service)).toList(),
      total: data['total'] ?? 0,
    );
  }
}