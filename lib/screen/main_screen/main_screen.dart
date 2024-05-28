// main_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';
import 'package:flutter_zameen_app/sell_buy/google_maps.dart';

class MainScreen extends StatefulWidget {
  final String searchQuery;

  const MainScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<SellerProfileModel> displayedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      // Fetch products on seearch query
      QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
          .collection('all_products')
          .where('productType', isEqualTo: widget.searchQuery.toUpperCase())
          .get();

      List<SellerProfileModel> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SellerProfileModel.fromJson(data);
      }).toList();

      setState(() {
        displayedProducts = products;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            //cap shape app bar
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Main Screen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            'Select Location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Card(
            child: IconButton(
              icon: Icon(
                Icons.location_on,
                size: 30,
                color: Colors.blue,
              ),
              onPressed: () async {
                String? selectedLocation = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocationScreen()));

                if (selectedLocation != null) {
                  fetchProductsByLocation(selectedLocation);
                }
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 0.43,
              ),
              itemCount: displayedProducts.length,
              itemBuilder: (context, index) {
                SellerProfileModel product = displayedProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 20),
                      Container(
                        height: 250,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: product.imageUrls != null &&
                                  product.imageUrls!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(product.imageUrls![0]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              product.productType ?? 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Price:${product.price ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Text(
                                'See Detail',
                              ),
                              color: Color(0xFFC8291D),
                              minWidth: 120,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchProductsByLocation(String selectedLocation) async {
    try {
      // Fetch products based on selected location
      QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
          .collection('all_products')
          .where('city', isEqualTo: selectedLocation)
          .get();

      List<SellerProfileModel> products = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return SellerProfileModel.fromJson(data);
      }).toList();

      setState(() {
        displayedProducts = products;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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
