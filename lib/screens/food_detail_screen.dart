import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../providers/nutrition_provider.dart';
import '../widgets/nutrition_info_widget.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  final Map<String, String> _selectedCustomizations = {};
  final TextEditingController _specialInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize required customizations
    for (final customization in widget.foodItem.customizations) {
      if (customization.required && customization.options.isNotEmpty) {
        _selectedCustomizations[customization.id] = customization.options.first;
      }
    }
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double price = widget.foodItem.price;
    
    for (final customization in widget.foodItem.customizations) {
      if (_selectedCustomizations.containsKey(customization.id) &&
          _selectedCustomizations[customization.id] != customization.options.first) {
        price += customization.priceModifier;
      }
    }
    
    return price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodItem.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[200],
              child: Icon(
                Icons.fastfood,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name, Price and Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.foodItem.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.foodItem.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${widget.foodItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ingredients
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.foodItem.ingredients.map((ingredient) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          ingredient,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nutrition Info
                  NutritionInfoWidget(nutrition: widget.foodItem.nutrition),
                  
                  const SizedBox(height: 24),
                  
                  // Customizations
                  if (widget.foodItem.customizations.isNotEmpty) ...[
                    const Text(
                      'Customizations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ...widget.foodItem.customizations.map((customization) {
                      return _buildCustomizationSection(customization);
                    }).toList(),
                  ],
                  
                  // Special Instructions
                  const SizedBox(height: 16),
                  const Text(
                    'Special Instructions (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _specialInstructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any special requests or dietary needs?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom sheet
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
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
          child: Row(
            children: [
              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _quantity > 1 ? () {
                        setState(() {
                          _quantity--;
                        });
                      } : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      _quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _canAddToCart() ? _addToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Add to Cart • \$${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationSection(CustomizationOption customization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              customization.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (customization.required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        
        ...customization.options.map((option) {
          final isSelected = _selectedCustomizations[customization.id] == option;
          
          return RadioListTile<String>(
            title: Text(option),
            subtitle: customization.priceModifier > 0 && option != customization.options.first
                ? Text('+\$${customization.priceModifier.toStringAsFixed(2)}')
                : null,
            value: option,
            groupValue: _selectedCustomizations[customization.id],
            onChanged: (value) {
              setState(() {
                _selectedCustomizations[customization.id] = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
        
        const SizedBox(height: 16),
      ],
    );
  }

  bool _canAddToCart() {
    // Check if all required customizations are selected
    for (final customization in widget.foodItem.customizations) {
      if (customization.required && !_selectedCustomizations.containsKey(customization.id)) {
        return false;
      }
    }
    return true;
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(
      widget.foodItem,
      _selectedCustomizations,
      quantity: _quantity,
      specialInstructions: _specialInstructionsController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.foodItem.name} added to cart!'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            // Navigate to cart/orders screen
          },
        ),
      ),
    );
    
    Navigator.of(context).pop();
  }
}