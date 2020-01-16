import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class SunsetClass {
  final String time;
  final String date;

  SunsetClass({this.date, this.time});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocationData currentLocation;

  var location = Location();

  var longitude;

  var latitude;

  var date;

  Future getLocation() async {
    currentLocation = await location.getLocation();
    longitude = currentLocation.longitude;
    latitude = currentLocation.latitude;
    print(latitude);
    print(longitude);
  }

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

//      print(time);
//      print(sunsetDate);
//      print(utcDateTime.toLocal().toString());
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return sunsetData;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: FutureBuilder<SunsetClass>(
            future: getSunsetTime(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
//                    child: Text(
//                      'Loading sunset data..',
//                      style:
//                          TextStyle(fontFamily: 'ShareTechMono', fontSize: 69),
//                    ),
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data.time,
                      style: TextStyle(
                        fontFamily: 'ShareTechMono',
                        fontSize: 69,
                        color: Color(0xFFFD5E53),
                      ),
                    ),
                    Text(
                      'Sunset on ' + snapshot.data.date,
                      style: TextStyle(
                        fontFamily: 'ShareTechMono',
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
