import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/current_location.dart';
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
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
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
