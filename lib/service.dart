import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunsetlover/model/sunset.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:location/location.dart';

class Service {
  LocationData currentLocation;
  var location = Location();
  var longitude;
  var latitude;
  var cityName;

//  var longitude = 104.9282;
//  var latitude = 11.5564;

  var date;

  Future<SunsetClass> getSunsetTime() async {
    await getLocation();
    var url =
        'https://api.sunrise-sunset.org/json?lat=$latitude&lng=$longitude&formatted=0';
    SunsetClass sunsetData = SunsetClass();
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      var sunsetUTC = jsonResponse['results']['sunset'];

      // DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSXXX');
      DateTime utcDateTime = DateTime.parse(sunsetUTC);
      String time = DateFormat.jm().format(utcDateTime.toLocal());
      String sunsetDate =
          DateFormat.yMMMMd('en_US').format(utcDateTime.toLocal());

      sunsetData = SunsetClass(time: time, date: sunsetDate);

      print(time);
      print(sunsetDate);
      print(utcDateTime.toLocal().toString());
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return sunsetData;
  }

  Future getLocation() async {
    currentLocation = await location.getLocation();
    longitude = currentLocation.longitude;
    latitude = currentLocation.latitude;

//    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
//        double.parse(latitude), double.parse(longitude));
//    if (placemark.length != 0) {
//      cityName = placemark[0].name;
//    }
    print(latitude);
    print(longitude);
//    print(cityName);
  }
}
