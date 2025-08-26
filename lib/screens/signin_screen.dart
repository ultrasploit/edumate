import 'package:edumate/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SigIinScreenState();
}

class _SigIinScreenState extends State<SignInScreen> {
  // TextField Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String errorMessage = '';
  bool isProcessing = false;
  
  Future signIn() async {
    if (isProcessing == true) {
      return;
    }
    
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        isProcessing = false;
        errorMessage = 'Please enter your email and password!';
      });
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      await authService.value.signIn(email: email, password: password);
      setState(() {
        isProcessing = false;
      });

    } on FirebaseAuthException catch (e) {
      setState(() {
        isProcessing = false;
        errorMessage = e.message ?? 'An uncaught error occurred!';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(padding: EdgeInsetsGeometry.all(20), child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Greeting
          Text(
            'Hello Again!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36
            ),
          ),

          SizedBox(height: 40),
          Text(errorMessage, style: TextStyle(fontSize: 14, color: Colors.red),),
          SizedBox(height: 10,),

          // Email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 10),

          // Password
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 10),

          // Button
          GestureDetector(
            onTap: signIn,
            child: Container(
              decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(child: !isProcessing
                ? Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                )
                : CircularProgressIndicator(color: Colors.white,)
              ),
            ),
          ),

          SizedBox(height: 10),
          
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Not a member?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(width: 10,),

            Text(
              'Register now',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),
            ),
          ]),

          SizedBox(height: 100,)
          
        ],
      ),)),
    );
  }
}