import 'package:flutter/material.dart';
import '/models/cart_item.dart';
import 'dart:math';

enum DeliveryType { standard, express, pickup }

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DeliveryType selectedDeliveryType = DeliveryType.standard;
  String? selectedAddress;
  double shippingFee = 0;


  final List<String> userAddresses = [
    'Home: 123 Main St, Cairo',
    'Work: 456 Office Blvd, Giza',
  ];

  @override
  void initState() {
    super.initState();
    calculateShippingFee();
  }

  void calculateShippingFee() {
    final random = Random();
    setState(() {
      switch (selectedDeliveryType) {
        case DeliveryType.standard:
          shippingFee = 30 + random.nextDouble() * 20; // Between 30-50
          break;
        case DeliveryType.express:
          shippingFee = 70 + random.nextDouble() * 30; // Between 70-100
          break;
        case DeliveryType.pickup:
          shippingFee = 0;
          break;
      }
    });
  }

  void _showDeliveryOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Delivery Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...DeliveryType.values.map(
                  (type) => ListTile(
                    title: Text(
                      type == DeliveryType.standard
                          ? 'Standard Delivery (3-4 days)'
                          : type == DeliveryType.express
                          ? 'Express Delivery (1 day)'
                          : 'Pick up from store',
                    ),
                    subtitle: Text(
                      type == DeliveryType.pickup
                          ? 'Free'
                          : 'EGP ${type == DeliveryType.standard ? "30-50" : "70-100"}',
                    ),
                    onTap: () {
                      setState(() {
                        selectedDeliveryType = type;
                        calculateShippingFee();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showAddressOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...userAddresses.map(
                  (address) => ListTile(
                    title: Text(address),
                    onTap: () {
                      setState(() => selectedAddress = address);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add New Address'),
                  onTap: () {
                    // Here you would navigate to address form
                    // and save to database
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: const Icon(Icons.chevron_left, size: 24),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE6E6E6), height: 0.5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [_buildCheckoutSections(), _buildItems()],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final double total = widget.subtotal + shippingFee;

    final List<Map<String, dynamic>> summaryItems = [
      {
        'label': 'Subtotal (${widget.cartItems.length})',
        'value': 'EGP ${widget.subtotal.toStringAsFixed(2)}',
      },
      {
        'label': 'Shipping total',
        'value':
            selectedDeliveryType == DeliveryType.pickup
                ? 'Free'
                : 'EGP ${shippingFee.toStringAsFixed(2)}',
      },
      {
        'label': 'Total',
        'value': 'EGP ${total.toStringAsFixed(2)}',
        'highlight': true,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            summaryItems.map((item) {
              final bool highlight = item['highlight'] == true;
              final String label = item['label'] ?? '';
              final String value = item['value'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            highlight ? const Color(0xFFA41930) : Colors.black,
                        fontWeight:
                            highlight ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            highlight ? const Color(0xFFA41930) : Colors.black,
                        fontWeight:
                            highlight ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCheckoutSections() {
    final sections = [
      {
        'label': 'ADDRESS',
        'content': selectedAddress ?? 'Select delivery address',
        'placeholder': selectedAddress == null,
        'onTap': _showAddressOptions,
      },
      {
        'label': 'DELIVERY',
        'content': [
          selectedDeliveryType == DeliveryType.standard
              ? 'Standard Delivery (3-4 days)'
              : selectedDeliveryType == DeliveryType.express
              ? 'Express Delivery (1 day)'
              : 'Pick up from store',
          'EGP ${shippingFee.toStringAsFixed(2)}',
        ],
        'onTap': _showDeliveryOptions,
      },
      {'label': 'PAYMENT', 'content': 'Cash on delivery'},
      {'label': 'PROMOS', 'content': 'Apply promo code', 'placeholder': true},
    ];

    return Column(
      children:
          sections.map((section) {
            return GestureDetector(
              onTap: section['onTap'] as void Function()?,
              child: CheckoutSection(
                label: section['label'] as String,
                content: section['content'],
                isPlaceholder: section['placeholder'] == true,
                showArrow: section['label'] != 'PAYMENT',
              ),
            );
          }).toList(),
    );
  }

  Widget _buildItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'ITEMS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'DESCRIPTION',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'PRICE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(), // This ensures it scrolls with parent
          itemCount: widget.cartItems.length,
          itemBuilder: (context, index) {
            final item = widget.cartItems[index];
            return CheckoutItemCard(
              image: item.imageURL,
              brand: item.brandName,
              name: item.productName,
              description:
                  'Size: ${item.size}, Colors: ${item.color}',
              quantity: item.quantity.toString(),
              price: 'EGP ${(item.price * item.quantity).toStringAsFixed(2)}',
            );
          },
        ),
        const SizedBox(height: 16), // Add some bottom padding
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6), width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOrderSummary(),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Place order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 134,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final String label;
  final dynamic content;
  final bool isPlaceholder;
  final bool showArrow;

  const CheckoutSection({
    super.key,
    required this.label,
    required this.content,
    this.isPlaceholder = false,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE6E6E6), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child:
                content is List
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (content as List)
                              .map(
                                (line) => Text(
                                  line.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isPlaceholder
                                            ? Colors.black38
                                            : Colors.black,
                                  ),
                                ),
                              )
                              .toList(),
                    )
                    : Text(
                      content.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: isPlaceholder ? Colors.black38 : Colors.black,
                      ),
                    ),
          ),
          if (showArrow) const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}

class CheckoutItemCard extends StatelessWidget {
  final String image;
  final String brand;
  final String name;
  final String description;
  final String quantity;
  final String price;

  const CheckoutItemCard({
    super.key,
    required this.image,
    required this.brand,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x42000000), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                image,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 26),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Brand ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        TextSpan(
                          text: brand,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFA41930),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Quantity: $quantity',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 26),
            Text(
              price,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
