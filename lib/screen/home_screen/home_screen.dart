import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/models/carousel_slider_model/carousel_slider_model.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
import 'package:flutter_zameen_app/models/ui_models/carousel_slider_model.dart';
import 'package:flutter_zameen_app/privacy_policy/privacy_policy.dart';
import 'package:flutter_zameen_app/screen/credentials/login_screen.dart';
import 'package:flutter_zameen_app/screen/home_screen/user_profile_screen.dart';
import 'package:flutter_zameen_app/screen/home_screen/user_screen/User_screens/rate_app.dart';
import 'package:flutter_zameen_app/screen/search_screen/search_screen.dart';
import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';
import 'package:flutter_zameen_app/sell_buy/products_in_category.dart';
import 'package:flutter_zameen_app/sell_buy/seller.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Adjust the height as needed
        child: ClipPath(
          // clipper: AppBarClipper(),
          child: Container(
            color: Color.fromARGB(255, 12, 67, 111),
            child: AppBar(
              backgroundColor: Color(0xFFC8291D),
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Zameen App',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              actions: [
                ///icon button
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: drawerComponent(context),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 239, 239),
          borderRadius: BorderRadius.circular(40),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSliderWidget(
                imagePaths:
                    carouselSliderModel.map((value) => value.imageUrl).toList(),
                names: carouselSliderModel.map((value) => value.title).toList(),
              ),
              _displayAssetsInCategories(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell_rounded),
            label: 'Seller Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SellScreen()));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()));

              break;
          }
        },
      ),
    );
  }

  Widget _displayAssetsInCategories() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('all_products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No assets found.'));
        } else {
          var assets = snapshot.data!.docs;
          var landAssets =
              assets.where((asset) => asset['productType'] == 'LAND').toList();
          Divider();
          var houseAssets =
              assets.where((asset) => asset['productType'] == 'HOUSE').toList();
          Divider();
          var shopAssets =
              assets.where((asset) => asset['productType'] == 'SHOPS').toList();
          var factoriesAssets = assets
              .where((asset) => asset['productType'] == 'FACTORIES')
              .toList();
          var buildingsAssets = assets
              .where((asset) => asset['productType'] == 'BUILDINGS')
              .toList();
          var hotelsAssets = assets
              .where((asset) => asset['productType'] == 'HOTELS')
              .toList();

          return Column(
            children: [
              _displayCategoryAssets("LANDS", landAssets),
              _displayCategoryAssets("HOUSES", houseAssets),
              _displaySeeAllButton(assets, shopAssets, factoriesAssets,
                  buildingsAssets, hotelsAssets),
            ],
          );
        }
      },
    );
  }

  Widget _displaySeeAllButton(
      List assets,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> shopAssets,
      factoriesAssets,
      buildingsAssets,
      hotelsAssets) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductsInCategoryScreen(category: 'category'),
            ),
          );
        },
        child: Text(''),
      ),
    );
  }

  Widget _displayCategoryAssets(String categoryName, List assets) {
    return Column(
      children: [
        ListTile(
          title: Text(
            categoryName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            var asset = assets[index];
            var productType = asset['productType'] ?? 'Unknown';

            return Container(
              height: 150,
              width: double.infinity,
              color: Color.fromARGB(255, 240, 228, 228),
              child: Column(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(asset['productName'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset['description'] ?? ''),
                          Text(
                            'Price: ${asset['price'] ?? 'N/A'}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Text('Type: $productType'),
                    ),
                  ),
                  Spacer(),
                  MaterialButton(
                    color: Color(0xFFC8291D),
                    minWidth: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: SellerProfileModel(
                              name: asset['name'] ?? '',
                              productName: asset['productName'] ?? '',
                              description: asset['description'] ?? '',
                              price: asset['price'] ?? 0.0,
                              phoneNumber: asset['phoneNumber'] ?? 0,
                              imageUrls:
                                  asset['imageUrls']?.cast<String>() ?? [],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "See Details",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

Widget drawerComponent(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Drawer(
    backgroundColor: const Color(0xFFC8291D),
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'Seller Screen ',
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
            color: const Color.fromARGB(255, 221, 216, 216),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              _listTileComponent(context, () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return RateAppScreen();
                  }),
                  (route) => false,
                );
              }, Icons.rate_review, 'Rate App'),
              const Divider(),
              _listTileComponent(context, () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return PrivacyPolicy();
                  }),
                  (route) => false,
                );
              }, Icons.privacy_tip, 'Privacy Policy'),
              const Divider(),
              _listTileComponent(context, () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return LogInScreen();
                  }),
                  (route) => false,
                );
              }, Icons.logout, 'LogOut'),
              Divider(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _listTileComponent(
  BuildContext context,
  void Function()? onTap,
  IconData leadingIcon,
  String title,
) {
  return Column(
    children: [
      ListTile(
        onTap: onTap,
        leading: Icon(leadingIcon),
        title: Text(title),
        trailing: Icon(Icons.forward_outlined),
      )
    ],
  );
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_zameen_app/components/drawer_components.dart';
// import 'package:flutter_zameen_app/models/carousel_slider_model/carousel_slider_model.dart';
// import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
// import 'package:flutter_zameen_app/models/ui_models/carousel_slider_model.dart';
// import 'package:flutter_zameen_app/privacy_policy/privacy_policy.dart';
// import 'package:flutter_zameen_app/rate_app/rate_app.dart';
// import 'package:flutter_zameen_app/screen/see_all_assets.dart';
// import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? searchQuery = '';
//   int? myIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xFFC8291D),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFC8291D),
//         title: const Text('zameen'),
//         // actions: [
//         //   IconButton(
//         //     onPressed: () {},
//         //     icon: const Center(child: Icon(FontAwesomeIcons.search, size: 20)),
//         //   ),
//         // ],
//       ),
//       drawer: Drawer(
//         backgroundColor: const Color(0xFFC8291D),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const SizedBox(
//               height: 200,
//               child: Center(
//                 child: Text(
//                   'Seller Screen ',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: size.width,
//               height: size.height,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 221, 216, 216),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             //   child: Column(
//             //     children: [
//             //       Container(
//             // width: size.width,
//             // height: size.height,
//             // decoration: BoxDecoration(
//             //   color: const Color.fromARGB(255, 221, 216, 216),
//             //   borderRadius: BorderRadius.circular(30),
//             // ),
//             child: Column(
//               children: [
//                 _listTileComponent(context, () async {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (_) {
//                       return RateApp();
//                     }),
//                     (route) => false,
//                   );
//                 }, Icons.rate_review, 'Rate App'),
//                 const Divider(),
//                 _listTileComponent(context, () async {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (_) {
//                       return PrivacyPolicy();
//                     }),
//                     (route) => false,
//                   );
//                 }, Icons.privacy_tip, 'Privacy Policy'),
//                 const Divider(),
//                 _listTileComponent(context, () async {
//                   await FirebaseAuth.instance.signOut();
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (_) {
//                       return LogInScreen();
//                     }),
//                     (route) => false,
//                   );
//                 }, Icons.logout, 'LogOut'),
//                 Divider(),
//               ],
//             ),
//           ),
//      ], ),
//       body:  Container(
//         width: size.width,
//         height: size.height,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 247, 247, 247),
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // StreamBuilder(
//               //   stream: FirebaseAuth.instance.authStateChanges(),
//               //   builder: (context, snapshot) {
//               //     if (snapshot.connectionState == ConnectionState.waiting) {
//               //       return const Center(child: CircularProgressIndicator());
//               //     } else if (snapshot.hasError) {
//               //       debugPrint("Auth State Error: ${snapshot.error}");
//               //       return Center(child: Text('Error: ${snapshot.error}'));
//               //     } else if (snapshot.hasData && snapshot.data != null) {
//               //       User? user = FirebaseAuth.instance.currentUser;
//               //       String? uid = user?.uid;

//               //       if (uid != null && uid.isNotEmpty) {
//               //         return StreamBuilder(
//               //           stream: FirebaseFirestore.instance
//               //               .collection('users')
//               //               .doc(uid)
//               //               .snapshots(),
//               //           builder: (context, snapshot) {
//               //             if (snapshot.connectionState ==
//               //                 ConnectionState.waiting) {
//               //               return const Center(
//               //                   child: CircularProgressIndicator());
//               //             } else if (snapshot.hasError) {
//               //               debugPrint("User Data Error: ${snapshot.error}");
//               //               return Center(
//               //                   child: Text('Error: ${snapshot.error}'));
//               //             } else if (snapshot.hasData && snapshot.data != null) {
//               //               var user = snapshot.data;
//               //               final photo = user!['photoUrl']?.toString() ??
//               //                   AppUtils.splashScreenBgImg;
//               //               final displayName =
//               //                   user['displayName']?.toString() ?? '';

//               //               return ListTile(
//               //                 leading: CircleAvatar(
//               //                   backgroundImage:
//               //                       CachedNetworkImageProvider(photo),
//               //                 ),
//               //                 title: SelectableText("Welcome $displayName"),
//               //               );
//               //             } else {
//               //               return const Center(
//               //                   child: Text('No user data found.'));
//               //             }
//               //           },
//               //         );
//               //       } else {
//               //         return const Center(child: Text('User UID is empty.'));
//               //       }
//               //     } else {
//               //       return const Center(child: Text('User not logged in.'));
//               //     }
//               //   },
//               // ),

//               CarouselSliderWidget(
//                 imagePaths:
//                     carouselSliderModel.map((value) => value.imageUrl).toList(),
//                 names: carouselSliderModel.map((value) => value.title).toList(),
//               ),

//               ///
//               _displayAssetsInCategories(),

//               // Container(
//               //   height: 50,
//               //   width: 300,
//               //   decoration: BoxDecoration(
//               //     color: Colors.blue,
//               //     borderRadius: BorderRadius.circular(25),
//               //   ),
//               //   child: MaterialButton(
//               //     onPressed: () {
//               //       Navigator.push(
//               //         context,
//               //         MaterialPageRoute(builder: (context) => SellScreen()),
//               //       );
//               //     },
//               //     child: Text('Sell',
//               //         style:
//               //             TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//               //   ),
//               // ),
//               // SizedBox(height: 30),
//               // Container(
//               //   height: 50,
//               //   width: 300,
//               //   decoration: BoxDecoration(
//               //     color: Colors.red,
//               //     borderRadius: BorderRadius.circular(25),
//               //   ),
//               //   child: MaterialButton(
//               //     onPressed: () {
//               //       Navigator.push(
//               //         context,
//               //         MaterialPageRoute(builder: (context) => BuyScreen()),
//               //       );
//               //     },
//               //     child: Text('Buy',
//               //         style:
//               //             TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//       drawer: drawerComponent(context),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.black,
//         onTap: (index) {
//           setState(() {
//             myIndex = index;
//           });

//           switch (index) {
//             case 0:
//               Navigator.pushReplacementNamed(context, '/home');
//               break;
//             case 1:
//               Navigator.pushReplacementNamed(context, '/search');
//               break;
//             case 2:
//               Navigator.pushReplacementNamed(context, '/sell');
//               break;
//             case 3:
//               Navigator.pushReplacementNamed(context, '/user_profile');
//               break;
//           }
//         },
//         currentIndex: myIndex!,
//         items: [
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.sell),
//             label: 'Sell Assets',
//           ),
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'User',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _displayAssetsInCategories() {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('all_products').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return const Center(child: Text('No assets found.'));
//         } else {
//           var assets = snapshot.data!.docs;
//           // Filter assets based on categories or any other criteria
//           var landAssets =
//               assets.where((asset) => asset['productType'] == 'LAND').toList();
//           Divider();
//           var houseAssets =
//               assets.where((asset) => asset['productType'] == 'HOUSE').toList();
//           Divider();
//           var shopAssets =
//               assets.where((asset) => asset['productType'] == 'SHOPS').toList();
//           var factoriesAssets = assets
//               .where((asset) => asset['productType'] == 'FACTORIES')
//               .toList();
//           var buildingsAssets = assets
//               .where((asset) => asset['productType'] == 'BUILDINGS')
//               .toList();
//           var hotelsAssets = assets
//               .where((asset) => asset['productType'] == 'HOTELS')
//               .toList();

//           return Column(
//             children: [
//               _displayCategoryAssets("LANDS", landAssets),

//               _displayCategoryAssets("HOUSES", houseAssets),

//               // _displayCategoryAssets("Shops", shopAssets),
//               _displaySeeAllButton(assets, shopAssets, factoriesAssets,
//                   buildingsAssets, hotelsAssets),
//             ],
//           );
//         }
//       },
//     );
//   }

//   Widget _displaySeeAllButton(
//       List assets,
//       List<QueryDocumentSnapshot<Map<String, dynamic>>> shopAssets,
//       factoriesAssets,
//       buildingsAssets,
//       hotelsAssets) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   SeeAllAssetsScreen(assets: assets, shopAssets: shopAssets),
//             ),
//           );
//         },
//         child: Text(
//           "See All",
//           style: TextStyle(
//             color: Color.fromRGBO(7, 7, 7, 1),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _displayCategoryAssets(String categoryName, List assets) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             categoryName,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: assets.length,
//           itemBuilder: (context, index) {
//             var asset = assets[index];

//             var productType = asset['productType'] ?? 'Unknown';

//             return Container(
//               height: 150,
//               width: double.infinity,
//               color: Color.fromARGB(255, 239, 238, 238),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListTile(
//                       title: Text(asset['productName'] ?? ''),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(asset['description'] ?? ''),
//                           Text(
//                             'Price: ${asset['price'] ?? 'N/A'}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       trailing: Text('Type: $productType'),
//                     ),
//                   ),
//                   Spacer(),
//                   MaterialButton(
//                     color: Color(0xFFC8291D),
//                     minWidth: 50,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProductDetailsScreen(
//                             product: SellerProfileModel(
//                               name: asset['name'] ?? '',
//                               productName: asset['productName'] ?? '',
//                               description: asset['description'] ?? '',
//                               price: asset['price'] ?? 0.0,
//                               phoneNumber: asset['phoneNumber'] ?? 0,
//                               imageUrls:
//                                   asset['imageUrls']?.cast<String>() ?? [],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "See Details",
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//   Widget _listTileComponent(
//   BuildContext context,
//   void Function()? onTap,
//   IconData leadingIcon,
//   String title,
// ) {
//   return Column(
//     children: [
//       ListTile(
//         onTap: onTap,
//         leading: Icon(leadingIcon),
//         title: Text(title),
//         trailing: Icon(Icons.forward_outlined),
//       )
//     ],
//   );
// }
// }