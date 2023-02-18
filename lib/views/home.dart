// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:find_my_anbesa/models/bus.dart';
import 'package:find_my_anbesa/models/detail.dart';
import 'package:find_my_anbesa/services/api_services.dart';
import 'package:find_my_anbesa/utils/connection_util.dart';
import 'package:find_my_anbesa/views/detail_page.dart';
import 'package:find_my_anbesa/views/map_test.dart';
import 'package:find_my_anbesa/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Color backgroundColor = Color(0xffffffff);
  Color backgroundColor = Color(0xfff5f7fa);
  Color cardColor = Color(0xffDFDADA);

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(

        automaticallyImplyLeading: false,
        centerTitle: true,
        title:  Text("Find my Anbesa", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.more_vert,
                     size: 26.0,
                ),
              )
          ),
        ],
        backgroundColor: Color(0xffefab3d),
        iconTheme: IconThemeData(color: Colors.black, size: 35),
        elevation: 0,
      ),

      body: FutureBuilder(
          future: ConnectionUtil.checkConnection(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data as bool) {
                return body();
              } else {
                return notConnectedBody();
              }
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Widget notConnectedBody() {
    return const Center(
      child: Icon(Icons.cloud_off, size: 100, color: Colors.grey),
    );
  }

  Widget body() {

    final box = GetStorage();
    var logged_in = box.read('logged_in');

    return FutureBuilder<List<Bus>>(
      future: APIService().getBuses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.cloud_off, size: 100, color: Colors.grey),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refresh,
              color: Colors.orange,
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {

                        if(logged_in == null || logged_in == false){

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const  SignIn(),  //replace with DetailPage

                            ),
                          );

                        }
                        else{
                        Map<String, dynamic> info = {'bus_id': snapshot.data![index].busId!, 'user_id': box.read('user_id'), 'lat': snapshot.data![index].lat!, 'long': snapshot.data![index].long!, 'last_update':snapshot.data![index].lastUpdate!, 'bus_no':snapshot.data![index].busNo!};
                        //Map<String, num> info = {'user_id': 1, 'bus_id': 1};
                        /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailPage()));*/

                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => const  DetailPage(),  //replace with DetailPage
                        settings: RouteSettings(
                        arguments: info,
                        ),
                        ),
                        );
                        }



                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        constraints: BoxConstraints(
                          minHeight: 130,
                        ),
                        margin: const EdgeInsets.fromLTRB(10,5,10,5),
                        decoration: BoxDecoration(
                            //color: Colors.teal[400],
                            color: backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Bus No: ',
                                  style: TextStyle(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  snapshot.data![index].busNo ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Origin: ',
                                  style: TextStyle(),
                                ),
                                Text(
                                  snapshot.data![index].origin ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Through: ',
                                  style: TextStyle(),
                                ),
                                Text(
                                  snapshot.data![index].through ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Destination: ',
                                  style: TextStyle(),
                                ),
                                Text(
                                  snapshot.data![index].destination ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        }
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }
}
