// lib/services/banten_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banten_model.dart';
import 'auth_service.dart';

class BantenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  
  // Collection reference
  CollectionReference get _bantensCollection => _firestore.collection('bantens');
  
  // Mendapatkan daftar banten milik pengguna tertentu
  Stream<List<BantenModel>> getUserBantens() {
    String? uid = _authService.currentUser?.uid;
    
    return _bantensCollection
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BantenModel.fromJson(
              doc.id, 
              doc.data() as Map<String, dynamic>
            );
          }).toList();
        });
  }
  
  // Mendapatkan semua daftar banten
  Stream<List<BantenModel>> getAllBantens() {
    return _bantensCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BantenModel.fromJson(
              doc.id, 
              doc.data() as Map<String, dynamic>
            );
          }).toList();
        });
  }
  
  // Menambahkan banten baru
  Future<DocumentReference> addBanten(String name, String description) async {
    String? uid = _authService.currentUser?.uid;
    
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    
    BantenModel banten = BantenModel(
      name: name,
      description: description,
      userId: uid,
      createdAt: DateTime.now(),
    );
    
    return _bantensCollection.add(banten.toJson());
  }
  
  // Mengupdate banten
  Future<void> updateBanten(String id, String name, String description) async {
    String? uid = _authService.currentUser?.uid;
    
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    
    // Pastikan banten ini milik pengguna yang sedang login
    DocumentSnapshot doc = await _bantensCollection.doc(id).get();
    
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      if (data['userId'] != uid) {
        throw Exception('Not authorized to update this banten');
      }
      
      return _bantensCollection.doc(id).update({
        'name': name,
        'description': description,
      });
    } else {
      throw Exception('Banten not found');
    }
  }
  
  // Menghapus banten
  Future<void> deleteBanten(String id) async {
    String? uid = _authService.currentUser?.uid;
    
    if (uid == null) {
      throw Exception('User not authenticated');
    }
    
    // Pastikan banten ini milik pengguna yang sedang login
    DocumentSnapshot doc = await _bantensCollection.doc(id).get();
    
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      
      if (data['userId'] != uid) {
        throw Exception('Not authorized to delete this banten');
      }
      
      return _bantensCollection.doc(id).delete();
    } else {
      throw Exception('Banten not found');
    }
  }
  
  // Mendapatkan banten berdasarkan ID
  Future<BantenModel> getBantenById(String id) async {
    DocumentSnapshot doc = await _bantensCollection.doc(id).get();
    
    if (doc.exists) {
      return BantenModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Banten not found');
    }
  }
}