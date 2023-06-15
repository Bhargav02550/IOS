import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> Username() {
  String? note;
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        note = snapshot.data?.docs[0]['Name'] as String?;
      }
      return Text('$note');
    },
  );
}
