import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class MenuProvider extends ChangeNotifier {
  final List<FoodItem> _menuItems = [];
  final List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<FoodItem> get menuItems => _isLoading ? [] : List.unmodifiable(_menuItems);
  List<String> get categories => List.unmodifiable(_categories);
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  MenuProvider() {
    _initializeMenu();
  }

  void _initializeMenu() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading with sample data
    Future.delayed(const Duration(seconds: 1), () {
      _menuItems.addAll(_getSampleMenuItems());
      _categories.addAll(['All', 'Burgers', 'Pizza', 'Salads', 'Drinks', 'Desserts']);
      _isLoading = false;
      notifyListeners();
    });
  }

  List<FoodItem> getFilteredItems() {
    if (_selectedCategory == 'All') {
      return _menuItems;
    }
    return _menuItems.where((item) => item.category == _selectedCategory).toList();
  }

  List<FoodItem> getFeaturedItems() {
    return _menuItems.take(3).toList();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  FoodItem? getItemById(String id) {
    try {
      return _menuItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<FoodItem> searchItems(String query) {
    if (query.isEmpty) return _menuItems;
    
    final lowercaseQuery = query.toLowerCase();
    return _menuItems.where((item) => 
      item.name.toLowerCase().contains(lowercaseQuery) ||
      item.description.toLowerCase().contains(lowercaseQuery) ||
      item.ingredients.any((ingredient) => ingredient.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  List<FoodItem> _getSampleMenuItems() {
    return [
      FoodItem(
        id: '1',
        name: 'Classic Burger',
        description: 'Juicy beef patty with lettuce, tomato, onion, and our special sauce',
        price: 12.99,
        category: 'Burgers',
        imageUrl: 'https://via.placeholder.com/300x200',
        ingredients: ['Beef patty', 'Lettuce', 'Tomato', 'Onion', 'Special sauce', 'Bun'],
        nutrition: NutritionInfo(
          calories: 650,
          protein: 35.0,
          carbs: 45.0,
          fat: 35.0,
          fiber: 3.5,
          sugar: 8.0,
          sodium: 1200.0,
        ),
        customizations: [
          CustomizationOption(
            id: 'patty_count',
            name: 'Patty Count',
            type: 'portion_size',
            options: ['Single', 'Double', 'Triple'],
            priceModifier: 0.0,
            required: true,
          ),
          CustomizationOption(
            id: 'cheese',
            name: 'Add Cheese',
            type: 'ingredient_add',
            options: ['No Cheese', 'Cheddar', 'Swiss', 'Blue Cheese'],
            priceModifier: 1.50,
          ),
        ],
      ),
      FoodItem(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Fresh mozzarella, tomato sauce, and basil on crispy crust',
        price: 16.99,
        category: 'Pizza',
        imageUrl: 'https://via.placeholder.com/300x200',
        ingredients: ['Pizza dough', 'Tomato sauce', 'Mozzarella', 'Fresh basil', 'Olive oil'],
        nutrition: NutritionInfo(
          calories: 280,
          protein: 12.0,
          carbs: 36.0,
          fat: 10.0,
          fiber: 2.0,
          sugar: 4.0,
          sodium: 640.0,
        ),
        customizations: [
          CustomizationOption(
            id: 'size',
            name: 'Size',
            type: 'portion_size',
            options: ['Small', 'Medium', 'Large'],
            priceModifier: 0.0,
            required: true,
          ),
          CustomizationOption(
            id: 'crust',
            name: 'Crust Type',
            type: 'cooking_style',
            options: ['Thin', 'Thick', 'Stuffed Crust'],
            priceModifier: 2.00,
          ),
        ],
      ),
      FoodItem(
        id: '3',
        name: 'Caesar Salad',
        description: 'Crisp romaine lettuce with Caesar dressing, croutons, and parmesan',
        price: 10.99,
        category: 'Salads',
        imageUrl: 'https://via.placeholder.com/300x200',
        ingredients: ['Romaine lettuce', 'Caesar dressing', 'Croutons', 'Parmesan cheese', 'Lemon'],
        nutrition: NutritionInfo(
          calories: 320,
          protein: 8.0,
          carbs: 15.0,
          fat: 25.0,
          fiber: 4.0,
          sugar: 3.0,
          sodium: 890.0,
        ),
        customizations: [
          CustomizationOption(
            id: 'protein',
            name: 'Add Protein',
            type: 'ingredient_add',
            options: ['None', 'Grilled Chicken', 'Grilled Shrimp', 'Salmon'],
            priceModifier: 4.00,
          ),
        ],
      ),
      FoodItem(
        id: '4',
        name: 'Fresh Orange Juice',
        description: 'Freshly squeezed orange juice packed with vitamin C',
        price: 4.99,
        category: 'Drinks',
        imageUrl: 'https://via.placeholder.com/300x200',
        ingredients: ['Fresh oranges'],
        nutrition: NutritionInfo(
          calories: 110,
          protein: 2.0,
          carbs: 26.0,
          fat: 0.5,
          fiber: 0.5,
          sugar: 21.0,
          sodium: 2.0,
        ),
        customizations: [
          CustomizationOption(
            id: 'size',
            name: 'Size',
            type: 'portion_size',
            options: ['Small', 'Medium', 'Large'],
            priceModifier: 0.0,
            required: true,
          ),
        ],
      ),
      FoodItem(
        id: '5',
        name: 'Chocolate Cake',
        description: 'Rich chocolate cake with chocolate ganache and fresh berries',
        price: 7.99,
        category: 'Desserts',
        imageUrl: 'https://via.placeholder.com/300x200',
        ingredients: ['Chocolate', 'Flour', 'Sugar', 'Eggs', 'Butter', 'Fresh berries'],
        nutrition: NutritionInfo(
          calories: 450,
          protein: 6.0,
          carbs: 65.0,
          fat: 20.0,
          fiber: 3.0,
          sugar: 45.0,
          sodium: 320.0,
        ),
        customizations: [
          CustomizationOption(
            id: 'topping',
            name: 'Extra Toppings',
            type: 'ingredient_add',
            options: ['None', 'Ice Cream', 'Whipped Cream', 'Extra Berries'],
            priceModifier: 2.50,
          ),
        ],
      ),
    ];
  }
}