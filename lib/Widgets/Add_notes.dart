import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class Add_notes extends StatelessWidget {
  const Add_notes({
    super.key,
    required this.high,
    required this.wid,
    required this.tittle,
    required this.notes,
  });

  final double high;
  final double wid;
  final TextEditingController tittle;
  final TextEditingController notes;

  // Function to get the present time

  String getPresentTime() {
    var now = DateTime.now();
    var formatter = DateFormat('hh:mm a');
    return formatter.format(now);
  }

  // Function to get the present date month year
  String getPresentDateMonthYear() {
    var now = DateTime.now();
    var formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(now);
  }

  Future<void> notesadd(String tittle, String notes, String id) async {
    await FirebaseFirestore.instance.collection('notes').add({
      'notes': notes,
      'id': id,
      'tittle': tittle.isEmpty ? 'Untitled' : tittle,
      'cime': getPresentTime(),
      'Date': getPresentDateMonthYear(),
      'utime': getPresentTime(),
      'udate': getPresentDateMonthYear(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
          ),
          height: high * 0.7,
          width: wid * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Add New Notes',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Tittle',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: tittle,
                        decoration: const InputDecoration(
                          hintText: 'Enter the Tittle',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Notes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        textInputAction: TextInputAction.newline,
                        controller: notes,
                        onChanged: (value) {},
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Enter your Notes',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => {
                          Navigator.of(context).pop(),
                          notesadd(tittle.text, notes.text,
                              FirebaseAuth.instance.currentUser!.uid)
                        },
                        child: const Text(
                          'Add Notes',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
