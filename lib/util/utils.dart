
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ton_tin_local/util/share_pref.dart';
import 'dart:convert' as JSON;

import 'package:vibrate/vibrate.dart';

class Utils {
  static final int DURATION = 3;
  static void showToast(BuildContext context, String message) {

  }

  static void showToastError(BuildContext context, String message) {

  }

  static void showToastInfo(BuildContext context, String message) {

  }


  static String messageErrorController(String org) {
    //{"error":"invalid_grant","error_description":"Bad credentials","error_code":"APPE0005","message":"Phone number not found.","message_ch":"找不到电话号码","message_kh":"លេខទូរសព្ទ័មិនមាននៅក្នុងប្រព័ន្ធ"}
    try {
      Map me = JSON.jsonDecode(org);
      if (me.containsKey("message_kh")) {
        return me["message_kh"];
      }
      else if (me.containsKey("error_description")) {
        return me["error_description"];
      } else if (me.containsKey("error_message")) {
        return me[ "error_message"];
      }
    } catch (e) {
      return "Technical Error";
    }

    return "General Failed Exception";
  }

  static Future<bool> isTokeExpire() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var tokenMilli = await _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt(PrefUtil.TOKEN_TIME) ?? 0);
    });
    var current = new DateTime.now().millisecondsSinceEpoch;
    var remain = current - tokenMilli;
    return (remain > 1000 * 30) || remain < 0;
  }


  static String dateConvert(int milli) {
    final df = new DateFormat('dd-MM-yyyy');
    return df.format(new DateTime.fromMillisecondsSinceEpoch(milli));
  }

  static String addMonth(int milli, int month) {
    final df = new DateFormat('dd-MM-yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(milli);
    var dateAddMonth = new DateTime(date.year, date.month + month, date.day);
    return df.format(dateAddMonth);
  }

  static bool isDateMatch(String compareDate) {
    print('how many call ???');
    var sub = compareDate.substring(3);
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-yyyy');
    String currentDate = formatter.format(now);

    return sub == currentDate;
  }

  static dynamic showBottomSheet(BuildContext context) {
   return  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
       backgroundColor: Color(0xFF2d3447),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        builder: (context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                SizedBox(
                height: 32.0,
              ),
                new Center(
                  child: new CircularProgressIndicator(backgroundColor: Colors.white,),
                ),
                SizedBox(height: 6.0),
              Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Please Wait', style: TextStyle(color: Colors.white),)

                ),
              ),

              SizedBox(height: 32.0),


                ],
              ),
            ),
          );
        });
  }

  static  Future startHapticNormal() async {
   /* var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.light;
      Vibrate.feedback(_type);
    }*/
  }
  static  Future startHapticSuccess() async {
  /*  var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.success;
      Vibrate.feedback(_type);
    }*/
  }
  static  Future startHapticError() async {
   /* var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.error;
      Vibrate.feedback(_type);
    }*/
  }
  static  Future startHapticWarning() async {
    /*var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.warning;
      Vibrate.feedback(_type);
    }*/
  }

  static Map<String, double> listTrackHelper(String listTrack){
    Map<String, double> data = new Map();
    if(listTrack.isEmpty) return data;
    // m_1#12.0@m_2 .. month 1 has 12.0$

    if(listTrack.contains('@')){

      var str = listTrack.split('@');

      for(var me in str){
        var txt = me.split("#");

        if(txt.length > 1){
          var k = txt[0].replaceAll('#', '');
          var v = txt[1].replaceAll('#', '');
          k = k.replaceAll('@', '');
          v = v.replaceAll('@', '');
          data[k] = double.parse(v);
        }

      }
    }else if(listTrack.contains('#')) {


        var txt = listTrack.split("#");

        if(txt.length > 1){
          var k = txt[0].replaceAll('#', '');
          var v = txt[1].replaceAll('#', '');
          k = k.replaceAll('@', '');
          v = v.replaceAll('@', '');
          data[k] = double.parse(v);
        }


    }
    return data;
  }

  static String listTrackMapToString(Map<String, double> data){
    var str = '';

    if(data.length <= 0) return str;

    data.forEach((k, v){

      str = str + '$k#$v@'; //month1#12.0@month2#20.5
    });

    if(str.contains('@')){
      str = str.substring(0, str.length -1);
    }
    return str;

  }
}