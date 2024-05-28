class SellerProfileModel {
  final String? name;
  final String? id;

  final String? description;
  final List<String>? imageUrls;
  final double? price;
  final int? phoneNumber;
  final String? productType;
  final String? city; // Added city field

  SellerProfileModel({
    this.name,
    this.id,
    this.description,
    this.imageUrls,
    this.price,
    this.phoneNumber,
    this.productType,
    this.city,
    required productName,
  });

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileModel(
      name: json['name'] as String?,
      id: json['id'],
      // productName: json['productName'] as String?,
      description: json['description'] as String?,
      imageUrls: List<String>.from(json['imageUrls'] as List<dynamic>? ?? []),
      price: (json['price'] as num?)?.toDouble(),
      phoneNumber: json['phoneNumber'] != null
          ? int.tryParse(json['phoneNumber'].toString())
          : null,
      productType: json['productType'] as String?,
      city: json['city'] as String?,
      productName: null, // Retrieve city field from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      // 'productName': productName,
      'description': description,
      'imageUrls': imageUrls,
      'price': price,
      'phoneNumber': phoneNumber,
      'productType': productType,
      'city': city, // Include city field in JSON
    };
  }
}
