import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../order/presentation/widgets/order_summary.dart';
import '../../../order/presentation/widgets/order_item_card.dart';
import '../../../order/presentation/widgets/order_section.dart';
import '../../data/models/order.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;
  final int orderNumber;

  const OrderDetailsPage({
    super.key,
    required this.order,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.black26,
        title: Text(
          'Order #$orderNumber',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            current is ProductReturned ||
            (current is ProfileError &&
                previous is! ProfileError &&
                current is! OrderCancelled),
        listener: (context, state) {
          if (state is ProductReturned) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Return request submitted successfully'),
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildOrderSections(context),
                    _buildItems(context),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSections(BuildContext context) {
    final sections = [
      {
        'label': 'Order Date',
        'content':
            order.createdAt != null
                ? '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}'
                : 'Not available',
      },
      if (order.shipment?.method != null) ...[
        {
          'label':
              order.status == 'delivered'
                  ? 'Delivery Date'
                  : 'Estimated Delivery Date',
          'content':
              order.status == 'delivered' && order.shipment?.deliveredAt != null
                  ? '${order.shipment!.deliveredAt!.day}/${order.shipment!.deliveredAt!.month}/${order.shipment!.deliveredAt!.year}'
                  : order.shipment?.estimatedDeliveryDate != null
                  ? '${order.shipment!.estimatedDeliveryDate!.day}/${order.shipment!.estimatedDeliveryDate!.month}/${order.shipment!.estimatedDeliveryDate!.year}'
                  : 'To be determined',
        },
        {
          'label': 'Address',
          'content':
              order.address != null
                  ? '${order.address!.city}, ${order.address!.street}, Building ${order.address!.building}'
                  : 'No address provided',
        },
      ],
      {
        'label': 'Phone',
        'content':
            order.phoneNumber?.isNotEmpty == true
                ? order.phoneNumber!
                : 'No phone number',
      },
      {'label': 'Delivery', 'content': order.shipment?.method ?? 'Pickup'},
      {'label': 'Payment', 'content': 'Cash on delivery'},
    ];

    return Column(
      children:
          sections.map((section) {
            return OrderSection(
              label: section['label'] as String,
              content: section['content'] as String,
              showArrow: false,
            );
          }).toList(),
    );
  }

  Widget _buildItems(BuildContext context) {
    final cartItems = order.products ?? [];
    if (cartItems.isEmpty) return const SizedBox.shrink();

    // Show return button only if:
    // 1. Order is delivered
    // 2. Delivery date exists
    // 3. It's within 14 days of delivery
    final bool canReturn = order.status == 'delivered' && 
                          order.shipment?.deliveredAt != null &&
                          DateTime.now().difference(order.shipment!.deliveredAt!).inDays <= 14;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Order Summary',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            return OrderItemCard(
              item: cartItems[index],
              showReturnButton: canReturn,
              onReturn: () => _showReturnConfirmationDialog(
                context,
                cartItems[index].productId,
                cartItems[index].variantId,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showReturnConfirmationDialog(
    BuildContext context,
    String productId,
    String variantId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Return'),
          content: const Text(
            'Are you sure you want to return this item?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); 

                if (order.id != null) {
                  context.read<ProfileCubit>().returnProduct(
                    order.id!,
                    productId,
                    variantId,
                  );
                }
              },
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final subtotal = order.price ?? 0.0;
    final shipmentFee = order.shipment?.fees ?? 0.0;
    final itemCount = order.products?.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6), width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderSummary(
            subtotal: subtotal,
            shipmentFee: shipmentFee,
            itemCount: itemCount,
          ),
          const SizedBox(height: 12),
          if (order.status == 'processing')
            BlocConsumer<ProfileCubit, ProfileState>(
              listenWhen:
                  (previous, current) =>
                      current is OrderCancelled || current is ProfileError,
              listener: (context, state) {
                if (state is OrderCancelled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order cancelled successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                } else if (state is ProfileError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return ElevatedButton(
                  onPressed:
                      state is OrdersLoading
                          ? null
                          : () {
                            context.read<ProfileCubit>().cancelOrder(
                              order.id ?? '',
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      state is OrdersLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Cancel order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                );
              },
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
