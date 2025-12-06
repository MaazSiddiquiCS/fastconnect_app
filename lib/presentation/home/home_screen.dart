import 'package:fastconnect/presentation/profile/screens/profile_screen.dart';
import '../../presentation/reels/screens/reel_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../feed/bloc/feed_bloc.dart';
import '../feed/screens/feed_screen.dart';
import 'wigdets/logout_button.dart'; // Import the new widget
import '../../core/di/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    BlocProvider<FeedBloc>(
      create: (_) => locator<FeedBloc>(),
      child: const FeedScreen(),
    ),
    const Center(child: Text("Societies Screen Placeholder")),
    const ReelsScreen(),
    const Center(child: Text("Notifications Screen Placeholder")),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get colors from the theme for consistent look
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
                    '../../../assets/images/fastconnect_logo.png',
                    width: 90, 
                    height: 90,
                  ),
        centerTitle: true,
        // Using theme colors for a distinct AppBar color (optional, but consistent)
        backgroundColor: Colors.indigo, 
        foregroundColor: colorScheme.onPrimary,
        
        actions: const [
          LogoutButton(),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Societies"),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: "Reels"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}