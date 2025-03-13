import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/responsive_utils.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  geo.Position? currentPosition;
  bool isLoading = true;
  String? errorMessage;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      // Check location services
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled. Please enable them in device settings.';
          isLoading = false;
        });
        return;
      }

      // Check and request location permissions
      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          setState(() {
            errorMessage = 'Location permissions are required to show the map';
            isLoading = false;
          });
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location permissions are permanently denied. Please enable them in app settings.';
          isLoading = false;
        });
        return;
      }

      try {
        // Get current position
        final position = await getCurrentPosition();
        
        setState(() {
          currentPosition = position;
          isLoading = false;
        });
        
        // Add current location marker
        _addMarker(
          LatLng(position.latitude, position.longitude),
          'current_location',
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          'Current Location'
        );

        // Check for event location arguments
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            final latitude = args['latitude'] as double;
            final longitude = args['longitude'] as double;
            
            // Add event location marker
            _addMarker(
              LatLng(latitude, longitude),
              'event_location',
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              'Event Location'
            );

            // Move camera to event location
            mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 15.0,
                ),
              ),
            );
          }
        });
      } catch (locationError) {
        setState(() {
          errorMessage = 'Failed to get current location: ${locationError.toString()}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<geo.Position> getCurrentPosition() async {
    try {
      print('Checking location services...');
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        throw Exception('Location services are disabled');
      }

      print('Checking location permissions...');
      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          throw Exception('Location permissions are required to show the map');
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable them in app settings.');
      }

      try {
        final position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high,
        );
        return position;
      } catch (locationError) {
        throw Exception('Failed to get current location: $locationError');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  void _addMarker(LatLng position, String markerId, BitmapDescriptor icon, String title) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: icon,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    print("Map created successfully");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppPalette.gradient2,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                SizedBox(height: 16),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializeMap,
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            key: const ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentPosition?.latitude ?? 0,
                currentPosition?.longitude ?? 0
              ),
              zoom: 15.0,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: Responsive.verticalPadding * 2,
            right: Responsive.horizontalPadding,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: "recenter",
                  onPressed: () {
                    if (currentPosition != null) {
                      mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: LatLng(
                              currentPosition!.latitude,
                              currentPosition!.longitude,
                            ),
                            zoom: 15.0,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
                SizedBox(height: Responsive.spacingHeight),
                FloatingActionButton(
                  heroTag: "zoomIn",
                  onPressed: () {
                    mapController?.animateCamera(CameraUpdate.zoomIn());
                  },
                  child: const Icon(Icons.add),
                ),
                SizedBox(height: Responsive.spacingHeight),
                FloatingActionButton(
                  heroTag: "zoomOut",
                  onPressed: () {
                    mapController?.animateCamera(CameraUpdate.zoomOut());
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
