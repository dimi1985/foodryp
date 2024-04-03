import 'package:flutter/material.dart';
import 'package:foodryp/screens/auth_screen/components/reusable_textfield.dart';
import 'package:foodryp/utils/responsive.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxWidth:
                    Responsive.isDesktop(context) ? 500 : screenSize.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or App Name
                Image.asset(
                  'assets/logo.png',
                  height: Responsive.isMobile(context) ? 300 : 400,
                  width: Responsive.isMobile(context) ? 300 : 400,
                ),
                const SizedBox(height: 30.0),

                ReusableTextField(
                    hintText: 'Email', controller: emailController),
                const SizedBox(height: 15.0),
                if(!isLogin)
                ReusableTextField(
                    hintText: 'Username', controller: userNameController),
                const SizedBox(height: 15.0),
                ReusableTextField(
                    hintText: 'Password', controller: passwordController),

                const SizedBox(height: 20.0),

                // Login Button
                SizedBox(
                  width: Responsive.isDesktop(context) ? 500 : screenSize.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle lo gin logic
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                ),
                const SizedBox(height: 15.0),

                // Optional: Forgot Password Link
                TextButton(
                  onPressed: () {
                    // Handle forgot password logic
                  },
                  child: const Text('Forgot Password?'),
                ),

                const SizedBox(height: 75.0),
                // Optional: Forgot Password Link
                Row(
               mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? 'Dont Have an Account?'
                        : 'Already Have an Account?'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(isLogin ? 'Sign Up' : 'Sign In'))
                  ],
                )

                // Optional: Social Login Buttons
                // ... (Implement logic for social login buttons)
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCredetials(String p1) {}
}
