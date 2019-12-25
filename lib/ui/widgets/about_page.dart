import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ton_tin_local/util/lang.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color(0xFF1b1e44),
              Color(0xFF2d3447),
            ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              Icon(
                Icons.wifi_tethering,
                size: 90.0,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20.0),
              Text(
                Language.app_name(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Version 1.0',
                textAlign: TextAlign.center,
                style: TextStyle(

                    color: Colors.white70,
                    fontSize: 12.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 20.0),
              Text(
                Language.developerIntro(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ));
  }
}



