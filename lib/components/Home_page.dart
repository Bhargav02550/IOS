import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database/Auth/get_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Auth/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? userDataUrl;

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = snapshot.docs[0];
      setState(() {
        userDataUrl = userSnapshot.get('Name') as String?;
      });
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  // Widget _userUid() {
  //   return Text(user?.email ?? 'User email');
  // }

  Widget _signOutButton() {
    return GestureDetector(
      onTap: signOut,
      child: const Icon(Icons.logout_outlined),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Hello $userDataUrl')],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: signOut, child: const Icon(Icons.logout_outlined)),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.amber.shade400),
                height: 50,
                width: double.infinity,
                child: Text('$userDataUrl'),
              ),
            ),
          ],
        ));
  }
}
