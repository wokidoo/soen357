import 'package:flutter/material.dart';
import './models/plant.dart';
import './database/plant_database.dart';

class PlantSearchPage extends StatefulWidget {
  final void Function(Plant plant) onAddPlant;

  const PlantSearchPage({Key? key, required this.onAddPlant}) : super(key: key);

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
            child: ListView.separated(
              itemCount: filteredPlants.length,
              separatorBuilder: (context, index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.green,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade50,
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              itemBuilder: (context, index) {
                final plant = filteredPlants[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 80,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 8),
                    leading: Image.asset(plant.imageUrl ?? ''),
                    title: Text(
                      plant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(plant.species),
                    trailing: ElevatedButton(
                      onPressed: () {
                        widget.onAddPlant(plant);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.green), // Green border added
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: const Text(
                        "Add to Personal Catalog",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
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
