class OfferModel {
  final String id;
  final String brandId;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercentage;
  final String category;
  final DateTime expiryDate;
  final double rating;
  final String imageUrl;

  OfferModel({
    required this.id,
    required this.brandId,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.category,
    required this.expiryDate,
    required this.rating,
    required this.imageUrl,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      discountPercentage: json['discountPercentage'] as int,
      category: json['category'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'discountPercentage': discountPercentage,
      'category': category,
      'expiryDate': expiryDate.toIso8601String(),
      'rating': rating,
      'imageUrl': imageUrl,
    };
  }
}
