import 'package:flutter/material.dart';
import '../main.dart';

class DashboardSidebar extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;
  final bool isMobile;

  const DashboardSidebar({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMobile ? double.infinity : 280,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          _buildAppHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'REGIONS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...categories.map((cat) => _buildSidebarItem(context, cat)),
                ],
              ),
            ),
          ),
          _buildUserInfo(context),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emergency_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'US Guided',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, String title) {
    final bool isSelected = selectedCategory == title;
    return InkWell(
      onTap: () {
        onCategorySelected(title);
        if (isMobile) Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _getIconForCategory(title),
              size: 20,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodySmall?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) const Spacer(),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('Z', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Resident', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  'Manual v2.0',
                  style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode_outlined 
                : Icons.dark_mode_outlined,
              size: 20, 
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            onPressed: () {
              bool isDark = Theme.of(context).brightness == Brightness.dark;
              themeManager.toggleTheme(!isDark);
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'all': return Icons.grid_view_outlined;
      case 'favorites': return Icons.star_rounded;
      case 'shoulder': return Icons.accessibility_new_outlined;
      case 'elbow': return Icons.adjust_outlined;
      case 'hand': return Icons.front_hand_outlined;
      case 'hip': return Icons.directions_walk_outlined;
      case 'knee': return Icons.nordic_walking_outlined;
      case 'foot': return Icons.pest_control_rodent_outlined;
      default: return Icons.category_outlined;
    }
  }
}
