import 'package:flutter/material.dart';
import './models/plant.dart'; // Adjust path as needed
import 'main.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    // If imageUrl is missing, use a local placeholder
    final String effectiveImageUrl = plant.imageUrl ?? 'assets/placeholder.png';
    final ImageProvider imageProvider = effectiveImageUrl.startsWith('assets/')
        ? AssetImage(effectiveImageUrl)
        : NetworkImage(effectiveImageUrl) as ImageProvider;

    return Scaffold(
      // Minimalistic AppBar similar to the style in your screenshot
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 300,
        leading: GestureDetector(
          onTap: () {
            // Navigate back to the main (dashboard) page.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
              (route) => false,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset(
              'assets/Bloom.png', // Ensure this asset is declared in pubspec.yaml.
              fit: BoxFit.contain,
            ),
          ),
        ), // Note the comma here to end the "leading" widget.
        title: null, // This sets the center title to null.
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            iconSize: 40, // Increase the icon size.
            onPressed: () {
              // Profile button logic here.
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large plant image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: imageProvider,
                    width: MediaQuery.of(context).size.width * 0.65,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Plant Name & Species
              Text(
                plant.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "(${plant.species})",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),

              // Plant Description
              Text(
                plant.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Health Profile Section
              Text(
                "Health Profile",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Divider(thickness: 1.2),
              // Display each relevant property
              _InfoRow(label: "Current Status", value: plant.currentStatus),
              _InfoRow(label: "Leaf Condition", value: plant.leafCondition),
              _InfoRow(label: "Care Schedule", value: plant.wateringSchedule),
              _InfoRow(label: "Sunlight", value: plant.sunlightPreference),
              _InfoRow(label: "Temperature", value: plant.temperatureRange),
              const SizedBox(height: 24),

              // Learn More Button (Optional)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Open external link or show more info
                  },
                  child: const Text(
                    "Learn More",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A small helper widget for displaying a label and value in a row
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
              ),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
