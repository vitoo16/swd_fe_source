# Restaurant Ordering App

A comprehensive Flutter app for restaurant ordering with customization, nutrition tracking, and AI-powered food suggestions.

## Features

### 🏠 Home Screen
- Welcome message and restaurant introduction
- Category quick navigation chips
- Featured food items showcase
- Quick action cards for custom meals and AI suggestions

### 🍽️ Menu Screen
- Browse all available food items
- Search functionality across name, description, and ingredients
- Category filtering (Burgers, Pizza, Salads, Drinks, Desserts)
- Nutrition info and health labels for each item

### 🛠️ Food Customization
- Detailed food item screens with complete ingredient lists
- Customization options for portion size, cooking style, and ingredients
- Special instructions field for dietary needs
- Real-time price calculation based on customizations
- Complete nutrition facts display

### 🥗 Custom Meal Builder
- Build your own meal from individual ingredients
- Ingredients organized by category (Protein, Grains, Vegetables, etc.)
- Real-time nutrition and price calculation
- Visual ingredient selection with category icons

### 🤖 AI Chat Assistant
- Interactive chat interface for food recommendations
- Intelligent responses based on dietary preferences and restrictions
- Quick suggestion chips for common requests
- Clickable food recommendations that lead to detailed views

### 🛒 Order Management
- Shopping cart with quantity controls and item management
- Complete order summary with nutrition analysis
- Order history tracking
- Nutrition overview and personalized dietary advice

### 📊 Nutrition System
- Complete nutrition facts for all menu items
- Health labels (Low Calorie, High Protein, Healthy Choice, etc.)
- Cart-wide nutrition analysis and advice
- Daily value percentages calculation

## Technical Architecture

### Clean Structure Organization
```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── food_item.dart       # Food item and nutrition models
│   └── cart_item.dart       # Shopping cart item model
├── providers/                # State management
│   ├── cart_provider.dart   # Shopping cart state
│   ├── menu_provider.dart   # Menu items state
│   └── nutrition_provider.dart # Nutrition calculations
├── screens/                  # App screens
│   ├── main_screen.dart     # Main screen with bottom navigation
│   ├── home_screen.dart     # Home/welcome screen
│   ├── menu_screen.dart     # Menu browsing screen
│   ├── food_detail_screen.dart # Individual food item details
│   ├── custom_meal_screen.dart # Custom meal builder
│   ├── ai_chat_screen.dart  # AI chat assistant
│   └── orders_screen.dart   # Cart and order history
└── widgets/                  # Reusable UI components
    ├── category_chip.dart   # Category selection chips
    ├── featured_food_card.dart # Featured item cards
    ├── food_item_card.dart  # Regular food item cards
    └── nutrition_info_widget.dart # Nutrition display
```

### State Management
- **Provider Pattern**: Using the Provider package for clean state management
- **CartProvider**: Manages shopping cart items, quantities, and calculations
- **MenuProvider**: Handles food items, categories, and search functionality
- **NutritionProvider**: Calculates nutrition data and provides health advice

### Key Dependencies
- `flutter`: UI framework
- `provider`: State management
- `material_design_icons_flutter`: Additional icons
- `json_annotation`: JSON serialization
- `http`: API requests (for future backend integration)
- `shared_preferences`: Local storage

## Setup Instructions

1. **Install Flutter**: Make sure you have Flutter SDK installed
2. **Get Dependencies**: 
   ```bash
   flutter pub get
   ```
3. **Generate JSON Serialization** (if needed):
   ```bash
   flutter packages pub run build_runner build
   ```
4. **Run the App**:
   ```bash
   flutter run
   ```

## App Navigation

The app uses a **bottom tab navigation** with 5 main sections:

1. **🏠 Home** - Welcome screen with featured items and quick actions
2. **🍽️ Menu** - Full menu browsing with search and filtering
3. **🛠️ Custom** - Build your own custom meal
4. **🤖 AI Chef** - Chat with AI for food recommendations
5. **🛒 Orders** - Shopping cart and order history

## Future Enhancements

- Backend API integration for real menu data
- User authentication and profiles
- Order tracking and delivery status
- Payment integration
- Restaurant location and hours
- Push notifications for order updates
- Favorites and meal recommendations based on history

## Screenshots

The app features a clean, modern design with:
- Material 3 design system
- Orange/warm color scheme appropriate for food apps
- Intuitive navigation with clear visual hierarchy
- Comprehensive nutrition information display
- Interactive AI chat interface
- Easy-to-use customization flows
