import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fastconnect/presentation/home/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'login_screen.dart';

// Convert to StatefulWidget to handle animations and minimum display duration
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Use SingleTickerProviderStateMixin for AnimationController
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  // Define the minimum time the splash screen should be displayed (2 seconds for admiration)
  static const Duration _minSplashDuration = Duration(milliseconds: 4000); 

  @override
  void initState() {
    super.initState();

    // Setup Animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    // Scale from 0.5x to 1.0x with an elastic curve for a nice "pop" effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Used Curves.elasticOut for a more noticeable scale effect
      ),
    );

    // Start the animation immediately
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get colors from the theme for consistent look
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        // --- LOGIC MODIFIED TO INCLUDE MINIMUM DELAY ---
        // Only navigate if the state is final (Authenticated or Unauthenticated/Failure)
        if (state is AuthAuthenticated || state is AuthUnauthenticated || state is AuthFailure) {
          // Await the minimum splash duration to ensure the logo is properly admired
          await Future.delayed(_minSplashDuration);

          // Original navigation logic (untouched)
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthUnauthenticated || state is AuthFailure) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          // Use background color from the theme for consistency
          backgroundColor: colorScheme.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with Scale Animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    '../../../assets/images/fastconnect_logo.png',
                    width: 250, 
                    height: 250,
                  ),
                ),
                const SizedBox(height: 50),
                // Circular Progress Indicator with Theme primary color
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}