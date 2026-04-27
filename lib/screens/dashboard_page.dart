import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/injection_provider.dart';
import '../models/injection_technique.dart';
import '../theme/app_theme.dart';
import '../widgets/injection_card.dart';
import '../widgets/dashboard_sidebar.dart';
import '../theme/favorites_manager.dart';
import '../theme/recently_viewed_manager.dart';

class DashboardPage extends StatefulWidget {
  final String? initialCategory;

  const DashboardPage({super.key, this.initialCategory});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _searchQuery = '';
  late String _selectedCategory;
  final List<String> _categories = [
    'All', 'Favorites', 'Recent',
    'Shoulder', 'Elbow', 'Hand', 'Hip', 'Knee', 'Foot',
  ];

  final FocusNode _pageFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
    _searchFocusNode.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDisclaimer());
  }

  Future<void> _maybeShowDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('disclaimer_seen_v1') ?? false;
    if (!seen && mounted) {
      await _showDisclaimerDialog();
      await prefs.setBool('disclaimer_seen_v1', true);
    }
  }

  Future<void> _showDisclaimerDialog() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.surfaceElevated : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            side: BorderSide(color: AppTheme.cyan.withValues(alpha: 0.25)),
          ),
          title: Row(
            children: [
              Icon(Icons.school_outlined, color: AppTheme.cyan, size: 20),
              const SizedBox(width: 10),
              Text(
                'Educational Use Only',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.cyan.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.15)),
                  ),
                  child: Text(
                    'Ultrasound-Pro is intended for educational and training purposes only. '
                    'The content in this application — including procedural descriptions, '
                    'illustrations, and reference images — does not constitute medical advice '
                    'and is not a substitute for formal clinical training, direct supervision, '
                    'or professional judgment.\n\n'
                    'Always follow your institution\'s protocols and seek guidance from '
                    'a qualified supervisor before performing any procedure.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.55,
                      color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'By continuing, you acknowledge that this application is for learning purposes only.',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppTheme.textTertiary : const Color(0xFF9098A3),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.cyan,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
              ),
              child: Text(
                'I Understand',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageFocusNode.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<InjectionTechnique> _getFilteredInjections(BuildContext context) {
    final dataProvider = context.watch<InjectionDataProvider>();
    final favManager = context.watch<FavoritesManager>();
    final recentManager = context.watch<RecentlyViewedManager>();

    if (!dataProvider.isLoaded) return [];

    if (_selectedCategory == 'Recent') {
      return recentManager.recentIds
          .map((id) => dataProvider.findById(id))
          .where((t) => t != null)
          .cast<InjectionTechnique>()
          .where((inj) => _searchQuery.isEmpty || _matchesSearch(inj, _searchQuery))
          .toList();
    }

    return dataProvider.injections.where((inj) {
      final matchesSearch = _searchQuery.isEmpty || _matchesSearch(inj, _searchQuery);
      final bool matchesCategory;
      if (_selectedCategory == 'All') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Favorites') {
        matchesCategory = favManager.isFavorite(inj.id);
      } else {
        matchesCategory = inj.category == _selectedCategory;
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

  bool _matchesSearch(InjectionTechnique inj, String query) {
    final q = query.toLowerCase();
    return inj.title.toLowerCase().contains(q) ||
        inj.category.toLowerCase().contains(q) ||
        inj.tags.any((tag) => tag.toLowerCase().contains(q)) ||
        inj.treats.any((c) => c.toLowerCase().contains(q)) ||
        inj.landmarking.any((l) => l.toLowerCase().contains(q)) ||
        inj.corridor.any((c) => c.toLowerCase().contains(q)) ||
        inj.avoid.any((a) => a.toLowerCase().contains(q)) ||
        inj.steps.any((s) => s.toLowerCase().contains(q)) ||
        inj.pearls.any((p) => p.toLowerCase().contains(q));
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.slash && !_searchFocusNode.hasFocus) {
      _searchFocusNode.requestFocus();
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_searchFocusNode.hasFocus) _searchFocusNode.unfocus();
      if (_searchQuery.isNotEmpty) {
        setState(() {
          _searchQuery = '';
          _searchController.clear();
        });
      }
      _selectedIndex = -1;
      return;
    }

    if (_searchFocusNode.hasFocus) return;

    final filteredInjections = _getFilteredInjectionsSync();
    if (filteredInjections.isEmpty) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      setState(() => _selectedIndex = (_selectedIndex + 1).clamp(0, filteredInjections.length - 1));
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      setState(() => _selectedIndex = (_selectedIndex - 1).clamp(0, filteredInjections.length - 1));
    } else if (event.logicalKey == LogicalKeyboardKey.enter && _selectedIndex >= 0) {
      context.go('/procedure/${filteredInjections[_selectedIndex].id}');
    }
  }

  List<InjectionTechnique> _getFilteredInjectionsSync() {
    final dataProvider = context.read<InjectionDataProvider>();
    final favManager = context.read<FavoritesManager>();
    final recentManager = context.read<RecentlyViewedManager>();

    if (!dataProvider.isLoaded) return [];

    if (_selectedCategory == 'Recent') {
      return recentManager.recentIds
          .map((id) => dataProvider.findById(id))
          .where((t) => t != null)
          .cast<InjectionTechnique>()
          .where((inj) => _searchQuery.isEmpty || _matchesSearch(inj, _searchQuery))
          .toList();
    }

    return dataProvider.injections.where((inj) {
      final matchesSearch = _searchQuery.isEmpty || _matchesSearch(inj, _searchQuery);
      final bool matchesCategory;
      if (_selectedCategory == 'All') {
        matchesCategory = true;
      } else if (_selectedCategory == 'Favorites') {
        matchesCategory = favManager.isFavorite(inj.id);
      } else {
        matchesCategory = inj.category == _selectedCategory;
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredInjections = _getFilteredInjections(context);
    final dataProvider = context.watch<InjectionDataProvider>();

    if (!dataProvider.isLoaded) {
      return Scaffold(
        backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.cyan.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'LOADING PROCEDURES',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  letterSpacing: 2.0,
                  color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return KeyboardListener(
      focusNode: _pageFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
        appBar: isMobile ? AppBar(
          backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              Icon(Icons.monitor_heart_outlined, color: AppTheme.cyan, size: 18),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'US GUIDED',
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 1.5,
                      color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                    ),
                  ),
                  Text(
                    'INJECTION MANUAL',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                      color: AppTheme.cyan.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: isDark ? AppTheme.cyan : AppTheme.cyanDim, size: 20),
              tooltip: 'Open navigation menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ) : null,
        drawer: isMobile ? Drawer(
          width: 280,
          backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          child: DashboardSidebar(
            selectedCategory: _selectedCategory,
            categories: _categories,
            onCategorySelected: (cat) => setState(() {
              _selectedCategory = cat;
              _selectedIndex = -1;
            }),
            isMobile: true,
          ),
        ) : null,
        body: Row(
          children: [
            if (!isMobile)
              DashboardSidebar(
                selectedCategory: _selectedCategory,
                categories: _categories,
                onCategorySelected: (cat) => setState(() {
                  _selectedCategory = cat;
                  _selectedIndex = -1;
                }),
              ),
            Expanded(
              child: _buildMainContent(filteredInjections, isMobile, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(List<InjectionTechnique> injections, bool isMobile, bool isDark) {
    final catColor = _getCategoryHeaderColor();

    return Column(
      children: [
        _buildSearchBar(isMobile, isDark),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              0,
              isMobile ? 16 : 24,
              24,
            ),
            children: [
              // Category header
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: catColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _selectedCategory.toUpperCase(),
                      style: GoogleFonts.jetBrainsMono(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 1.5,
                        color: catColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${injections.length} procedures',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Introduction to Ultrasound entry card — prominent above the grid.
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _UsIntroEntryCard(isDark: isDark),
              ),
              // Phone: compact list rows. Tablet/desktop: card grid.
              if (MediaQuery.of(context).size.width < 600)
                ListView.separated(
                  key: ValueKey('list-$_selectedCategory'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: injections.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                  itemBuilder: (context, index) => InjectionCard(
                    technique: injections[index],
                    isSelected: index == _selectedIndex,
                    index: index,
                    compact: true,
                  ),
                )
              else
                GridView.builder(
                  key: ValueKey('grid-$_selectedCategory'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 1400
                        ? 4
                        : (MediaQuery.of(context).size.width > 900 ? 3 : 2),
                    childAspectRatio: MediaQuery.of(context).size.width < 900 ? 1.8 : 1.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: injections.length,
                  itemBuilder: (context, index) => InjectionCard(
                    technique: injections[index],
                    isSelected: index == _selectedIndex,
                    index: index,
                  ),
                ),
              // Context-aware empty state
              if (injections.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          _selectedCategory == 'Favorites'
                              ? Icons.star_outline_rounded
                              : _selectedCategory == 'Recent'
                                  ? Icons.history_rounded
                                  : Icons.search_off_rounded,
                          size: 40,
                          color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedCategory == 'Favorites'
                              ? 'No favorites yet'
                              : _selectedCategory == 'Recent'
                                  ? 'No recently viewed procedures'
                                  : _searchQuery.isNotEmpty
                                      ? 'No results for "$_searchQuery"'
                                      : 'No procedures found',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedCategory == 'Favorites'
                              ? 'Tap the star on any procedure to save it here'
                              : _selectedCategory == 'Recent'
                                  ? 'Procedures you open will appear here'
                                  : _searchQuery.isNotEmpty
                                      ? 'Try a different search term'
                                      : '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isMobile, bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 12 : 32,
        isMobile ? 16 : 24,
        16,
      ),
      child: Semantics(
        textField: true,
        label: 'Search injections',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: _searchFocusNode.hasFocus
                  ? AppTheme.cyan.withValues(alpha: 0.4)
                  : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppTheme.cyan.withValues(alpha: 0.5), size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (v) => setState(() {
                    _searchQuery = v;
                    _selectedIndex = -1;
                  }),
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search procedures, conditions...',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.inter(
                      color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                      fontSize: 13,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              // Keyboard shortcut hint / animated clear button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: _searchQuery.isEmpty
                    ? Container(
                        key: const ValueKey('slash'),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '/',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                          ),
                        ),
                      )
                    : SizedBox(
                        key: const ValueKey('clear'),
                        width: 28,
                        height: 28,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                          ),
                          tooltip: 'Clear search',
                          onPressed: () => setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _selectedIndex = -1;
                          }),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryHeaderColor() {
    switch (_selectedCategory.toLowerCase()) {
      case 'all': return AppTheme.cyan;
      case 'favorites': return AppTheme.amber;
      case 'recent': return const Color(0xFF7B61FF);
      default: return AppTheme.categoryColor(_selectedCategory);
    }
  }
}

/// Prominent entry card that links to the Introduction to Ultrasound primer.
class _UsIntroEntryCard extends StatefulWidget {
  final bool isDark;
  const _UsIntroEntryCard({required this.isDark});

  @override
  State<_UsIntroEntryCard> createState() => _UsIntroEntryCardState();
}

class _UsIntroEntryCardState extends State<_UsIntroEntryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final textSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: _isHovered && !reduceMotion
            // ignore: deprecated_member_use
            ? (Matrix4.identity()..translate(0.0, -2.0))
            : Matrix4.identity(),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            onTap: () => context.go('/us-intro'),
            hoverColor: Colors.transparent,
            child: AnimatedContainer(
              duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: AppTheme.cyan.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                  color: AppTheme.cyan.withValues(alpha: _isHovered ? 0.55 : 0.30),
                  width: 1.5,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppTheme.cyan.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Prerequisite badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.amber.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: AppTheme.amber.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'REVIEW BEFORE INJECTIONS',
                      style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.amber,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Main title
                  Text(
                    'ULTRASOUND BASICS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Body description
                  Text(
                    'Complete this primer before reviewing any injection procedure. '
                    'Covers probe selection, machine settings, tissue appearance, '
                    'artifacts, needle technique, viewing planes, probe movements, '
                    'safety protocols, and injectates.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      height: 1.6,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Footer row: section count + CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '9 SECTIONS',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 12,
                        color: AppTheme.cyan.withValues(alpha: 0.30),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'START HERE',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Arrow nudges right on hover
                      AnimatedContainer(
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        transform: _isHovered && !reduceMotion
                            // ignore: deprecated_member_use
                            ? (Matrix4.identity()..translate(4.0, 0.0))
                            : Matrix4.identity(),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.cyan,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
