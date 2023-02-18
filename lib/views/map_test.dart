// ignore_for_file: prefer_const_constructors

import 'package:find_my_anbesa/models/detail.dart';
import 'package:find_my_anbesa/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() {
  runApp(const MapApp());
}

class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {

    setState(() {
      _markers.clear();

      final marker = Marker(
        markerId: MarkerId("Addis"),
        position: LatLng(38,8),
        infoWindow: InfoWindow(
          title: "name",
          snippet: "something",
        ),
      );
      _markers["Addis"] = marker;

    });
  }

  @override
  Widget build(BuildContext context) {

    final info = ModalRoute.of(context)!.settings.arguments as Map<String, num>;

    return Scaffold(
          body: Stack(
            children: [
            GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            markers: _markers.values.toSet(),
          ),
                 FutureBuilder<Detail>(
                  future: APIService().getDetail(userId: info['user_id']!, busId: info['bus_id']!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.hasError){
                        return Center(child:Text(snapshot.error.toString()));
                      }else{
                        return Text("Hello");
                      }
                    } else {
                      return const Center(child:CircularProgressIndicator());
                    }
                  }),
            ],
          )

    );
  }
}