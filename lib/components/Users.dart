import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database/Auth/auth.dart';
import 'package:database/components/Addimage.dart';
import 'package:database/components/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  // ignore: non_constant_identifier_names
  final String API =
      "https://94bc-2401-4900-4ccb-f04d-512-8b24-d880-2541.ngrok-free.app";
  bool shouldShowFloatingActionButton = true;
  String? userDataUrl;
  String? imageUrl;
  // ignore: non_constant_identifier_names
  List<Shop> Student = [];
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
        if (userData != null && userData.containsKey('name')) {
          final name = userData['name'] as String?;
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

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: shouldShowFloatingActionButton
          ? FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddItem()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello! $userDataUrl",
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                )
              ],
            )
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
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getItemNames(index),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.9,
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Shop>> fetchData() async {
    final response = await http.get(
      Uri.parse('$API/api/call/shop'),
    );

    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      shops.clear();
      for (Map<String, dynamic> index in data) {
        shops.add(Shop.fromJson(index));
      }
      //print("Number of items added to Student: $shops");
      return shops;
    } else {
      return shops;
    }
  }

  String getItemNames(int index) {
    List<String> itemNames =
        shops[index].items.map((item) => item.itemdis).toList();
    return itemNames.join(", ");
  }
}
