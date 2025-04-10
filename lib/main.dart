import 'package:flutter/material.dart';
import './models/plant.dart';
import './database/plant_database.dart';
import 'plant_detail_page.dart';
import 'plant_search_page.dart';

void main() {
  runApp(const PlantApp());
}

class PlantApp extends StatelessWidget {
  const PlantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home:
          DashboardPage(), // Removed const from DashboardPage since it holds non-const fields.
    );
  }
}

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  // Fetch plants from your PlantDatabase (runtime values, not compile‑time constants)
  final List<Plant> myPlants = PlantDatabase().getAllPlants();
  // For this example, we'll re-use the same plant list for "Grow the Family."
  final List<Plant> recommendedPlants = PlantDatabase().getAllPlants();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using an AppBar here; if you want a custom header instead, you can adjust accordingly.
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // ===== Search Bar =====
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.green.shade50,
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const PlantSearchPage()),
              //       );
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 16, vertical: 14),
              //       decoration: BoxDecoration(
              //         color: Colors.green.shade50,
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: Row(
              //         children: const [
              //           Icon(Icons.search, color: Colors.black54),
              //           SizedBox(width: 8),
              //           Text(
              //             "Search Plant Catalog",
              //             style: TextStyle(color: Colors.black54),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),

              // ===== My Plants Section =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Plants",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.green,
                    iconSize: 32,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlantSearchPage()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: myPlants.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return PlantCard(plant: myPlants[index]);
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ===== Today's Tasks =====
              Text(
                "Today's Tasks",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const TaskItem(label: "Water ZZ Plant", icon: Icons.water_drop),
              const TaskItem(label: "Water Monstera", icon: Icons.water_drop),
              const TaskItem(
                  label: "Move Snake Plant out of the sun",
                  icon: Icons.wb_sunny),
              const TaskItem(
                  label: "Change Monstera’s soil", icon: Icons.grass),
              const SizedBox(height: 8),

              // ===== Streak Info =====
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "5 Days",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                    ),
                    const SizedBox(width: 6),
                    const Text("Current Streak"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ===== Grow the Family Section =====
              Text(
                "Grow the Family",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedPlants.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return PlantCard(plant: recommendedPlants[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Plant plant;
  const PlantCard({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the image provider based on the imageUrl.
    final ImageProvider imageProvider =
        (plant.imageUrl != null && plant.imageUrl!.startsWith("assets/"))
            ? AssetImage(plant.imageUrl!) as ImageProvider
            : NetworkImage(plant.imageUrl ?? '');

    return InkWell(
      onTap: () {
        // Navigate to the Plant Detail Page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailPage(plant: plant),
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            // Plant Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Plant Name and Species
            Text(
              plant.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              plant.species,
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final String label;
  final IconData icon;

  const TaskItem({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkbox
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          activeColor: Colors.green,
        ),
        // Icon
        Icon(widget.icon, color: Colors.green),
        const SizedBox(width: 8),
        // Label
        Expanded(
          child: Text(widget.label),
        ),
      ],
    );
  }
}
