import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _productname = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _currency = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  final TextEditingController _number = TextEditingController();
  String? userDataUrl;

  @override
  void initState() {
    _currency.text = "₹";
    countrycontroller.text = "+91";
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

  Future<void> _pickImage(ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 100,
    );
    if (file != null) {
      setState(() {
        _imageFile = File(file.path);
      });
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(90)),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.green[900],
              ),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Colors.green[900],
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> postData() async {
    fetchUserData();
    final msg = jsonEncode({
      'name': userDataUrl,
      'number': _number.text,
      'items': [
        {
          'itemname': _productname.text,
          'itemdis': _description.text,
          'price': _price.text,
          'imageurl': imageUrl,
        }
      ],
    });
    // ignore: unused_local_variable
    final response = await http.post(
      Uri.parse('https://2512-103-10-133-46.ngrok-free.app/api/call/shop/add'),
      headers: {
        'Content-Type': 'application/json', // Set the correct content type
      },
      body: msg,
    );
    if (response.statusCode == 200) {
      // Show a SnackBar if data is added successfully
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[400],
          content: const Text('Data added successfully!'),
        ),
      );
      _productname.clear();
      _description.clear();
      _price.clear();
      _number.clear();
      _imageFile = '' as File?;
    }
  }

  GlobalKey<FormState> key = GlobalKey();
  String imageUrl = '';
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final double wid = MediaQuery.of(context).size.width;
    final double hig = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Products'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Please\n upload the \npicture of your\n Product",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, fontFamily: 'Broad'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_imageFile != null)
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          height: 200,
                        ),
                      ),
                      onTap: () {
                        _showImageSourceOptions(context);
                      },
                    )
                  else
                    GestureDetector(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: hig / 4.5,
                            width: wid / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: DashedBorder.all(dashLength: 2),
                              color: Colors.green[200],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: (() {
                                  _showImageSourceOptions(context);
                                }),
                                icon: const Icon(Icons.add_a_photo_outlined),
                              ),
                              const Text(
                                'Upload\n Image for preview',
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ],
                      ),
                      onTap: () async {
                        _showImageSourceOptions(context);
                      },
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextField(
                    controller: _productname,
                    decoration: const InputDecoration(
                      //contentPadding: EdgeInsets.only(left: 15),
                      border: InputBorder.none,
                      hintText: "Enter Product name",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextField(
                    maxLines: 5,
                    controller: _description,
                    decoration: const InputDecoration(
                      //contentPadding: EdgeInsets.only(left: 15),
                      border: InputBorder.none,
                      hintText: "Enter Product description",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 55,
                    width: wid / 2.5,
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
                            textAlign: TextAlign.center,
                            enabled: false,
                            controller: _currency,
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
                            controller: _price,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Price",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 55,
                    width: wid / 1.9,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                            controller: countrycontroller,
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
                          maxLength: 10,
                          controller: _number,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: "Enter your Mobile Number",
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 150,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[400],
                          content: const Text('Please upload an image'),
                        ),
                      );
                      return;
                    } else if (_productname.text.isEmpty ||
                        _description.text.isEmpty ||
                        _price.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[400],
                          content: const Text('Please fill all the fields'),
                        ),
                      );
                      return;
                    } else {
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      //Get a reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');
                      //Create a reference for the image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);
                      try {
                        //Store the file
                        await referenceImageToUpload.putFile(_imageFile!);
                        //Success: get the download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        //Some error occurred
                      }
                      postData();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Product'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
