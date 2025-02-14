import 'package:flutter/material.dart';
import 'home.dart'; // Replace with actual home screen import if needed
import 'login.dart'; // Replace with actual login screen import if needed
import 'reset password.dart'; // Corrected import name for reset password page

class ForgotPasswordVerificationPage extends StatefulWidget {
  @override
  _ForgotPasswordVerificationPageState createState() => _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState extends State<ForgotPasswordVerificationPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjusts for keyboard
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Full screen size
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login.png"), // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 290), // Space to move "Verify" text down
              // Header with fade and slide animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Header text with fade and slide animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    "Enter One Time Password",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input field with fade and slide animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "One Time Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.orange.shade900),
                        filled: true,
                        fillColor: Colors.orange[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0), // Reduce height
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Verify Button with fade and slide animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to ResetPasswordPage when the button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 132.5), // Added horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                ),
              ),
              const SizedBox(height: 20),
              // Resend OTP text
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    "Didn't receive OTP? Resend",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Already have an account? Login text
              TextButton(
                onPressed: () {
                  // Navigate to Login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
