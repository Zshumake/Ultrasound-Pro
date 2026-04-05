import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/injection_technique.dart';
class InteractiveAnatomicalView extends StatefulWidget {
  final AnatomicalPlacement placement;

  const InteractiveAnatomicalView({
    super.key,
    required this.placement,
  });

  @override
  State<InteractiveAnatomicalView> createState() => _InteractiveAnatomicalViewState();
}

class _InteractiveAnatomicalViewState extends State<InteractiveAnatomicalView> with SingleTickerProviderStateMixin {
  int _currentStepIndex = 0;
  final TransformationController _transformationController = TransformationController();
  bool _isInitZoomApplied = false;
  
  // Animation controller for zooming
  late AnimationController _animController;
  Animation<Matrix4>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.addListener(() {
      if (_zoomAnimation != null) {
        _transformationController.value = _zoomAnimation!.value;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStepIndex < widget.placement.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _reset() {
    if (_currentStepIndex != 0) {
      setState(() {
        _currentStepIndex = 0;
      });
    }
  }

  void _applyInitialZoom(BoxConstraints constraints, double baseWidth, double baseHeight) {
    if (_isInitZoomApplied) return;
    
    // We delay the animation slightly so the user sees the full body for a moment
    // before it zooms in.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _isInitZoomApplied = true;

      // Calculate 'fit-to-screen' matrix (full body)
      final fullScale = math.min(constraints.maxWidth / baseWidth, constraints.maxHeight / baseHeight);
      final fullDx = (constraints.maxWidth - baseWidth * fullScale) / 2;
      final fullDy = (constraints.maxHeight - baseHeight * fullScale) / 2;
      // ignore: deprecated_member_use
      final fullMatrix = Matrix4.identity()..translate(fullDx, fullDy)..scale(fullScale);

      if (widget.placement.focusRegion == null || widget.placement.focusRegion!.length < 4) {
        // No focus region, just show full body
        _transformationController.value = fullMatrix;
        return;
      }

      // Calculate 'zoomed' matrix
      final fr = widget.placement.focusRegion!;
      final frX = fr[0];
      final frY = fr[1];
      final frW = fr[2];
      final frH = fr[3];

      // Add a little padding to the focus region
      final scale = math.min(constraints.maxWidth / frW, constraints.maxHeight / frH) * 0.9;
      final dx = (constraints.maxWidth - frW * scale) / 2 - frX * scale;
      final dy = (constraints.maxHeight - frH * scale) / 2 - frY * scale;
      // ignore: deprecated_member_use
      final zoomedMatrix = Matrix4.identity()..translate(dx, dy)..scale(scale);

      // Start at full matrix, then animate to zoomed matrix
      _transformationController.value = fullMatrix;
      
      _zoomAnimation = Matrix4Tween(
        begin: fullMatrix,
        end: zoomedMatrix,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ));
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _animController.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.placement.steps.isEmpty) {
      return const Center(child: Text("No placement steps available."));
    }

    final currentStep = widget.placement.steps[_currentStepIndex];

    // The base SVG dimensions (our standard reference canvas)
    const double baseWidth = 1000.0;
    const double baseHeight = 1000.0; 

    final String baseSvgPath = 'assets/images/${widget.placement.baseSvgName}.svg';
    final hasMultipleSteps = widget.placement.steps.length > 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        _applyInitialZoom(constraints, baseWidth, baseHeight);

        return Column(
          children: [
            if (hasMultipleSteps)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  currentStep.description,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: ClipRect(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  constrained: false, // Let the stack inside be its exact baseWidth x baseHeight
                  minScale: 0.1,
                  maxScale: 10.0,
                  child: SizedBox(
                    width: baseWidth,
                    height: baseHeight,
                    child: Stack(
                      children: [
                        // 1. Base Anatomical SVG Layer
                        Positioned.fill(
                          child: SvgPicture.asset(
                            baseSvgPath,
                            width: baseWidth,
                            height: baseHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        // 2. Probe Layer (Animated)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          left: currentStep.probeX - 50,
                          top: currentStep.probeY - 50,
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            turns: currentStep.probeRotationDegrees / 360.0,
                            child: SvgPicture.asset(
                              'assets/images/ultrasound_probe.svg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),

                        // 3. Needle Layer (Animated)
                        if (currentStep.needleX != null && currentStep.needleY != null)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            left: currentStep.needleX! - 50,
                            top: currentStep.needleY! - 50,
                            child: AnimatedRotation(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              turns: (currentStep.needleRotationDegrees ?? 0) / 360.0,
                              child: SvgPicture.asset(
                                'assets/images/injection_needle.svg',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (hasMultipleSteps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fast_rewind),
                      onPressed: _currentStepIndex > 0 ? _reset : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: _currentStepIndex > 0 ? _prevStep : null,
                    ),
                    Text("Step ${_currentStepIndex + 1} of ${widget.placement.steps.length}"),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: _currentStepIndex < widget.placement.steps.length - 1 ? _nextStep : null,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
