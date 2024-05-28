// import 'package:flutter/material.dart';

// class AnimatedScreen extends StatefulWidget {
//   const AnimatedScreen({Key? key}) : super(key: key);

//   @override
//   _AnimatedScreenState createState() => _AnimatedScreenState();
// }

// class _AnimatedScreenState extends State<AnimatedScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   List<String> imagePaths = [
//     'assets/images/mountain_water.jpg',
//     'assets/images/land.png', // Add the path to your next image
//   ];
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10), // Adjust the duration as needed
//     );

//     _animation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_controller)
//       ..addListener(() {
//         setState(() {}); // Redraw the widget when animation changes
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           // Delay before starting the animation of the next image
//           Future.delayed(Duration(seconds: 2), () {
//             setState(() {
//               _currentIndex = (_currentIndex + 1) % imagePaths.length;
//               _controller.reset();
//               _controller.forward();
//             });
//           });
//         }
//       });

//     _controller.forward(); // Start the animation
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return ClipRect(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 heightFactor: _animation.value,
//                 child: Image.asset(
//                   imagePaths[_currentIndex],
//                   width: screenSize.width,
//                   height: screenSize.height,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
