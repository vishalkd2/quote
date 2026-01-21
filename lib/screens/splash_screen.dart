import 'package:flutter/material.dart';
import 'package:quote/core/app_route.dart';
import 'package:quote/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    /// Animation controller
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 1400));

    /// Animations
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final payload = await NotificationService().getNotificationPayload();
    if(!mounted) return;
    if(payload=="open_quote"){
      Navigator.pushReplacementNamed(context, '/quoteOfDay');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (!mounted) return;

    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onBoarding');
    } else {
      Navigator.pushReplacementNamed(context, '/quoteScreen');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF5F2C82), // Deep Purple
              Color(0xFF49A09D), // Teal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

            /// App Logo Text in splash
            ScaleTransition(scale: _scaleAnimation,
              child: FadeTransition(opacity: _fadeAnimation,
                child: const Text("QUOTE",style: TextStyle(fontSize: 46,fontWeight: FontWeight.w900,
                    letterSpacing: 4,color: Colors.white,)),
              ),
            ),

            const SizedBox(height: 16),

            /// Second text line in splash
            SlideTransition(position: _slideAnimation,
              child: FadeTransition(opacity: _fadeAnimation,
                child: const Text("Start your day with powerful words",textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15,color: Colors.white70,letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
