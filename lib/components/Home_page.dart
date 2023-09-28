import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Auth/auth.dart';
import '../Widgets/Add_notes.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? userDataUrl;
  String? times;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = snapshot.docs.first;
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        // Check if 'Name' field exists
        if (userData != null && userData.containsKey('Name')) {
          final name = userData['Name'] as String?;
          setState(() {
            userDataUrl = name;
          });
        } else {
          setState(() {
            userDataUrl = "Name not found";
          });
        }
      }
    }
  }

  Future<void> notesadd(String tittle, String notes, String id) async {
    await FirebaseFirestore.instance.collection('Notes').add({
      'notes': notes,
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
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        backgroundColor: Colors.blue[100],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Hello! $userDataUrl"),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('Do you want to Logout?'),
                      //contentPadding: EdgeInsets.all(0), // Set padding to zero
                      content: SizedBox(
                        height: 50, // Adjust the height as needed
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.black, width: 0.7),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    signOut();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Logout'),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Colors.black, width: 0.7),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
              var note = snapshot.data!.docs[index]['notes'];
              var tittle = snapshot.data!.docs[index]['tittle'];
              var time = snapshot.data!.docs[index]['cime'];
              var utime = snapshot.data!.docs[index]['utime'];
              var date = snapshot.data!.docs[index]['Date'];
              var udate = snapshot.data!.docs[index]['udate'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tittle,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Column(
                              children: [
                                Text(
                                  time,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                Text(
                                  date,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                        ),
                        Text(note),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
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
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Update Notes',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                      ),
                                      const Text(
                                        'Tittle',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: TextField(
                                              controller: TextEditingController(
                                                  text: tittle),
                                              onChanged: (value) {
                                                // Update the note variable with new value
                                                tittle = value;
                                              },
                                              decoration: const InputDecoration(
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
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: TextField(
                                              maxLines: 5,
                                              controller: TextEditingController(
                                                  text: note),
                                              onChanged: (value) {
                                                // Update the note variable with new value
                                                note = value;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                // Update the note in Firebase
                                                await FirebaseFirestore.instance
                                                    .collection("Notes")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .delete();
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                // Update the note in Firebase
                                                await FirebaseFirestore.instance
                                                    .collection("Notes")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .update({
                                                  'notes': note,
                                                  'tittle': tittle,
                                                  'utime': getPresentTime(),
                                                  'udate':
                                                      getPresentDateMonthYear(),
                                                });
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Update'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Last Updated on $utime $udate',
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
