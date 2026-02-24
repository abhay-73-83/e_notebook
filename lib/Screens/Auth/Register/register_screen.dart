import 'package:e_notebook/Screens/Auth/Login/Login_Screen.dart';
import 'package:e_notebook/Widgets/Custom_Button/Custom_Button.dart';
import 'package:flutter/material.dart';
import '../../../DBHelper/DBHelper.dart';
import '../../../Widgets/Common_Textfields/common_textfields.dart';
// import '../../Dashboard/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _Formkey = GlobalKey<FormState>();
  final dbHelper = DBHelper.instance;

  TextEditingController uFirstName = TextEditingController();
  TextEditingController uLastName = TextEditingController();
  TextEditingController uEmail = TextEditingController();
  TextEditingController uPass = TextEditingController();
  TextEditingController uConfPass = TextEditingController();

  final RegExp emailRegEx =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _Formkey,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(height: 15),
                Image.asset('assets/logo1.png', height: 100, width: 250),
                SizedBox(height: 20),

                // First Name
                CommonTextField(
                  keyboardType: TextInputType.text,
                  controller: uFirstName,
                  hintText: 'Enter First Name',
                  labelText: 'First Name',
                  preFixIcon: Icon(Icons.person),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please Enter First Name' : null,
                  maxLine: 1,
                ),

                SizedBox(height: 20),

                // Last Name
                CommonTextField(
                  keyboardType: TextInputType.text,
                  controller: uLastName,
                  hintText: 'Enter Last Name',
                  labelText: 'Last Name',
                  preFixIcon: Icon(Icons.person),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please Enter Last Name' : null,
                  maxLine: 1,
                ),

                SizedBox(height: 20),

                // Email
                CommonTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: uEmail,
                  hintText: 'Enter Email Address',
                  labelText: 'Email Address',
                  preFixIcon: Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please Enter Email Address';
                    if (!emailRegEx.hasMatch(value)) return 'Please enter a valid email';
                    return null;
                  },
                  maxLine: 1,
                ),

                SizedBox(height: 20),

                // Password
                CommonTextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: uPass,
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  preFixIcon: Icon(Icons.lock),
                  obscureText: _obscurePassword,
                  sufFixIcon: IconButton(
                    icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please Enter Password';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                  maxLine: 1,
                ),

                SizedBox(height: 20),

                // Confirm Password
                CommonTextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: uConfPass,
                  hintText: 'Enter Confirm Password',
                  labelText: 'Confirm Password',
                  preFixIcon: Icon(Icons.lock),
                  obscureText: _obscureConfirmPassword,
                  sufFixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please Enter Confirm Password';
                    if (value != uPass.text) return 'Passwords do not match';
                    return null;
                  },
                  maxLine: 1,
                ),

                SizedBox(height: 20),

                // Register Button
                CustomButton(
                  buttonText: 'Register',
                  onPressed: () async {
                    if (_Formkey.currentState!.validate()) {
                      await _registerUser();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Please fill all fields correctly')));
                    }
                  },
                ),

                SizedBox(height: 20),

                // Already have an account
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [
                              Colors.blue.shade800,
                              Colors.lightBlue.shade300,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    Map<String, dynamic> row = {
      DBHelper.regFirstName: uFirstName.text.trim(),
      DBHelper.regLastName: uLastName.text.trim(),
      DBHelper.regEmail: uEmail.text.trim(),
      DBHelper.regPass: uPass.text.trim(),
      DBHelper.regConfirmPass: uConfPass.text.trim(),
    };

    print('Registering user...');
    final id = await dbHelper.insertRegisterData(row);
    print('User registered with id: $id');
  }
}
