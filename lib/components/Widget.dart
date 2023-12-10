import 'package:database/Auth/Regesterpage.dart';
import 'package:database/components/Users.dart';
import 'package:flutter/material.dart';
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
