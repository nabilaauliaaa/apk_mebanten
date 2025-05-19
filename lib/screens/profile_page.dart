// lib/profile_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../auth/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? userData = await _authService.getUserData();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Section (Avatar, Name, Username)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: _userData?.photoUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  _userData!.photoUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.person, size: 40, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData?.name ?? 'User',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userData?.email ?? 'user@example.com',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Implement edit functionality
                          // Navigate to edit profile page
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  // Settings List
                  Expanded(
                    child: ListView(
                      children: [
                        _buildListTile('Settings'),
                        _buildListTile('Terms and condition'),
                        _buildListTile('Privacy settings'),
                        _buildListTile('Notifications'),
                        _buildListTile('Help center'),
                        _buildListTile('Feedback'),
                        ListTile(
                          title: const Text('Logout'),
                          trailing: const Icon(Icons.logout, color: Colors.red),
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildListTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle tap on each setting
      },
    );
  }
}