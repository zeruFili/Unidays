import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/offer_model.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../services/data_service.dart';
import 'add_offer_page.dart';
import 'login_page.dart';

class BrandDashboardPage extends StatefulWidget {
  final UserModel user;

  const BrandDashboardPage({Key? key, required this.user}) : super(key: key);

  @override
  State<BrandDashboardPage> createState() => _BrandDashboardPageState();
}

class _BrandDashboardPageState extends State<BrandDashboardPage> {
  late List<OfferModel> brandOffers;

  @override
  void initState() {
    super.initState();
    _loadBrandOffers();
  }

  void _loadBrandOffers() {
    setState(() {
      brandOffers = DataService().getOffersByBrandId(widget.user.id);
    });
  }

  void _deleteOffer(String offerId) {
    DataService().deleteOffer(offerId);
    _loadBrandOffers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer deleted successfully'),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  void _editOffer(OfferModel offer) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AddOfferPage(
              existingOffer: offer,
              brandId: widget.user.id,
            ),
          ),
        )
        .then((_) => _loadBrandOffers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              color: AppColors.primaryColor,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${brandOffers.length} Active Offers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AddOfferPage(brandId: widget.user.id),
                          ),
                        )
                        .then((_) => _loadBrandOffers());
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Offer'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (brandOffers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Offers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: brandOffers.length,
                      itemBuilder: (context, index) {
                        final offer = brandOffers[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            offer.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            offer.description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${offer.discountPercentage}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Expires: ${offer.expiryDate.toString().split(' ')[0]}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _editOffer(offer),
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Edit'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _deleteOffer(offer.id),
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Delete'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.errorColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Icon(
                        Icons.local_offer_outlined,
                        size: 48,
                        color: AppColors.gray300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No offers yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create your first offer to get started',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
