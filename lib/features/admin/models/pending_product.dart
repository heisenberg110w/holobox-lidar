class PendingProduct {
  final String id;
  final String name;
  final String? notes;
  final String gender;
  final String ethnicity;
  final String ageGroup;
  final String? imageUrl;
  final String? scanUrl; // 3D scan OBJ file URL
  final DateTime submittedAt;

  const PendingProduct({
    required this.id,
    required this.name,
    required this.gender,
    required this.ethnicity,
    required this.ageGroup,
    required this.submittedAt,
    this.notes,
    this.imageUrl,
    this.scanUrl,
  });
}

