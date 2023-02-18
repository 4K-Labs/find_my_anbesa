import 'dart:convert';

import 'package:find_my_anbesa/constants/constants.dart';
import 'package:find_my_anbesa/models/bus.dart';
import 'package:find_my_anbesa/models/detail.dart';
import 'package:find_my_anbesa/models/user.dart';
import 'package:http/http.dart' as http;

class APIService {
  static var client = http.Client();

  Future<User> signUp({ required String firstName, required String lastName, required String email, required String phone, required String password}) async {

    var body = {"first_name": firstName, "last_name":lastName,"email": email, "phone":phone, "password": password};

    try {
      final response = await client.post(
        Uri.parse(Strings.signUp),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {

        var jsonMap = json.decode(response.body);
        return User.fromJson(jsonMap);
      }if (response.statusCode == 400) {
        return Future.error('User already exists');
      }else {
        return Future.error('Could not register user');
      }
    } catch (e) {
      return Future.error('Could not register user');
    }
  }

  Future<User> signIn({required String email, required String password}) async {

    var body = {"email": email, "password": password};

    try {
      final response = await client.post(
        Uri.parse(Strings.signIn),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {

        var jsonMap = json.decode(response.body);
        return User.fromJson(jsonMap);
      }if (response.statusCode == 400) {
        return Future.error('Login incorrect or in-existent');
      }else {
        return Future.error('Could not sign in');
      }
    } catch (e) {
      return Future.error('Could not sign in');
    }
  }

  Future<List<Bus>> getBuses() async {
    try {
      var response = await client.get(Uri.parse(Strings.getBuses));
      if (response.statusCode == 200) {

        List<Bus> buses= [];

        try {
          buses = (json.decode(response.body) as List).map((i) => Bus.fromJson(i)).toList();
        }catch(Exception){

          return Future.error("Failed to get buses");
        }
        return buses;
      } else {

        return Future.error("Failed to get buses");
      }
    } catch (Exception) {
      return Future.error("Failed to get buses");
    }
  }

  Future<Detail> getDetail({required num userId, required num busId}) async {
      var body = {"user_id": userId, "bus_id": busId};
      print("get detail-------------------------");
      print(userId);
      print(busId);
      try {
        final response = await client.post(
          Uri.parse(Strings.getDetail),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);
          print(jsonMap);
          return Detail.fromJson(jsonMap);

        }if (response.statusCode == 400) {
          return Future.error('Insufficient activity points');
        }else {
          return Future.error('Could not fetch data');
        }
      } catch (e) {
        print(e);
        return Future.error('Could not fetch data');
      }
    }

  Future<void> rate({required int userId, required int updateId, required int rate}) async {

    var body = {"user_id": userId, "update_id": updateId, 'rate': rate};
    print("in rate function ````````````````````");
    try {
      final response = await client.post(
        Uri.parse(Strings.ratePost),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
          print("post rated ````````````````````");
      }
     else if (response.statusCode == 400) {
        print("post not rated 400 ````````````````````");
        return Future.error('Post already rated');
      }else {

        print("post not rated 500````````````````````");
        print(userId);
        print(updateId);
        print(rate);

        return Future.error('Could not rate post');
      }
    } catch (e) {
      print(e);
      return Future.error('Could not rate post');
    }
  }

  Future<void> updateBus({required int userId, required int busId, required num long, required num lat}) async {

    var body = {"user_id": userId, "bus_id": busId, 'long': long, 'lat':lat};
      print(json.encode(body));
      print(json.encode(body));
      print(json.encode(body));
      print(json.encode(body));
      print(json.encode(body));
    try {
      final response = await client.post(
        Uri.parse(Strings.updateBus),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {

      }
      else if (response.statusCode == 400) {
        print("400 000000000000000000");
        print("400 000000000000000000");
        print("400 000000000000000000");
        print("400 000000000000000000");
        print("400 000000000000000000");
        print("400 000000000000000000");
        print("400 000000000000000000");
        return Future.error('User updated bus recently');
      }else {
        return Future.error('Bus could not be updated');
      }
    } catch (e) {
      print(e);
      return Future.error('Bus could not be updated');
    }
  }



}