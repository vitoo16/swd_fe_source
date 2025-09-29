import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.name,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        selected: isSelected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected 
              ? Colors.white 
              : Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          name,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).colorScheme.primary,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}