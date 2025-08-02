class FavoritePlace {
  final String id;
  final String name;
  final String address;
  final String iconData;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FavoritePlace({
    required this.id,
    required this.name,
    required this.address,
    required this.iconData,
    required this.createdAt,
    this.updatedAt,
  });

  // Conversion depuis JSON (API)
  factory FavoritePlace.fromJson(Map<String, dynamic> json) {
    return FavoritePlace(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      iconData: json['icon_data'] ?? '🏠',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  // Conversion vers JSON (pour l'API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'icon_data': iconData,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Méthode copyWith pour les mises à jour
  FavoritePlace copyWith({
    String? id,
    String? name,
    String? address,
    String? iconData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FavoritePlace(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      iconData: iconData ?? this.iconData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FavoritePlace(id: $id, name: $name, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoritePlace && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}