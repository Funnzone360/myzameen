// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';

class ProductsInCategoryScreen extends StatefulWidget {
  final String category;

  const ProductsInCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _ProductsInCategoryScreenState createState() =>
      _ProductsInCategoryScreenState();
}

class _ProductsInCategoryScreenState extends State<ProductsInCategoryScreen> {
  String _selectedPriceRange = 'All';

  late Map<String, List<String>> _categoryPriceRanges;

  @override
  void initState() {
    _categoryPriceRanges = {
      'LAND': [
        'All',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
      'HOUSE': [
        'All',
        '50,000-2,00000',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
      'SHOPS': [
        'All',
        '50,000-2,00000',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
      'FACTORIES': [
        'All',
        '50,000-2,00000',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
      'BUILDINGS': [
        'All',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
      'HOTELS': [
        'All',
        '2,00000-10,00,000',
        '10,00,000-3000000',
        '3000000-5,000,000',
        '5,000,000-10,000,000',
        '10,000,000-20,00,00,000',
        '20,00,00,000-500000000',
        '500000000-2,00,00,000'
      ],
    };
    super.initState();
  }

  String truncateDescription(String description, int maxLength) {
    if (description.length <= maxLength) {
      return description;
    } else {
      return '${description.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Color(0xFFC8291D),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Products In category'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Card(
            child: DropdownButton<String>(
              dropdownColor: Color.fromARGB(255, 242, 228, 228),
              borderRadius: BorderRadius.circular(20),
              menuMaxHeight: 350,
              value: _selectedPriceRange,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPriceRange = newValue!;
                });
              },
              items: _categoryPriceRanges[widget.category]!.map((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('all_products')
                  .where('productType', isEqualTo: widget.category)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No products found in ${widget.category}'));
                }

                // Filter products based on selected price range
                List<DocumentSnapshot> filteredProducts =
                    snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  if (_selectedPriceRange == 'All') {
                    return true; // Include all products if 'All' is selected
                  } else {
                    List<String> rangeValues = _selectedPriceRange.split('-');
                    double lowerBound =
                        double.parse(rangeValues[0].replaceAll(',', '').trim());
                    double upperBound =
                        double.parse(rangeValues[1].replaceAll(',', '').trim());
                    double productPrice =
                        (data['price'] ?? 0).toDouble(); // Parse as double
                    return productPrice >= lowerBound &&
                        productPrice <= upperBound;
                  }
                }).toList();

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        filteredProducts[index].data() as Map<String, dynamic>;

                    SellerProfileModel product = SellerProfileModel(
                      name: data['name'],
                      phoneNumber: data['phoneNumber'],
                      description: data['description'],
                      price: (data['price'] ?? 0).toDouble(), // Parse as double
                      city: data['city'], productName: null,
                    );

                    return Card(
                      child: Container(
                        height: 190,
                        width: double.infinity,
                        color: Color.fromARGB(255, 240, 228, 228),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(data['productType'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      truncateDescription(
                                          'description: ${data['description'] ?? ''}',
                                          30), // Adjust 50 to the desired length
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Price: ${data['price'] ?? ''}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Radius for rounded corners
                              ),
                              child: Text(
                                'See Detail',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Color(0xFFC8291D),
                              minWidth: 80,
                              onPressed: () {
                                SellerProfileModel product = SellerProfileModel(
                                  name: data['name'],

                                  description: data['description'],
                                  imageUrls: List<String>.from(
                                      data['imageUrls'] ?? []),
                                  price: (data['price'] ?? 0)
                                      .toDouble(), // Parse as double
                                  phoneNumber: data['phoneNumber'] as int?,
                                  productType: data['productType'],
                                  city: data['city'], productName: null,
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
