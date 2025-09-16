// 2. Modèle de données pour les profils
import 'package:flutter/material.dart';

class ProfileType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isActive; 

  ProfileType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isActive': isActive,
    };
  }
}