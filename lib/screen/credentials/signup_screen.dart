import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_zameen_app/screen/credentials/login_screen.dart';
import 'package:flutter_zameen_app/models/user_model/user_model.dart';
import 'package:flutter_zameen_app/widgets/account_selection.dart';
import 'package:flutter_zameen_app/widgets/custom_button.dart';
import 'package:flutter_zameen_app/widgets/custom_text_feild.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _phoneNumberC = TextEditingController();
  final TextEditingController _passwordC = TextEditingController();
  final TextEditingController _rePassC = TextEditingController();
  bool _isObscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signUpCredentials() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordC.text != _rePassC.text) {
        Fluttertoast.showToast(msg: "Passwords do not match!");
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailC.text, password: _passwordC.text);

        if (userCredential.user != null) {
          UserModel userModel = UserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            // displayName: _nameC.text,
            displayName: FirebaseAuth.instance.currentUser!.displayName,
            email: _emailC.text,
            // phoneNumber: int.parse(_phoneNumberC.text),
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userModel.uid)
              .set(userModel.toMap());

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return const LogInScreen();
          }));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'Email is already in use. Please sign in.');
        } else {
          Fluttertoast.showToast(msg: 'Error: ${e.message}');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Container(
                          height: size.height * 0.99,
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'WELCOME TO ZAMEEN App\nCreate Your Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircleAvatar(
                                radius: 100,
                                child: Image.asset(
                                  'assets/images/logo.zameen.jpg',
                                ),
                              ),
                              CustomTextField(
                                textEditingController: _nameC,
                                prefixIcon: Icons.person_outline,
                                hintText: 'Enter Name',
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextField(
                                textEditingController: _emailC,
                                prefixIcon: Icons.email_outlined,
                                hintText: 'Enter Email',
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  } else if (!RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                      .hasMatch(v)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextField(
                                textEditingController: _phoneNumberC,
                                prefixIcon: Icons.phone_android,
                                hintText: 'Enter Phone Number',
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  }

                                  // else if (!RegExp(r'^[0-11]+$')
                                  //     .hasMatch(v)) {
                                  //   return 'Enter a valid phone number';
                                  // }
                                  return null;
                                },
                              ),
                              CustomTextField(
                                textEditingController: _passwordC,
                                prefixIcon: Icons.password_outlined,
                                obscureText: _isObscureText,
                                hintText: 'Enter Password',
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  } else if (v.length < 5) {
                                    return 'Invalid Length';
                                  }
                                  return null;
                                },
                                suffixWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscureText = !_isObscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              CustomTextField(
                                textEditingController: _rePassC,
                                prefixIcon: Icons.password_outlined,
                                obscureText: _isObscureText,
                                hintText: 'Re-Enter Password',
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'Field Should Not be Empty';
                                  } else if (v.length < 5) {
                                    return 'Invalid Length';
                                  }
                                  return null;
                                },
                                suffixWidget: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscureText = !_isObscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              CustomButton(
                                title: _isLoading ? 'SIGNING UP...' : 'SIGN UP',
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        _signUpCredentials();
                                      },
                              ),
                              AccountSelection(
                                title: 'Already have an account?',
                                buttonTitle: 'LOGIN',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )),
                    ),
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
