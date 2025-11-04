import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/offer_model.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../services/data_service.dart';

class AddOfferPage extends StatefulWidget {
  final String brandId;
  final OfferModel? existingOffer;

  const AddOfferPage({
    Key? key,
    required this.brandId,
    this.existingOffer,
  }) : super(key: key);

  @override
  State<AddOfferPage> createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController originalPriceController;
  late TextEditingController discountedPriceController;
  late TextEditingController imageUrlController;

  final List<String> categories = [
    'Food',
    'Fashion',
    'Electronics',
    'Books',
    'Travel',
    'Entertainment',
    'Sports',
  ];

  String selectedCategory = 'Fashion';
  DateTime selectedExpiryDate = DateTime.now().add(const Duration(days: 30));
  double rating = 4.5;

  @override
  void initState() {
    super.initState();
    if (widget.existingOffer != null) {
      titleController =
          TextEditingController(text: widget.existingOffer!.title);
      descriptionController =
          TextEditingController(text: widget.existingOffer!.description);
      originalPriceController = TextEditingController(
          text: widget.existingOffer!.originalPrice.toString());
      discountedPriceController = TextEditingController(
          text: widget.existingOffer!.discountedPrice.toString());
      imageUrlController =
          TextEditingController(text: widget.existingOffer!.imageUrl);
      selectedCategory = widget.existingOffer!.category;
      selectedExpiryDate = widget.existingOffer!.expiryDate;
      rating = widget.existingOffer!.rating;
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      originalPriceController = TextEditingController();
      discountedPriceController = TextEditingController();
      imageUrlController = TextEditingController();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    originalPriceController.dispose();
    discountedPriceController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _selectExpiryDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedExpiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => selectedExpiryDate = pickedDate);
    }
  }

  int _calculateDiscountPercentage() {
    if (originalPriceController.text.isEmpty ||
        discountedPriceController.text.isEmpty) {
      return 0;
    }
    final original = double.tryParse(originalPriceController.text) ?? 0;
    final discounted = double.tryParse(discountedPriceController.text) ?? 0;
    if (original == 0) return 0;
    return ((original - discounted) / original * 100).toInt();
  }

  void _saveOffer() {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        originalPriceController.text.isEmpty ||
        discountedPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    final offer = OfferModel(
      id: widget.existingOffer?.id ??
          'offer_${DateTime.now().millisecondsSinceEpoch}',
      brandId: widget.brandId,
      title: titleController.text,
      description: descriptionController.text,
      originalPrice: double.parse(originalPriceController.text),
      discountedPrice: double.parse(discountedPriceController.text),
      discountPercentage: _calculateDiscountPercentage(),
      category: selectedCategory,
      expiryDate: selectedExpiryDate,
      rating: rating,
      imageUrl: imageUrlController.text.isNotEmpty
          ? imageUrlController.text
          : 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    );

    if (widget.existingOffer != null) {
      DataService().updateOffer(widget.existingOffer!.id, offer);
    } else {
      DataService().addOffer(offer);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.existingOffer != null
            ? 'Offer updated successfully'
            : 'Offer created successfully'),
        backgroundColor: AppColors.successColor,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.existingOffer != null ? 'Edit Offer' : 'Create Offer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offer Title',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Enter offer title'),
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration:
                  const InputDecoration(hintText: 'Enter offer description'),
            ),
            const SizedBox(height: 16),
            Text(
              'Original Price',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: originalPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter original price',
                prefixText: '\$',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Discounted Price',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: discountedPriceController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Enter discounted price',
                prefixText: '\$',
                suffixText: '${_calculateDiscountPercentage()}% off',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Image URL (Optional)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                hintText: 'Enter image URL',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedCategory = value);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Expiry Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _selectExpiryDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(selectedExpiryDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Rating',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: rating.toStringAsFixed(1),
              onChanged: (value) => setState(() => rating = value),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveOffer,
                child: Text(widget.existingOffer != null
                    ? 'Update Offer'
                    : 'Save Offer'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
