import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/injection_technique.dart';
import '../widgets/medical_ui.dart';
import '../widgets/resident_pearls_card.dart';
import '../widgets/youtube_player.dart';
import '../widgets/sketchfab_viewer.dart';
import '../widgets/us_image_gallery.dart';
import '../widgets/injection_illustration.dart';
import '../widgets/procedure_mode_view.dart';
import '../theme/app_theme.dart';
import '../theme/favorites_manager.dart';
import '../theme/recently_viewed_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InjectionDetailPage extends StatefulWidget {
  final InjectionTechnique technique;

  const InjectionDetailPage({super.key, required this.technique});

  @override
  State<InjectionDetailPage> createState() => _InjectionDetailPageState();
}

class _InjectionDetailPageState extends State<InjectionDetailPage>
    with SingleTickerProviderStateMixin {
  final Set<int> _checkedSupplies = {};
  bool _isProcedureMode = false;
  late final AnimationController _entryController;
  late final Animation<double> _fadeIn;
  final _videoSectionKey = GlobalKey();
  final _playerKey = GlobalKey<YouTubePlayerState>();
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    _scrollController.addListener(_onScroll);

    _loadProcedureModePref();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).disableAnimations) {
        _entryController.value = 1.0;
      } else {
        _entryController.forward();
      }
      context.read<RecentlyViewedManager>().recordView(widget.technique.id);
    });
  }

  Future<void> _loadProcedureModePref() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _isProcedureMode = prefs.getBool('procedure_mode') ?? false);
    }
  }

  Future<void> _toggleProcedureMode() async {
    final newValue = !_isProcedureMode;
    setState(() {
      _isProcedureMode = newValue;
      _scrollProgress = 0.0;
      _showScrollToTop = false;
    });
    // Jump to top after the new scroll view is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('procedure_mode', newValue);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final offset = _scrollController.offset.clamp(0.0, double.infinity);
    final max = pos.maxScrollExtent;
    setState(() {
      _scrollProgress = max > 0 ? (offset / max).clamp(0.0, 1.0) : 0.0;
      _showScrollToTop = offset > 400;
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favManager = context.watch<FavoritesManager>();
    final isFav = favManager.isFavorite(widget.technique.id);
    final catColor = AppTheme.categoryColor(widget.technique.category);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      body: _isProcedureMode
          ? _buildProcedureModeScaffold(context, isFav, favManager, catColor, isDark)
          : _buildStudyModeScaffold(context, isFav, favManager, catColor, isDark),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_showScrollToTop) ...[
            FloatingActionButton.small(
              heroTag: 'scroll_to_top',
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
              backgroundColor: isDark ? AppTheme.surfaceElevated : Colors.white,
              foregroundColor: catColor,
              elevation: 2,
              tooltip: 'Back to top',
              child: const Icon(Icons.keyboard_arrow_up_rounded, size: 20),
            ),
            const SizedBox(height: 8),
          ],
          _buildModeToggleFab(isDark),
        ],
      ),
    );
  }

  Widget _buildModeToggleFab(bool isDark) {
    final catColor = AppTheme.categoryColor(widget.technique.category);
    return FloatingActionButton.extended(
      onPressed: _toggleProcedureMode,
      backgroundColor: _isProcedureMode
          ? AppTheme.vitalGreen
          : (isDark ? AppTheme.surfaceElevated : AppTheme.surfaceLight),
      foregroundColor: _isProcedureMode
          ? Colors.black
          : catColor,
      elevation: _isProcedureMode ? 6 : 2,
      icon: Icon(
        _isProcedureMode ? Icons.menu_book_rounded : Icons.bolt_rounded,
        size: 18,
      ),
      label: Text(
        _isProcedureMode ? 'STUDY MODE' : 'PROCEDURE MODE',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProcedureModeScaffold(BuildContext context, bool isFav, FavoritesManager favManager, Color catColor, bool isDark) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(context, isFav, favManager, catColor, isDark),
        SliverPersistentHeader(
          pinned: true,
          delegate: _ProgressDelegate(progress: _scrollProgress, color: catColor),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: ProcedureModeView(
            technique: widget.technique,
            catColor: catColor,
            onTimestampTap: _scrollToVideoAndPlay,
          ),
        ),
      ],
    );
  }

  Widget _buildStudyModeScaffold(BuildContext context, bool isFav, FavoritesManager favManager, Color catColor, bool isDark) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(context, isFav, favManager, catColor, isDark),
        SliverPersistentHeader(
          pinned: true,
          delegate: _ProgressDelegate(progress: _scrollProgress, color: catColor),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === STUDY SECTION (top) ===
                    // Flow: Indications → Setup → Approach (illustration + steps)
                    //       → US View → Tips → Pearls → Video
                    _buildIntroSection(context, catColor, isDark),
                    const SizedBox(height: 48),
                    // 1. Positioning + probe images/text
                    _buildVisualSetupGrid(context),
                    const SizedBox(height: 48),
                    // 2. Illustration (blue bar = probe, red dot = needle) +
                    //    probe placement steps + injection steps side-by-side
                    _buildApproachSection(context),
                    const SizedBox(height: 48),
                    // 3. Target US view — single image slot (no duplicate gallery)
                    _buildUSViewSection(context),
                    // 4. Gallery only rendered when actual images exist
                    if (widget.technique.usGalleryImages.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      USImageGallery(
                        imagePaths: widget.technique.usGalleryImages,
                        imageLabels: widget.technique.usGalleryLabels,
                        accentColor: catColor,
                      ),
                    ],
                    // 5. Pro tips sit right below the ultrasound picture
                    if (widget.technique.tips.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildTipsBox(context),
                    ],
                    if (widget.technique.anatomyModelId != null) ...[
                      const SizedBox(height: 48),
                      SketchfabViewer(
                        modelId: widget.technique.anatomyModelId!,
                        modelTitle: widget.technique.anatomyModelTitle,
                        accentColor: catColor,
                      ),
                    ],
                    const SizedBox(height: 48),
                    ResidentPearlsCard(pearls: widget.technique.pearls),
                    if (widget.technique.videoUrl != null) ...[
                      const SizedBox(height: 48),
                      _buildVideoSection(context, catColor, isDark),
                    ],
                    // === PROCEDURE PREP SECTION (bottom) ===
                    const SizedBox(height: 64),
                    Divider(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
                    const SizedBox(height: 16),
                    Text(
                      'PROCEDURE PREPARATION',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (widget.technique.contraindications.isNotEmpty) ...[
                      _buildContraindicationsSection(context, isDark),
                      const SizedBox(height: 32),
                    ],
                    if (widget.technique.preChecklist.isNotEmpty) ...[
                      _buildPreChecklistSection(context, isDark),
                      const SizedBox(height: 32),
                    ],
                    _buildSupplySection(context, isDark),
                    const SizedBox(height: 32),
                    if (widget.technique.postProcedure.isNotEmpty) ...[
                      _buildPostProcedureSection(context, isDark),
                      const SizedBox(height: 32),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<VideoTimestamp> _timestampsForSection(String section) {
    return widget.technique.videoTimestamps
        .where((t) => t.section == section)
        .toList();
  }

  void _scrollToVideoAndPlay(int seconds) {
    final ctx = _videoSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      ).then((_) {
        _playerKey.currentState?.seekAndPlay(seconds);
      });
    }
  }

  Widget _buildTimestampBadge(String section, Color catColor) {
    final timestamps = _timestampsForSection(section);
    if (timestamps.isEmpty || widget.technique.videoUrl == null) {
      return const SizedBox.shrink();
    }
    final ts = timestamps.first;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _scrollToVideoAndPlay(ts.seconds),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_outline_rounded, size: 14, color: catColor),
              const SizedBox(width: 4),
              Text(
                ts.formattedTime,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: catColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isFav, FavoritesManager favManager, Color catColor, bool isDark) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      centerTitle: true,
      backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
      surfaceTintColor: Colors.transparent,
      leading: Semantics(
        button: true,
        label: 'Back to procedures',
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      actions: [
        Semantics(
          button: true,
          label: 'Print cheat sheet',
          child: IconButton(
            icon: const Icon(Icons.print_outlined, size: 18),
            tooltip: 'Print cheat sheet',
            onPressed: () => _showPrintView(context),
          ),
        ),
        Semantics(
          button: true,
          label: isFav ? 'Remove from favorites' : 'Add to favorites',
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                key: ValueKey(isFav),
                color: isFav ? AppTheme.amber : null,
                size: 22,
              ),
            ),
            onPressed: () => favManager.toggleFavorite(widget.technique.id),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 14),
        title: Text(
          widget.technique.category.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
            color: catColor.withValues(alpha: 0.5),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                catColor.withValues(alpha: isDark ? 0.04 : 0.02),
                isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [catColor.withValues(alpha: 0.3), catColor.withValues(alpha: 0.0)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context, Color catColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.technique.title,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.technique.tags.map((tag) => MedicalTag(text: tag, color: catColor)).toList(),
        ),
        const SizedBox(height: 24),
        const MedicalSectionHeader(title: 'INDICATIONS'),
        const SizedBox(height: 4),
        ...widget.technique.treats.map((item) => BulletPointItem(text: item)),
      ],
    );
  }

  Widget _buildContraindicationsSection(BuildContext context, bool isDark) {
    return _buildSafetyCard(
      context: context,
      isDark: isDark,
      icon: Icons.warning_amber_rounded,
      accentColor: AppTheme.surgicalRed,
      label: 'CONTRAINDICATIONS',
      items: widget.technique.contraindications,
    );
  }

  Widget _buildPreChecklistSection(BuildContext context, bool isDark) {
    return _buildSafetyCard(
      context: context,
      isDark: isDark,
      icon: Icons.checklist_rounded,
      accentColor: AppTheme.amber,
      label: 'PRE-PROCEDURE TIMEOUT',
      items: widget.technique.preChecklist,
    );
  }

  Widget _buildPostProcedureSection(BuildContext context, bool isDark) {
    return _buildSafetyCard(
      context: context,
      isDark: isDark,
      icon: Icons.healing_rounded,
      accentColor: AppTheme.vitalGreen,
      label: 'POST-PROCEDURE COUNSELING',
      items: widget.technique.postProcedure,
    );
  }

  Widget _buildSafetyCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color accentColor,
    required String label,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7, right: 10),
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark ? AppTheme.textSecondary : AppTheme.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSupplySection(BuildContext context, bool isDark) {
    final supplies = widget.technique.supplies;
    final checkedCount = _checkedSupplies.length;
    final totalCount = supplies.length;
    final allDone = checkedCount == totalCount && totalCount > 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: allDone
              ? AppTheme.vitalGreen.withValues(alpha: 0.3)
              : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (allDone ? AppTheme.vitalGreen : AppTheme.cyan).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  allDone ? Icons.check_circle_rounded : Icons.inventory_2_outlined,
                  color: allDone ? AppTheme.vitalGreen : AppTheme.cyan,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREPARE YOUR TRAY',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: allDone ? AppTheme.vitalGreen : AppTheme.cyan,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      allDone ? 'All items ready' : '$checkedCount / $totalCount items',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: allDone
                            ? AppTheme.vitalGreen
                            : (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight),
                      ),
                    ),
                  ],
                ),
              ),
              if (_checkedSupplies.isNotEmpty)
                Semantics(
                  button: true,
                  label: 'Reset checklist',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    onTap: () => setState(() => _checkedSupplies.clear()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text('Reset', style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: totalCount > 0 ? checkedCount / totalCount : 0,
              backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                allDone ? AppTheme.vitalGreen : AppTheme.cyan,
              ),
              minHeight: 2,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              mainAxisExtent: 40,
              crossAxisSpacing: 12,
            ),
            itemCount: supplies.length,
            itemBuilder: (context, index) {
              final isChecked = _checkedSupplies.contains(index);
              return InkWell(
                onTap: () => setState(() {
                  if (isChecked) {
                    _checkedSupplies.remove(index);
                  } else {
                    _checkedSupplies.add(index);
                  }
                }),
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (val) => setState(() {
                          if (val == true) {
                            _checkedSupplies.add(index);
                          } else {
                            _checkedSupplies.remove(index);
                          }
                        }),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        supplies[index],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked
                              ? (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight)
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVisualSetupGrid(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final catColor = AppTheme.categoryColor(widget.technique.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: MedicalSectionHeader(title: 'PATIENT & EQUIPMENT SETUP')),
            _buildTimestampBadge('positioning', catColor),
          ],
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildInfoImagePair(context, 'Positioning', widget.technique.positioning.join('\n'), 'Position Image', Icons.person_pin_outlined, widget.technique.positioningImg, imageAlignment: const Alignment(0.0, -0.3)),
          const SizedBox(height: 24),
          _buildInfoImagePair(context, 'Hardware', widget.technique.probe.join('\n'), 'Probe Image', Icons.sensors_outlined, widget.technique.probeImg),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfoImagePair(context, 'Positioning', widget.technique.positioning.join('\n'), 'Position Image', Icons.person_pin_outlined, widget.technique.positioningImg, imageAlignment: const Alignment(0.0, -0.3))),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoImagePair(context, 'Hardware', widget.technique.probe.join('\n'), 'Probe Image', Icons.sensors_outlined, widget.technique.probeImg)),
            ],
          ),
      ],
    );
  }

  /// Combined approach section: illustration anchors probe placement steps
  /// and injection procedure steps together in one visual block.
  Widget _buildApproachSection(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    final catColor = AppTheme.categoryColor(widget.technique.category);
    final hasIllustration = widget.technique.injectionImg != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Left column: probe placement steps ---
    Widget findingTheView() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: MedicalSectionHeader(title: 'FINDING THE VIEW', fontSize: 9)),
            _buildTimestampBadge('landmarking', catColor),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.technique.landmarking.asMap().entries.map(
          (e) => NumberedStepItem(number: e.key + 1, text: e.value),
        ),
      ],
    );

    // --- Right column: needle corridor + steps + avoid ---
    Widget injectionSteps() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: MedicalSectionHeader(title: 'INJECTION STEPS', fontSize: 9)),
            _buildTimestampBadge('steps', catColor),
          ],
        ),
        const SizedBox(height: 12),
        MedicalInfoBox(
          title: 'NEEDLE CORRIDOR',
          text: widget.technique.corridor.join('\n'),
          icon: Icons.straighten_outlined,
          color: AppTheme.accentTeal,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STEPS',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.technique.steps.asMap().entries.map(
                (e) => NumberedStepItem(number: e.key + 1, text: e.value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildAlertBox(context, 'AVOID', widget.technique.avoid),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Illustration spans full width — reference for both probe and needle
        if (hasIllustration) ...[
          InjectionIllustration(
            longImg: widget.technique.injectionImg!,
            shortImg: widget.technique.injectionImgShort,
            catColor: catColor,
          ),
          const SizedBox(height: 28),
        ] else if (widget.technique.landmarkImg != null) ...[
          // No illustration yet — show landmark photo as fallback
          MedicalPlaceholderImage(
            label: 'Probe Positioning on Skin',
            height: 200,
            imagePath: widget.technique.landmarkImg,
          ),
          const SizedBox(height: 28),
        ],
        // Two columns on desktop, stacked on mobile
        if (isMobile) ...[
          findingTheView(),
          const SizedBox(height: 32),
          injectionSteps(),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: findingTheView()),
              const SizedBox(width: 32),
              Expanded(child: injectionSteps()),
            ],
          ),
      ],
    );
  }

  Widget _buildUSViewSection(BuildContext context) {
    final catColor = AppTheme.categoryColor(widget.technique.category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: MedicalSectionHeader(title: 'TARGET ULTRASOUND VIEW')),
            _buildTimestampBadge('us_view', catColor),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.technique.ultrasoundImg != null)
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.2)),
            ),
            child: Image.asset(
              widget.technique.ultrasoundImg!,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => MedicalPlaceholderImage(
                label: 'Main Ultrasound Target View',
                height: 300,
                isMain: true,
              ),
            ),
          )
        else
          MedicalPlaceholderImage(label: 'Main Ultrasound Target View', height: 300, isMain: true),
        const SizedBox(height: 16),
        MedicalInfoBox(title: 'CORRECT IMAGE CRITERIA', text: widget.technique.correctImage.join('\n'), icon: Icons.image_search_outlined),
      ],
    );
  }

  Widget _buildInfoImagePair(BuildContext context, String title, String text, String placeholderLabel, IconData icon, String? imagePath, {Alignment imageAlignment = Alignment.center}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicalPlaceholderImage(label: placeholderLabel, height: 200, imagePath: imagePath, alignment: imageAlignment),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(icon, size: 14, color: AppTheme.cyan),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight)),
          ],
        ),
        const SizedBox(height: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTipsBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const tipColor = Color(0xFF00E676); // Vital green for pro tips
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tipColor.withValues(alpha: isDark ? 0.04 : 0.03),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: tipColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: tipColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.lightbulb_outline_rounded, color: tipColor, size: 14),
              ),
              const SizedBox(width: 10),
              Text(
                'PRO TIPS',
                style: GoogleFonts.jetBrainsMono(color: tipColor, fontWeight: FontWeight.w700, fontSize: 9, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.technique.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(width: 4, height: 4, decoration: BoxDecoration(color: tipColor.withValues(alpha: 0.5), shape: BoxShape.circle)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(tip, style: GoogleFonts.inter(color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight, fontSize: 13, height: 1.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAlertBox(BuildContext context, String title, List<String> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surgicalRed.withValues(alpha: isDark ? 0.06 : 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.surgicalRed.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.surgicalRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppTheme.surgicalRed, size: 14),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.surgicalRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(width: 4, height: 4, decoration: BoxDecoration(color: AppTheme.surgicalRed.withValues(alpha: 0.5), shape: BoxShape.circle)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item, style: GoogleFonts.inter(color: AppTheme.surgicalRed, fontWeight: FontWeight.w500, fontSize: 13, height: 1.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context, Color catColor, bool isDark) {
    return Column(
      key: _videoSectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionHeader(title: 'VIDEO DEMONSTRATION'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: catColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: YouTubePlayer(
            key: _playerKey,
            videoUrl: widget.technique.videoUrl!,
            accentColor: catColor,
            timestamps: widget.technique.videoTimestamps,
          ),
        ),
      ],
    );
  }

  void _showPrintView(BuildContext context) {
    final t = widget.technique;
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            title: Text('Print Preview', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
            leading: IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(ctx)),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.print_rounded, size: 16),
                label: Text('Print (Cmd+P)', style: GoogleFonts.inter(fontSize: 12)),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.category.toUpperCase(), style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(t.title, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87)),
                    const Divider(height: 32),
                    _printSection('INDICATIONS', t.treats.map((e) => '  \u2022  $e').join('\n')),
                    _printSection('SUPPLIES', t.supplies.map((e) => '  [ ]  $e').join('\n')),
                    _printSection('POSITIONING', t.positioning.join('\n')),
                    _printSection('PROBE', t.probe.join('\n')),
                    _printSection('LANDMARKING', t.landmarking.asMap().entries.map((e) => '  ${e.key + 1}. ${e.value}').join('\n')),
                    _printSection('CORRECT IMAGE', t.correctImage.join('\n')),
                    _printSection('NEEDLE CORRIDOR', t.corridor.join('\n')),
                    _printSection('STEPS', t.steps.asMap().entries.map((e) => '  ${e.key + 1}. ${e.value}').join('\n')),
                    _printSection('AVOID', t.avoid.map((e) => '  \u26a0  $e').join('\n')),
                    if (t.tips.isNotEmpty) _printSection('PRO TIPS', t.tips.map((e) => '  \u2022  $e').join('\n')),
                    if (t.pearls.isNotEmpty) _printSection('RESIDENT PEARLS', t.pearls.map((e) => '  \u2022  $e').join('\n')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _printSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 2, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(content, style: GoogleFonts.inter(fontSize: 12, height: 1.7, color: Colors.black87)),
        ],
      ),
    );
  }
}

/// Thin reading-progress bar that sits pinned just below the SliverAppBar.
class _ProgressDelegate extends SliverPersistentHeaderDelegate {
  final double progress;
  final Color color;

  const _ProgressDelegate({required this.progress, required this.color});

  @override
  double get minExtent => 2.0;

  @override
  double get maxExtent => 2.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.55)),
      minHeight: 2.0,
    );
  }

  @override
  bool shouldRebuild(_ProgressDelegate old) =>
      old.progress != progress || old.color != color;
}
