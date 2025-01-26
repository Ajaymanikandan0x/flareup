import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/routes/routs.dart';

class LocationContainer extends StatefulWidget {
  final String lat;
  final String lng;
  const LocationContainer({super.key, required this.lat, required this.lng});

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    final latLng = LatLng(
      double.parse(widget.lat),
      double.parse(widget.lng),
    );
    
    markers.add(
      Marker(
        markerId: const MarkerId('event_location'),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(
      double.parse(widget.lat),
      double.parse(widget.lng),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRouts.location,
            arguments: {
              'latitude': double.parse(widget.lat),
              'longitude': double.parse(widget.lng),
            },
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 470,
            height: 120,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: latLng,
                    zoom: 15,
                  ),
                  markers: markers,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  onTap: (_) {}, // Prevent map interaction
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
