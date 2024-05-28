import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/privacy_policy/privacy_policy.dart';
import 'package:flutter_zameen_app/screen/home_screen/user_screen/User_screens/rate_app.dart';
import 'package:flutter_zameen_app/screen/credentials/login_screen.dart';

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              _listTileComponent(context, () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return RateAppScreen();
                  }),
                );
              }, Icons.rate_review, 'Rate App'),
              const Divider(),
              _listTileComponent(context, () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return PrivacyPolicy();
                  }),
                );
              }, Icons.privacy_tip, 'Privacy Policy'),
              const Divider(),
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
      ],
    ),
  );
}

// Widget for each ListTile in the drawer
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
