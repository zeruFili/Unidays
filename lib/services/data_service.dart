import '../models/user_model.dart';
import '../models/brand_model.dart';
import '../models/offer_model.dart';

class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  // Demo data
  final List<BrandModel> brands = [
    BrandModel(
      id: '1',
      name: 'Nike',
      description: 'Leading athletic wear and sports equipment brand',
      logoUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      category: 'Fashion',
      rating: 4.8,
      website: 'www.nike.com',
      totalOffers: 5,
      offers: ['offer1', 'offer2'],
    ),
    BrandModel(
      id: '2',
      name: 'McDonald\'s',
      description: 'Fast food restaurant chain',
      logoUrl:
          'https://images.unsplash.com/photo-1565958011504-4b34f80b0d69?w=200',
      category: 'Food',
      rating: 4.5,
      website: 'www.mcdonalds.com',
      totalOffers: 8,
      offers: ['offer3', 'offer4'],
    ),
    BrandModel(
      id: '3',
      name: 'Zara',
      description: 'Fashion retail company',
      logoUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200',
      category: 'Fashion',
      rating: 4.6,
      website: 'www.zara.com',
      totalOffers: 6,
      offers: ['offer5'],
    ),
    BrandModel(
      id: '4',
      name: 'Spotify',
      description: 'Music streaming platform',
      logoUrl:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=200',
      category: 'Entertainment',
      rating: 4.7,
      website: 'www.spotify.com',
      totalOffers: 4,
      offers: ['offer6'],
    ),
  ];

  final List<OfferModel> offers = [
    OfferModel(
      id: 'offer1',
      brandId: '1',
      title: '50% Off on All Shoes',
      description: 'Get 50% discount on selected Nike shoes',
      originalPrice: 100,
      discountedPrice: 50,
      discountPercentage: 50,
      category: 'Fashion',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      rating: 4.8,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    ),
    OfferModel(
      id: 'offer2',
      brandId: '1',
      title: '30% Off on Apparel',
      description: 'Exclusive student discount on Nike apparel',
      originalPrice: 80,
      discountedPrice: 56,
      discountPercentage: 30,
      category: 'Fashion',
      expiryDate: DateTime.now().add(const Duration(days: 20)),
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    ),
    OfferModel(
      id: 'offer3',
      brandId: '2',
      title: 'Buy 1 Get 1 Free Burgers',
      description: 'Valid with student ID every Tuesday',
      originalPrice: 12,
      discountedPrice: 6,
      discountPercentage: 50,
      category: 'Food',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      rating: 4.5,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
    ),
    OfferModel(
      id: 'offer4',
      brandId: '2',
      title: '25% Off on Meals',
      description: 'Student discount on combo meals',
      originalPrice: 15,
      discountedPrice: 11.25,
      discountPercentage: 25,
      category: 'Food',
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      rating: 4.7,
      imageUrl:
          'https://images.unsplash.com/photo-1555939594-58d7cb561620?w=400',
    ),
    OfferModel(
      id: 'offer5',
      brandId: '3',
      title: '40% Off on New Collection',
      description: 'Limited time offer on latest fashion collection',
      originalPrice: 120,
      discountedPrice: 72,
      discountPercentage: 40,
      category: 'Fashion',
      expiryDate: DateTime.now().add(const Duration(days: 25)),
      rating: 4.6,
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    ),
    OfferModel(
      id: 'offer6',
      brandId: '4',
      title: '3 Months Free Premium',
      description: 'Get 3 months of Spotify Premium for free',
      originalPrice: 29.97,
      discountedPrice: 0,
      discountPercentage: 100,
      category: 'Entertainment',
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      rating: 4.9,
      imageUrl:
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400',
    ),
  ];

  // Get all brands
  List<BrandModel> getAllBrands() {
    return brands;
  }

  // Get all offers
  List<OfferModel> getAllOffers() {
    return offers;
  }

  // Filter offers by category
  List<OfferModel> getOffersByCategory(String category) {
    if (category == 'All') {
      return offers;
    }
    return offers.where((offer) => offer.category == category).toList();
  }

  // Search offers
  List<OfferModel> searchOffers(String query) {
    return offers
        .where((offer) =>
            offer.title.toLowerCase().contains(query.toLowerCase()) ||
            offer.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get brand by ID
  BrandModel? getBrandById(String id) {
    try {
      return brands.firstWhere((brand) => brand.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get offers for a brand
  List<OfferModel> getOffersByBrandId(String brandId) {
    return offers.where((offer) => offer.brandId == brandId).toList();
  }

  // Add new offer
  void addOffer(OfferModel offer) {
    offers.add(offer);
  }

  // Update offer
  void updateOffer(String offerId, OfferModel updatedOffer) {
    final index = offers.indexWhere((offer) => offer.id == offerId);
    if (index != -1) {
      offers[index] = updatedOffer;
    }
  }

  // Delete offer
  void deleteOffer(String offerId) {
    offers.removeWhere((offer) => offer.id == offerId);
  }

  // Get featured offers (top rated)
  List<OfferModel> getFeaturedOffers() {
    final sortedOffers = List<OfferModel>.from(offers);
    sortedOffers.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedOffers.take(4).toList();
  }

  // Authenticate user
  UserModel? authenticateUser(String email, String password) {
    if (email == 'student@demo.com' && password == 'demo123') {
      return UserModel(
        id: '1',
        name: 'John Student',
        email: email,
        university: 'Stanford University',
        loyaltyPoints: 1250,
        joinDate: DateTime(2023, 1, 15),
        savedOffers: ['offer1', 'offer3'],
        isBrand: false,
      );
    } else if (email == 'brand@demo.com' && password == 'demo123') {
      return UserModel(
        id: '2',
        name: 'Nike Brand',
        email: email,
        university: 'N/A',
        loyaltyPoints: 0,
        joinDate: DateTime(2022, 6, 1),
        savedOffers: [],
        isBrand: true,
      );
    }
    return null;
  }
}
