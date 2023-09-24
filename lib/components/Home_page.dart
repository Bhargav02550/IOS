// Suggestions:
// 1. Add comments to explain the purpose and functionality of each section of code.
// 2. Consider breaking the code into separate functions or files for better organization and maintainability.
// 3. Implement error handling and validation for user input in the text fields.
// 4. Consider using a state management solution like Provider or Riverpod for better code structure and separation of concerns.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth/auth.dart';
import '../Widgets/Add_notes.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

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

  Future<void> notesadd(String tittle, String notes, String id) async {
    await FirebaseFirestore.instance.collection('Notes').add({
      'Notes': notes,
      'id': id,
      'tittle': tittle,
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final double high = MediaQuery.of(context).size.height;
    final double wid = MediaQuery.of(context).size.width;
    final TextEditingController tittle = TextEditingController();
    final TextEditingController notes = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Add_notes(
                high: high,
                wid: wid,
                tittle: tittle,
                notes: notes,
              );
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Hello $userDataUrl'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: signOut,
              child: const Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Notes")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Data Found!"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var note = snapshot.data!.docs[index]['Notes'];

              return Card(
                child: ListTile(
                  title: Text(
                    note,
                  ),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Update Notes'),
                          content: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                enabled: true,
                                maxLines: 5,
                                controller: TextEditingController(text: note),
                                onChanged: (value) {
                                  // Update the note variable with new value
                                  note = value;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  border: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                // Update the note in Firebase
                                await FirebaseFirestore.instance
                                    .collection("Notes")
                                    .doc(snapshot.data!.docs[index].id)
                                    .update({'Notes': note});

                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
