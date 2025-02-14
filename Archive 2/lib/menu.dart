import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  // List to track the selected state of the cards
  List<bool> isSelected = [false, false, false, false];

  // Animation controller and animations for fade-in and slide-up effects
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Duration of the animation
      vsync: this,
    );

    // Slide animation for sliding up
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start position below the screen
      end: Offset.zero, // End position at the normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Fade animation for fading in
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation when the page is loaded
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Set AppBar background color to white
          iconTheme: IconThemeData(color: Colors.orange.shade900), // Icon color
          title: Text(
            "Menu",
            style: TextStyle(color: Colors.orange.shade900), // Title text color
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.orange.shade900, // Tab indicator color
            labelColor: Colors.orange.shade900, // Selected tab text color
            unselectedLabelColor: Colors.orange.shade900.withOpacity(0.6), // Unselected tab text color
            tabs: const [
              Tab(text: "Appetizers"),
              Tab(text: "Mains"),
              Tab(text: "Desserts"),
            ],
          ),
        ),
        body: FadeTransition(
          opacity: _fadeAnimation, // Apply fade animation
          child: SlideTransition(
            position: _slideAnimation, // Apply slide animation
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final menuItems = [
                          'Zinger Burger',
                          'Loaded Cheese Burger',
                          'Tandoori Burger',
                          'Nashville Burger'
                        ];
                        final descriptions = [
                          'Signature Chicken, Cheese',
                          'Spicy Chicken, Cheese Sauce',
                          'Tandoori Chicken, Secret Sauce',
                          'Spicy Chicken, Nashville Sauce'
                        ];
                        final prices = ['\$5.99', '\$6.99', '\$7.99', '\$8.99'];
                        final images = [
                          'assets/zinger.jpg',
                          'assets/loadedcheese.jpg',
                          'assets/tandoori.jpg',
                          'assets/nashville.jpg'
                        ]; // Image asset paths

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // Toggle the selected state of the clicked card
                              isSelected[index] = !isSelected[index];
                            });
                          },
                          child: Card(
                            elevation: 0, // Removed the shadow by setting elevation to 0
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover, // Make the image fill the card
                                    width: double.infinity, // Ensure the image spans full width
                                    height: double.infinity, // Ensure the image spans full height
                                  ),
                                ),
                                if (isSelected[index]) // Show orange shade when selected
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            menuItems[index],
                                            style: const TextStyle(
                                              fontSize: 14, // Reduced font size
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            descriptions[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            prices[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Handle the 'Add to Cart' action
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange.shade900,
                                            ),
                                            child: const Text(
                                              'Add to Cart',
                                              style: TextStyle(color: Colors.white), // White text
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
