import 'package:elevate/features/home/presentation/screens/home_page.dart';
import 'package:elevate/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import '../notification/presentation/screens/notifications_page.dart';
import '../profile/presentation/screens/profile_page.dart';
import '../favorites/presentation/screens/favorites_page.dart';
import '../cart/presentation/screens/cart_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4;
  final PageController _pageController = PageController(initialPage: 4);

  final List<Widget> _pages = [
    HomePage(),
    FavoritesPage(),
    CartPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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
        padding: EdgeInsets.only(bottom: 5 * SizeConfig.verticalBlock),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, -4), // 👈 ABOVE shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0, // ✅ Remove default shadow
            iconSize: 30 * SizeConfig.verticalBlock,
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(
                    _selectedIndex == 0
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(
                    _selectedIndex == 1
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(
                    _selectedIndex == 2
                        ? Icons.shopping_bag_rounded
                        : Icons.shopping_bag_outlined,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(
                    _selectedIndex == 3
                        ? Icons.notifications_rounded
                        : Icons.notifications_none_rounded,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(Icons.person_outline_rounded),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
