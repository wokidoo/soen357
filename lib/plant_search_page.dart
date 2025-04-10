import 'package:flutter/material.dart';
import './models/plant.dart';
import './database/plant_database.dart';

class PlantSearchPage extends StatefulWidget {
  const PlantSearchPage({Key? key}) : super(key: key);

  @override
  State<PlantSearchPage> createState() => _PlantSearchPageState();
}

class _PlantSearchPageState extends State<PlantSearchPage> {
  final List<Plant> allPlants = PlantDatabase().getAllPlants();
  List<Plant> filteredPlants = [];

  @override
  void initState() {
    super.initState();
    filteredPlants = allPlants;
  }

  void _filterPlants(String query) {
    setState(() {
      filteredPlants = allPlants
          .where((plant) =>
              plant.name.toLowerCase().contains(query.toLowerCase()) ||
              plant.species.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Plants"),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _filterPlants,
              decoration: InputDecoration(
                hintText: "Search Plant Catalog",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];
                return ListTile(
                  leading: Image.asset(plant.imageUrl ?? ''),
                  title: Text(plant.name),
                  subtitle: Text(plant.species),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Logic to add plants
                    },
                    child: const Text("Add to Personal Catalog"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
