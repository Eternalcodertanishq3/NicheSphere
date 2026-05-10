import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/glass_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(34.0522, -118.2437); // Los Angeles

  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('1'),
      position: const LatLng(34.0195, -118.4912),
      infoWindow: const InfoWindow(title: 'Sunset Yoga Session'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
    ),
    Marker(
      markerId: const MarkerId('2'),
      position: const LatLng(34.0522, -118.2437),
      infoWindow: const InfoWindow(title: 'Indie Game Playtest'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          // Search Bar
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: GlassCard(
              blur: 15,
              opacity: 0.7,
              borderRadius: BorderRadius.circular(30),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: Colors.black54),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for events...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 20, indent: 10, endIndent: 10),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_rounded, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Back Button
          Positioned(
            bottom: 40,
            left: 24,
            child: GestureDetector(
              onTap: () => context.go('/home'),
              child: const GlassCard(
                blur: 10,
                opacity: 0.8,
                padding: EdgeInsets.all(12),
                child: Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          
          // Floating Action Button
          Positioned(
            bottom: 40,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
