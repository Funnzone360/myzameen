import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({Key? key}) : super(key: key);

  Future<void> shareApp() async {
    // Set the app link and the message to be shared
    final String appLink =
        'https://play.google.com/store/apps/details?id=com.zameen.zameenapp&pcampaignid=web_share';
    final String message = 'share this app with your friends: $appLink';

    // Share the app link and message using the share dialog
    await FlutterShare.share(
      title: 'Share App',
      text: message,
      linkUrl: appLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            color: Color(0xFFC8291D),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text('Share App'),
              centerTitle: true,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/zameen.jpg',
              width: 400,
              height: 300,
            ),
            const Text(
              'Share this app with your friends!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.red,
              onPressed: shareApp,
              child: const Text('Share'),
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
