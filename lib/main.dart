import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunsetlover/model/sunset.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocationData currentLocation;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var location = Location();

  var longitude;
  var latitude;
  var cityName;

//  var longitude = 104.9282;
//  var latitude = 11.5564;

  var date;

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: body(),
      ),
    );
  }

  Widget body() {
    return SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: () {
        setState(() {
          print("refresh");
        });
        _refreshController.refreshCompleted();
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sunsetpic.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FutureBuilder<SunsetClass>(
            future: getSunsetTime(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Text(
                    'Loading sunset hour..',
                    style: TextStyle(fontFamily: 'ShareTechMono', fontSize: 69),
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      snapshot.data.time,
                      style: TextStyle(
                        fontFamily: 'ShareTechMono',
                        fontSize: 109,
                        // color: Color(0xFFFD5E53),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 11),
                      child: Text(
                        'Sunset on ' + snapshot.data.date,
                        style: TextStyle(
                          fontFamily: 'ShareTechMono',
                          fontSize: 12,
                        ),
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
