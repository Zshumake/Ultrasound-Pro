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
  });

  factory InjectionTechnique.fromJson(Map<String, dynamic> json) {
    return InjectionTechnique(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      tags: List<String>.from(json['tags']),
      treats: List<String>.from(json['treats']),
      positioning: List<String>.from(json['positioning']),
      probe: List<String>.from(json['probe']),
      landmarking: List<String>.from(json['landmarking']),
      correctImage: List<String>.from(json['correctImage']),
      corridor: List<String>.from(json['corridor']),
      avoid: List<String>.from(json['avoid']),
      steps: List<String>.from(json['steps']),
      tips: List<String>.from(json['tips']),
      pearls: List<String>.from(json['pearls']),
      supplies: List<String>.from(json['supplies']),
      positioningImg: json['positioningImg'] as String?,
      probeImg: json['probeImg'] as String?,
      landmarkImg: json['landmarkImg'] as String?,
      ultrasoundImg: json['ultrasoundImg'] as String?,
    );
  }
}
