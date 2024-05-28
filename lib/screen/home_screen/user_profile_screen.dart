import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/privacy_policy/privacy_policy.dart';
import 'package:flutter_zameen_app/screen/credentials/login_screen.dart';
import 'package:flutter_zameen_app/screen/home_screen/user_screen/User_screens/rate_app.dart';
import 'package:flutter_zameen_app/screen/home_screen/user_screen/share_app.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);
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
              title: Text('Seller Profile'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/images/logo.zameen.jpg'),
            ),
            ////////

            SizedBox(height: 20),
            Divider(),
            _listTileComponent(context, () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RateAppScreen()),
              );
            }, Icons.privacy_tip, 'Rate App'),
            Divider(),
            SizedBox(height: 20),
            ////
            _listTileComponent(context, () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PrivacyPolicy()));
            }, Icons.rate_review, 'Privacy Policy'),
            Divider(),
            SizedBox(height: 20),
            _listTileComponent(context, () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ShareAppScreen()));
            }, Icons.share, 'Share App'),
            Divider(),
            SizedBox(height: 20),

            _listTileComponent(context, () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return LogInScreen();
                }),
              );
            }, Icons.logout, 'LogOut'),
            Divider(),
          ],
        ),
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
        ),
      ],
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
