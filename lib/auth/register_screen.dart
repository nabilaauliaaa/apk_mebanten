// lib/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_screen.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Validasi form
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all required fields.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters.';
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _errorMessage = 'You must agree to the Terms and Conditions.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.registerWithEmailAndPassword(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Navigate to home if registration successful
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      
      switch (e.code) {
        case 'email-already-in-use':
          message = 'The email address is already in use.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sesuaikan dengan kode register_screen.dart yang sudah Anda miliki
    // Di sini hanya mengganti onPressed pada tombol untuk memanggil fungsi _register
    
    return Scaffold(
      // ...kode lainnya (pertahankan UI asli)
    );
  }
}