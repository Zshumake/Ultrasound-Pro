import 'package:flutter/material.dart';
import '../models/injection_technique.dart';
import '../widgets/medical_ui.dart';
import '../widgets/resident_pearls_card.dart';
import '../theme/app_theme.dart';
import '../theme/favorites_manager.dart';

class InjectionDetailPage extends StatefulWidget {
  final InjectionTechnique technique;

  const InjectionDetailPage({super.key, required this.technique});

  @override
  State<InjectionDetailPage> createState() => _InjectionDetailPageState();
}

class _InjectionDetailPageState extends State<InjectionDetailPage> {
  @override
  void initState() {
    super.initState();
    favoritesManager.addListener(_update);
  }

  @override
  void dispose() {
    favoritesManager.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroSection(context),
                  const SizedBox(height: 32),
                  _buildSupplySection(context),
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
                  const SizedBox(height: 64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final bool isFav = favoritesManager.isFavorite(widget.technique.id);
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      centerTitle: true,
      backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFav ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isFav ? Colors.orange : null,
          ),
          onPressed: () => favoritesManager.toggleFavorite(widget.technique.id),
        ),
        const SizedBox(width: 8),
      ],
      title: Text(
        widget.technique.category.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
          color: Theme.of(context).primaryColor,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.05),
                Theme.of(context).cardColor,
              ],
            ),
          ),
          child: Opacity(
            opacity: 0.03,
            child: Icon(Icons.medical_services_outlined, size: 150, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.technique.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.titleLarge?.color,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.technique.tags.map((tag) => MedicalTag(text: tag)).toList(),
        ),
        const SizedBox(height: 24),
        const MedicalSectionHeader(title: 'INDICATIONS'),
        ...widget.technique.treats.map((item) => BulletPointItem(text: item)),
      ],
    );
  }

  Widget _buildSupplySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.inventory_2_outlined, color: Theme.of(context).primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREPARE YOUR TRAY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Essential Clinical Kit',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              mainAxisExtent: 32,
              crossAxisSpacing: 16,
            ),
            itemCount: widget.technique.supplies.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 16, color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.technique.supplies[index],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
          _buildInfoImagePair(
            context,
            'Positioning',
            widget.technique.positioning.join('\n'),
            'Position Image',
            Icons.person_pin_outlined,
            widget.technique.positioningImg,
          ),
          const SizedBox(height: 24),
          _buildInfoImagePair(
            context,
            'Hardware',
            widget.technique.probe.join('\n'),
            'Probe Image',
            Icons.sensors_outlined,
            widget.technique.probeImg,
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoImagePair(
                  context,
                  'Positioning',
                  widget.technique.positioning.join('\n'),
                  'Position Image',
                  Icons.person_pin_outlined,
                  widget.technique.positioningImg,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoImagePair(
                  context,
                  'Hardware',
                  widget.technique.probe.join('\n'),
                  'Probe Image',
                  Icons.sensors_outlined,
                  widget.technique.probeImg,
                ),
              ),
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
          MedicalPlaceholderImage(
            label: 'Probe Positioning on Skin', 
            height: 200,
            imagePath: widget.technique.landmarkImg,
          ),
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
                child: MedicalPlaceholderImage(
                  label: 'Probe Positioning on Skin', 
                  height: 180,
                  imagePath: widget.technique.landmarkImg,
                ),
              ),
            ],
          ),
        if (widget.technique.tips.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTipsBox(),
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
        MedicalPlaceholderImage(
          label: 'Main Ultrasound Target View', 
          height: 300, 
          isMain: true,
          imagePath: widget.technique.ultrasoundImg,
        ),
        const SizedBox(height: 16),
        MedicalInfoBox(
          title: 'CORRECT IMAGE CRITERIA',
          text: widget.technique.correctImage.join('\n'),
          icon: Icons.image_search_outlined,
        ),
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
        const MedicalSectionHeader(title: 'STEPS', fontSize: 13),
        const SizedBox(height: 8),
        ...widget.technique.steps.asMap().entries.map((e) => NumberedStepItem(number: e.key + 1, text: e.value)).toList(),
        const SizedBox(height: 24),
        _buildAlertBox(context, 'AVOID', widget.technique.avoid),
      ],
    );
  }

  Widget _buildInfoImagePair(BuildContext context, String title, String text, String placeholderLabel, IconData icon, String? imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicalPlaceholderImage(label: placeholderLabel, height: 120, imagePath: imagePath),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTipsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.teal, size: 20),
              const SizedBox(width: 8),
              Text('PRO TIPS', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w800, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.technique.tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $tip', style: const TextStyle(color: Colors.teal, fontSize: 14)),
              )),
        ],
      ),
    );
  }

  Widget _buildAlertBox(BuildContext context, String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.2)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    Expanded(child: Text(item, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500, fontSize: 14))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
