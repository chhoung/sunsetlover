import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sunsetlover/model/sunset.dart';
import 'package:sunsetlover/service.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Service service = Service();

  @override
  Widget build(BuildContext context) {
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
            future: service.getSunsetTime(),
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
