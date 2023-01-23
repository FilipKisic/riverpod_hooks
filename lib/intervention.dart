class Intervention {
  final int id;
  final String? description;
  final bool isFavorite;

  const Intervention(this.id, this.description, this.isFavorite);

  factory Intervention.fromJson(Map<String, dynamic> json) => Intervention(
        json['interventionId'] as int,
        json['description'] as String?,
        (json['interventionId'] as int) % 2 == 0 ? false : true,
      );
}
