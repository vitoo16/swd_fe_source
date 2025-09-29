import 'package:flutter/material.dart';
import '../models/food_item.dart';

class NutritionInfoWidget extends StatelessWidget {
  final NutritionInfo nutrition;
  final bool showPercentages;

  const NutritionInfoWidget({
    super.key,
    required this.nutrition,
    this.showPercentages = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition Facts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            
            // Calories (highlighted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    nutrition.calories.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Other nutrients
            _buildNutrientRow('Protein', '${nutrition.protein.toStringAsFixed(1)}g'),
            _buildNutrientRow('Carbohydrates', '${nutrition.carbs.toStringAsFixed(1)}g'),
            _buildNutrientRow('Total Fat', '${nutrition.fat.toStringAsFixed(1)}g'),
            _buildNutrientRow('Dietary Fiber', '${nutrition.fiber.toStringAsFixed(1)}g'),
            _buildNutrientRow('Sugars', '${nutrition.sugar.toStringAsFixed(1)}g'),
            _buildNutrientRow('Sodium', '${nutrition.sodium.toStringAsFixed(0)}mg'),
            
            if (showPercentages) ...[
              const SizedBox(height: 12),
              const Divider(),
              Text(
                'Based on a 2000 calorie diet',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}