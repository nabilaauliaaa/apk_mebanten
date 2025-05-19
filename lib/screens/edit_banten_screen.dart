// lib/screens/edit_banten_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/banten_model.dart';
import '../services/banten_service.dart';

class EditBantenScreen extends StatefulWidget {
  final BantenModel banten;
  
  const EditBantenScreen({super.key, required this.banten});

  @override
  State<EditBantenScreen> createState() => _EditBantenScreenState();
}

class _EditBantenScreenState extends State<EditBantenScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bantenNameController;
  late TextEditingController _bantenDescController;
  bool _isLoading = false;
  final BantenService _bantenService = BantenService();
  
  @override
  void initState() {
    super.initState();
    _bantenNameController = TextEditingController(text: widget.banten.name);
    _bantenDescController = TextEditingController(text: widget.banten.description);
  }
  
  @override
  void dispose() {
    _bantenNameController.dispose();
    _bantenDescController.dispose();
    super.dispose();
  }
  
  Future<void> _updateBanten() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _bantenService.updateBanten(
        widget.banten.id!,
        _bantenNameController.text.trim(),
        _bantenDescController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Banten berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Banten'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Detail Banten',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bantenNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Banten',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Banten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bantenDescController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateBanten,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3FAE82),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan Perubahan',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}