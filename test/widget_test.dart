import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_ordering_app/main.dart';
import 'package:restaurant_ordering_app/providers/cart_provider.dart';
import 'package:restaurant_ordering_app/providers/menu_provider.dart';
import 'package:restaurant_ordering_app/providers/nutrition_provider.dart';

void main() {
  group('Restaurant Ordering App Tests', () {
    testWidgets('App loads with bottom navigation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Wait for the app to load
      await tester.pumpAndSettle();

      // Verify that the app has bottom navigation
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Verify all navigation tabs exist
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('AI Chef'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
    });

    testWidgets('Home screen displays welcome content', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify home screen content
      expect(find.text('Delicious Restaurant'), findsOneWidget);
      expect(find.text('Welcome to Delicious!'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('Featured Items'), findsOneWidget);
    });

    testWidgets('Can navigate between tabs', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap on Menu tab
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();
      
      // Should be on menu screen now
      expect(find.text('Menu'), findsOneWidget);
      
      // Tap on Custom tab
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();
      
      // Should be on custom meal screen
      expect(find.text('Build Your Meal'), findsOneWidget);
    });
  });

  group('Provider Tests', () {
    test('CartProvider can add items', () {
      final cartProvider = CartProvider();
      expect(cartProvider.items.length, 0);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.totalPrice, 0.0);
    });

    test('MenuProvider initializes with sample data', () {
      final menuProvider = MenuProvider();
      // Initially loading
      expect(menuProvider.isLoading, true);
      expect(menuProvider.menuItems.isEmpty, true);
    });

    test('NutritionProvider can calculate nutrition', () {
      final nutritionProvider = NutritionProvider();
      final result = nutritionProvider.calculateCartNutrition([]);
      
      expect(result.calories, 0);
      expect(result.protein, 0.0);
      expect(result.carbs, 0.0);
      expect(result.fat, 0.0);
    });
  });
}