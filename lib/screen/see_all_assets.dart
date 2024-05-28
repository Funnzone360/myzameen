import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';
import 'package:flutter_zameen_app/sell_buy/product_detail_screen.dart';

class SeeAllAssetsScreen extends StatefulWidget {
  final List<dynamic> assets;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> shopAssets;

  const SeeAllAssetsScreen({
    Key? key,
    required this.assets,
    required this.shopAssets,
  }) : super(key: key);

  @override
  State<SeeAllAssetsScreen> createState() {
    return _SeeAllAssetsScreenState();
  }
}

class _SeeAllAssetsScreenState extends State<SeeAllAssetsScreen> {
  TextEditingController searchController = TextEditingController();
  String? searchQuery;
  String selectedCategory = 'All';
  String selectedPriceRange = 'All';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFC8291D),
      appBar: AppBar(
        backgroundColor: Color(0xFFC8291D),
        title: Text('All Assets'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 218, 218), // Move the color here
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search.....',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // DropdownButton<String>(
                    //   value: selectedCategory,
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       selectedCategory = newValue!;

                    //       selectedPriceRange = 'All';
                    //     });
                    //   },
                    //   items: ['All', 'LAND', 'HOUSE', 'SHOPS']
                    //       .map<DropdownMenuItem<String>>(
                    //         (category) => DropdownMenuItem<String>(
                    //           value: category,
                    //           child: Text(category),
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedPriceRange,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPriceRange = newValue!;
                        });
                      },
                      items: ['land', 'house', 'shop']
                          .map<DropdownMenuItem<String>>(
                            (priceRange) => DropdownMenuItem<String>(
                              value: priceRange,
                              child: Text(priceRange),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _displayFilteredAssets(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayFilteredAssets() {
    List<dynamic> filteredAssets = [];

    if (selectedCategory == 'All') {
      filteredAssets = widget.assets + widget.shopAssets;
    } else if (selectedCategory == 'LAND') {
      filteredAssets = widget.assets
          .where((asset) => asset['productType'] == 'LAND')
          .toList();
    } else if (selectedCategory == 'HOUSE') {
      filteredAssets = widget.assets
          .where((asset) => asset['productType'] == 'HOUSE')
          .toList();
    } else if (selectedCategory == 'SHOPS') {
      filteredAssets = widget.shopAssets;
    }

    if (selectedPriceRange != 'All') {
      List<String> range = selectedPriceRange.split(' - ');
      double minPrice = double.parse(range[0].replaceAll(',', ''));
      double maxPrice = double.parse(range[1].replaceAll(',', ''));
      filteredAssets = filteredAssets
          .where((asset) =>
              asset['price'] >= minPrice && asset['price'] <= maxPrice)
          .toList();
    }

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filteredAssets = filteredAssets.where((asset) {
        return asset['productName']
                .toString()
                .toLowerCase()
                .contains(searchQuery!) ||
            asset['description']
                .toString()
                .toLowerCase()
                .contains(searchQuery!);
      }).toList();
    }

    return ListView.builder(
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        var asset = filteredAssets[index];
        var productType = asset['productType'] ?? 'Unknown';

        return Card(
          child: Container(
            height: 150,
            width: double.infinity,
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
                  minWidth: 100,
                  onPressed: () {
                    // Navigate to product details screen
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
                            imageUrls: asset['imageUrls']?.cast<String>() ?? [],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text("See Details"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
