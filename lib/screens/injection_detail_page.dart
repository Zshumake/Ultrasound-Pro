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
import '../widgets/anatomy_diagram.dart';
import '../theme/app_theme.dart';
import '../theme/favorites_manager.dart';
import '../theme/recently_viewed_manager.dart';

class InjectionDetailPage extends StatefulWidget {
  final InjectionTechnique technique;

  const InjectionDetailPage({super.key, required this.technique});

  @override
  State<InjectionDetailPage> createState() => _InjectionDetailPageState();
}

class _InjectionDetailPageState extends State<InjectionDetailPage>
    with SingleTickerProviderStateMixin {
  final Set<int> _checkedSupplies = {};
  late final AnimationController _entryController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _fadeIn = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecentlyViewedManager>().recordView(widget.technique.id);
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
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
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, isFav, favManager, catColor, isDark),
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
                      _buildIntroSection(context, catColor, isDark),
                      const SizedBox(height: 32),
                      _buildSupplySection(context, isDark),
                      const SizedBox(height: 32),
                      _buildVisualSetupGrid(context),
                      const SizedBox(height: 32),
                      _buildLandmarkingSection(context),
                      const SizedBox(height: 32),
                      _buildUSViewSection(context),
                      const SizedBox(height: 32),
                      _buildProcedureSection(context),
                      const SizedBox(height: 32),
                      ResidentPearlsCard(pearls: widget.technique.pearls),
                      const SizedBox(height: 32),
                      AnatomyDiagram(
                        probePositionImg: widget.technique.landmarkImg,
                        expectedSonoImg: widget.technique.ultrasoundImg,
                        accentColor: catColor,
                        procedureTitle: widget.technique.title,
                      ),
                      const SizedBox(height: 32),
                      USImageGallery(
                        imagePaths: widget.technique.usGalleryImages,
                        imageLabels: widget.technique.usGalleryLabels,
                        accentColor: catColor,
                      ),
                      if (widget.technique.anatomyModelId != null) ...[
                        const SizedBox(height: 32),
                        SketchfabViewer(
                          modelId: widget.technique.anatomyModelId!,
                          modelTitle: widget.technique.anatomyModelTitle,
                          accentColor: catColor,
                        ),
                      ],
                      if (widget.technique.videoUrl != null) ...[
                        const SizedBox(height: 32),
                        _buildVideoSection(context, catColor, isDark),
                      ],
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
              mainAxisExtent: 34,
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
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: isChecked,
                        onChanged: (val) => setState(() {
                          if (val == true) {
                            _checkedSupplies.add(index);
                          } else {
                            _checkedSupplies.remove(index);
                          }
                        }),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionHeader(title: 'PATIENT & EQUIPMENT SETUP'),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildInfoImagePair(context, 'Positioning', widget.technique.positioning.join('\n'), 'Position Image', Icons.person_pin_outlined, widget.technique.positioningImg),
          const SizedBox(height: 24),
          _buildInfoImagePair(context, 'Hardware', widget.technique.probe.join('\n'), 'Probe Image', Icons.sensors_outlined, widget.technique.probeImg),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfoImagePair(context, 'Positioning', widget.technique.positioning.join('\n'), 'Position Image', Icons.person_pin_outlined, widget.technique.positioningImg)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoImagePair(context, 'Hardware', widget.technique.probe.join('\n'), 'Probe Image', Icons.sensors_outlined, widget.technique.probeImg)),
            ],
          ),
      ],
    );
  }

  Widget _buildLandmarkingSection(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionHeader(title: 'FINDING THE VIEW'),
        const SizedBox(height: 16),
        if (isMobile) ...[
          MedicalPlaceholderImage(label: 'Probe Positioning on Skin', height: 200, imagePath: widget.technique.landmarkImg),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.technique.landmarking.asMap().entries.map((e) => NumberedStepItem(number: e.key + 1, text: e.value)).toList(),
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.technique.landmarking.asMap().entries.map((e) => NumberedStepItem(number: e.key + 1, text: e.value)).toList(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: MedicalPlaceholderImage(label: 'Probe Positioning on Skin', height: 180, imagePath: widget.technique.landmarkImg),
              ),
            ],
          ),
        if (widget.technique.tips.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTipsBox(context),
        ],
      ],
    );
  }

  Widget _buildUSViewSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionHeader(title: 'TARGET ULTRASOUND VIEW'),
        const SizedBox(height: 16),
        MedicalPlaceholderImage(label: 'Main Ultrasound Target View', height: 300, isMain: true, imagePath: widget.technique.ultrasoundImg),
        const SizedBox(height: 16),
        MedicalInfoBox(title: 'CORRECT IMAGE CRITERIA', text: widget.technique.correctImage.join('\n'), icon: Icons.image_search_outlined),
      ],
    );
  }

  Widget _buildProcedureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionHeader(title: 'INJECTION PROCEDURE'),
        const SizedBox(height: 16),
        MedicalInfoBox(
          title: 'NEEDLE CORRIDOR',
          text: widget.technique.corridor.join('\n'),
          icon: Icons.straighten_outlined,
          color: AppTheme.accentTeal,
        ),
        const SizedBox(height: 16),
        const MedicalSectionHeader(title: 'STEPS', fontSize: 9),
        const SizedBox(height: 8),
        ...widget.technique.steps.asMap().entries.map((e) => NumberedStepItem(number: e.key + 1, text: e.value)),
        const SizedBox(height: 24),
        _buildAlertBox(context, 'AVOID', widget.technique.avoid),
      ],
    );
  }

  Widget _buildInfoImagePair(BuildContext context, String title, String text, String placeholderLabel, IconData icon, String? imagePath) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicalPlaceholderImage(label: placeholderLabel, height: 120, imagePath: imagePath),
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
            videoUrl: widget.technique.videoUrl!,
            accentColor: catColor,
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
