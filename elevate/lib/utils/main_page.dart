import 'package:elevate/screens/home_page.dart';
import 'package:elevate/utils/Size_Config.dart';
import 'package:flutter/material.dart';
import '/screens/notifications_page.dart';
import '/screens/user_profile/profile_page.dart';
import '/screens/favorites_page.dart';
import '/screens/cart_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4;
  final PageController _pageController = PageController(initialPage: 4);

  final List<Widget> _pages = [
    HomePage(), // Placeholder for Home Page
    FavoritesPage(),
    CartPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Changed from animateToPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        // Added Padding widget
        padding:  EdgeInsets.only(bottom: 5*SizeConfig.verticalBlock), // Added bottom padding
        child: Theme(
        data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0, // removes top border/shadow
        backgroundColor: Colors.white, // optional
        ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 30*SizeConfig.verticalBlock,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
              ),
              label: 'Home',
              tooltip: 'Home',

            ),
            label: '',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
            ),
            label: '',
            tooltip: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.shopping_bag_rounded
                  : Icons.shopping_bag_outlined,
            ),
            label: '',
            tooltip: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.notifications_rounded
                  : Icons.notifications_none_rounded,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '',
              tooltip: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
      ),)

    );
  }
}
