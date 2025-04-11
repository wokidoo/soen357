import 'package:flutter/material.dart';
import 'package:soen357/database/article_database.dart';
import './models/plant.dart';
import './database/plant_database.dart';
import 'database/article_preview_loader.dart';
import './models/article.dart';
import 'plant_detail_page.dart';
import './components/article_card.dart';

void main() {
  runApp(const PlantApp());
}

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

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
  DashboardPage({super.key});

  // Fetch plants from your PlantDatabase (runtime values, not compile‑time constants)
  final List<Plant> myPlants = PlantDatabase().getAllPlants();
  // For this example, we'll re-use the same plant list for "Grow the Family."
  final List<Plant> recommendedPlants = PlantDatabase().getAllPlants();

  Future<List<Article>> loadRecommendedArticles() {
    return Future.wait(
      ArticleDatabase.articleUrls.map((url) => ArticlePreviewLoader.load(url)),
    );
  }

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
              // ===== Search Bar =====
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Plant Catalog",
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) {
                    // Handle search logic
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ===== My Plants Section =====
              Text(
                "My Plants",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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

              // ===== Recommendation Section =====
              Text(
                "Recommended Articles",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Article>>(
                future: loadRecommendedArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load articles');
                  } else {
                    final articles = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          return ArticleCard(article: articles[index]);
                        },
                      ),
                    );
                  }
                },
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
  const PlantCard({super.key, required this.plant});

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
    super.key,
    required this.label,
    required this.icon,
  });

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
