class VideoTimestamp {
  final String label;
  final String section;
  final int seconds;

  const VideoTimestamp({
    required this.label,
    required this.section,
    required this.seconds,
  });

  factory VideoTimestamp.fromJson(Map<String, dynamic> json) {
    return VideoTimestamp(
      label: json['label'] as String? ?? '',
      section: json['section'] as String? ?? '',
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
    );
  }

  String get formattedTime {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class AnatomicalPlacementStep {
  final double probeX;
  final double probeY;
  final double probeRotationDegrees;
  final double? needleX;
  final double? needleY;
  final double? needleRotationDegrees;
  final String description;

  const AnatomicalPlacementStep({
    required this.probeX,
    required this.probeY,
    required this.probeRotationDegrees,
    this.needleX,
    this.needleY,
    this.needleRotationDegrees,
    this.description = '',
  });

  factory AnatomicalPlacementStep.fromJson(Map<String, dynamic> json) {
    return AnatomicalPlacementStep(
      probeX: (json['probeX'] as num).toDouble(),
      probeY: (json['probeY'] as num).toDouble(),
      probeRotationDegrees: (json['probeRotationDegrees'] as num).toDouble(),
      needleX: json['needleX'] != null ? (json['needleX'] as num).toDouble() : null,
      needleY: json['needleY'] != null ? (json['needleY'] as num).toDouble() : null,
      needleRotationDegrees: json['needleRotationDegrees'] != null ? (json['needleRotationDegrees'] as num).toDouble() : null,
      description: json['description'] as String? ?? '',
    );
  }
}

class AnatomicalPlacement {
  final String baseSvgName;
  final List<double>? focusRegion;
  final List<AnatomicalPlacementStep> steps;

  const AnatomicalPlacement({
    required this.baseSvgName,
    this.focusRegion,
    required this.steps,
  });

  factory AnatomicalPlacement.fromJson(Map<String, dynamic> json) {
    return AnatomicalPlacement(
      baseSvgName: json['baseSvgName'] as String,
      focusRegion: json['focusRegion'] != null 
          ? (json['focusRegion'] as List).map((e) => (e as num).toDouble()).toList() 
          : null,
      steps: (json['steps'] as List)
          .map((e) => AnatomicalPlacementStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class InjectionTechnique {
  final String id;
  final String title;
  final String category;
  final List<String> tags;
  final List<String> treats;
  final List<String> positioning;
  final List<String> probe;
  final List<String> landmarking;
  final List<String> correctImage;
  final List<String> corridor;
  final List<String> avoid;
  final List<String> steps;
  final List<String> tips;
  final List<String> pearls;
  final List<String> supplies;

  // Optional image paths for easy addition
  final String? positioningImg;
  final String? probeImg;
  final String? landmarkImg;
  final String? ultrasoundImg;
  final String? injectionImg;

  // Optional video URL for procedure demonstration
  final String? videoUrl;

  // Optional Sketchfab 3D anatomy model embed ID
  final String? anatomyModelId;
  final String? anatomyModelTitle;

  // Optional US image gallery paths (user-uploaded clinical images)
  final List<String> usGalleryImages;
  final List<String> usGalleryLabels;

  // Video chapter timestamps
  final List<VideoTimestamp> videoTimestamps;

  // Interactive anatomical placement
  final AnatomicalPlacement? anatomicalPlacement;

  // Safety scaffolding (added 2026-04-08 from medical audit)
  final List<String> contraindications;
  final List<String> preChecklist;
  final List<String> postProcedure;

  InjectionTechnique({
    required this.id,
    required this.title,
    required this.category,
    required this.tags,
    required this.treats,
    required this.positioning,
    required this.probe,
    required this.landmarking,
    required this.correctImage,
    required this.corridor,
    required this.avoid,
    required this.steps,
    required this.tips,
    required this.pearls,
    required this.supplies,
    this.positioningImg,
    this.probeImg,
    this.landmarkImg,
    this.ultrasoundImg,
    this.injectionImg,
    this.videoUrl,
    this.anatomyModelId,
    this.anatomyModelTitle,
    this.usGalleryImages = const [],
    this.usGalleryLabels = const [],
    this.videoTimestamps = const [],
    this.anatomicalPlacement,
    this.contraindications = const [],
    this.preChecklist = const [],
    this.postProcedure = const [],
  });

  static List<String> _strings(dynamic val) =>
      val != null ? List<String>.from(val as List) : const [];

  factory InjectionTechnique.fromJson(Map<String, dynamic> json) {
    return InjectionTechnique(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      tags: _strings(json['tags']),
      treats: _strings(json['treats']),
      positioning: _strings(json['positioning']),
      probe: _strings(json['probe']),
      landmarking: _strings(json['landmarking']),
      correctImage: _strings(json['correctImage']),
      corridor: _strings(json['corridor']),
      avoid: _strings(json['avoid']),
      steps: _strings(json['steps']),
      tips: _strings(json['tips']),
      pearls: _strings(json['pearls']),
      supplies: _strings(json['supplies']),
      positioningImg: json['positioningImg'] as String?,
      probeImg: json['probeImg'] as String?,
      landmarkImg: json['landmarkImg'] as String?,
      ultrasoundImg: json['ultrasoundImg'] as String?,
      injectionImg: json['injectionImg'] as String?,
      videoUrl: json['videoUrl'] as String?,
      anatomyModelId: json['anatomyModelId'] as String?,
      anatomyModelTitle: json['anatomyModelTitle'] as String?,
      usGalleryImages: json['usGalleryImages'] != null
          ? List<String>.from(json['usGalleryImages'])
          : const [],
      usGalleryLabels: json['usGalleryLabels'] != null
          ? List<String>.from(json['usGalleryLabels'])
          : const [],
      videoTimestamps: json['videoTimestamps'] != null
          ? (json['videoTimestamps'] as List)
              .map((e) => VideoTimestamp.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      anatomicalPlacement: json['anatomicalPlacement'] != null
          ? AnatomicalPlacement.fromJson(json['anatomicalPlacement'] as Map<String, dynamic>)
          : null,
      contraindications: json['contraindications'] != null
          ? List<String>.from(json['contraindications'])
          : const [],
      preChecklist: json['preChecklist'] != null
          ? List<String>.from(json['preChecklist'])
          : const [],
      postProcedure: json['postProcedure'] != null
          ? List<String>.from(json['postProcedure'])
          : const [],
    );
  }
}
