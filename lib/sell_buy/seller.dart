import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_zameen_app/screen/crud_screens/delete_assets.dart';
import 'package:flutter_zameen_app/screen/crud_screens/update_assets.dart';
import 'package:flutter_zameen_app/screen/crud_screens/view_assets.dart';

List<Map<String, dynamic>> sellerProducts = [];

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final imagePicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageUrls = [];
  var uuid = const Uuid();
  bool isSaving = false;
  bool isUploading = false;
  String? productType;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: const Color(0xFFC8291D),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0), // Adjust the height as needed
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Seller Profile'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFC8291D),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Seller Use Things ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _listTileComponent(context, () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ViewProductsScreen()),
                    );
                  }, Icons.view_agenda, 'View Products'),
                  const Divider(),
                  SizedBox(height: 20),
                  _listTileComponent(context, () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DeleteProductsScreen(products: sellerProducts)),
                    );
                  }, Icons.delete, 'Delete Products'),
                  const Divider(),
                  SizedBox(height: 20),
                  _listTileComponent(context, () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UpdateProductsScreen(products: sellerProducts),
                      ),
                    );
                  }, Icons.update, 'Update Products'),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: isSaving ? _buildSavingIndicator() : _buildForm(size),
    );
  }

  Widget _buildSavingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(Size size) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage('assets/images/logo.zameen.jpg'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                prefixIcon: Icon(FontAwesomeIcons.productHunt),
                hintText: 'Enter seller Name...',
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Field should not be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.productHunt),
                hintText: 'Select Product Type',
                border: OutlineInputBorder(),
              ),
              value: productType,
              onChanged: (newValue) {
                setState(() {
                  productType = newValue;
                });
              },
              items: <String>[
                'LAND',
                'HOUSE',
                'SHOPS',
                'FACTORIES',
                'BUILDINGS',
                'HOTELS',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a product type';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(FontAwesomeIcons.audioDescription),
                hintText: 'Enter Description.......',
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Field should not be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(FontAwesomeIcons.moneyBill),
                hintText: 'Enter price.....',
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Field should not be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(FontAwesomeIcons.moneyBill),
                hintText: 'Phono no.....',
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Field should not be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: cityController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(FontAwesomeIcons.city),
                hintText: 'City name.....',
              ),
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Field should not be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            if (images.length < 5)
              MaterialButton(
                color: const Color(0xFFC8291D),
                child: Text(
                  images.length < 5
                      ? "Pick Images"
                      : "Pick ${5 - images.length} more image(s) to complete",
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  pickImage();
                },
              ),
            const SizedBox(height: 10),
            if (images.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Image.file(
                              File(images[index].path),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _removeImage(index);
                            },
                            icon: const Center(
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            // _buildLocationDiv(),
            MaterialButton(
              color: const Color(0xFFC8291D),
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _saveProductsMethod();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void _saveProductsMethod() async {
    try {
      print("Starting save process...");

      if (!validateFields()) {
        print("Validation failed: Some fields are empty.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all required fields")),
        );
        return;
      }

      if (productType == null) {
        print("Validation failed: Product type is not selected.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a product type")),
        );
        return;
      }

      print("Validation passed.");

      print("Uploading images...");
      await uploadImages();
      print("Images uploaded successfully.");

      print("Saving data to Firestore...");
      DocumentReference productRef =
          await FirebaseFirestore.instance.collection('all_products').add(
        {
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.parse(priceController.text),
          'phoneNumber': int.parse(phoneNumberController.text),
          'imageUrls': imageUrls,
          'productType': productType,
          'city': cityController.text,
        },
      );
      print("Data saved successfully.");

      // Create a map containing the product data
      Map<String, dynamic> newProduct = {
        'id': productRef.id,
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'phoneNumber': int.parse(phoneNumberController.text),
        'imageUrls': imageUrls,
        'productType': productType,
        'city': cityController.text,
      };

      // Add the product data to the global variable
      sellerProducts.add(newProduct);

      clearControllers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added Successfully")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. ${e.toString()}")),
      );
    }
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        // productNameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void clearControllers() {
    nameController.clear();
    // productNameController.clear();
    descriptionController.clear();
    priceController.clear();
    phoneNumberController.clear();
    cityController.clear();
  }

  Future<void> uploadImages() async {
    for (var image in images) {
      try {
        String? downLoadUrl = await postImages(image);

        if (downLoadUrl != null) {
          setState(() {
            imageUrls.add(downLoadUrl);
          });
        } else {
          Fluttertoast.showToast(msg: "Error: Image upload failed");
        }
      } catch (e) {
        print("Error uploading image: $e");
        Fluttertoast.showToast(msg: "Error: Image upload failed");
      }
    }
  }

  Future<String?> postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });

    String? urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);

    await ref.putData(
      await imageFile.readAsBytes(),
      SettableMetadata(contentType: "image/jpeg"),
    );

    urls = await ref.getDownloadURL();
    setState(() {
      isUploading = false;
    });
    return urls;
  }

  void pickImage() async {
    final pickedFiles = await imagePicker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        images.addAll(pickedFiles);
      } else {
        print('No images selected.');
      }
    });
  }
}

Widget _listTileComponent(BuildContext context, void Function()? onTap,
    IconData leadingIcon, String title) {
  return Column(
    children: [
      ListTile(
        onTap: onTap,
        leading: Icon(leadingIcon),
        title: Text(title),
        trailing: const Icon(Icons.forward_outlined),
      ),
    ],
  );
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height); // Start from bottom-left
    path.quadraticBezierTo(size.width / 2, size.height * 0.7, size.width,
        size.height); // Curve to bottom-right
    path.lineTo(size.width, 0); // Line to top-right
    path.quadraticBezierTo(
        size.width / 2, size.height * 0, 0, 0); // Curve to top-left
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
