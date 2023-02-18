// ignore_for_file: prefer_const_constructors, unused_field

import 'package:find_my_anbesa/models/detail.dart';
import 'package:find_my_anbesa/services/api_services.dart';
import 'package:find_my_anbesa/utils/location_util.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:find_my_anbesa/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Color backgroundColor = Color(0xffF5F7FA);
  final box = GetStorage();
  late GoogleMapController mapController;


  var rated_state = "Rated!";
  var update_state = "Succesfully updated!!";

  bool _buttonIsVisible = true;
  bool _starIsVisible = true;

  late double lat;
  late double long;
  late String lastupdate;
  late String busno;


  @override
  Widget build(BuildContext context) {
    final info = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    //APIService().getDetaill(userId: info['bus_id']!, busId: info['user_id']!);
    //return Container(child:Text(info['bus_id']!.toString()+info['user_id']!.toString()));

    lat = info['lat']!.toDouble();
    long = info['long']!.toDouble();
    lastupdate = info['last_update']!.toString();
    busno = info['bus_no']!.toString();

    LatLng _center = LatLng(info['lat']!.toDouble(), info['long']!.toDouble());

    var context_copy;



    return Scaffold(
      //backgroundColor: backgroundColor,
      body: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:  _center,
                zoom: 10,
              ),
              markers: _markers.values.toSet(),
            ),FutureBuilder<Detail>(
            future: APIService().getDetail(userId: info['user_id']!, busId: info['bus_id']!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasError){
                  return Center(child:Text(snapshot.error.toString()));
                }else{
                  var ratingVisibility = snapshot.data!.canRate!;
                  var updateVisibility = snapshot.data!.canUpdate!;
                  print("--------------------------------------");
                  print(snapshot.data!.busInfo!.updateId);
                  print(snapshot.data!.busInfo!.busId);

                  //_buttonIsVisible = snapshot.data!.canUpdate!;
                  return Stack(
                      children: [
                        Positioned(
                          top: 50,
                          left: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black, size:27),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Positioned(
                          top: 50,
                          right: 20,
                          child: snapshot.data!.canUpdate! ? Visibility(
                            visible: _buttonIsVisible,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffefab3d)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    )
                                ),
                              ),
                              icon: Icon(Icons.update, color: Colors.black,),
                              label: Text("Update", style: TextStyle(color: Colors.black),),
                              onPressed: () async {


                                context_copy = context;

                                /*final snackBar = SnackBar(content: Text(update_state));
                                ScaffoldMessenger.of(context_copy).showSnackBar(snackBar);
                                update_state = "User updated bus recently";*/

                                setState(() {
                                  _buttonIsVisible = false;
                                  _starIsVisible = false;
                                });

                                Navigator.pop(context);


                                final snackBar = SnackBar(content: Text(update_state));
                                ScaffoldMessenger.of(context_copy).showSnackBar(snackBar);
                                update_state = "User updated bus recently";


                                await LocationUtil().determinePosition().then((value) {

                                  print(value.latitude);
                                  print(value.longitude);
                                  print(value.latitude);
                                  print(value.longitude);
                                  print(value.latitude);
                                  print(value.longitude);
                                  print(value.latitude);
                                  print(value.longitude);
                                  print(value.latitude);
                                  print(value.longitude);
                                  print(value.latitude);
                                  print(value.longitude);

                                  FutureBuilder<void>(
                                  future: APIService().updateBus(userId: box.read('user_id'), busId: snapshot.data!.busInfo!.busId!, lat: value.latitude, long: value.longitude),
                                  builder: (context, snap) {
                                  if (snap.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError) {

                                  update_state = snapshot.error.toString();

                                  return SizedBox.shrink();
                                  } else {

                                  setState(() {
                                  updateVisibility = false;
                                  });
                                  return SizedBox.shrink();
                                  }
                                  } else {
                                  return const CircularProgressIndicator();
                                  }
                                  });

                                }).catchError((onError) {

                                  print(onError);
                                  print(onError);
                                  print(onError);
                                  print(onError);
                                  print(onError);
                                  print(onError);
                                  print(onError);

                                  setState(() {

                                  });

                                });
                              },
                            ),
                          ):SizedBox.shrink(),
                        ),
                          Positioned(
                            bottom: 50,
                            left: 20,
                            child: snapshot.data!.canRate! ? Visibility(
                              visible: _starIsVisible,
                              child: RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  final snackBar = SnackBar(content: Text(rated_state));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  rated_state = "Post already rated";
                                  setState(() {
                                    _starIsVisible = false;
                                  });
                                  print(rating.toInt());
                                  FutureBuilder<void>(
                                      future: APIService().rate(userId: box.read('user_id'), updateId: snapshot.data!.busInfo!.updateId!, rate: rating.toInt()),
                                      builder: (context, snap) {
                                        if (snap.connectionState == ConnectionState.done) {

                                          if (snapshot.hasError) {

                                            rated_state = snapshot.error.toString();

                                            return SizedBox.shrink();
                                          } else {
                                            setState(() {
                                              ratingVisibility = false;
                                            });
                                            return SizedBox.shrink();
                                          }
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      });
                                },
                              ),
                            ): SizedBox.shrink() ,
                          ),


                    //replace button witj ProgressIndicator
                    Positioned(
                    top: 50,
                    right: 20,
                    child: snapshot.data!.canUpdate! ? SizedBox.shrink():SizedBox.shrink(),
                    ),
                      ]);
                }
              } else {
                return const Center(child:CircularProgressIndicator());
              }
            }),]
      ),
    );
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {

    setState(() {
      _markers.clear();

        final marker = Marker(
          markerId: MarkerId("Addis"),
          position: LatLng(lat,long),
          infoWindow: InfoWindow(
            title: "Bus "+busno,
            snippet: structureDate(lastupdate),
          ),
        );
        _markers["Addis"] = marker;

    });
  }

  String structureDate(String s_date){

    DateTime dt = DateTime.parse(s_date);
    return "Last update: ${DateFormat.MMMM().format(dt)} ${dt.day}, ${DateFormat.jm().format(dt)}";

  }
}