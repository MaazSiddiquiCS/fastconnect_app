import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../../../core/utils/helpers.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            Helpers.showSnack(context, 'Account created successfully! Please log in.');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              // The Card now relies on the AppTheme for elevation and shape
              child: Card(
                // REMOVED: elevation, shape: RoundedRectangleBorder
                child: Padding(
                  // Consistent padding for all form cards
                  padding: const EdgeInsets.all(28),
                  child: RegisterForm(isLoading: isLoading),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}