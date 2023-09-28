import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widgets/Textfield.dart';
import '../Widgets/images.dart';
import '../Widgets/password_field.dart';
import '../Widgets/welcome_message.dart';
import 'auth.dart';

class Loginpage extends StatefulWidget {
  final Function()? onTap;
  const Loginpage({super.key, required this.onTap});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? errorMessage = '';

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controlleremail.text,
        password: _controllerpassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _submitButton(
    String button,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: signInWithEmailAndPassword,
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
          'Dosen\'t have an acoount?  ',
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
      //backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              images(
                siz: high / 2,
                path: 'images/Mobile login-cuate.svg',
              ),
              const Welcomemessage(
                first: 'Heyy!',
                second: 'Good to see you ',
                third: 'Again',
              ),
              Textf(
                title: 'Enter Your Mail',
                controller: _controlleremail,
              ),
              Textp(
                title: 'Enter Your Password',
                controller: _controllerpassword,
                visible: true,
              ),
              _errorMessage(),
              _submitButton('LOGIN'),
              _regorlog('Register'),
            ],
          ),
        ),
      ),
    );
  }
}
