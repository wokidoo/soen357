import 'package:flutter/material.dart';

void main() {
  runApp(const PlantApp());
}

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final List<Map<String, String>> plants = const [
    {"name": "Snake Plant"},
    {"name": "Monstera"},
    {"name": "ZZ Plant"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add plant logic
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Plants',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            ...plants.map((plant) => PlantCard(plant: plant)),
            const SizedBox(height: 24),
            Text('Daily Tasks',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const TaskCheckbox(label: "Water Snake Plant"),
            const TaskCheckbox(label: "Check Monstera Soil"),
            const SizedBox(height: 24),
            Text('Recommendations',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const TipCard(text: "Keep Monstera away from direct sunlight."),
            const TipCard(text: "ZZ Plant prefers low light and dry soil."),
          ],
        ),
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final Map<String, String> plant;

  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(plant['name']!),
        trailing: TextButton(
          child: const Text("Plant Profile"),
          onPressed: () {
            // Navigate to plant profile
          },
        ),
      ),
    );
  }
}

class TaskCheckbox extends StatefulWidget {
  final String label;

  const TaskCheckbox({super.key, required this.label});

  @override
  TaskCheckboxState createState() => TaskCheckboxState();
}

class TaskCheckboxState extends State<TaskCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.label),
      value: isChecked,
      onChanged: (val) {
        setState(() {
          isChecked = val ?? false;
        });
      },
    );
  }
}

class TipCard extends StatelessWidget {
  final String text;

  const TipCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text),
      ),
    );
  }
}
