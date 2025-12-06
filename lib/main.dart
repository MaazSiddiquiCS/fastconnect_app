import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// 1. Import Firebase Core
import 'package:firebase_core/firebase_core.dart'; 
// 2. Import the generated options file
import 'firebase_options.dart'; 

import 'core/di/service_locator.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/auth/bloc/auth_event.dart';
import 'presentation/auth/screens/splash_screen.dart';
import 'presentation/profile/bloc/profile_bloc.dart'; // <-- New import for ProfileBloc

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 
 // FIX: Initialize Firebase using the generated configuration
 try {
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );
 } catch (e) {
  // Log the error if initialization fails
  debugPrint('Firebase initialization failed: $e');
 }

 await setupLocator();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
  return MultiBlocProvider( // <--- Changed to MultiBlocProvider
      // Note: Ensure ProfileBloc (and other BLoCs) are registered in your servicelocator.dart
     providers: [
        BlocProvider<AuthBloc>(
          // AuthStarted() is correctly dispatched here to check session status
          create: (_) => locator<AuthBloc>()..add(AuthStarted()),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => locator<ProfileBloc>(),
        ),
        // Add other BLoCs like FeedBloc, ConnectionsBloc, etc., here as they are implemented
      ],
   child: const FASTConnectMaterialApp(),
  );
 }
}

class FASTConnectMaterialApp extends StatelessWidget {
 const FASTConnectMaterialApp({super.key});

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   title: 'FASTConnect',
   debugShowCheckedModeBanner: false,
   theme: ThemeData.light(),
   darkTheme: ThemeData.dark(),
   home: const SplashScreen(),
  );
 }
}