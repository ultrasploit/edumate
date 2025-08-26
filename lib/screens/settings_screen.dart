import 'package:edumate/services/auth_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isProcessing = false;
  String _school = '';
  
  // TextField Controllers
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _schoolController = TextEditingController();

  final student = authService.value.currentUser!;

  void _save() {
    final displayName = _displayNameController.text;
    final school = _schoolController.text;
    
    if (displayName != student.displayName) {
      authService.value.currentUser!.updateDisplayName(displayName);

    } if (school != _school) {
      authService.value.setSchool(school: school);
      
    }
  }

  void _setUp() async {
    setState(() {
      isProcessing = true;
    });
    
    try {
      final email = student.email ?? '';
      final name = student.displayName ?? '';
      final school = await authService.value.school ?? '';

      setState(() {
        _displayNameController.text = name;
        _schoolController.text = school;
        _emailController.text = email;
        _school = school;
        isProcessing = false;
      });

    } catch (e) {
      return;
    }

  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _schoolController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.adaptive.arrow_back, color: Colors.white),
        ),
        actions: [IconButton(
          onPressed: _save,
          icon: Icon(Icons.save, color: Colors.white,),
        )],
        title: Text(
          'Profile & Settigs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: isProcessing ? LinearProgressIndicator() : Padding(
          padding: EdgeInsetsGeometry.all(30),
          child: Column(
            children: [
              // Display Name
              TextField(
                controller: _displayNameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  label: Text('Display name')
                ),
              ),

              SizedBox(height: 20,),

              // Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  label: Text('Email')
                ),
              ),

              SizedBox(height: 20,),

              // School
              TextField(
                controller: _schoolController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  label: Text('School')
                ),
              ),

              SizedBox(height: 20,),

              // Grade


            ],
          ),
        ),
      ),
    );
  }
}