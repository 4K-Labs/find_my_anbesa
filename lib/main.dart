// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:find_my_anbesa/views/home.dart';
import 'package:find_my_anbesa/views/home_1.dart';
import 'package:find_my_anbesa/views/sign_in.dart';
import 'package:find_my_anbesa/views/test-search.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor : Colors.transparent, systemNavigationBarIconBrightness: Brightness.dark));

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home_1()
      );

  }
}

