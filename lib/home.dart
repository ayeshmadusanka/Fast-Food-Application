import 'package:flutter/material.dart';
import 'profile.dart';
import 'menu.dart';
import 'offers.dart';
import 'cart.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _fadeAnimation;

  final PageController _pageController = PageController(); // Add PageController
  int _currentPageIndex = 0; // Track the current page index

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..forward();

    // For text (slide in from right)
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // For images (slide in from left)
    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose(); // Dispose PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAnimatedText(_buildSearchBar()),
              const SizedBox(height: 16),
              _buildAnimatedImage(_buildSpecialOffers()),
              const SizedBox(height: 16),
              _buildAnimatedText(_buildCarouselIndicators()),
              const SizedBox(height: 16),
              _buildAnimatedText(_buildSectionTitle('   Special Menu')),
              const SizedBox(height: 16),
              _buildAnimatedImage(_buildMenuRow()),
              const SizedBox(height: 16),
              _buildAnimatedText(
                  _buildSectionTitle("   This Week's Highlight")),
              const SizedBox(height: 16),
              _buildAnimatedImage(_buildHighlightContainer()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Text fade-in from right
  Widget _buildAnimatedText(Widget child) {
    return SlideTransition(
      position: _imageSlideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: child,
      ),
    );
  }

  // Images fade-in from left
  Widget _buildAnimatedImage(Widget child) {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: child,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      // Add 12px padding from the top
      child: FractionallySizedBox(
        alignment: Alignment.center, // Center the search bar
        widthFactor: 0.98, // Reduce the width by 20%
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.orange[100],
            hintText: 'Search Here',
            prefixIcon: Icon(Icons.search, color: Colors.orange.shade900),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 16), // Internal padding
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "  TODAY'S SPECIAL OFFERS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: PageView(
            controller: _pageController, // Attach PageController
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index; // Update current page index
              });
            },
            children: [
              _buildSpecialOfferImage('assets/offer2.jpg'),
              _buildSpecialOfferImage('assets/offer1.jpg'),
              _buildSpecialOfferImage('assets/offer3.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferImage(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCarouselIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.circle,
            size: 8,
            color: index == _currentPageIndex
                ? Colors.orange[800] // Highlight the current page
                : Colors.orange[300], // Lighter color for other pages
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMenuCard('assets/menu1.jpg'),
        _buildMenuCard('assets/menu2.jpg'),
        _buildMenuCard('assets/menu3.jpg'),
      ],
    );
  }

  Widget _buildMenuCard(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHighlightContainer() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/special.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  int _currentIndex = 0; // Track the selected index

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.orange[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      currentIndex: _currentIndex,
      // Highlight the selected tab
      onTap: (index) {
        setState(() {
          _currentIndex = index; // Update the selected index
        });

        // Handle navigation based on the selected index
        if (index == 2) {
          // Navigate to Profile Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        } else if (index == 3) {
          // Navigate to Menu Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuPage()),
          );
        } else if (index == 1) {
          // Navigate to Offers Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OffersPage()),
          );
        } else if (index == 4) {
          // Navigate to Cart Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Offers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
      ],
    );
  }
}