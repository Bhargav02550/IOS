import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late User _user;
  String? userDataUrl;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _user.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = snapshot.docs[0];
      setState(() {
        userDataUrl = userSnapshot.get('url') as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User Data'),
        ),
        body: Center(
          child: userDataUrl != null
              ? Text(
                  'User Data URL: $userDataUrl',
                  style: const TextStyle(fontSize: 18),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
