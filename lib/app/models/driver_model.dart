class Driver {
  final String name;
  final String status; // "Actif" ou "Inactif"
  final double distance; // Distance en km ou m
  final String? positionStatus; // "Position désactivée" si applicable

  Driver({
    required this.name,
    required this.status,
    required this.distance,
    this.positionStatus,
  });
}