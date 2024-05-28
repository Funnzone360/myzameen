// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({Key? key}) : super(key: key);

//   @override
//   _SettingScreenState createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   late String _selectedLanguage = 'English';

//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedLanguage();
//   }

//   Future<void> _loadSelectedLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
//     });
//   }

//   Future<void> _saveSelectedLanguage(String language) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedLanguage', language);
//     setState(() {
//       _selectedLanguage = language;
//     });

//     _setLocale(language);
//   }

//   void _setLocale(String language) {
//     Locale? locale;
//     switch (language) {
//       case 'Urdu':
//         locale = Locale('ur', 'PK');
//         break;
//       case 'Chinese':
//         locale = Locale('zh', 'CN');
//         break;
//       default:
//         locale = Locale('en', 'US');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color(0xFFC8291D),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFC8291D),
//         title: Text('Settings'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Container(
//           width: size.width,
//           height: size.height,
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 221, 216, 216),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Select Language:'),
//               DropdownButton<String>(
//                 value: _selectedLanguage,
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     _saveSelectedLanguage(newValue);
//                   }
//                 },
//                 items: <String>['English', 'Urdu', 'Chinese']
//                     .map<DropdownMenuItem<String>>(
//                       (String value) => DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
