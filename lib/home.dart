import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Ensure baseUrl and imageUrl are defined here
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
  int _currentIndex = 0; // For bottom navigation

  // List to store recommended items details
  List<dynamic> _recommendedItems = [];
  bool _isLoadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

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

    // Fetch recommendations when screen initializes
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      print('User ID is not available');
      setState(() {
        _isLoadingRecommendations = false;
      });
      return;
    }

    try {
      // Call the recommendations API
      final recUrl = 'https://model.ayeshmadusanka.site/recommendations/$userId';
      final recResponse = await http.get(Uri.parse(recUrl));
      print('Recommendations Response: ${recResponse.body}');

      if (recResponse.statusCode == 200) {
        final recData = json.decode(recResponse.body);
        List<dynamic> recommendations = recData['recommendations'];
        if (recommendations.isNotEmpty) {
          // Build comma-separated string of IDs
          final ids = recommendations.join(',');
          // Call the item details API with the recommended IDs
          final detailsUrl = '$baseUrl/get_item_details.php?ids=$ids';
          final detailsResponse = await http.get(Uri.parse(detailsUrl));
          print('Item Details Response: ${detailsResponse.body}');

          if (detailsResponse.statusCode == 200) {
            List<dynamic> items = json.decode(detailsResponse.body);
            // Replace the relative image path prefix with the baseUrl
            items = items.map((item) {
              String imagePath = item['image_path'];
              // Remove any "../" and prepend baseUrl
              imagePath = imagePath.replaceAll('../', '');
              item['image_path'] = '$imageUrl/$imagePath';
              return item;
            }).toList();
            setState(() {
              _recommendedItems = items;
              _isLoadingRecommendations = false;
            });
          } else {
            print('Failed to load item details');
            setState(() {
              _isLoadingRecommendations = false;
            });
          }
        } else {
          print('No recommendations available');
          setState(() {
            _isLoadingRecommendations = false;
          });
        }
      } else {
        print('Failed to load recommendations');
        setState(() {
          _isLoadingRecommendations = false;
        });
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        _isLoadingRecommendations = false;
      });
    }
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
              _buildAnimatedText(_buildSectionTitle('    Recommendations')),
              const SizedBox(height: 16),
              _buildAnimatedImage(_buildRecommendationsWidget()),
              const SizedBox(height: 16),
              _buildAnimatedText(_buildSectionTitle("   This Week's Highlight")),
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
      child: FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.98,
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
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
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
                ? Colors.orange[800]
                : Colors.orange[300],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

  // Recommendations widget updated for better layout and UX
  Widget _buildRecommendationsWidget() {
    if (_isLoadingRecommendations) {
      return const Center(child: CircularProgressIndicator());
    } else if (_recommendedItems.isEmpty) {
      return const Center(child: Text('No recommendations available'));
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _recommendedItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display the image using the updated image path
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item['image_path']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display the item name with wrapping and a smaller font
                  Container(
                    width: 100,
                    child: Text(
                      item['name'],
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.orange[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OffersPage()),
          );
        } else if (index == 4) {
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
