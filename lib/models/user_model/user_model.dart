class UserModel {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final String? userType;
  final bool? isSeller;
  final bool? isBuyer;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.userType,
    this.isSeller,
    this.isBuyer, // Add this line
  });

  // Create a method to convert the UserModel object to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'userType': userType,
      'isSeller': isSeller,
      'isBuyer': isBuyer, // Add this line
    };
  }

  // Create a factory method to create a UserModel object from Firestore data.
  factory UserModel.fromMap(Map<String, dynamic> user) {
    return UserModel(
      uid: user['uid'] ?? '',
      email: user['email'] ?? '',
      displayName: user['displayName'] ?? '',
      phoneNumber: user['phoneNumber'] ?? '',
      photoUrl: user['photoUrl'] ?? '',
      userType: user['userType'] ?? '',
      isSeller: user['isSeller'] ?? false,
      isBuyer: user['isBuyer'] ?? false, // Add this line
    );
  }
}
