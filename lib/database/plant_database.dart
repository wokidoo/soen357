import '../models/plant.dart';

class PlantDatabase {
  static final List<Plant> _plants = [
    Plant(
      id: '1',
      name: 'Snake Plant',
      species: 'Monstera Deliciosa',
      description: 'Snake Plant is a vibrant Monstera Deliciosa, notable for its large, glossy, and fenestrated leaves. Each leaf features distinctive natural splits and holes, contributing to its tropical allure.',
      currentStatus: 'Healthy, with two new leaves unfurling.',
      leafCondition: 'A few brown edges on older leaves.',
      wateringSchedule: 'Once a week, allowing the top inch of soil to dry out before watering.',
      sunlightPreference: 'Prefers bright, indirect sunlight near a window (avoid harsh midday rays).',
      temperatureRange: 'Thrives in 65–85°F (18–29°C).',
      imageUrl: 'assets/snake_plant.png', 
    ),
    Plant(
      id: '2',
      name: 'Monstera',
      species: 'Boston Fern',
      description: 'Monstera is a lush Boston Fern with arching fronds of bright green foliage. Perfect for humid environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 60–75°F (16–24°C).',
      imageUrl: 'assets/boston_fern.png',
    ),
    Plant(
      id: '3',
      name: 'ZZ Plant',
      species: 'Boston Fern',
      description: 'Fernanda is a lush Boston Fern with arching fronds of bright green foliage. Perfect for humid environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 60–75°F (16–24°C).',
      imageUrl: 'assets/zz.png',
    ),
    Plant(
      id: '4',
      name: 'Hanine',
      species: 'Tangeria',
      description: 'Hanine is a lush Tangeria with arching fronds of bright green foliage. Perfect for humid environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 60–75°F (16–24°C).',
      imageUrl: 'assets/hanine.png',
    ),
     Plant(
      id: '5',
      name: 'Ikram',
      species: 'Pasteria',
      description: 'Ikram is a lush Pasteria with arching fronds of bright green foliage. Perfect for humid environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 60–75°F (16–24°C).',
      imageUrl: 'assets/ikram.png',
    ),
     Plant(
      id: '6',
      name: 'Monopera',
      species: 'Tango',
      description: 'Monopera is a lush Tango with arching fronds of bright green foliage. Perfect for humid environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 65–75°F (18–24°C).',
      imageUrl: 'assets/monopera.png',
    ),
    Plant(
      id: '7',
      name: 'Cactus',
      species: 'Cacteria',
      description: 'Cactus is a lush Cacteria with arching fronds of bright green cactis. Perfect for dry environments.',
      currentStatus: 'Healthy, although requires misting for humidity.',
      leafCondition: 'A few fronds are turning yellow at the tips.',
      wateringSchedule: 'Water when the top soil becomes slightly dry, generally twice a week in warm months.',
      sunlightPreference: 'Prefers bright, indirect light, but can tolerate lower light areas.',
      temperatureRange: 'Ideal range: 65–75°F (18–24°C).',
      imageUrl: 'assets/cactus.png',
    ),
  ];

  List<Plant> getAllPlants() => _plants;

  Plant? getPlantById(String id) {
    try {
      return _plants.firstWhere((p) => p.id == id);
    } on StateError {
      return null; // If not found
    }
  }
}
