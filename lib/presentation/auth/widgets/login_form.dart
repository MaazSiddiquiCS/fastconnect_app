import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/helpers.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../screens/register_screen.dart'; 

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _submit() {
    Helpers.dismissKeyboard();

    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtl.text.trim();
    final password = _passCtl.text;

    context.read<AuthBloc>().add(
      AuthLoginRequested(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rely on Theme.of(context).colorScheme.primary for consistency
    final primaryColor = Theme.of(context).colorScheme.primary; 

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Use Theme Text Styles for Title
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to your FASTConnect account',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 32),

              // Email Field (Relying on InputDecorationTheme)
              TextFormField(
                controller: _emailCtl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                // REMOVED ALL INLINE DECORATION STYLING
                decoration: const InputDecoration(
                  labelText: 'FAST Email',
                  hintText: 'example@fast.edu.pk',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!Helpers.isEmailValid(value)) {
                    return 'Enter a valid email';
                  }
                  if (!value.toLowerCase().contains('fast.edu')) {
                    return 'Use your FAST University email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password Field (Relying on InputDecorationTheme)
              TextFormField(
                controller: _passCtl,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                // REMOVED ALL INLINE DECORATION STYLING
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) { // Use 6 for consistency with Firebase
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Login Button (Relying on ElevatedButtonTheme)
              SizedBox(
                // Removed redundant width and height, now handled by ElevatedButtonTheme minimumSize
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  // REMOVED ALL INLINE BUTTON STYLING
                  // The theme handles shape, size, and text style
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            // Use inverse primary color (usually white/black)
                            valueColor: AlwaysStoppedAnimation(Colors.white), 
                          ),
                        )
                      : const Text('Login'), // Text style is handled by the Theme
                ),
              ),

              const SizedBox(height: 12),

              // Register Hint
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        ),
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium, // Use text theme
                    children: [
                      const TextSpan(text: "New to FASTConnect? "),
                      TextSpan(
                        text: "Create Account",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: primaryColor), // Highlight using primary color
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}