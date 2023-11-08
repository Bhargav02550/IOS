import 'package:database/Auth/Regesterpage.dart';
import 'package:database/Auth/Verify.dart';
import 'package:database/Auth/loginorregisterpage.dart';
import 'package:database/Auth/loginpage.dart';
import 'package:database/components/Addimage.dart';
import 'package:database/components/Users.dart';
import 'package:flutter/material.dart';
import 'Home_page.dart';
import '../Auth/auth.dart';

class Widgettree extends StatefulWidget {
  const Widgettree({super.key});

  @override
  State<Widgettree> createState() => _WidgettreeState();
}

class _WidgettreeState extends State<Widgettree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Users();
        } else {
          return const RegisterPage();
        }
      },
    );
  }
}
