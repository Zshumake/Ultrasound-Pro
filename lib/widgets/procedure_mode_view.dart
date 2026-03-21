import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/injection_technique.dart';
import '../theme/app_theme.dart';

/// Compact, bedside-optimized single-screen view of a procedure.
/// Shows only: Supplies, Patient Positioning, Probe Placement,
/// Find the View, Correct US Image, Needle Corridor, Avoid.
class ProcedureModeView extends StatefulWidget {
  final InjectionTechnique technique;
  final Color catColor;

  const ProcedureModeView({
    super.key,
    required this.technique,
    required this.catColor,
  });

  @override
  State<ProcedureModeView> createState() => _ProcedureModeViewState();
}

class _ProcedureModeViewState extends State<ProcedureModeView> {
  final Set<int> _checkedSupplies = {};

  InjectionTechnique get t => widget.technique;
  Color get catColor => widget.catColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                t.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),

              // 1. SUPPLIES
              _buildSection(
                context,
                isDark: isDark,
                label: 'SUPPLIES',
                icon: Icons.inventory_2_outlined,
                color: catColor,
                child: _buildSupplyChecklist(isDark),
              ),

              // 2. PATIENT POSITIONING
              _buildSection(
                context,
                isDark: isDark,
                label: 'PATIENT POSITIONING',
                icon: Icons.person_pin_outlined,
                color: catColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlot(isDark, _positioningPhotoDescription()),
                    const SizedBox(height: 8),
                    ...t.positioning.map((p) => _compactBullet(p, isDark)),
                  ],
                ),
              ),

              // 3. PROBE PLACEMENT
              _buildSection(
                context,
                isDark: isDark,
                label: 'PROBE PLACEMENT',
                icon: Icons.sensors_outlined,
                color: catColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlot(isDark, _probePhotoDescription()),
                    const SizedBox(height: 8),
                    ...t.probe.map((p) => _compactBullet(p, isDark)),
                  ],
                ),
              ),

              // 4. FIND THE VIEW
              _buildSection(
                context,
                isDark: isDark,
                label: 'FIND THE VIEW',
                icon: Icons.search_rounded,
                color: catColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: t.landmarking.asMap().entries.map((e) =>
                    _compactNumbered(e.key + 1, e.value, isDark),
                  ).toList(),
                ),
              ),

              // 5. CORRECT US IMAGE
              _buildSection(
                context,
                isDark: isDark,
                label: 'CORRECT US IMAGE',
                icon: Icons.monitor_heart_outlined,
                color: catColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSlot(isDark, _usImagePhotoDescription()),
                    const SizedBox(height: 8),
                    ...t.correctImage.map((c) => _compactBullet(c, isDark)),
                  ],
                ),
              ),

              // 6. NEEDLE CORRIDOR
              _buildSection(
                context,
                isDark: isDark,
                label: 'NEEDLE CORRIDOR',
                icon: Icons.straighten_outlined,
                color: AppTheme.accentTeal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: t.corridor.map((c) => _compactBullet(c, isDark)).toList(),
                ),
              ),

              // 7. AVOID
              _buildAvoidSection(isDark),
            ],
          ),
        ),
      ),
    );
  }

  // ── Supplies checklist ──────────────────────────────────────────

  Widget _buildSupplyChecklist(bool isDark) {
    final supplies = t.supplies;
    final allDone = _checkedSupplies.length == supplies.length && supplies.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress
        Row(
          children: [
            Text(
              allDone ? 'All items ready' : '${_checkedSupplies.length} / ${supplies.length}',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9,
                color: allDone ? AppTheme.vitalGreen : (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight),
              ),
            ),
            const Spacer(),
            if (_checkedSupplies.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _checkedSupplies.clear()),
                child: Text('Reset', style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight)),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: supplies.isNotEmpty ? _checkedSupplies.length / supplies.length : 0,
            backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            valueColor: AlwaysStoppedAnimation(allDone ? AppTheme.vitalGreen : catColor),
            minHeight: 2,
          ),
        ),
        const SizedBox(height: 6),
        // Compact list
        ...supplies.asMap().entries.map((e) {
          final isChecked = _checkedSupplies.contains(e.key);
          return GestureDetector(
            onTap: () => setState(() {
              if (isChecked) {
                _checkedSupplies.remove(e.key);
              } else {
                _checkedSupplies.add(e.key);
              }
            }),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (val) => setState(() {
                        if (val == true) { _checkedSupplies.add(e.key); }
                        else { _checkedSupplies.remove(e.key); }
                      }),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      e.value,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                        color: isChecked
                            ? (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight)
                            : (isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Image slot with photo description ───────────────────────────

  Widget _buildImageSlot(bool isDark, String photoDescription) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.bgDark : AppTheme.bgLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: catColor.withValues(alpha: 0.2),
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_camera_outlined,
            color: catColor.withValues(alpha: 0.3),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            photoDescription,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // ── Photo descriptions ──────────────────────────────────────────

  String _positioningPhotoDescription() {
    final pos = t.positioning.join('. ');
    return 'PHOTO NEEDED: $pos\n'
        'Frame: Show full patient position from head to affected limb. '
        'Include any supports (pillows, towel rolls). '
        'Camera angle: standing at bedside looking down at patient.';
  }

  String _probePhotoDescription() {
    final probe = t.probe.join('. ');
    final firstLandmark = t.landmarking.isNotEmpty ? t.landmarking.first : '';
    return 'PHOTO NEEDED: $probe\n'
        'Placement: $firstLandmark\n'
        'Frame: Close-up of probe on skin with visible anatomical landmarks. '
        'Show probe orientation and hand grip position.';
  }

  String _usImagePhotoDescription() {
    final criteria = t.correctImage.join('. ');
    return 'US SCREENSHOT NEEDED: $criteria\n'
        'Capture: Save directly from ultrasound machine. '
        'Include depth markers and orientation indicator. '
        'Label key structures with arrows/text overlay.';
  }

  // ── Section wrapper ─────────────────────────────────────────────

  Widget _buildSection(
    BuildContext context, {
    required bool isDark,
    required String label,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  // ── AVOID section (special red styling) ─────────────────────────

  Widget _buildAvoidSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surgicalRed.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppTheme.surgicalRed.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 14, color: AppTheme.surgicalRed),
              const SizedBox(width: 6),
              Text(
                'AVOID',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.surgicalRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...t.avoid.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surgicalRed.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.surgicalRed,
                      height: 1.4,
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

  // ── Compact text helpers ────────────────────────────────────────

  Widget _compactBullet(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight).withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11,
                height: 1.4,
                color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactNumbered(int number, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Text(
              '$number.',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: catColor,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11,
                height: 1.4,
                color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
