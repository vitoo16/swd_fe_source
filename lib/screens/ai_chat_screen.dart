import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/menu_provider.dart';
import '../models/food_item.dart';
import '../widgets/food_item_card.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text: "Hello! I'm your AI chef assistant. I can help you find the perfect meal based on your preferences, dietary restrictions, or nutritional goals. What would you like to eat today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chef Assistant'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggestions chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSuggestionChip('Healthy options', Icons.favorite),
                _buildSuggestionChip('High protein', Icons.fitness_center),
                _buildSuggestionChip('Low calorie', Icons.trending_down),
                _buildSuggestionChip('Vegetarian', Icons.eco),
                _buildSuggestionChip('Quick meals', Icons.access_time),
                _buildSuggestionChip('Budget friendly', Icons.attach_money),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about food recommendations...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(text),
        onPressed: () => _sendMessage(text),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 16,
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                
                if (message.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...message.recommendations.map((foodItem) => 
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: FoodItemCard(foodItem: foodItem),
                    ),
                  ).toList(),
                ],
                
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      _generateAiResponse(text);
    });
  }

  void _generateAiResponse(String userMessage) {
    final menuProvider = context.read<MenuProvider>();
    final menuItems = menuProvider.menuItems;
    
    String response;
    List<FoodItem> recommendations = [];

    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('healthy') || lowerMessage.contains('nutritious')) {
      response = "Great choice! Here are some healthy options that are packed with nutrients and low in calories:";
      recommendations = menuItems.where((item) => 
        item.nutrition.calories < 400 || item.category == 'Salads'
      ).take(2).toList();
    } else if (lowerMessage.contains('protein') || lowerMessage.contains('muscle')) {
      response = "Perfect for your fitness goals! Here are high-protein options to fuel your workouts:";
      recommendations = menuItems.where((item) => 
        item.nutrition.protein > 20
      ).take(2).toList();
    } else if (lowerMessage.contains('low calorie') || lowerMessage.contains('diet')) {
      response = "I've got you covered with these delicious low-calorie options:";
      recommendations = menuItems.where((item) => 
        item.nutrition.calories < 350
      ).take(2).toList();
    } else if (lowerMessage.contains('vegetarian') || lowerMessage.contains('vegan')) {
      response = "Here are some fantastic plant-based options for you:";
      recommendations = menuItems.where((item) => 
        item.category == 'Salads' || item.ingredients.any((ingredient) => 
          ingredient.toLowerCase().contains('vegetable') || 
          ingredient.toLowerCase().contains('tofu')
        )
      ).take(2).toList();
    } else if (lowerMessage.contains('quick') || lowerMessage.contains('fast')) {
      response = "Need something quick? These meals are prepared fast without compromising on taste:";
      recommendations = menuItems.where((item) => 
        item.category == 'Drinks' || item.category == 'Salads'
      ).take(2).toList();
    } else if (lowerMessage.contains('budget') || lowerMessage.contains('cheap')) {
      response = "Great value meals that won't break the bank:";
      recommendations = menuItems.where((item) => item.price < 8.0).take(2).toList();
    } else if (lowerMessage.contains('burger')) {
      response = "I love burgers too! Here are our best burger options:";
      recommendations = menuItems.where((item) => item.category == 'Burgers').take(2).toList();
    } else if (lowerMessage.contains('pizza')) {
      response = "Pizza is always a great choice! Check out these options:";
      recommendations = menuItems.where((item) => item.category == 'Pizza').take(2).toList();
    } else {
      response = "Based on your preferences, I'd recommend these popular items from our menu:";
      recommendations = menuProvider.getFeaturedItems();
    }

    setState(() {
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
          recommendations: recommendations,
        ),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use AI Chef'),
        content: const Text(
          'You can ask me about:\n\n'
          '• Healthy food recommendations\n'
          '• High protein options\n'
          '• Low calorie meals\n'
          '• Vegetarian/vegan options\n'
          '• Quick meals\n'
          '• Budget-friendly options\n'
          '• Specific food categories\n\n'
          'Just type your preferences and I\'ll suggest the best options for you!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<FoodItem> recommendations;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendations = const [],
  });
}