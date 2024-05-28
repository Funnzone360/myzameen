import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  TextEditingController searchController = TextEditingController();
  String? searchQuery;
  LatLng? location;
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Search'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchAndSetLocation(searchController.text);
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  String selectedLocation = searchController.text;
                  Navigator.pop(context, selectedLocation);
                  if (searchQuery != null) {
                    createLocation(searchQuery!);
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0), // Default position
                zoom: 10,
              ),
              mapType: _currentMapType,
              markers: location != null
                  ? {
                      Marker(
                        markerId: MarkerId('location'),
                        position: location!,
                        infoWindow:
                            InfoWindow(title: searchQuery ?? 'Location'),
                      ),
                    }
                  : {},
            ),
          ),
          DropdownButton<MapType>(
            value: _currentMapType,
            items: [
              DropdownMenuItem(
                value: MapType.normal,
                child: Text('Normal'),
              ),
              DropdownMenuItem(
                value: MapType.satellite,
                child: Text('Satellite'),
              ),
              DropdownMenuItem(
                value: MapType.hybrid,
                child: Text('Hybrid'),
              ),
              DropdownMenuItem(
                value: MapType.terrain,
                child: Text('Terrain'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _currentMapType = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> searchAndSetLocation(String query) async {
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      setState(() {
        location = LatLng(locations.first.latitude, locations.first.longitude);
      });
      mapController.animateCamera(CameraUpdate.newLatLngZoom(location!, 10));
    }
  }

  void createLocation(String city) async {
    if (location != null) {
      try {
        // Store the location in Firestore
        await FirebaseFirestore.instance.collection('locations').add({
          'city': city,
          'latitude': location!.latitude,
          'longitude': location!.longitude,
        });
        // Display a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location created and stored for $city'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (error) {
        // Display an error message if saving fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to store location for $city'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Display a message if location is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location data is not available'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
