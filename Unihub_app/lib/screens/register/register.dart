import 'package:flutter/material.dart';
import 'package:unihub_app/controllers/register_controller.dart';
import 'package:http/http.dart' as http;
import 'package:unihub_app/screens/login/login.dart';

class RegisterScreen extends StatefulWidget {
  Register createState() => Register();
}

class Register extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  bool _isHidden = true;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/images/unihubLogo.png',
                                height: 250, width: 250),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Enter an email';
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return 'Please enter a valid Email';
                                  }
                                  return null;
                                },
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: TextFormField(
                                obscureText: _isHidden,
                                validator: (val) =>
                                    val.isEmpty ? 'Missing password' : null,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  alignLabelWithHint: true,
                                  suffix: InkWell(
                                    onTap: _tooglePasswordView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: TextFormField(
                                obscureText: _isHidden,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Missing password';
                                  }
                                  if (_passwordController.text != (value)) {
                                    return 'Passwords are not equal. Please enter same password';
                                  }
                                  return null;
                                },
                                controller: _password2Controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Repeat password',
                                  alignLabelWithHint: true,
                                  suffix: InkWell(
                                    onTap: _tooglePasswordView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 50,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          child: Text('Sign up',
                                              style: TextStyle(fontSize: 20)),
                                          style: ButtonStyle(
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(250, 40)),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.blue),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              final http.Response response =
                                                  await RegisterController()
                                                      .registerUser(
                                                          _nameController.text,
                                                          _passwordController
                                                              .text);
                                              if (response.statusCode == 200) {
                                                createToast(
                                                    "Account correctly created",
                                                    Colors.green);

                                                Navigator.of(context)
                                                    .pushNamed('/login');
                                              } else if (response.statusCode ==
                                                  201) {
                                                createToast(
                                                    "There exists an account with this email",
                                                    Colors.green);
                                              } else {
                                                createToast(
                                                    response.body, Colors.red);
                                              }
                                            }
                                          }),
                                    ])),
                          ],
                        ))))));
  }

  void _tooglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
