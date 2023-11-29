// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
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
  final String API = "https://f168-103-10-133-192.ngrok-free.app";
  bool shouldShowFloatingActionButton = true;
  String? userDataUrl;
  String? imageUrl;
  // ignore: non_constant_identifier_names
  List<Shop> Student = [];
  List<Shop> shops = [];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData();
    });
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
        onRefresh: fetchData,
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
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
                        vertical: 5,
                        horizontal: 5,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              getItemimage(index),
                              height: 150,
                              width: 150,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Farm Fresh',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(getItemNames(index)),
                              Text("Price ₹:${getItemprice(index)}"),
                              const SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  FilledButton(
                                      style: FilledButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor: Colors.green[500]),
                                      onPressed: () {
                                        _showBottomSheet(context, index);
                                      },
                                      child: const Text("More Info"))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
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

  void _showBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures full-height bottom sheet
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95, // Adjust as needed, e.g., 0.9 for 90% height
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white, // Customize background color
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: const Icon(Icons.arrow_back_rounded),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "PRODUCT DETAILS",
                              style:
                                  TextStyle(fontFamily: 'Broad', fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(getItemimage(index)),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.green[900],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getItemNames(index),
                          style: const TextStyle(
                              fontFamily: 'Broad', fontSize: 30),
                        ),
                        Text(
                          '₹${getItemprice(index)}/KG',
                          style: const TextStyle(
                              fontFamily: 'Broad', fontSize: 30),
                        ),
                      ],
                    ),
                    Text(getItemdis(index)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _launchDialer(shops[index].number);
                        },
                        child: const Text(
                          "Contact Seller",
                          style: TextStyle(color: Colors.white),
                        ),
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
  }

  Future<List<Shop>> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://3a72-2401-4900-4b36-f3b4-857c-90a0-8a0e-58dd.ngrok-free.app/api/call/shop'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List<dynamic>;
      shops.clear();
      for (Map<String, dynamic> shopData in data) {
        //shops.clear();
        Shop shop = Shop.fromJson(shopData);
        shops.add(shop);
      }
      return shops;
    } else {
      // Handle the case where the response status code is not 200
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  String getItemNames(int index) {
    List<String> itemNames =
        shops[index].items.map((item) => item.itemname).toList();
    return itemNames.join(", ");
  }

  String getItemimage(int index) {
    List<String> itemNames =
        shops[index].items.map((item) => item.imageurl).toList();
    return itemNames.join(", ");
  }

  String getItemprice(int index) {
    List<String> itemNames =
        shops[index].items.map((item) => item.price).toList();
    return itemNames.join(", ");
  }

  String getItemdis(int index) {
    List<String> itemNames =
        shops[index].items.map((item) => item.itemdis).toList();
    return itemNames.join(", ");
  }

  Future<void> _launchDialer(phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      throw 'Could not launch $phoneLaunchUri';
    }
  }
}
