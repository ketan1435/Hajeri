import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../employee_screens/emp_home_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _adminLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logging in...'), duration: Duration(seconds: 2)),
        );

        // Sign in with Firebase Auth
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Navigate to another screen if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Welcome, ${userCredential.user?.email}'), duration: Duration(seconds: 3)),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } on FirebaseAuthException catch (e) {
        // Handle different error cases
        String message = 'An error occurred';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), duration: Duration(seconds: 2)),
        );
      } catch (e) {
        // Handle general errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred.'), duration: Duration(seconds: 2)),
        );
      }
    }
  }

  void empLogin() async {
    final username = _emailController.text;
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter both username and password');
      return;
    }
    final snapshot = await FirebaseFirestore.instance.collection('user').get();
    final users = snapshot.docs;
    for (var user in users) {
      final data = user.data() as Map<String, dynamic>;
      if (data['username'] == username && data['password'] == password) {
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // await preferences.setBool('isLogin', true);
        // Get.to(EmpHomeScreen());
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmpHomeScreen(),));
        return;
      }
    }
    Get.snackbar('Error', 'Invalid username or password');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w), // Use responsive padding
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 2.h), // Add spacing
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _adminLogin,
                          child: Text('Admin Login'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Full width
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            empLogin();
                          },
                          child: Text('Employee Login'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50), // Full width
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  TextButton(
                    onPressed: () {
                      // Navigate to sign-up page or perform another action
                    },
                    child: Text('Don\'t have an account? Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
