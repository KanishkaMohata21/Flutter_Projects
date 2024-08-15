import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/MealDetails.dart';
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    // Convert affordability enum to text
    String affordabilityText;
    switch (meal.affordability) {
      case Affordability.affordable:
        affordabilityText = 'Affordable';
        break;
      case Affordability.pricey:
        affordabilityText = 'Pricey';
        break;
      case Affordability.luxurious:
        affordabilityText = 'Luxurious';
        break;
      default:
        affordabilityText = 'Unknown';
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // Implement the navigation to MealScreen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => MealDetails(meal: meal,),
            ),
          );
        },
        child: Stack(
          children: [
            // Image placeholder and actual image
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
              fit: BoxFit.cover, // Ensure the image covers the area
              height: 200, // Fixed height for the image
              width: double.infinity,
            ),
            // Overlay with meal details
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                color: Colors.black54,
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                            icon: Icons.schedule,
                            label: '${meal.duration} min'),
                        const SizedBox(
                          width: 8,
                        ),
                        MealItemTrait(
                            icon: Icons.work,
                            label: meal.complexity.toString().split('.').last),
                        const SizedBox(
                          width: 8,
                        ),
                        MealItemTrait(
                            icon: Icons.attach_money,
                            label: affordabilityText),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
