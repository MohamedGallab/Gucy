import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameError = '';
  var passwordError = '';
  var state = "login";
  var password = '';
  var username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png'),
              const Spacer(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                          onChanged: (value) => username = value,
                          decoration: InputDecoration(
                            helperText: usernameError,
                            border: const OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: 250,
                        child: TextField(
                          onChanged: (value) => password = value,
                          obscureText: true,
                          decoration: InputDecoration(
                            helperText: passwordError,
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(state == "login" ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
