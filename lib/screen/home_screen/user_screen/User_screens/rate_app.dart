import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateAppScreen extends StatelessWidget {
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  double userRating = 3.0;

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
              title: Text('Rate'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'How would you rate the Zameen App?',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 50,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print("User's rating: $rating");
                userRating = rating; // Store the user's rating in the variable
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Store the rating in Firestore
                await ratingsCollection.add({
                  'rating': userRating,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Check if there is a route to pop before attempting to pop
                if (Navigator.canPop(context)) {
                  // Delay the pop to ensure the data is stored before popping
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
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






// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class RateApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Rate App',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'How would you rate the Zameen App?',
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             RatingBar.builder(
//               initialRating: 3,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 50,
//               itemBuilder: (context, _) => Icon(
//                 Icons.favorite,
//                 color: Colors.red,
//               ),
//               onRatingUpdate: (rating) {
//                 print("User's rating: $rating");
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
