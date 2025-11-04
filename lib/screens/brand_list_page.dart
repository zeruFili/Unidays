import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user_model.dart';
import '../models/brand_model.dart';
import '../utils/colors.dart';
import '../services/data_service.dart';
import 'brand_detail_page.dart';

class BrandListPage extends StatefulWidget {
  final UserModel user;

  const BrandListPage({Key? key, required this.user}) : super(key: key);

  @override
  State<BrandListPage> createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  late List<BrandModel> brands;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    brands = DataService().getAllBrands();
    print('Total brands loaded: ${brands.length}');
    for (var brand in brands) {
      print('Brand: ${brand.name}, ID: ${brand.id}');
    }
  }

  List<BrandModel> getFilteredBrands() {
    if (searchQuery.isEmpty) {
      return brands;
    }
    return brands
        .where((brand) =>
            brand.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBrands = getFilteredBrands();
    print('Filtered brands count: ${filteredBrands.length}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: 'Search brands...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() => searchQuery = '');
                          },
                          child: const Icon(Icons.clear),
                        )
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredBrands.length,
                itemBuilder: (context, index) {
                  final brand = filteredBrands[index];
                  return Card(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          print('Tapped on brand: ${brand.name}');
                          print('Brand ID: ${brand.id}');
                          print('User email: ${widget.user.email}');

                          try {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => BrandDetailPage(
                                  brand: brand,
                                  user: widget.user,
                                ),
                              ),
                            )
                                .then((_) {
                              print('Returned from BrandDetailPage');
                            });
                          } catch (e) {
                            print('Navigation error: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Navigation failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 120,
                              color: AppColors.gray100,
                              child: CachedNetworkImage(
                                imageUrl: brand.logoUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.store),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    brand.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    brand.category,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: AppColors.warningColor,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            brand.rating.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${brand.totalOffers} deals',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
