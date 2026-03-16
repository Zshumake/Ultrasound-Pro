import 'package:flutter/material.dart';
import '../data/injection_data.dart';
import '../widgets/injection_card.dart';
import '../widgets/dashboard_sidebar.dart';

import '../theme/favorites_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Favorites', 'Shoulder', 'Elbow', 'Hand', 'Hip', 'Knee', 'Foot'];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;
    
    final filteredInjections = injectionData.where((inj) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = inj.title.toLowerCase().contains(query) ||
          inj.category.toLowerCase().contains(query) ||
          inj.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          inj.treats.any((c) => c.toLowerCase().contains(query));
      
      final bool matchesCategory;
      if (_selectedCategory == 'All') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Favorites') {
        matchesCategory = favoritesManager.isFavorite(inj.id);
      } else {
        matchesCategory = inj.category == _selectedCategory;
      }
      
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: isMobile ? AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('US Guided', style: TextStyle(fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.titleLarge?.color)),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Icon(Icons.menu_rounded, color: Theme.of(context).primaryColor, size: 20),
              ),
            ),
          ),
        ),
      ) : null,
      drawer: isMobile ? Drawer(
        width: 280,
        backgroundColor: Theme.of(context).cardColor,
        child: DashboardSidebar(
          selectedCategory: _selectedCategory,
          categories: _categories,
          onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
          isMobile: true,
        ),
      ) : null,
      body: Row(
        children: [
          if (!isMobile)
            DashboardSidebar(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
            ),
          Expanded(
            child: _buildMainContent(filteredInjections, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(List<dynamic> injections, bool isMobile) {
    return Column(
      children: [
        _buildSearchBar(isMobile),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '$_selectedCategory Injections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.titleLarge?.color),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 1400 ? 4 : (MediaQuery.of(context).size.width > 900 ? 3 : (MediaQuery.of(context).size.width > 600 ? 2 : 1)),
                  childAspectRatio: 0.82,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: injections.length,
                itemBuilder: (context, index) {
                  return InjectionCard(technique: injections[index]);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, isMobile ? 8 : 48, 24, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Search injections, conditions...',
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Theme.of(context).primaryColor, size: 20),
            hintStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
