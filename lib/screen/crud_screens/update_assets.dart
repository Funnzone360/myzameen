import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateProductsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const UpdateProductsScreen({Key? key, required this.products})
      : super(key: key);

  @override
  _UpdateProductsScreenState createState() => _UpdateProductsScreenState();
}

class _UpdateProductsScreenState extends State<UpdateProductsScreen> {
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
              title: Text('Update Profile'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (BuildContext context, int index) {
          // Extract product details from the list
          Map<String, dynamic> product = widget.products[index];

          // Create UI elements to display and update product details
          return Card(
            color: Color.fromARGB(255, 240, 228, 228),
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text(product['description']),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Implement logic to update product details
                  _navigateToUpdateScreen(product);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToUpdateScreen(Map<String, dynamic> product) {
    // Navigate to the screen where the user can update the product details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateProductDetailsScreen(product: product),
      ),
    );
  }
}

class UpdateProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const UpdateProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _UpdateProductDetailsScreenState createState() =>
      _UpdateProductDetailsScreenState();
}

class _UpdateProductDetailsScreenState
    extends State<UpdateProductDetailsScreen> {
  // Declare controllers for editing product details
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product details
    nameController.text = widget.product['name'];
    descriptionController.text = widget.product['description'];
    priceController.text = widget.product['price'].toString();
    phoneNumberController.text = widget.product['phoneNumber'].toString();
    cityController.text = widget.product['city'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(10.0), // Adjust the height as needed
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Update Products'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update product details in Firestore
                _updateProductDetails();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProductDetails() async {
    try {
      // Get a reference to the document of the product to update
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('all_products')
          .doc(widget.product['id']);

      // Update the product details in Firestore
      await productRef.update({
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'phoneNumber': int.parse(phoneNumberController.text),
        'city': cityController.text,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product details updated successfully")),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show an error message if update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update product details: $e")),
      );
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
