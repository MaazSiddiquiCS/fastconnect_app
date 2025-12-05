import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../../../core/utils/helpers.dart';

class RegisterForm extends StatefulWidget {
  final bool isLoading;
  const RegisterForm({super.key, required this.isLoading});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _submit() {
    Helpers.dismissKeyboard();
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            name: _nameCtl.text.trim(),
            email: _emailCtl.text.trim(),
            password: _passCtl.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Rely on Theme.of(context).colorScheme.primary for consistency
    final primaryColor = Theme.of(context).colorScheme.primary; 

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo / Title (Using Theme Text Styles)
          Text(
            'FASTConnect',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your account', 
            style: Theme.of(context).textTheme.bodyMedium
          ),
          const SizedBox(height: 32),

          // Full Name (Relying on InputDecorationTheme)
          TextFormField(
            controller: _nameCtl,
            textCapitalization: TextCapitalization.words,
            // REMOVED ALL INLINE DECORATION STYLING
            decoration: const InputDecoration(
              labelText: "Full Name",
              prefixIcon: Icon(Icons.person),
            ),
            validator: (v) => v?.trim().isEmpty ?? true ? "Name required" : null,
          ),
          const SizedBox(height: 16),

          // Email (Relying on InputDecorationTheme)
          TextFormField(
            controller: _emailCtl,
            keyboardType: TextInputType.emailAddress,
            // REMOVED ALL INLINE DECORATION STYLING
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "Email required";
              if (!Helpers.isEmailValid(v.trim())) return "Enter a valid email";
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password (Relying on InputDecorationTheme)
          TextFormField(
            controller: _passCtl,
            obscureText: _obscurePassword,
            // REMOVED ALL INLINE DECORATION STYLING
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return "Password required";
              if (v.length < 6) return "Password must be at least 6 characters";
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Submit Button (Relying on ElevatedButtonTheme)
          SizedBox(
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              // REMOVED ALL INLINE BUTTON STYLING
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white, 
                        strokeWidth: 3
                      ),
                    )
                  : const Text("Create Account"),
            ),
          ),

          const SizedBox(height: 16),

          // Login link
          TextButton(
            onPressed: widget.isLoading ? null : () => Navigator.pop(context),
            child: Text(
              "Already have an account? Log in",
              style: TextStyle(color: primaryColor), // Highlight using primary color
            ),
          ),
        ],
      ),
    );
  }
}