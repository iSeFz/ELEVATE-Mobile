import 'package:flutter/material.dart';
import '../../models/address.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../cubits/customer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageAddressesPage extends StatefulWidget {
  const ManageAddressesPage({super.key});

  @override
  State<ManageAddressesPage> createState() => _ManageAddressesPageState();
}

class _ManageAddressesPageState extends State<ManageAddressesPage> {
  final List<UserAddress> _addresses = [];
  bool _isLoading = true; // Add loading state

  // To keep track of which card is expanded
  String? _expandedAddressId;

  // Controllers for editing - consider moving to a separate stateful widget for the form
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _postalCodeController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>(); // Added FormKey

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    super.dispose();
  }

  Future<void> fetchAddresses() async {
    setState(() {
      _isLoading = true;
    });
    final customerState = context.read<CustomerCubit>().state;
    String? userId;
    if (customerState is CustomerLoggedIn) {
      userId = customerState.customer.id;
    } else if (customerState is CustomerLoaded) {
      userId = customerState.customer.id;
    }
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = "$apiBaseURL/v1/customers/me?userId=$userId";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {testAuthHeader: testAuthValue},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addresses = data['data']['addresses'] as List<dynamic>? ?? [];
        setState(() {
          _addresses.clear();
          for (int i = 0; i < addresses.length; i++) {
            final addr = addresses[i];
            _addresses.add(
              UserAddress(
                id: i.toString(),
                displayedAddress:
                    '${addr['building']} ${addr['street']}, ${addr['city']}',
                city: addr['city'] ?? '',
                street: addr['street'] ?? '',
                building: addr['building'].toString(),
                postalCode: addr['postalCode'].toString(),
                latitude: addr['latitude'].toString(),
                longitude: addr['longitude'].toString(),
                isDefault: i == 0, // Mark first as default
              ),
            );
          }
          _isLoading = false; // Done loading
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching addresses: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load addresses.')));
    }
  }

  void _toggleExpand(String addressId) {
    setState(() {
      if (_expandedAddressId == addressId) {
        _expandedAddressId = null; // Collapse if already expanded
        // Clear controllers when collapsing
        _cityController.clear();
        _streetController.clear();
        _buildingController.clear();
        _postalCodeController.clear();
      } else {
        _expandedAddressId = addressId;
        // Populate controllers when expanding
        final address = _addresses.firstWhere((addr) => addr.id == addressId);
        _cityController.text = address.city;
        _streetController.text = address.street;
        _buildingController.text = address.building;
        _postalCodeController.text = address.postalCode;
      }
    });
  }

  void _saveAddress(String addressId) {
    // Validate and save the form
    if (_addressFormKey.currentState?.validate() ?? false) {
      // _addressFormKey.currentState!.save(); // Not strictly needed as we use controllers

      // TODO: Implement save logic (e.g., update backend, local state)
      setState(() {
        final index = _addresses.indexWhere((addr) => addr.id == addressId);
        if (index != -1) {
          _addresses[index].city = _cityController.text;
          _addresses[index].street = _streetController.text;
          _addresses[index].building = _buildingController.text;
        }
        _expandedAddressId = null; // Collapse after saving
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Address saved!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  void _deleteAddress(String addressId) {
    // TODO: Implement delete logic
    setState(() {
      _addresses.removeWhere((addr) => addr.id == addressId);
      if (_expandedAddressId == addressId) {
        _expandedAddressId = null; // Collapse if the deleted card was expanded
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Address deleted!')));
  }

  void _addNewAddress() {
    // TODO: Implement logic to add a new address, possibly navigate to a new form page or show a dialog
    final newId = (_addresses.length + 1).toString();
    final newAddress = UserAddress(
      id: newId,
      displayedAddress: '',
      city: '',
      street: '',
      building: '',
      postalCode: '',
      latitude: '',
      longitude: '',
    );
    setState(() {
      _addresses.add(newAddress);
      _expandedAddressId = newId; // Expand the new card for editing
      _cityController.clear();
      _streetController.clear();
      _buildingController.clear();
      _postalCodeController.clear();
    });
  }

  void _setDefaultAddress(String addressId) {
    setState(() {
      for (var address in _addresses) {
        address.isDefault = address.id == addressId;
      }
    });
    // TODO: Update backend about the default address change
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Default address updated!')));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses'), centerTitle: true),
      floatingActionButton:
          _addresses
                  .isEmpty // Conditionally display FAB
              ? null
              : FloatingActionButton(
                onPressed: _addNewAddress,
                tooltip: 'Add New Address',
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.add),
              ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _addresses.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: screenWidth * 0.2,
                      color: Colors.grey,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'No addresses found.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Add a new address to get started.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.add_location_alt_outlined,
                        size: screenWidth * 0.07,
                      ),
                      label: Text(
                        'Add New Address',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      onPressed: _addNewAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenHeight * 0.016,
                        ),
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(screenWidth * 0.04),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  final isExpanded = _expandedAddressId == address.id;

                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () => _toggleExpand(address.id),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    (address.city.isEmpty &&
                                            address.street.isEmpty &&
                                            address.building.isEmpty &&
                                            _expandedAddressId == address.id &&
                                            !_addresses.any(
                                              (a) =>
                                                  a.id == address.id &&
                                                  (a.city.isNotEmpty ||
                                                      a.street.isNotEmpty ||
                                                      a.building.isNotEmpty),
                                            ))
                                        ? 'New Address'
                                        : address.displayedAddress,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (address.isDefault)
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(context).primaryColor,
                                    size: screenWidth * 0.06,
                                  ),
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                              ],
                            ),
                            if (isExpanded)
                              Form(
                                // Added Form widget
                                key: _addressFormKey,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.02,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildEditableAddressField(
                                              label: 'City',
                                              controller: _cityController,
                                              screenWidth: screenWidth,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.03),
                                          Expanded(
                                            child: _buildEditableAddressField(
                                              label: 'Postal Code',
                                              controller: _postalCodeController,
                                              screenWidth: screenWidth,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.015),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildEditableAddressField(
                                              label: 'Street',
                                              controller: _streetController,
                                              screenWidth: screenWidth,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.03),
                                          Expanded(
                                            child: _buildEditableAddressField(
                                              label: 'Building',
                                              controller: _buildingController,
                                              screenWidth: screenWidth,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton.icon(
                                            icon: Icon(
                                              address.isDefault
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                              size: screenWidth * 0.065,
                                            ),
                                            label: Text(
                                              'Set as Default',
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                fontSize: screenWidth * 0.04,
                                              ),
                                            ),
                                            onPressed:
                                                address.isDefault
                                                    ? null
                                                    : () => _setDefaultAddress(
                                                      address.id,
                                                    ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                  size: screenWidth * 0.06,
                                                ),
                                                onPressed:
                                                    () => _deleteAddress(
                                                      address.id,
                                                    ),
                                                tooltip: 'Delete Address',
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.02,
                                              ),
                                              ElevatedButton(
                                                child: Text('Save'),
                                                onPressed:
                                                    () => _saveAddress(
                                                      address.id,
                                                    ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                  foregroundColor: Colors.white,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        screenWidth * 0.04,
                                                    vertical:
                                                        screenHeight * 0.01,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildEditableAddressField({
    required String label,
    required TextEditingController controller,
    required double screenWidth,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
      ),
      style: TextStyle(fontSize: screenWidth * 0.04),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      autovalidateMode:
          AutovalidateMode.onUserInteraction, // Validate as user types
    );
  }
}
