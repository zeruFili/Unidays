import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/offer_model.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../services/data_service.dart';
import 'widgets/offer_card.dart';
import 'widgets/category_filter.dart';
import 'brand_list_page.dart';
import 'user_profile_page.dart';
import 'login_page.dart';

class LandingPage extends StatefulWidget {
  final UserModel user;

  const LandingPage({Key? key, required this.user}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late List<OfferModel> allOffers;
  late List<OfferModel> filteredOffers;
  String selectedCategory = 'All';
  String searchQuery = '';
  int _currentIndex = 0;

  final List<String> categories = [
    'All',
    'Food',
    'Fashion',
    'Electronics',
    'Books',
    'Travel',
    'Entertainment',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    allOffers = DataService().getAllOffers();
    filteredOffers = allOffers;
  }

  void _filterOffers() {
    setState(() {
      if (searchQuery.isNotEmpty) {
        filteredOffers = DataService().searchOffers(searchQuery);
      } else if (selectedCategory != 'All') {
        filteredOffers = DataService().getOffersByCategory(selectedCategory);
      } else {
        filteredOffers = allOffers;
      }
    });
  }

  void _onCategoryChanged(String category) {
    setState(() {
      selectedCategory = category;
      searchQuery = '';
    });
    _filterOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Discounts'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildHomeTab()
          : _currentIndex == 1
              ? BrandListPage(user: widget.user)
              : UserProfilePage(user: widget.user),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Brands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                searchQuery = value;
                _filterOffers();
              },
              decoration: InputDecoration(
                hintText: 'Search offers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            searchQuery = '';
                            selectedCategory = 'All';
                          });
                          _filterOffers();
                        },
                        child: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
          ),
          CategoryFilter(
            selectedCategory: selectedCategory,
            categories: categories,
            onCategorySelected: _onCategoryChanged,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Offers',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 225,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: DataService()
                  .getFeaturedOffers()
                  .map((offer) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 300,
                          child: OfferCard(offer: offer),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              selectedCategory == 'All'
                  ? 'All Offers'
                  : '$selectedCategory Offers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredOffers.length,
              itemBuilder: (context, index) {
                return OfferCard(offer: filteredOffers[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
