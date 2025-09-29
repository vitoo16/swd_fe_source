import 'package:json_annotation/json_annotation.dart';

part 'food_item.g.dart';

@JsonSerializable()
class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final NutritionInfo nutrition;
  final List<CustomizationOption> customizations;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.nutrition,
    required this.customizations,
    this.isAvailable = true,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    List<String>? ingredients,
    NutritionInfo? nutrition,
    List<CustomizationOption>? customizations,
    bool? isAvailable,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      nutrition: nutrition ?? this.nutrition,
      customizations: customizations ?? this.customizations,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

@JsonSerializable()
class NutritionInfo {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionInfoToJson(this);
}

@JsonSerializable()
class CustomizationOption {
  final String id;
  final String name;
  final String type; // "ingredient_add", "ingredient_remove", "portion_size", "cooking_style"
  final List<String> options;
  final double priceModifier;
  final bool required;

  CustomizationOption({
    required this.id,
    required this.name,
    required this.type,
    required this.options,
    this.priceModifier = 0.0,
    this.required = false,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) =>
      _$CustomizationOptionFromJson(json);

  Map<String, dynamic> toJson() => _$CustomizationOptionToJson(this);
}