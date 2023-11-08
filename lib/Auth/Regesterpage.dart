import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database/Auth/Verify.dart';
import 'package:database/Auth/otpauth.dart';
import 'package:database/Widgets/password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Widgets/Textfield.dart';
import '../Widgets/images.dart';
import '../Widgets/welcome_message.dart';
import 'auth.dart';

class RegisterPage extends StatefulWidget {
  static String verify = '';
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController countryController = TextEditingController();
  var phone = "";
  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

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
      postData();
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
      'name': name,
      'uid': uid,
    });
  }

  Future<void> postData() async {
    final msg = jsonEncode({
      'name': _controllerusername.text,
      'number': _controllerEmail.text,
    });
    // ignore: unused_local_variable
    final response = await http.post(
      Uri.parse('https://729d-103-10-133-46.ngrok-free.app/api/call/shop/add'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: msg,
    );
  }

  // ignore: unused_element
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

  // ignore: unused_element
  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    final double high = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              images(
                path: 'images/farm.svg',
                siz: high / 2,
              ),
              const SizedBox(
                height: 25,
              ),
              const Welcomemessage(
                first: 'Heyy!',
                second: 'Create Account ',
                third: 'now',
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerusername,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: "Enter your Nickname",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        enabled: false,
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your Mobile Number",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countryController.text + phone,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          RegisterPage.verify = verificationId;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyVerify(
                                name: _controllerusername.text,
                              ),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: const Text("Verify Mobile Number")),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
