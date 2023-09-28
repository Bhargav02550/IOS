import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database/Widgets/password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/Textfield.dart';
import '../Widgets/images.dart';
import '../Widgets/welcome_message.dart';
import 'auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerusername = TextEditingController();
  //User? user = FirebaseAuth.instance.currentUser;
  String? currentUserUID = '';

  Future<void> createUserWithEmailAndPAssword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      usernameadd(
          _controllerusername.text, FirebaseAuth.instance.currentUser!.uid);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future usernameadd(String name, String uid) async {
    await FirebaseFirestore.instance.collection('users').add({
      'Name': name,
      'uid': uid,
    });
  }

  Widget _submitButton(
    String button,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: createUserWithEmailAndPAssword,
        child: Text(button),
      ),
    );
  }

  Widget _regorlog(
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ALready! have an Account?  ',
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            value,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    final double high = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                images(
                  siz: high / 2.8,
                  path: 'images/Mobile login-pana.svg',
                ),
                const Welcomemessage(
                  first: 'Heyy!  ',
                  second: 'Create account ',
                  third: 'now',
                ),
                Textf(
                  title: 'Username',
                  controller: _controllerusername,
                ),
                Textf(
                  title: 'Enter Your Mail',
                  controller: _controllerEmail,
                ),
                Textp(
                  title: 'Enter Your Password',
                  controller: _controllerPassword,
                  visible: true,
                ),
                _errorMessage(),
                _submitButton('REGISTER'),
                _regorlog('Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
