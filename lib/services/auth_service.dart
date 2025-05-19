// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Mendapatkan user saat ini
  User? get currentUser => _auth.currentUser;
  
  // Stream untuk mendapatkan status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Mendaftarkan user baru
  Future<UserCredential> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Simpan data user di Firestore
      await _createUserInFirestore(userCredential.user!.uid, name, email);
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Membuat data user di Firestore
  Future<void> _createUserInFirestore(String uid, String name, String email) async {
    UserModel user = UserModel(
      uid: uid,
      name: name,
      email: email,
    );
    
    await _firestore.collection('users').doc(uid).set(user.toJson());
  }
  
  // Login dengan email dan password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Opsional: simpan info login di secure storage
      await _storage.write(key: 'uid', value: userCredential.user!.uid);
      
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Logout
  Future<void> signOut() async {
    await _storage.delete(key: 'uid');
    await _auth.signOut();
  }
  
  // Mengambil data user dari Firestore
  Future<UserModel?> getUserData() async {
    try {
      String uid = currentUser?.uid ?? '';
      if (uid.isEmpty) return null;
      
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
  
  // Update user data
  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      String uid = currentUser?.uid ?? '';
      if (uid.isEmpty) return;
      
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }
}