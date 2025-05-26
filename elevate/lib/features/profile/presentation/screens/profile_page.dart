import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubits/customer_cubit.dart';
import 'edit_profile_page.dart';
import '../../../../core/utils/google_utils.dart';
import 'change_password_page.dart';
import '../../../auth/presentation/screens/login_page.dart';

// Profile Page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Get theme data

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: Colors.white,                // add shadow below
        shadowColor: Colors.black.withOpacity(0.25), // subtle black shadow
        title: Text(
          'Profile',
          style: TextStyle(
            color: theme.colorScheme.secondary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.07,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: screenWidth * 0.2,
                backgroundColor:
                    theme.colorScheme.tertiary, // Theme color
                child: Icon(
                  Icons.person,
                  size: screenWidth * 0.2,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoaded) {
                    // Combine firstName and lastName for fullName
                    final fullName =
                        '${state.customer.firstName ?? ''} ${state.customer.lastName ?? ''}';
                    return Text(
                      fullName.trim().isNotEmpty
                          ? fullName.trim()
                          : 'User Name', // Display full name or a default
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    );
                  } else if (state is CustomerLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is CustomerError) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return Text(
                    'John Doe', // Default text if no state matches or in initial state
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.015),
              // Container for Loyalty Points
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      // spreadRadius: 1,
                      // blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 24, color: Color(0xFFFFD700)),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      '1250 Points', // TODO: Replace with actual loyalty points
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Removed Expanded, Container will size to its children (ListView with shrinkWrap: true)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Theme color for card background
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  children: <Widget>[
                    _buildProfileOption(
                      context,
                      icon: Icons.edit_outlined,
                      text: 'Edit Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.lock_outline_rounded,
                      text: 'Change Password', // Changed from Add Pin
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon:
                          Icons
                              .history_outlined, // Changed icon for Order History
                      text: 'Order History', // Changed from Invite a friend
                      onTap: () {
                        // TODO: Implement Order History navigation/action
                      },
                    ),
                    _buildProfileOption(
                      context,
                      icon: Icons.settings_outlined,
                      text: 'Settings',
                      onTap: () {
                        // TODO: Implement Settings navigation/action
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ), // Spacing before logout button
              // Logout Button
              SizedBox(
                width:double.infinity, // Make button take full width available in padding
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: screenWidth * 0.06,
                  ),
                  label: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    signOutGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const LoginPage(), // TODO: Replace with actual login page
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Get theme data

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary, // Simplified color logic
        size: screenWidth * 0.07,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyLarge?.color, // Simplified color logic
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: screenWidth * 0.05,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.005,
      ),
    );
  }
}
