import 'package:e_notebook/SharedPreference/SharePref.dart';
import 'package:e_notebook/Screens/Auth/Register/register_screen.dart';
import 'package:e_notebook/Screens/Dashboard/home.dart';
import 'package:e_notebook/DBHelper/DBHelper.dart';
import 'package:e_notebook/Widgets/Custom_Button/Custom_Button.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/Common_Textfields/common_textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController uEmail = TextEditingController();
  final TextEditingController uPass = TextEditingController();

  final dbHelper = DBHelper.instance;

  final RegExp emailRegEx =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _obscurePassword = true;

  Future<void> loginUser() async {
    final email = uEmail.text.trim();
    final password = uPass.text.trim();

    // Check if user exists
    bool userExists = await dbHelper.checkUserExists(email);

    if (!userExists) {
      // User not registered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not registered, please register first')),
      );
      return;
    }

    // Validate password
    bool isValid = await dbHelper.validateUser(email, password);

    if (isValid) {
      // Save login status
      await SharedPref.saveLoginStatus(true);
      await SharedPref.saveUserEmail(email); // Save email for future reference

      // Login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    } else {
      // Invalid password
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Incorrect password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:  EdgeInsets.all(18.0),
            child: Column(
              children: [
                 SizedBox(height: 10),
                Image.asset('assets/logo1.png', height: 150),
                 SizedBox(height: 50),

                // Email Field
                CommonTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: uEmail,
                  hintText: 'Enter Email Address',
                  labelText: 'Email Address',
                  preFixIcon:  Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!emailRegEx.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  maxLine: 1,
                ),
                 SizedBox(height: 20),

                // Password Field with toggle icon
                CommonTextField(
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  controller: uPass,
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  preFixIcon:  Icon(Icons.lock),
                  sufFixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  maxLine: 1,
                ),
                 SizedBox(height: 20),

                // Login Button
                CustomButton(
                  buttonText: 'Login',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginUser();
                    }
                  },
                ),
                 SizedBox(height: 20),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  RegisterScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [
                                  Color(0xffF9D5E5),
                                  Color(0xffB8A9D9),
                                ],
                              ).createShader( Rect.fromLTWH(0, 0, 200, 70)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
