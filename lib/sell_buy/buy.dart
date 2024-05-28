// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
// import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';

// class BuyScreen extends StatefulWidget {
//   const BuyScreen({Key? key}) : super(key: key);

//   @override
//   _BuyScreenState createState() => _BuyScreenState();
// }

// class _BuyScreenState extends State<BuyScreen> {
//   late TextEditingController searchController;
//   TextEditingController nameController = TextEditingController();

//   List<SellerProfileModel> allProducts = [];
//   List<SellerProfileModel> displayedProducts = [];

//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     fetchProducts();
//   }

//   void fetchProducts() async {
//     try {
//       QuerySnapshot<Object?> querySnapshot =
//           await FirebaseFirestore.instance.collection('all_products').get();

//       List<SellerProfileModel> products = querySnapshot.docs.map((doc) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         return SellerProfileModel.fromJson(data);
//       }).toList();

//       setState(() {
//         allProducts = products;
//         displayedProducts = allProducts;
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   void filterProducts(String query) {
//     List<SellerProfileModel> filteredProducts = allProducts
//         .where((product) =>
//             product.productName?.toLowerCase().contains(query.toLowerCase()) ==
//             true)
//         .toList();

//     setState(() {
//       displayedProducts = filteredProducts;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Buy Screen'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: (query) {
//                 filterProducts(query);
//               },
//               decoration: InputDecoration(
//                 labelText: 'Search Products',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: displayedProducts.isEmpty
//                 ? const Center(child: Text('No products found'))
//                 : ListView.builder(
//                     itemCount: displayedProducts.length,
//                     itemBuilder: (context, index) {
//                       SellerProfileModel product = displayedProducts[index];

//                       return ListTile(
//                         title: Text(product.productName ?? 'N/A'),
//                         subtitle: Text(product.description ?? 'N/A'),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProductDetailsScreen(
//                                 product: product,
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
