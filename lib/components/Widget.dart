import 'package:database/Auth/loginorregisterpage.dart';
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
          return Homepage();
        } else {
          return LoginOrRigester();
        }
      },
    );
  }
}
