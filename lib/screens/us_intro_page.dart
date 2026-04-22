import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Introduction to Ultrasound teaching page for first-year residents.
/// Five expandable sections: probe selection, machine settings,
/// tissue appearance, artifacts, and needle technique.
class UsIntroPage extends StatefulWidget {
  const UsIntroPage({super.key});

  @override
  State<UsIntroPage> createState() => _UsIntroPageState();
}

class _UsIntroPageState extends State<UsIntroPage> {
  // All sections expanded by default.
  final List<bool> _expanded = List<bool>.filled(9, true);

  void _toggle(int i) => setState(() => _expanded[i] = !_expanded[i]);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.bgDark : AppTheme.bgLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? AppTheme.cyan : AppTheme.cyanDim, size: 20),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'INTRODUCTION TO ULTRASOUND',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 1.5,
                color:
                    isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
              ),
            ),
            Text(
              'MSK US-GUIDED INJECTION PRIMER',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.0,
                color: AppTheme.cyan.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
            children: [
              _buildHeroIntro(isDark),
              const SizedBox(height: 20),
              _ExpandableSection(
                title: 'PROBE SELECTION',
                expanded: _expanded[0],
                onToggle: () => _toggle(0),
                child: _buildProbeSelection(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'MACHINE SETTINGS',
                expanded: _expanded[1],
                onToggle: () => _toggle(1),
                child: _buildMachineSettings(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'TISSUE APPEARANCE',
                expanded: _expanded[2],
                onToggle: () => _toggle(2),
                child: _buildTissueAppearance(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'ARTIFACTS',
                expanded: _expanded[3],
                onToggle: () => _toggle(3),
                child: _buildArtifacts(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'NEEDLE TECHNIQUE',
                expanded: _expanded[4],
                onToggle: () => _toggle(4),
                child: _buildNeedleTechnique(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'VIEWING PLANES',
                expanded: _expanded[5],
                onToggle: () => _toggle(5),
                child: _buildViewingPlanes(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'PROBE MOVEMENTS',
                expanded: _expanded[6],
                onToggle: () => _toggle(6),
                child: _buildProbeMovements(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'SAFETY & WORKFLOW',
                expanded: _expanded[7],
                onToggle: () => _toggle(7),
                child: _buildSafetyWorkflow(isDark),
              ),
              const SizedBox(height: 16),
              _ExpandableSection(
                title: 'INJECTATES & COMPLICATIONS',
                expanded: _expanded[8],
                onToggle: () => _toggle(8),
                child: _buildInjectatesComplications(isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero intro ─────────────────────────────────────────────────
  Widget _buildHeroIntro(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cyan.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.cyan.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.cyan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'START HERE',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.cyan,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Nine sections for MSK ultrasound-guided injections: '
            'probe selection, machine settings, tissue appearance, '
            'artifacts, needle technique, viewing planes, probe '
            'movements, safety and workflow, and injectates. '
            'Work through all of them before your first supervised injection.',
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.55,
              color: isDark
                  ? AppTheme.textPrimary
                  : AppTheme.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section 1: Probe selection ─────────────────────────────────
  Widget _buildProbeSelection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          title: 'LINEAR (7-18 MHz)',
          body:
              'Flat face, rectangular image. Best for superficial targets '
              'within 4-5 cm. The workhorse for most MSK injections.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'CURVILINEAR (2-5 MHz)',
          body:
              'Curved face, fan-shaped image. Use for deep targets '
              'beyond 5 cm - hip, piriformis, obese patients. Trades '
              'fine detail for depth.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          title: 'HOCKEY STICK (8-15 MHz)',
          body:
              'Tiny footprint. Small joints and tight spaces - fingers, '
              'wrist, foot. Great access where a linear probe will not fit.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.amber.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.amber.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE CORE RULE',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'High MHz = sharp image but shallow penetration. '
                'Low MHz = less detail but reaches deeper tissue. '
                'Match the probe to the depth of your target.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.5,
                  color: isDark
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Section 2: Machine settings ────────────────────────────────
  Widget _buildMachineSettings(bool isDark) {
    final items = <_SettingItem>[
      _SettingItem(
        title: 'DEPTH',
        body:
            'Target should be centered left-to-right and sit in the '
            'middle-to-lower portion of the screen (~50-70% down). '
            'That keeps it in the focal zone. Resist centering it '
            'exactly - that often pushes it above the sharpest part '
            'of the image.',
      ),
      _SettingItem(
        title: 'GAIN',
        body:
            'Overall brightness. Fluid (bursa, effusion) should appear '
            'truly black. Too high and false "snow" fills fluid. Too '
            'low and real structures disappear.',
      ),
      _SettingItem(
        title: 'FOCUS',
        body:
            'Set the focal zone marker at the depth of your target. '
            'That is where lateral resolution is best.',
      ),
      _SettingItem(
        title: 'TGC (TIME GAIN COMPENSATION)',
        body:
            'Row of sliders that brighten specific depths. Use to '
            'compensate for signal loss in deep tissue.',
      ),
      _SettingItem(
        title: 'FREQUENCY / PRESET',
        body:
            'Start with the MSK or Small Parts preset, then fine-tune.',
      ),
      _SettingItem(
        title: 'FREEZE + CALIPERS',
        body:
            'Freeze the image to measure depth from skin to target '
            'before inserting the needle.',
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _InfoCard(
            title: items[i].title,
            body: items[i].body,
            accent: AppTheme.cyan,
            isDark: isDark,
          ),
          if (i != items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  // ── Section 3: Tissue appearance ───────────────────────────────
  Widget _buildTissueAppearance(bool isDark) {
    final tissues = <_TissueItem>[
      _TissueItem(
        title: 'TENDON',
        body:
            'Very bright (hyperechoic). Fine parallel fibrillar lines '
            'in long axis, like tightly packed strings. Bright oval '
            'cluster in short axis.',
        caveat:
            'Highly susceptible to anisotropy - always rock the probe '
            'before calling a tendon abnormal.',
      ),
      _TissueItem(
        title: 'MUSCLE',
        body:
            'Dark (hypoechoic) background with bright fascial streaks. '
            '"Starry night" in short axis, feathered in long axis.',
      ),
      _TissueItem(
        title: 'NERVE',
        body:
            'Honeycomb of small dark circles with bright rims in short '
            'axis. Parallel tram-track lines in long axis. Less bright '
            'than tendon.',
      ),
      _TissueItem(
        title: 'ARTERY',
        body:
            'Dark round tube, pulsates, does not compress with probe '
            'pressure. Use color Doppler to confirm.',
      ),
      _TissueItem(
        title: 'VEIN',
        body:
            'Dark round tube, compresses easily with light probe '
            'pressure, does not pulsate.',
      ),
      _TissueItem(
        title: 'BONE',
        body:
            'Brightest line on screen. Complete dark shadow behind it. '
            'Reliable landmark.',
      ),
      _TissueItem(
        title: 'FLUID / BURSA',
        body:
            'Completely black (anechoic). Bright area directly behind '
            'it (posterior enhancement). Compressible.',
      ),
      _TissueItem(
        title: 'CARTILAGE',
        body:
            'Thin dark layer hugging bone surface. Do not mistake for '
            'joint fluid.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 560;
        final columns = wide ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: wide ? 2.1 : 3.2,
          ),
          itemCount: tissues.length,
          itemBuilder: (context, i) {
            final t = tissues[i];
            return _TissueCard(item: t, isDark: isDark);
          },
        );
      },
    );
  }

  // ── Section 4: Artifacts (headline section) ────────────────────
  Widget _buildArtifacts(bool isDark) {
    final artifacts = <_ArtifactItem>[
      _ArtifactItem(
        title: 'ANISOTROPY',
        svg: 'assets/images/artifacts/anisotropy.jpg',
        whatIs:
            'The most common pitfall. Tendons, ligaments, and nerves '
            'only appear bright when the sound beam hits them at '
            'exactly 90 degrees. Tilt the probe even a few degrees '
            'and they go dark - mimicking a tear. Fix: rock the probe '
            'until brightness is maximized before concluding anything.',
        whyMatters:
            'The #1 cause of false-positive findings and wrong '
            'injection targets. Always rock before you inject.',
      ),
      _ArtifactItem(
        title: 'ACOUSTIC SHADOWING',
        svg: 'assets/images/artifacts/acoustic_shadowing.jpg',
        whatIs:
            'Bone, calcifications, and gas completely block the sound '
            'beam, leaving a dark stripe behind them. Everything behind '
            'bone is invisible.',
        whyMatters:
            'You cannot see - or inject into - anything deep to bone. '
            'Plan your needle path around, not through, bony landmarks.',
      ),
      _ArtifactItem(
        title: 'POSTERIOR ENHANCEMENT',
        svg: 'assets/images/artifacts/posterior_enhancement.jpg',
        whatIs:
            'The area directly behind a fluid-filled structure (bursa, '
            'cyst, effusion) appears brighter than surrounding tissue '
            'because fluid transmits sound without loss.',
        whyMatters:
            'A useful positive sign - brightness behind a dark structure '
            'confirms it is truly fluid (aspirable), not a solid mass.',
      ),
      _ArtifactItem(
        title: 'REVERBERATION',
        svg: 'assets/images/artifacts/reverberation.jpg',
        whatIs:
            'Sound bounces between two strong reflectors (e.g., the '
            'needle surface and skin), producing equally-spaced '
            'ladder-like bright lines deep to the real structure.',
        whyMatters:
            'The needle shaft itself produces reverberation. These '
            'false lines can be mistaken for anatomy or the needle '
            'tip. Learn to recognize the ladder pattern.',
      ),
      _ArtifactItem(
        title: 'NEAR-FIELD ARTIFACT',
        svg: 'assets/images/artifacts/near_field.jpg',
        whatIs:
            'The first few millimeters directly below the probe face '
            'show noise and dead zones from beam-forming physics and '
            'poor acoustic contact.',
        whyMatters:
            'Superficial targets (thin bursae, very superficial '
            'tendons) can be lost in this noise. Use more gel, consider '
            'a standoff pad, and reduce near-field gain.',
      ),
      _ArtifactItem(
        title: 'COMET TAIL',
        svg: 'assets/images/artifacts/comet_tail.jpg',
        whatIs:
            'A small highly-reflective object (calcification, needle, '
            'metal) produces a tapering bright streak extending deep '
            'from it.',
        whyMatters:
            'Helps identify calcifications and needle tips, but can '
            'obscure anatomy behind the reflector.',
      ),
    ];

    return Column(
      children: [
        for (int i = 0; i < artifacts.length; i++) ...[
          _ArtifactCard(item: artifacts[i], isDark: isDark),
          if (i != artifacts.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }

  // ── Section 5: Needle technique ────────────────────────────────
  Widget _buildNeedleTechnique(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubsectionLabel(text: 'APPROACH', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'IN-PLANE (IP)',
          body:
              'Needle parallel to probe long axis. You see the entire '
              'needle as a bright line - shaft and tip. Safest for '
              'injections near nerves and vessels. Requires a longer '
              'needle path through tissue.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'OUT-OF-PLANE (OOP)',
          body:
              'Needle perpendicular to probe. Shorter, more direct '
              'path. You only see a single bright dot where the needle '
              'crosses the beam. Cannot tell if the dot is the shaft '
              'or the tip without a test injection.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(
            text: 'IMPROVING NEEDLE VISIBILITY', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'HEEL-TOE TILT',
          body:
              'Tilt the probe so its beam becomes more perpendicular '
              'to the needle. Dramatically brightens the needle. Press '
              'the toe end (closest to needle entry) down.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'HYDRODISSECTION / TEST INJECTION',
          body:
              'Inject 0.1-0.2 mL and watch where the fluid goes in real '
              'time. Even if the tip is invisible, the fluid spread '
              'confirms position.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'JIGGLE TEST',
          body:
              'Gently wiggle the needle hub while watching the screen. '
              'Tissue motion at the tip reveals its location when the '
              'needle itself cannot be seen.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surgicalRed.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: AppTheme.surgicalRed.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE SHAFT / TIP PROBLEM (OOP)',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.surgicalRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The dot on screen could be the shaft with the tip 1 cm '
                'deeper. Always do a test injection before the full '
                'dose. This is how needles end up in the wrong place.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.5,
                  color: isDark
                      ? AppTheme.textPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ── Section 6: Viewing planes ──────────────────────────────────
  Widget _buildViewingPlanes(bool isDark) {
    final body = isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Critical concept callout
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.amber.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.amber.withValues(alpha: 0.20), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CRITICAL DISTINCTION',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'LA / SA  =  probe orientation relative to the TARGET STRUCTURE.\n'
                'IP / OOP  =  needle orientation relative to the PROBE BEAM.\n'
                'These are completely independent concepts. Long axis does not mean in-plane.',
                style: GoogleFonts.inter(fontSize: 13.5, height: 1.55, color: body),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SubsectionLabel(text: 'LONG AXIS vs SHORT AXIS', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'LONG AXIS (LA)',
          body: 'Probe aligned parallel to the target\'s long axis. The image shows the '
              'length of the structure. Tendons in LA show the classic fibrillar pattern — '
              'tight parallel hyperechoic lines. Best for tendinopathy, tears, and '
              'guiding a needle along a tendon sheath. LA/SA is defined by the '
              'TARGET\'s anatomy, not the body\'s sagittal/coronal/transverse planes.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'SHORT AXIS (SA)',
          body: 'Probe perpendicular to the target. Shows a cross-section. Tendons in SA '
              'appear as a bright oval "broom-end." Nerves show the honeycomb pattern — '
              'hypoechoic fascicles inside hyperechoic epineurium. Best for identifying '
              'and tracing nerves and vessels. Standard approach: find the target in SA '
              'first, then rotate into LA to scan its length.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'ANISOTROPY IS WORSE IN SHORT AXIS',
          body: 'In SA the beam hits tendon fibers end-on. Any tilt off perpendicular '
              'makes the entire cross-section go dark instantly — it looks exactly like '
              'fluid or a tear. Before calling a hypoechoic area in SA pathologic, '
              'tilt the probe through several degrees. If the area brightens, it was '
              'anisotropy, not pathology.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'IN-PLANE vs OUT-OF-PLANE', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'IN-PLANE (IP)',
          body: 'Needle is advanced within the probe\'s scanning plane. The entire shaft '
              'and tip are visible as a continuous bright hyperechoic line. Preferred '
              'for most MSK injections — you see the needle at all times relative to '
              'vessels and nerves. Requires the needle and probe to be precisely co-planar '
              '(~1 mm tolerance). Shallower insertion angles (20-35°) improve visibility.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'OUT-OF-PLANE (OOP)',
          body: 'Needle crosses the scanning plane — only a bright dot appears on screen. '
              'That dot may be the shaft, not the tip. Use the walk-down technique: '
              'advance the needle in small steps while sliding the probe to keep the dot '
              'centered; tissue motion at the advancing front or a small test bolus of '
              'saline confirms tip position. Useful in tight spaces where an IP approach '
              'is geometrically impossible.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surgicalRed.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.surgicalRed.withValues(alpha: 0.12), width: 1),
          ),
          child: Text(
            'In OOP the bright dot on screen could be the shaft with the tip '
            '1 cm deeper than you think. Never inject based on a dot alone — '
            'always confirm tip position with a test bolus first.',
            style: GoogleFonts.inter(
                fontSize: 13, height: 1.5,
                color: AppTheme.surgicalRed.withValues(alpha: 0.92)),
          ),
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'PROBE MARKER CONVENTION', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'AIUM STANDARD',
          body: 'The probe marker (ridge or light on one end) corresponds to the LEFT '
              'side of the screen. For transverse body scans: marker points to the '
              'patient\'s right. For longitudinal scans: marker points cephalad (toward '
              'the head). Confirm by touching the marked end — a bright disturbance '
              'should appear on the left of the screen. If it appears on the right, '
              'press the invert / L-R button. Reconfirm after every 90-degree probe rotation.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
      ],
    );
  }

  // ── Section 7: Probe movements ─────────────────────────────────
  Widget _buildProbeMovements(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubsectionLabel(text: 'FIVE MOVEMENTS — PSRTF', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'PRESSURE',
          body: 'Increase downward force to compress veins (veins collapse, arteries '
              'do not — the fastest bedside test to distinguish them). Also reduces '
              'depth to target by compressing superficial tissue. Start every scan '
              'with minimal pressure — heavy pressure flattens bursae and displaces '
              'fluid, making real pathology disappear.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'SLIDING (TRANSLATION)',
          body: 'Translate the probe along the skin without changing its angle. '
              'Use to follow a structure from origin to insertion, find the best '
              'acoustic window, or center the target before a needle pass. '
              'Anchor the pinky on the patient to prevent inadvertent sliding '
              'during the injection.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'ROTATION',
          body: 'Pivot the probe around its center point. A true 90-degree rotation '
              'switches between LA and SA. Smaller rotations (5-10°) fine-tune '
              'alignment with oblique tendons for maximal echogenicity. Common '
              'mistake: rotating and sliding simultaneously — keep the center point '
              'stationary over the target.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'TILTING (HEEL-TOE)',
          body: 'Rock the probe along its long axis so the beam tilts toward one end. '
              'This changes the angle the beam strikes tendon fibers. Even a few '
              'degrees of tilt can turn a falsely dark tendon bright — or vice versa. '
              'Also brings the beam closer to perpendicular with an in-plane needle, '
              'dramatically improving needle visibility.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'FANNING (SWEEPING)',
          body: 'Rock the probe perpendicular to its long axis — sweeping the beam '
              'through tissue planes on either side. Builds a 3D mental model of a '
              'joint or bursa. Fanning is different from tilting: fanning changes '
              'which slice you see entirely; tilting changes the angle of the same '
              'slice. Use fanning to survey the full extent of an effusion or confirm '
              'OOP needle tip position.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'ERGONOMICS', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'VISUAL LINE',
          body: 'Eyes, screen, probe, needle entry, and target should sit in one '
              'visual line so you can glance between needle and screen with minimal '
              'head rotation. Position the screen directly across the patient at eye '
              'height before scrubbing in. Adjust the bed, stool, and machine before '
              'the sterile field goes down — not during.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'PINKY ANCHOR',
          body: 'Rest the pinky and ulnar border of the scanning hand on the patient. '
              'This converts the probe from a free-floating instrument into a short '
              'lever with a fixed fulcrum, reducing drift and tremor to a fraction '
              'of what a floating hand produces. Allows millimeter-precision adjustments.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: '90-DEGREE ELBOW RULE',
          body: 'Keep the scanning-arm elbow at roughly 90 degrees of flexion with '
              'the upper arm close to the body. Abducted shoulders ("chicken wing") '
              'fatigue within 60-90 seconds and cause visible tremor. Set the table '
              'height so the patient\'s skin surface is at approximately your elbow '
              'height when standing.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'PRESSURE DISCIPLINE',
          body: 'Begin every scan with the minimum pressure needed to maintain gel '
              'contact. Heavy-by-default pressure compresses veins to nothing, '
              'flattens bursae, and increases hand tremor within minutes. Assess '
              'pressure-dependent findings (effusion volume, vein compressibility) '
              'at minimal pressure. Only increase pressure deliberately for a '
              'specific maneuver.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
      ],
    );
  }

  // ── Section 8: Safety & workflow ───────────────────────────────
  Widget _buildSafetyWorkflow(bool isDark) {
    final body = isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubsectionLabel(text: 'ALARA PRINCIPLE', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'THERMAL INDEX (TI)',
          body: 'Estimates tissue heating risk. Target TI < 0.7 during routine MSK '
              'scanning. Keep TI < 1.0 at all times. If TI > 2.0, reduce output '
              'power, shorten dwell time, or switch modes. TIB (bone sub-index) '
              'is highest near periosteum — watch it during bone-adjacent scans.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'MECHANICAL INDEX (MI)',
          body: 'Estimates cavitation risk. Keep MI < 0.7 for MSK work. '
              'FDA caps non-ophthalmic output at MI 1.9. In practice, MSK presets '
              'on modern machines stay well within limits — your main job is '
              'not leaving Doppler running unnecessarily.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.amber.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.amber.withValues(alpha: 0.18), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DOPPLER RAISES TI 5-10x',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.amber,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Turn on Doppler only to answer a specific question — '
                '"is that structure a vessel?" — then turn it off immediately. '
                'Leaving Doppler running also slows the frame rate and masks '
                'B-mode findings during the needle pass.',
                style: GoogleFonts.inter(fontSize: 13.5, height: 1.5, color: body),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'SCAN-BEFORE-PREP WORKFLOW', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'STEP 1 — SCAN WITH CLEAN GEL',
          body: 'Before opening any sterile supplies, use bare probe and '
              'non-sterile gel. Both hands are free. Perform a complete survey '
              'of the target region.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'STEP 2 — IDENTIFY AND PLAN',
          body: 'Localize the target. Identify vessels, nerves, and other '
              'structures to avoid. Mentally rehearse the needle path — '
              'entry point, angle, IP vs OOP, expected depth. Find the single '
              'best view before prepping.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'STEP 3 — MARK THE SKIN',
          body: 'Mark probe edges or needle entry site with a skin marker, or '
              'press a capped needle briefly to leave an indentation that '
              'survives the prep solution. Alternatively, memorize probe '
              'position relative to a bony landmark.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'STEP 4 — PREP AND RE-ACQUIRE',
          body: 'Prep skin, drape, apply sterile gel, and apply sterile probe '
              'cover (or use no-touch technique per department protocol). '
              'Re-acquire your target view — it should match the pre-scan '
              'almost exactly if positioning was preserved.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.cyan.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.cyan.withValues(alpha: 0.12), width: 1),
          ),
          child: Text(
            'Never skip the pre-scan to "save time." '
            'The pre-scan is the procedure. The injection is the last '
            '30 seconds of a 10-minute planning process.',
            style: GoogleFonts.inter(
                fontSize: 13, height: 1.5,
                fontStyle: FontStyle.italic,
                color: AppTheme.cyan.withValues(alpha: 0.85)),
          ),
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'STERILE TECHNIQUE', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'FULL STERILE COVER (PREFERRED)',
          body: 'Sterile probe cover + sterile gel inside + sterile gel on skin. '
              'Required for intra-articular injections, prosthetic joints, '
              'PRP and tenotomy procedures, immunocompromised patients, and any '
              'deep or high-risk approach.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'GEL CONTAMINATION RISK',
          body: 'Multi-use gel bottles have caused outbreaks of Burkholderia cepacia '
              'and Pseudomonas aeruginosa. These organisms grow in warm, non-sterile '
              'gel. Use single-use sterile gel packets for any procedure involving a '
              'needle. Never top off a gel bottle.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'DOCUMENTATION — CPT 76942', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'THREE REQUIRED IMAGES',
          body: '1. Target structure before needle insertion.\n'
              '2. Needle tip in the target.\n'
              '3. Injectate spread within the target (swirling, capsule distension, '
              'or anechoic tracking).\n'
              'Store all images in PACS — not just on the machine. Label laterality '
              '(L/R) and site before saving every image.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'REAL-TIME REQUIREMENT',
          body: '"Real-time guidance" means you were actively imaging during needle '
              'advancement. Landmark marking followed by a blind stick does not '
              'qualify for 76942, even if US was used earlier in the encounter. '
              'The note must state that the tip was confirmed in the target before '
              'injection.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'TOP MISTAKES', isDark: isDark),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surgicalRed.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.surgicalRed.withValues(alpha: 0.12), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOLDEN RULE',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.surgicalRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Never advance a needle you cannot see. When the needle '
                'disappears, stop. Hold the needle still, sweep the probe '
                'a few mm to re-acquire the shaft, then jiggle or use a '
                '0.1 mL test bolus to confirm tip location before continuing.',
                style: GoogleFonts.inter(
                    fontSize: 13.5, height: 1.5,
                    color: AppTheme.surgicalRed.withValues(alpha: 0.92)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'MOVING THE PROBE TO FIND THE NEEDLE',
          body: 'When the needle drifts out of plane, the reflex is to rotate the '
              'probe toward the needle. Do the opposite: hold the probe on the '
              'target view and redirect the needle back into the beam. The probe '
              'defines the imaging plane — the needle is the variable you control.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'NOT WATCHING INJECTATE SPREAD',
          body: 'Keep eyes on the screen during injection, not on the syringe. '
              'Watch for swirling in a joint, capsule distension, or anechoic '
              'tracking along a fascial plane. Pain with injection plus no '
              'visible spread in the target = stop and reposition.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'INJECTING WITHOUT VERBALLY CONFIRMING TIP POSITION',
          body: 'Before every injection, say aloud: "Tip in target?" '
              'Force the confirmation to be explicit. If uncertain, inject '
              '0.1 mL first and watch where the anechoic cloud appears. '
              'If it blooms outside the target — reposition before the full dose.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
      ],
    );
  }

  // ── Section 9: Injectates & complications ──────────────────────
  Widget _buildInjectatesComplications(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubsectionLabel(text: 'COMMON INJECTATES', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'LOCAL ANESTHETIC',
          body: 'Lidocaine 1% — onset 2-5 min, lasts 1-2 h. Bupivacaine 0.25-0.5% — '
              'onset 5-10 min, lasts 4-8 h. Always add 1-2 mL of LA to your steroid. '
              'Diagnostic value: >50% pain relief within 15-30 minutes confirms '
              'the injected structure as a pain generator. Document pre- and '
              'post-injection pain scores before the patient leaves the room.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'CORTICOSTEROIDS',
          body: 'Triamcinolone 40 mg (Kenalog) — most common. Appears as echogenic '
              '"snow" swirling in the target compartment under US — extremely useful '
              'confirmation of correct placement. If you inject and see no echogenic '
              'cloud in the target, reassess position. Methylprednisolone and '
              'betamethasone are alternatives. Limit to 3-4 injections per site '
              'per year, at least 3 months apart. Onset 2-7 days; effect lasts '
              'weeks to months.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'PRP (PLATELET-RICH PLASMA)',
          body: 'Autologous growth factors concentrated from the patient\'s own blood. '
              'Evidence strongest for lateral epicondylitis and knee OA. Anechoic '
              'on US — confirm position before injecting. Patients must stop NSAIDs '
              '5-7 days before and 2 weeks after. Warn patients to expect a '
              '24-72 hour inflammatory flare — this is expected, not a complication.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'SALINE — HYDRODISSECTION & BARBOTAGE',
          body: 'Hydrodissection: inject saline (± LA) into a fascial plane to '
              'separate adhered structures. Classic use: carpal tunnel (separate '
              'median nerve from flexor tendons) and adhesive capsulitis distension '
              '(10-30 mL). Barbotage: for calcific rotator cuff tendinopathy — '
              'inject into the calcium deposit and aspirate the slurry under US.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'CONTRAINDICATIONS', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'ABSOLUTE',
          body: 'Overlying skin infection or cellulitis — find an alternate approach '
              'or defer. Septic joint or active joint infection — never inject steroid '
              'into an infected joint (if in doubt, aspirate for cell count, Gram stain, '
              'and culture first). Patient refusal. Known anaphylaxis to a specific '
              'injectate component.',
          accent: AppTheme.surgicalRed,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'RELATIVE — CHECK BEFORE EVERY PROCEDURE',
          body: 'Anticoagulation: superficial injections generally safe; deep injections '
              'with INR > 3.5 need attending guidance. Uncontrolled diabetes (HbA1c > 9%) — '
              'consider non-steroid alternatives. Recent steroid at same site < 4-6 weeks — '
              'defer. Prosthetic joint — orthopedic surgeon input required. '
              'Pregnancy — LA generally safe, avoid epinephrine, discuss steroid '
              'with obstetrician.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _SubsectionLabel(text: 'COMPLICATIONS', isDark: isDark),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'VASOVAGAL (MOST COMMON — 5-10%)',
          body: 'Lightheadedness, diaphoresis, nausea, bradycardia during or '
              'immediately after injection. Management: stop, lay patient supine, '
              'elevate legs, cool compress to forehead, monitor vitals. Usually '
              'self-limited within minutes. Prevention: inject supine whenever '
              'possible, ensure patient has eaten, warn them early to report '
              'any lightheadedness.',
          accent: AppTheme.cyan,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surgicalRed.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
                color: AppTheme.surgicalRed.withValues(alpha: 0.12), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STEROID FLARE vs INFECTION',
                style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.surgicalRed,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'FLARE  —  onset within 6-48 h, no fever, no spreading redness, '
                'resolves by 72 h with ice and NSAIDs.\n\n'
                'INFECTION  —  onset 2-5 days post-injection, increasing pain, '
                'fever, expanding erythema, does not respond to NSAIDs.\n\n'
                'Any uncertainty = evaluate in person. Septic arthritis is a '
                'surgical emergency.',
                style: GoogleFonts.inter(
                    fontSize: 13.5, height: 1.55,
                    color: AppTheme.surgicalRed.withValues(alpha: 0.92)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'NERVE INJURY',
          body: 'Burning, electric, or radiating pain during needle advancement '
              'or injection = stop immediately. Withdraw the needle slightly and '
              'reassess position under US. Never inject against severe resistance '
              'or through electric pain. Persistent paresthesias beyond 6 weeks '
              'warrant EMG/NCS and neurology referral.',
          accent: AppTheme.surgicalRed,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'TENDON RUPTURE RISK',
          body: 'Never inject steroid directly into the substance of a load-bearing '
              'tendon. Watch the injectate spread under US — if the tendon fibers '
              'are splaying apart rather than the sheath filling, you are intratendinous. '
              'Stop and reposition. High-risk sites: Achilles, patellar, distal biceps.',
          accent: AppTheme.surgicalRed,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'HYPERGLYCEMIA IN DIABETICS',
          body: 'Steroids predictably elevate blood glucose starting within 24 h, '
              'peaking at 2-3 days, resolving by 5-7 days. Counsel diabetic patients '
              'to check glucose 2-4x per day for one week. Triamcinolone has a more '
              'sustained glycemic effect than betamethasone. Ask every patient about '
              'diabetes — do not rely on the medication list alone.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _InfoCard(
          title: 'SKIN COMPLICATIONS (SUPERFICIAL INJECTIONS)',
          body: 'Skin hypopigmentation and subcutaneous fat atrophy can be permanent. '
              'More visible in patients with darker skin tones. Discuss explicitly '
              'before injecting A1 pulley, de Quervain\'s, trigger points, or the '
              'lateral epicondyle. Minimize risk by using the smallest effective '
              'dose, diluting with LA, and injecting deep to the subcutaneous layer.',
          accent: AppTheme.amber,
          isDark: isDark,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Internal widgets
// ═══════════════════════════════════════════════════════════════════

class _ExpandableSection extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const _ExpandableSection({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.surfaceDark
            : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppTheme.cyan,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.jetBrainsMono(
                        color: isDark
                            ? AppTheme.textPrimary
                            : AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.cyan,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: child,
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Color accent;
  final bool isDark;

  const _InfoCard({
    required this.title,
    required this.body,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: accent.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: accent,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              height: 1.5,
              color:
                  isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final String body;
  const _SettingItem({required this.title, required this.body});
}

class _TissueItem {
  final String title;
  final String body;
  final String? caveat;
  const _TissueItem({
    required this.title,
    required this.body,
    this.caveat,
  });
}

class _TissueCard extends StatelessWidget {
  final _TissueItem item;
  final bool isDark;

  const _TissueCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cyan.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.cyan.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.cyan,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              item.body,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: isDark
                    ? AppTheme.textPrimary
                    : AppTheme.textPrimaryLight,
              ),
            ),
          ),
          if (item.caveat != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.amber.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                border: Border.all(
                  color: AppTheme.amber.withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AppTheme.amber, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.caveat!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.45,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArtifactItem {
  final String title;
  final String svg;
  final String whatIs;
  final String whyMatters;
  const _ArtifactItem({
    required this.title,
    required this.svg,
    required this.whatIs,
    required this.whyMatters,
  });
}

class _ArtifactCard extends StatelessWidget {
  final _ArtifactItem item;
  final bool isDark;

  const _ArtifactCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cyan.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.cyan.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: GoogleFonts.jetBrainsMono(
              color: AppTheme.cyan,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 10),
          _ArtifactDiagram(path: item.svg),
          const SizedBox(height: 12),
          _LabeledParagraph(
            label: 'WHAT IT IS',
            labelColor:
                isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
            body: item.whatIs,
            bodyColor:
                isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
          ),
          const SizedBox(height: 10),
          _LabeledParagraph(
            label: 'WHY IT MATTERS',
            labelColor: AppTheme.surgicalRed,
            body: item.whyMatters,
            bodyColor: AppTheme.surgicalRed.withValues(alpha: 0.92),
          ),
        ],
      ),
    );
  }
}

class _ArtifactDiagram extends StatelessWidget {
  final String path;
  const _ArtifactDiagram({required this.path});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF060D1A),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(
            color: AppTheme.cyan.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => const _DiagramFallback(),
        ),
      ),
    );
  }
}

class _DiagramFallback extends StatelessWidget {
  const _DiagramFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF060D1A),
      alignment: Alignment.center,
      child: Text(
        'DIAGRAM',
        style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class _LabeledParagraph extends StatelessWidget {
  final String label;
  final Color labelColor;
  final String body;
  final Color bodyColor;

  const _LabeledParagraph({
    required this.label,
    required this.labelColor,
    required this.body,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: labelColor,
            fontWeight: FontWeight.w700,
            fontSize: 9,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          body,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.5,
            color: bodyColor,
          ),
        ),
      ],
    );
  }
}

class _SubsectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SubsectionLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 2,
          decoration: BoxDecoration(
            color: AppTheme.cyan.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            color: isDark
                ? AppTheme.textSecondary
                : AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
