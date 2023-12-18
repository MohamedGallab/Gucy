import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gucy/providers/user_provider.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String usernameError = '';
  String passwordError = '';
  String confirmPasswordError = '';
  String state = "login";
  String password = '';
  String username = '';
  String confirmPassword = '';
  bool isAnimating = true;
  bool isSendingData = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  late AnimationController _animationController;
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handleAnimationCompleted();
      }
    });

    _animationController.forward();
  }

  void _handleAnimationCompleted() {
    if (mounted) {
      setState(() {
        isAnimating = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void moveToNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    void onLoginSignUpClick() async {
      setState(() {
        if (username == '') {
          usernameError = 'Username is required';
        } else {
          usernameError = '';
        }
        if (password == '') {
          passwordError = 'Password is required';
        } else {
          passwordError = '';
        }
        if (confirmPassword == '') {
          confirmPasswordError = 'Confirm Password is required';
        } else {
          confirmPasswordError = '';
        }
      });
      if (state == "login" && (username == '' || password == '')) {
        return;
      } else if (state == "signup" &&
          (username == '' || password == '' || confirmPassword == '')) {
        return;
      }
      RegExp emailRegex = RegExp(
        r'^[a-zA-Z]+[.][a-zA-Z]+@(student\.)?(admin\.)?guc\.edu\.eg$',
      );
      if (password != confirmPassword && state == "signup") {
        confirmPasswordError = 'Passwords do not match!';
      } else if (!emailRegex.hasMatch(username)) {
        usernameError = 'Invalid Email!';
      } else if (state == "login") //add and condition for db returning false
      {
        isSendingData = true;
        String code = await userProvider.loginUser(username, password);
        isSendingData = false;
        if (code == 'invalid-credential') {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Invalid Credentials!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (code == "too-many-requests") {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Too many requests. Try again later!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (code != "success") {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Unknown Error!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else if (state == "signup") {
        isSendingData = true;
        String code = await userProvider.registerUser(username, password);
        isSendingData = false;
        if (code == 'weak-password') {
          passwordError = 'Password is too weak!';
        } else if (code == 'email-already-in-use') {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('User already exists!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (code != "success") {
          await showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Unknown Error!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1100));
      _handleAnimationCompleted();
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  double currentSize =
                      lerpDouble(0.5, 1, _animationController.value)!;
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, isAnimating ? 0 : 0),
                      end: Offset(0, isAnimating ? -1.695 : 0),
                    ).animate(CurvedAnimation(
                      curve: Curves.easeInOut,
                      parent: _animationController,
                    )),
                    child: Transform.scale(
                      scale: currentSize,
                      child: child,
                    ),
                  );
                },
                child: Opacity(
                  opacity: 1, // Fade effect based on animation value
                  child: Image.asset('assets/icon/icon.png', height: 250),
                ),
              ),
              if (!isAnimating)
                AnimatedOpacity(
                  opacity: _animationController.value,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: SizedBox(
                          width: 250,
                          child: TextField(
                            focusNode: _usernameFocusNode,
                            controller: usernameController,
                            onChanged: (value) => username = value,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              moveToNextField(
                                  _usernameFocusNode, _passwordFocusNode);
                            },
                            decoration: InputDecoration(
                              errorText:
                                  usernameError != "" ? usernameError : null,
                              border: const OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: SizedBox(
                          width: 250,
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            textInputAction:
                                state == "signup" ? TextInputAction.next : null,
                            obscureText: true,
                            focusNode: _passwordFocusNode,
                            controller: passwordController,
                            onEditingComplete: () async {
                              if (state == "signup") {
                                moveToNextField(_passwordFocusNode,
                                    _confirmPasswordFocusNode);
                              } else {
                                FocusScope.of(context).unfocus();
                                onLoginSignUpClick();
                              }
                            },
                            decoration: InputDecoration(
                              errorText:
                                  passwordError != "" ? passwordError : null,
                              border: const OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (state == 'signup')
                        Container(
                          margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                          child: SizedBox(
                            width: 250,
                            child: TextField(
                              focusNode: _confirmPasswordFocusNode,
                              onEditingComplete: () async {
                                FocusScope.of(context).unfocus();
                                onLoginSignUpClick();
                              },
                              controller: confirmPasswordController,
                              onChanged: (value) => confirmPassword = value,
                              obscureText: true,
                              decoration: InputDecoration(
                                errorText: confirmPasswordError != ""
                                    ? confirmPasswordError
                                    : null,
                                border: const OutlineInputBorder(),
                                labelText: 'Confirm Password',
                              ),
                            ),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(50, 00, 50, 15),
                        child: isSendingData
                            ? const CircularProgressIndicator()
                            : FilledButton(
                                onPressed: onLoginSignUpClick,
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      state == "login" ? 'Login' : 'Sign Up',
                                    )),
                              ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              if (state == "login") {
                                state = "signup";
                              } else {
                                state = "login";
                              }
                              username = '';
                              password = '';
                              confirmPassword = '';
                              passwordError = '';
                              usernameError = '';
                              confirmPasswordError = '';
                              usernameController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();
                            });
                          },
                          child: Text(
                            state == "login"
                                ? 'Sign Up instead'
                                : 'Login instead',
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
