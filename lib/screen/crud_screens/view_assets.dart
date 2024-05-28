import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';

class ViewProductsScreen extends StatelessWidget {
  const ViewProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('View Products'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('all_products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Parse the documents into SellerProfileModel objects
            List<SellerProfileModel> products = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              // Ensure that your SellerProfileModel.fromJson function correctly parses the data
              return SellerProfileModel.fromJson(data);
            }).toList();

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                SellerProfileModel product = products[index];
                return Card(
                  color: Color.fromARGB(255, 240, 228, 228),
                  child: SizedBox(
                    height: 80,
                    child: ListTile(
                      title: Text(product.productType ?? 'N/A'),
                      subtitle: Text('Price: ${product.price ?? 'N/A'}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
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
