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
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Plant> myPlants = List.from(PlantDatabase().getAllPlants());
  final List<Plant> recommendedPlants = PlantDatabase().getAllPlants();

  void removePlant(Plant plant) {
    setState(() {
      myPlants.remove(plant);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 300,
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset(
            'assets/Bloom.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            iconSize: 40,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== My Plants Header with + icon ====
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
                    iconSize: 32,
                    color: Colors.green,
                    tooltip: "Add a new plant",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantSearchPage(
                            onAddPlant: (plant) {
                              setState(() {
                                if (!myPlants.contains(plant)) {
                                  myPlants.add(plant);
                                }
                              });
                            },
                          ),
                        ),
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
                    return PlantCard(
                      plant: myPlants[index],
                      onDelete: () => removePlant(myPlants[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

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
                    return PlantCard(
                      plant: recommendedPlants[index],
                      onDelete: null, // Not deletable
                    );
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
  final VoidCallback? onDelete;

  const PlantCard({Key? key, required this.plant, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider =
        (plant.imageUrl != null && plant.imageUrl!.startsWith("assets/"))
            ? AssetImage(plant.imageUrl!) as ImageProvider
            : NetworkImage(plant.imageUrl ?? '');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailPage(
              plant: plant,
              onDelete: () {
                onDelete?.call();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
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
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          activeColor: Colors.green,
        ),
        Icon(widget.icon, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(widget.label),
        ),
      ],
    );
  }
}
