import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/nutrition_info_widget.dart';

class CustomMealScreen extends StatefulWidget {
  const CustomMealScreen({super.key});

  @override
  State<CustomMealScreen> createState() => _CustomMealScreenState();
}

class _CustomMealScreenState extends State<CustomMealScreen> {
  final List<String> _selectedIngredients = [];
  final Map<String, double> _ingredientPrices = {
    'Grilled Chicken Breast': 6.99,
    'Salmon Fillet': 8.99,
    'Tofu': 4.99,
    'Quinoa': 2.99,
    'Brown Rice': 2.49,
    'Mixed Greens': 3.49,
    'Avocado': 2.99,
    'Cherry Tomatoes': 2.49,
    'Cucumber': 1.99,
    'Bell Peppers': 2.79,
    'Broccoli': 2.99,
    'Sweet Potato': 2.49,
    'Black Beans': 2.99,
    'Chickpeas': 2.79,
    'Feta Cheese': 3.99,
    'Olive Oil Dressing': 1.49,
    'Balsamic Vinaigrette': 1.49,
    'Lemon Herb Dressing': 1.49,
  };

  final Map<String, String> _ingredientCategories = {
    'Grilled Chicken Breast': 'Protein',
    'Salmon Fillet': 'Protein',
    'Tofu': 'Protein',
    'Quinoa': 'Grains',
    'Brown Rice': 'Grains',
    'Mixed Greens': 'Vegetables',
    'Avocado': 'Vegetables',
    'Cherry Tomatoes': 'Vegetables',
    'Cucumber': 'Vegetables',
    'Bell Peppers': 'Vegetables',
    'Broccoli': 'Vegetables',
    'Sweet Potato': 'Vegetables',
    'Black Beans': 'Legumes',
    'Chickpeas': 'Legumes',
    'Feta Cheese': 'Dairy',
    'Olive Oil Dressing': 'Dressing',
    'Balsamic Vinaigrette': 'Dressing',
    'Lemon Herb Dressing': 'Dressing',
  };

  double get _totalPrice {
    return _selectedIngredients.fold(0.0, (sum, ingredient) {
      return sum + (_ingredientPrices[ingredient] ?? 0.0);
    });
  }

  NutritionInfo get _customMealNutrition {
    // Simplified nutrition calculation based on selected ingredients
    int calories = _selectedIngredients.length * 80; // Average per ingredient
    double protein = _selectedIngredients.where((i) => _ingredientCategories[i] == 'Protein').length * 25.0;
    double carbs = _selectedIngredients.where((i) => _ingredientCategories[i] == 'Grains').length * 30.0;
    double fat = _selectedIngredients.length * 5.0;
    double fiber = _selectedIngredients.where((i) => _ingredientCategories[i] == 'Vegetables').length * 3.0;
    double sugar = _selectedIngredients.length * 2.0;
    double sodium = _selectedIngredients.length * 150.0;

    return NutritionInfo(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = _ingredientCategories.values.toSet().toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Your Meal'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedIngredients.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  _selectedIngredients.clear();
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          if (_selectedIngredients.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Custom Meal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_selectedIngredients.length} ingredients selected',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Ingredients List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryIngredients = _ingredientPrices.keys
                    .where((ingredient) => _ingredientCategories[ingredient] == category)
                    .toList();
                
                return _buildCategorySection(category, categoryIngredients);
              },
            ),
          ),
        ],
      ),
      bottomSheet: _selectedIngredients.isNotEmpty ? Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showNutritionInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('View Nutrition'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _addCustomMealToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text('Add to Cart • \$${_totalPrice.toStringAsFixed(2)}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) : null,
    );
  }

  Widget _buildCategorySection(String category, List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        ...ingredients.map((ingredient) {
          final isSelected = _selectedIngredients.contains(ingredient);
          final price = _ingredientPrices[ingredient]!;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: CheckboxListTile(
              title: Text(ingredient),
              subtitle: Text('\$${price.toStringAsFixed(2)}'),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedIngredients.add(ingredient);
                  } else {
                    _selectedIngredients.remove(ingredient);
                  }
                });
              },
              secondary: _getCategoryIcon(category),
            ),
          );
        }).toList(),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Protein':
        return const Icon(Icons.fitness_center, color: Colors.red);
      case 'Grains':
        return const Icon(Icons.grain, color: Colors.brown);
      case 'Vegetables':
        return const Icon(Icons.eco, color: Colors.green);
      case 'Legumes':
        return const Icon(Icons.circle, color: Colors.purple);
      case 'Dairy':
        return const Icon(Icons.local_drink, color: Colors.blue);
      case 'Dressing':
        return const Icon(Icons.colorize, color: Colors.orange);
      default:
        return const Icon(Icons.fastfood, color: Colors.grey);
    }
  }

  void _showNutritionInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Custom Meal Nutrition',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            NutritionInfoWidget(nutrition: _customMealNutrition),
          ],
        ),
      ),
    );
  }

  void _addCustomMealToCart() {
    if (_selectedIngredients.isEmpty) return;

    final customFoodItem = FoodItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Custom Meal',
      description: 'Your custom meal with ${_selectedIngredients.join(', ')}',
      price: _totalPrice,
      category: 'Custom',
      imageUrl: '',
      ingredients: _selectedIngredients,
      nutrition: _customMealNutrition,
      customizations: [],
    );

    context.read<CartProvider>().addItem(
      customFoodItem,
      {},
      quantity: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom meal added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Optionally clear selections after adding to cart
    setState(() {
      _selectedIngredients.clear();
    });
  }
}