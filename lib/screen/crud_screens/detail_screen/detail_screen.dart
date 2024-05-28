import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/models/seller_model/seller_profile_model.dart';

class AssetsDetailScreen extends StatefulWidget {
  final SellerProfileModel? product;

  const AssetsDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AssetsDetailScreen> createState() => _assetsDetailScreenState();
}

class _assetsDetailScreenState extends State<AssetsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product?.name ?? 'Assets Detail'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Center(
                child: Image.network(
                  widget.product!.imageUrls != null &&
                          widget.product!.imageUrls!.isNotEmpty
                      ? widget.product!.imageUrls![0]
                      : 'N/A',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text(widget.product?.productType ?? 'N/A'),
              ),
              subtitle: Text(widget.product?.description ?? 'N/A'),
              trailing: Text(widget.product?.price.toString() ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }
}
