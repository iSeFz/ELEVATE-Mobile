import 'package:flutter/material.dart';
import '/../core/utils/size_config.dart';
import '../auth/data/models/customer.dart';
import '../home/presentation/screens/home_page.dart';
import '../wishlist/presentation/screens/wishlist_page.dart';
import '../cart/presentation/screens/cart_page.dart';
import '../notification/presentation/screens/notifications_page.dart';
import '../profile/presentation/screens/profile_page.dart';

class MainPage extends StatefulWidget {
  final Customer customer;
  const MainPage({super.key, required this.customer});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 4;
  late final PageController _pageController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _pages = [
      HomePage(),
      WishlistPage(userID: widget.customer.id!),
      CartPage(),
      NotificationsPage(),
      ProfilePage(),
    ];
  }

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
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
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
                icon: Center(child: Icon(Icons.person_outline_rounded)),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
