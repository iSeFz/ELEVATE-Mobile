import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/customer_cubit.dart';
import '../models/customer.dart';
import 'profile_page.dart';
import 'manage_addresses_page.dart';

// Converted to StatefulWidget
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  // Initialize with empty strings, will be populated from Cubit
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phone = '';

  bool _dataInitialized = false; // Flag to initialize data only once

  // TODO: Add a variable to store the profile image, e.g., File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Attempt to initialize from current cubit state
    final customerState = context.read<CustomerCubit>().state;
    if (customerState is CustomerLoaded) {
      _initializeData(customerState.customer);
    } else if (customerState is CustomerLoggedIn) {
      _initializeData(customerState.customer);
    }
    // If not loaded yet, BlocListener will handle it
  }

  void _initializeData(Customer customer) {
    // Check _dataInitialized within setState to ensure it's set after first successful data load
    if (mounted) {
      // Ensure widget is mounted before calling setState
      setState(() {
        if (!_dataInitialized) {
          // Initialize only once
          final emailString = customer.email ?? '';
          if (emailString.isNotEmpty) {
            final atIndex = emailString.indexOf('@');
            if (atIndex != -1) {
              _username = emailString.substring(0, atIndex);
            } else {
              _username =
                  emailString; // Or handle as an invalid email case if preferred
            }
          } else {
            _username = ''; // Default if email is empty
          }
          _firstName = customer.firstName ?? '';
          _lastName = customer.lastName ?? '';
          _email = customer.email ?? '';
          _phone = customer.phoneNumber ?? '';
          _dataInitialized = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<CustomerCubit, CustomerState>(
      listener: (context, state) {
        // Listen for state changes to initialize data if not already done
        if (!_dataInitialized) {
          if (state is CustomerLoaded) {
            _initializeData(state.customer);
          } else if (state is CustomerLoggedIn) {
            _initializeData(state.customer);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: const Text(
            'Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.of(context).pop(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          const ProfilePage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07,
            vertical: screenHeight * 0.01,
          ),
          child: SingleChildScrollView(
            // Consider showing a loading indicator if !_dataInitialized and cubit state is loading
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.2,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          size: screenWidth * 0.2,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            onPressed: () {
                              // TODO: Implement profile image picking logic
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildEditableTextField(
                    context,
                    label: 'Username',
                    initialValue: _username, // Uses state variable
                    editable: false, // Username is typically not editable here
                    screenWidth: screenWidth,
                    onSaved: (value) {
                      // Username not saved from this form typically
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEditableTextField(
                          context,
                          label: 'First Name',
                          initialValue: _firstName, // Uses state variable
                          screenWidth: screenWidth,
                          onSaved:
                              (value) => setState(
                                () => _firstName = value ?? _firstName,
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: _buildEditableTextField(
                          context,
                          label: 'Last Name',
                          initialValue: _lastName, // Uses state variable
                          screenWidth: screenWidth,
                          onSaved:
                              (value) => setState(
                                () => _lastName = value ?? _lastName,
                              ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildEditableTextField(
                    context,
                    label: 'Email',
                    initialValue: _email, // Uses state variable
                    screenWidth: screenWidth,
                    onSaved:
                        (value) => setState(() => _email = value ?? _email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  _buildEditableTextField(
                    context,
                    label: 'Phone',
                    initialValue: _phone, // Uses state variable
                    screenWidth: screenWidth,
                    onSaved:
                        (value) => setState(() => _phone = value ?? _phone),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.007,
                    ),
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: screenWidth * 0.07,
                    ),
                    title: Text(
                      'Manage Addresses',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: screenWidth * 0.05,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageAddressesPage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // TODO: Implement save changes logic (e.g., call cubit to update user)
                          // For now, just print the values
                          print('Saving changes:');
                          print('Username: $_username');
                          print('First Name: $_firstName');
                          print('Last Name: $_lastName');
                          print('Email: $_email');
                          print('Phone: $_phone');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Changes saved (locally for now)'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTextField(
    BuildContext context, {
    required String label,
    required String initialValue,
    bool editable = true,
    required double screenWidth,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: TextFormField(
        initialValue: initialValue,
        enabled: editable,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
        style: TextStyle(
          color: editable ? Colors.black : Colors.grey.shade600,
          fontSize: 16,
        ),
        onSaved: onSaved,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
