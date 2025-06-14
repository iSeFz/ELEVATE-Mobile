import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/order_cubit.dart';
import '../cubits/order_state.dart';
import '../widgets/order_summary.dart';
import '../widgets/order_item_card.dart';
import '../widgets/order_section.dart';
import '../../../cart/data/models/cart_item.dart';
import '../../data/models/shipment_types.dart';
import '../../../../core/utils/validations.dart';

class OrderScreen extends StatelessWidget {
  final String orderId;
  final String userId;
  final List<CartItem> cartItems;
  const OrderScreen({
    super.key,
    required this.orderId,
    required this.userId,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create:
          (_) =>
              OrderCubit(cartItems: cartItems)
                ..initializeOrder(orderId, userId),
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is OrderReleased) {
            Navigator.of(context).pop();
          }
          if (state is OrderPlaced) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Order Placed Successfully'),
                  content: const Text(
                    'Thank you for your order. Your order has been placed successfully and you can track it in order history.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Close all screens back to cart screen for now
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // Alternatively, navigate to order history
                        // Navigator.of(context).pushReplacementNamed('/orderHistory');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
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
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is OrderLoaded || state is OrderPlaced) {
            return _OrderScreenBody(
              orderId: orderId,
              userId: userId,
              cartItems: cartItems,
            );
          } else if (state is OrderError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
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
              body: Center(child: Text(state.message)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OrderScreenBody extends StatelessWidget {
  final String orderId;
  final String userId;
  final List<CartItem> cartItems;
  const _OrderScreenBody({
    required this.orderId,
    required this.userId,
    required this.cartItems,
  });

  void _showDeliveryOptions(BuildContext context) {
    // Capture the outer context that has access to OrderCubit
    final outerContext = context;

    showModalBottomSheet(
      context: context,
      builder:
          (bottomSheetContext) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Delivery Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Standard Delivery (3-4 days)'),
                  subtitle: const Text('Calculated based on location'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(
                        content: Text("Calculating shipment fees..."),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    outerContext.read<OrderCubit>().updateShipmentType(
                      ShipmentTypes.standard,
                    );
                  },
                ),
                ListTile(
                  title: const Text('Express Delivery (1-2 days)'),
                  subtitle: const Text('Calculated based on location'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(
                        content: Text("Calculating shipment fees..."),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    outerContext.read<OrderCubit>().updateShipmentType(
                      ShipmentTypes.express,
                    );
                  },
                ),
                ListTile(
                  title: const Text('Pick up from store'),
                  subtitle: const Text('Free'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(
                        content: Text("Calculating shipment fees..."),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    outerContext.read<OrderCubit>().updateShipmentType(
                      ShipmentTypes.pickup,
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showAddressOptions(BuildContext context) {
    final outerContext = context;
    final cubit = context.read<OrderCubit>();
    showModalBottomSheet(
      context: context,
      builder:
          (bottomSheetContext) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...cubit.userAddresses.map(
                  (address) => ListTile(
                    title: Text(address),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(outerContext).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Updating address and recalculating shipment fees...",
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      outerContext.read<OrderCubit>().updateAddress(address);
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showPhoneNumberEditDialog(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final phoneController = TextEditingController(text: cubit.phoneNumber);
    final formKey = GlobalKey<FormState>();
    String? validationError;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Edit Phone Number',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
            children: [
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  // hintText: '010XXXXXXXX',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: validatePhoneNumber,
                onChanged: (value) {
                  validationError = validatePhoneNumber(value);
                  (dialogContext as Element).markNeedsBuild();
                },
              ),
              if (validationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0), // Left padding to align with input field
                  child: Text(
                    validationError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.left, // Ensure text is left aligned
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                cubit.updatePhoneNumber(phoneController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Phone number updated successfully"),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSections(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final hasAddress = cubit.selectedAddress != null;
    
    final sections = [
      {
        'label': 'ADDRESS',
        'content': cubit.selectedAddress ?? 'Select delivery address',
        'placeholder': cubit.selectedAddress == null,
        'onTap': () => _showAddressOptions(context),
      },
      {
        'label': 'PHONE',
        'content': cubit.phoneNumber.isEmpty ? 'Add phone number' : cubit.phoneNumber,
        'placeholder': cubit.phoneNumber.isEmpty,
        'onTap': () => _showPhoneNumberEditDialog(context),
        'showEditIcon': true,
      },
      {
        'label': 'DELIVERY',
        'content': [
          // Always show "Pick up from store" when no address is selected
          !hasAddress
              ? 'Pick up from store'
              : cubit.selectedShipmentType == ShipmentTypes.standard
                  ? 'Standard Delivery (3-4 days)'
                  : cubit.selectedShipmentType == ShipmentTypes.express
                      ? 'Express Delivery (1-2 day)'
                      : 'Pick up from store',
          'EGP ${cubit.shipmentFee.toStringAsFixed(2)}',
        ],
        // Only allow shipment selection if an address is selected
        'onTap': hasAddress ? () => _showDeliveryOptions(context) : null,
        'disabled': !hasAddress,
      },
      {'label': 'PAYMENT', 'content': 'Cash on delivery'},
    ];

    return Column(
      children: sections.map((section) {
        return GestureDetector(
          onTap: section['onTap'] as void Function()?,
          child: OrderSection(
            label: section['label'] as String,
            content: section['content'],
            isPlaceholder: section['placeholder'] == true,
            showArrow: section['label'] != 'PAYMENT' && section['disabled'] != true,
            disabled: section['disabled'] == true,
            showEditIcon: section['showEditIcon'] == true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItems(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final orderItem = cubit.orderItem;
    if (orderItem == null) return const SizedBox.shrink();

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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            return OrderItemCard(index: index);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    context.read<OrderCubit>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6), width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderSummary(),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              context.read<OrderCubit>().placeOrder();
            },
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Leave Checkout?'),
                content: const Text(
                  'If you leave now, you will lose your reserved items. Do you want to continue?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        );
        if (shouldLeave == true) {
          // Wait for releaseOrder to complete before navigation happens
          await context.read<OrderCubit>().releaseOrder(orderId, userId);
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.chevron_left, size: 24),
                  onPressed: () async {
                    // Use the same confirmation logic as WillPopScope
                    final shouldLeave = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Leave Checkout?'),
                        content: const Text(
                          'If you leave now, you will lose your reserved items. Do you want to continue?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                    if (shouldLeave == true && context.mounted) {
                      await context.read<OrderCubit>().releaseOrder(orderId, userId);
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
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
}
