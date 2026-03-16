
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
}
