import 'package:database/Auth/loginpage.dart';
import 'package:database/Auth/Regesterpage.dart';
import 'package:database/Auth/otpauth.dart';
import 'package:flutter/material.dart';

class LoginOrRigester extends StatefulWidget {
  const LoginOrRigester({super.key});

  @override
  State<LoginOrRigester> createState() => _LoginOrRigesterState();
}

class _LoginOrRigesterState extends State<LoginOrRigester> {
  bool showLoginpage = true;

  void toogle() {
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginpage) {
      return Loginpage();
    } else {
      return RegisterPage();
    }
  }
}
