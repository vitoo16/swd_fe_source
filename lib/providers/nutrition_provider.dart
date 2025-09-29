import 'package:flutter/foundation.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';

class NutritionProvider extends ChangeNotifier {
  NutritionInfo calculateCartNutrition(List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      return NutritionInfo(
        calories: 0,
        protein: 0.0,
        carbs: 0.0,
        fat: 0.0,
        fiber: 0.0,
        sugar: 0.0,
        sodium: 0.0,
      );
    }

    int totalCalories = 0;
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;
    double totalFiber = 0.0;
    double totalSugar = 0.0;
    double totalSodium = 0.0;

    for (final cartItem in cartItems) {
      final nutrition = cartItem.foodItem.nutrition;
      final quantity = cartItem.quantity;

      totalCalories += (nutrition.calories * quantity);
      totalProtein += (nutrition.protein * quantity);
      totalCarbs += (nutrition.carbs * quantity);
      totalFat += (nutrition.fat * quantity);
      totalFiber += (nutrition.fiber * quantity);
      totalSugar += (nutrition.sugar * quantity);
      totalSodium += (nutrition.sodium * quantity);
    }

    return NutritionInfo(
      calories: totalCalories,
      protein: totalProtein,
      carbs: totalCarbs,
      fat: totalFat,
      fiber: totalFiber,
      sugar: totalSugar,
      sodium: totalSodium,
    );
  }

  String getNutritionAdvice(NutritionInfo nutrition) {
    final List<String> advice = [];

    // Calorie advice
    if (nutrition.calories > 2000) {
      advice.add('High calorie content - consider smaller portions');
    } else if (nutrition.calories < 500) {
      advice.add('Low calorie content - you might want to add more items');
    }

    // Protein advice
    if (nutrition.protein < 20) {
      advice.add('Consider adding more protein-rich items');
    }

    // Sodium advice
    if (nutrition.sodium > 2300) {
      advice.add('High sodium content - drink plenty of water');
    }

    // Sugar advice
    if (nutrition.sugar > 50) {
      advice.add('High sugar content - consider reducing sweet items');
    }

    // Fiber advice
    if (nutrition.fiber < 10) {
      advice.add('Add more fiber with salads or whole grains');
    }

    if (advice.isEmpty) {
      return 'Your meal looks nutritionally balanced!';
    }

    return advice.join('. ');
  }

  Map<String, double> getNutritionPercentages(NutritionInfo nutrition, {int targetCalories = 2000}) {
    return {
      'calories': (nutrition.calories / targetCalories) * 100,
      'protein': (nutrition.protein / 50) * 100, // 50g daily target
      'carbs': (nutrition.carbs / 300) * 100, // 300g daily target
      'fat': (nutrition.fat / 65) * 100, // 65g daily target
      'fiber': (nutrition.fiber / 25) * 100, // 25g daily target
      'sugar': (nutrition.sugar / 50) * 100, // 50g daily limit
      'sodium': (nutrition.sodium / 2300) * 100, // 2300mg daily limit
    };
  }

  bool isHealthyChoice(FoodItem foodItem) {
    final nutrition = foodItem.nutrition;
    
    // Basic healthy criteria
    final bool lowSodium = nutrition.sodium < 600;
    final bool moderateCalories = nutrition.calories < 400;
    final bool goodProtein = nutrition.protein > 10;
    final bool lowSugar = nutrition.sugar < 15;
    
    // At least 2 out of 4 criteria should be met
    final healthyScore = [lowSodium, moderateCalories, goodProtein, lowSugar]
        .where((criteria) => criteria)
        .length;
    
    return healthyScore >= 2;
  }

  List<String> getHealthLabels(FoodItem foodItem) {
    final labels = <String>[];
    final nutrition = foodItem.nutrition;

    if (nutrition.calories < 300) labels.add('Low Calorie');
    if (nutrition.protein > 20) labels.add('High Protein');
    if (nutrition.fiber > 5) labels.add('High Fiber');
    if (nutrition.sodium < 300) labels.add('Low Sodium');
    if (nutrition.sugar < 5) labels.add('Low Sugar');
    if (isHealthyChoice(foodItem)) labels.add('Healthy Choice');

    return labels;
  }
}