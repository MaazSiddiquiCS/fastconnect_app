import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../../../core/utils/helpers.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FASTConnect — Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            Helpers.showSnack(context, state.message);
          }
          if (state is AuthAuthenticated) {
            // Use Theme-defined colors for better consistency
            Helpers.showSnack(context, 'Welcome back, ${state.user.fullName}!');
            
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            // Use dynamic padding that shrinks on small screens if necessary
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            // The Card now relies on the AppTheme for elevation and shape
            child: Card(
              // REMOVED: elevation, which is now defined in CardTheme
              child: Padding(
                // Consistent padding for all form cards
                padding: const EdgeInsets.all(28),
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}