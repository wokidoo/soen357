// lib/models/plant.dart

class Plant {
  final String id;
  final String name;
  final String species;
  final String description;
  final String currentStatus;
  final String leafCondition;
  final String wateringSchedule;
  final String sunlightPreference;
  final String temperatureRange;
  final String? imageUrl; // optional, if you want to store an image link

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.description,
    required this.currentStatus,
    required this.leafCondition,
    required this.wateringSchedule,
    required this.sunlightPreference,
    required this.temperatureRange,
    this.imageUrl,
  });
}
