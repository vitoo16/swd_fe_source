import 'food_item.dart';

class CartItem {
  final String id;
  final FoodItem foodItem;
  final int quantity;
  final Map<String, String> customizations;
  final double totalPrice;
  final String specialInstructions;

  CartItem({
    required this.id,
    required this.foodItem,
    required this.quantity,
    required this.customizations,
    required this.totalPrice,
    this.specialInstructions = '',
  });

  CartItem copyWith({
    String? id,
    FoodItem? foodItem,
    int? quantity,
    Map<String, String>? customizations,
    double? totalPrice,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      totalPrice: totalPrice ?? this.totalPrice,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}