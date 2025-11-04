class BrandModel {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String category;
  final double rating;
  final String website;
  final int totalOffers;
  final List<String> offers;

  BrandModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.category,
    required this.rating,
    required this.website,
    required this.totalOffers,
    required this.offers,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      website: json['website'] as String,
      totalOffers: json['totalOffers'] as int,
      offers: List<String>.from(json['offers'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'category': category,
      'rating': rating,
      'website': website,
      'totalOffers': totalOffers,
      'offers': offers,
    };
  }
}
