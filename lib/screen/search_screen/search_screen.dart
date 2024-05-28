import 'package:flutter/material.dart';
import 'package:flutter_zameen_app/screen/main_screen/main_screen.dart';

// SearchScreen

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> productType = [
    'LAND',
    'HOUSE',
    'SHOPS',
    'FACTORIES',
    'BUILDINGS',
    'HOTELS',
  ];

  String searchText = '';

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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText:
                    'Search for LAND, HOUSE, SHOPS, FACTORIES, BUILDINGS, HOTELS',
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: productType.length,
                itemBuilder: (context, index) {
                  final item = productType[index];
                  if (searchText.isEmpty ||
                      item.contains(searchText.toUpperCase())) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(
                              searchQuery:
                                  item, // Pass the selected product type as searchQuery
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(item),
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if the item doesn't match the search text
                  }
                },
              ),
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
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_zameen_app/screen/main_screen/main_screen.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   String? searchQuery = '';
//   List<String> categories = ['Land', 'Building', 'Factory'];
//   List<String> searchHistory = [];

//   @override
//   void initState() {
//     super.initState();
//     loadSearchHistory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               // Call a function to delete all search history
//               deleteAllSearchHistory();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) {
//                 setState(() {
//                   searchQuery = value;
//                 });
//               },
//               onSubmitted: (value) {
//                 saveSearchHistory(value);
//                 // Navigate to the main screen with the search query
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => MainScreen(searchQuery: value),
//                   ),
//                 );
//               },
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Text('Search History',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: searchHistory.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(searchHistory[index]),
//                   onLongPress: () {
//                     // Show dialog to confirm deletion
//                     showDeleteConfirmationDialog(index);
//                   },
//                   onTap: () {
//                     // Navigate to the main screen with the search query from history
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             MainScreen(searchQuery: searchHistory[index]),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void loadSearchHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       searchHistory = prefs.getStringList('searchHistory') ?? [];
//     });
//   }

//   void saveSearchHistory(String query) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> updatedHistory = [query, ...searchHistory];
//     prefs.setStringList('searchHistory', updatedHistory);
//     loadSearchHistory();
//   }

//   void deleteSearchHistory(int index) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     searchHistory.removeAt(index);
//     prefs.setStringList('searchHistory', searchHistory);
//     loadSearchHistory();
//   }

//   void deleteAllSearchHistory() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('searchHistory');
//     loadSearchHistory();
//   }

//   void showDeleteConfirmationDialog(int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Confirmation'),
//           content: Text('Are you sure you want to delete this search history?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 deleteSearchHistory(index);
//                 Navigator.of(context).pop();
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
