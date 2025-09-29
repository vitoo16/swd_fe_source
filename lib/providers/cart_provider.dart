import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(FoodItem foodItem, Map<String, String> customizations, {int quantity = 1, String specialInstructions = ''}) {
    final customizationKey = _generateCustomizationKey(customizations);
    final existingIndex = _items.indexWhere(
      (item) => item.foodItem.id == foodItem.id && 
                _generateCustomizationKey(item.customizations) == customizationKey,
    );

    if (existingIndex >= 0) {
      // Update existing item
      final existingItem = _items[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        totalPrice: _calculateItemPrice(foodItem, customizations, existingItem.quantity + quantity),
      );
      _items[existingIndex] = updatedItem;
    } else {
      // Add new item
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodItem: foodItem,
        quantity: quantity,
        customizations: customizations,
        totalPrice: _calculateItemPrice(foodItem, customizations, quantity),
        specialInstructions: specialInstructions,
      );
      _items.add(cartItem);
    }
    
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = _items[index];
      final updatedItem = item.copyWith(
        quantity: quantity,
        totalPrice: _calculateItemPrice(item.foodItem, item.customizations, quantity),
      );
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double _calculateItemPrice(FoodItem foodItem, Map<String, String> customizations, int quantity) {
    double basePrice = foodItem.price;
    
    // Add customization prices
    for (final customization in foodItem.customizations) {
      if (customizations.containsKey(customization.id)) {
        basePrice += customization.priceModifier;
      }
    }
    
    return basePrice * quantity;
  }

  String _generateCustomizationKey(Map<String, String> customizations) {
    final sortedKeys = customizations.keys.toList()..sort();
    return sortedKeys.map((key) => '$key:${customizations[key]}').join(',');
  }
}