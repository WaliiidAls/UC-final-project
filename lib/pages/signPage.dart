// sign in/up page

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';

class SignPage extends StatefulWidget {
  final void Function(Map user, bool registered) _handleSignIn;
  SignPage({
    Key? key,
    required void Function(Map user, bool registered) handleSignIn,
  })  : _handleSignIn = handleSignIn,
        super(key: key);
  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  Map _user = {
    "username": "",
    "emailAddress": "",
    "password": "",
  };
  bool _isRegistered = false;

  void _switchForm() {
    setState(() {
      _isRegistered = !_isRegistered;
    });
  }

  void _handleChange(key, value) {
    setState(() {
      _user[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/Logo.svg",
              height: 150,
              width: 150,
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(".welcome to joinquotation",
                        speed: Duration(milliseconds: 150))
                  ],
                  repeatForever: true,
                )),
            Container(
              margin: EdgeInsets.all(30),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isRegistered)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.75)),
                          hintText: ".username",
                          icon: Icon(Icons.person, color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (e) => _handleChange("username", e),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.75)),
                          hintText: ".email",
                          icon: Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Icon(
                              IconData(0x0040),
                              color: Colors.white,
                              size: 23,
                            ),
                          )),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          final msg = "Please enter some text";
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(msg)));
                          return msg;
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (e) => _handleChange("emailAddress", e),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.75)),
                        hintText: ".password",
                        icon: Icon(Icons.lock, color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      obscureText: true,
                      onChanged: (e) => _handleChange("password", e),
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5)),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).indicatorColor)),
                      onPressed: () =>
                          widget._handleSignIn(_user, _isRegistered),
                      child: Text(_isRegistered ? ".log in" : ".sign up",
                          style: TextStyle(fontSize: 18))),
                  GestureDetector(
                    onTap: () => _switchForm(),
                    child: Text(
                      _isRegistered
                          ? ".dont have an account? sign up"
                          : ".already have an account? log in",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
