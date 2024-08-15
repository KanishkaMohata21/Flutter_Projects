import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/favorites_provider.dart';

class MealDetails extends ConsumerWidget {
  const MealDetails({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              ref.read(favoriteMealsProvider.notifier).toggleMealFavorite(meal);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display meal image
              Image.network(
                meal.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              
              // Display meal title with custom style
              Text(
                meal.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              const SizedBox(height: 10),
              
              // Display duration, complexity, and affordability
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.white), // White icon color
                      const SizedBox(width: 6),
                      Text(
                        '${meal.duration} min',
                        style: const TextStyle(color: Colors.white), // White text color
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work, color: Colors.white), // White icon color
                      const SizedBox(width: 6),
                      Text(
                        meal.complexity.name,
                        style: const TextStyle(color: Colors.white), // White text color
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.white), // White icon color
                      const SizedBox(width: 6),
                      Text(
                        meal.affordability.name,
                        style: const TextStyle(color: Colors.white), // White text color
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Display ingredients section title
              Text(
                'Ingredients',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              const SizedBox(height: 10),
              ...meal.ingredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '• $ingredient',
                    style: const TextStyle(color: Colors.white), // White text color
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              
              // Display steps section title
              Text(
                'Steps',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
              const SizedBox(height: 10),
              ...meal.steps.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    step,
                    style: const TextStyle(color: Colors.white), // White text color
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
